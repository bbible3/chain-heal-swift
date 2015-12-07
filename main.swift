#if os(Linux)
import Glibc
#endif

import Foundation

/**
 Parse arguments from an array and create a ChainInfo item from them.
 
 - parameter args: An array of strings for parsing into a ChainInfo struct
 
 - returns: Returns an instance of ChainInfo initialized from the given array
 */
func parseChainInfo(args: [String]) -> ChainInfo {
    
    // This could, of course, be far more concise, but I wanted to output specific errors
    
    // Check that there are enough elements to make a ChainInfo
    guard args.count >= 5 else {
        fatalError("Not enough arguments")
    }
    // Validate all of the input
    guard let initialRange = Int(args[1]) else {
        fatalError("Initial range must be an Int")
    }
    guard let jumpRange = Int(args[2]) else {
        fatalError("Jump range must be an Int")
    }
    guard let numberOfJumps = Int(args[3]) else {
        fatalError("Number of jumps must be an Int")
    }
    guard let initialPower = Int(args[4]) else {
        fatalError("Initial power must be an Int")
    }
    guard let powerReduction = Double(args[5]) else {
        fatalError("Power reduction must be a Double")
    }
    
    // Create and return the ChainInfo
    return ChainInfo(initialRange: initialRange, jumpRange: jumpRange, numberOfJumps: numberOfJumps, initialPower: initialPower, powerReduction: powerReduction)
}

/**
 Parse arguments from an array into player objects. This will probably change to take a file name at some point.
 
 - parameter args: An array of player parameters
 
 - returns: An array of the players parsed
 */
func parsePlayers() -> [Player] {
    
    // Players for appending and returning
    var players = [Player]()
    
    var lineNumber = 0
    
    // Read in all players from std in
    while let line = readLine() {
        
        lineNumber += 1
    
        let line = line.characters.split{$0 == " "}.map(String.init)
        
        // Make sure we can get all valid parameters
        guard let
            x = Int(line[0]),
            y = Int(line[1]),
            currentPP = Int(line[2]),
            maxPP = Int(line[3])
            where line.count == 5
        else {
            fatalError("Invalid player at line number: \(lineNumber)")
        }
        
        // Create a point, a name and player, then append it
        let position = Point(x: x, y: y)
        let name = line[4]
        let newPlayer = Player(maxPP: maxPP, currentPP: currentPP, position: position, name: name)
        
        players.append(newPlayer)
    }
    
    // Loop through the players and create their adjacent arrays (perhaps should be Sets?)
    for player in players {
        
        // print(player.name)
        
        let adjacentPlayers = players.filter { otherPlayer in
            if otherPlayer === player {
                return false
            }
            return otherPlayer.position.distanceTo(player.position) <= Double(chainInfo.jumpRange)
        }
        
        player.adjacentPlayers = adjacentPlayers
    }
    
    // Return the array of parsed players
    return players
}

func dfs(player: Player, hop: Int, chainInfo: ChainInfo, totalHealing: Int) {
    
    if player.visited || (hop > chainInfo.numberOfJumps) {
        
//        print("Visited or done hopping")
        
        return
    }
    
//    print("Node: \(player.name)  Hop \(hop)")
    
    let totalHealing = totalHealing + player.heal(chainInfo.powerForHop(hop))
    
//    print("Total Healing: \(totalHealing)")
    
    if totalHealing > chainInfo.bestHealing {
        
//        print("Total greater than best!")
        
        chainInfo.bestHealing = totalHealing
        chainInfo.bestPath.removeAll()
        
        var bestPlayer: Player! = player
        
        while bestPlayer != nil {
//            print("Saving: \(bestPlayer.name)")
            chainInfo.bestPath.insert(bestPlayer, atIndex: 0)
            bestPlayer.bestHealing = bestPlayer.healing
            bestPlayer = bestPlayer.previousPlayer
        }
        
        // print(chainInfo.bestPath)
    }
    
//    print("Done saving the best")
    
    player.visited = true
    
    for adjacentPlayer in player.adjacentPlayers {
        if !adjacentPlayer.visited {
            
//            print("Setting \(adjacentPlayer.name) prev to \(player.name)")
            
            adjacentPlayer.previousPlayer = player
            dfs(adjacentPlayer, hop: hop + 1, chainInfo: chainInfo, totalHealing: totalHealing)
            adjacentPlayer.previousPlayer = nil
        }
    }
    
    player.visited = false
}

// Parse the chain info
let chainInfo = parseChainInfo(Process.arguments)

// Parse all the players
let players = parsePlayers()

for player in players {
    if player.name == "Urgosa_the_Healing_Shaman" {
        
        // print("Found Urgosa_the_Healing_Shaman")
        
        dfs(player, hop: 1, chainInfo: chainInfo, totalHealing: 0)

        for otherPlayer in players where otherPlayer.name != "Urgosa_the_Healing_Shaman" {
            if otherPlayer.position.distanceTo(player.position) <= Double(chainInfo.initialRange) {
                dfs(otherPlayer, hop: 1, chainInfo: chainInfo, totalHealing: 0)
            }
        }
    }
}

var totalHealing = 0

for player in chainInfo.bestPath {
    totalHealing += player.bestHealing
    print(player.name, player.bestHealing)
}

print("Total_Healing \(totalHealing)")
