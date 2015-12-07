//
//  ChainInfo.swift
//  chain-heal
//
//  Created by Kyle Bashour on 12/7/15.
//  Copyright © 2015 Kyle Bashour. All rights reserved.
//

#if os(Linux)
import Glibc
#endif

import Foundation

/// ChainInfo is the heart of the program. 
/// It's responsible for parsing all the relevant information, and performing the search for the best path.
class ChainInfo {
    
    let initialRange: Int
    let jumpRange: Int
    let numberOfJumps: Int
    let initialPower: Int
    let powerReduction: Double
    
    private var bestHealing = 0
    private var players = [Player]()
    private var bestPath = [Player]()
    private var urgosa: Player?
    
    /**
     Initialize a ChainInfo object with given values (not used in the current implementation)
     
     - parameter initialRange:   The initial range that Urgosa can cast the healing spell
     - parameter jumpRange:      The range the healing spell can jump after the intial cast
     - parameter numberOfJumps:  The number of times the spell can jump
     - parameter initialPower:   The initial healing power of the spell
     - parameter powerReduction: The amount by which the healing power is reduced each jump
     
     - returns: A fully initialized ChainInfo object
     */
    init(initialRange: Int, jumpRange: Int, numberOfJumps: Int, initialPower: Int, powerReduction: Double) {
        self.initialRange = initialRange
        self.jumpRange = jumpRange
        self.numberOfJumps = numberOfJumps
        self.initialPower = initialPower
        self.powerReduction = powerReduction
    }
    
    /**
     Parse arguments from an array with thorough error checking, and create a ChainInfo item from them.
     
     - parameter args: An array of strings for parsing into a ChainInfo struct
     
     - returns: A fully initialized ChainInfo object created from the given array
     */
    init(args: [String]) {
        
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
        
        self.initialRange = initialRange
        self.jumpRange = jumpRange
        self.numberOfJumps = numberOfJumps
        self.initialPower = initialPower
        self.powerReduction = powerReduction
    }
    
    /**
     Calculate the power left based on the given hop
     
     - parameter hop: The current hope we wish to know the power for
     
     - returns: The potential power for healing after on the given hop
     */
    func powerForHop(hop: Int) -> Int {
        
        // Create a double var for the calculations
        var potential = Double(initialPower)
        
        // Calculate the how much power we've lost
        for _ in 1..<hop {
            potential = potential * (1 - powerReduction)
        }
        
        // Use rint (as specified in the original lab) to return an Int value
        return Int(rint(potential))
    }
    
    /**
     Parse arguments from standard in into player objects.
     */
    func parsePlayers() {
        
        // Remove all current players
        players.removeAll()
        
        var lineNumber = 0
        
        // Read in all players from std in
        while let line = readLine() {
            
            lineNumber += 1
            
            // Split the line into the components specified in the lab (x, y, curPP, maxPP, name)
            let line = line.characters.split{$0 == " "}.map(String.init)
            
            // Grab all the parameters that need casting/checking, and also check that we have all 5 arguments
            guard let x = Int(line[0]), y = Int(line[1]), currentPP = Int(line[2]), maxPP = Int(line[3]) where line.count == 5 else {
                fatalError("Invalid player at line number: \(lineNumber)")
            }
            
            // Create a point, a name and player, then append it to the player array
            let position = Point(x: x, y: y)
            let name = line[4]
            let player = Player(maxPP: maxPP, currentPP: currentPP, position: position, name: name)
            
            players.append(player)
            
            // Save urgosa for casting the initial spell
            if player.name == "Urgosa_the_Healing_Shaman" {
                urgosa = player
            }
        }
    }
    
    /**
     Create the adjacency relationships for every player, based on the jump range of the spell
     */
    func createAdjacentArrays() {
        
        // Loop through the players and create their adjacent arrays
        for player in players {
            
            // Filter all the players based on their distance to the player
            player.adjacentPlayers = players.filter {
                $0.position.distanceTo(player.position) <= Double(jumpRange)
            }
        }
    }
    
    /**
     Perform depth first search on the players to find the path with the most healing.
     
     - returns: Returns a tuple with the best path and the score (healing) of that path
     */
    func findBestPath() -> (path: [Player], healing: Int) {
        
        // Make sure we have urgosa
        guard let urgosa = urgosa else { fatalError("No player named Urgosa_the_Healing_Shaman was given") }
           
        // Loop through all players, and if they're in urgosa's range, "cast the spell" (do the dfs)
        for player in players {
            if player.position.distanceTo(urgosa.position) <= Double(chainInfo.initialRange) {
                dfs(player, hop: 1, totalHealing: 0)
            }
        }
        
        return (bestPath, bestHealing)
    }

    /**
     Perform the depth first search, starting on the given player.
     
     - parameter player:       A player for the current search
     - parameter hop:          The current number of times the spell has jumped
     - parameter totalHealing: The current amount of healing
     */
    func dfs(player: Player, hop: Int, totalHealing: Int) {
        
        // Base case: we've either visited this player, or the spell can't jump anymore
        if (player.visited) || (hop > chainInfo.numberOfJumps) {
            return
        }
        
        // Add the healing for the current jump to the current total healing
        let totalHealing = totalHealing + player.heal(chainInfo.powerForHop(hop))
        
        // If the total is better than our best healing, save the path and score
        if totalHealing > bestHealing {
                        
            bestHealing = totalHealing
            bestPath.removeAll()
            
            var bestPlayer: Player! = player
            
            // Loop through all the previousPlayers, saving the current path 
            // (I bet there's a better way to do this, couldn't get my repeat-while working though)
            while bestPlayer != nil {
                bestPath.insert(bestPlayer, atIndex: 0)
                bestPlayer.bestHealing = bestPlayer.healing
                bestPlayer = bestPlayer.previousPlayer
            }
        }
        
        // Mark this player as visited
        player.visited = true
        
        // Loop through all adjacent, unvisited players, calling dfs on them
        for adjacentPlayer in player.adjacentPlayers {
            
            if !adjacentPlayer.visited {
                // Set the previousPlayer to current player
                adjacentPlayer.previousPlayer = player
                // Call the dfs
                dfs(adjacentPlayer, hop: hop + 1, totalHealing: totalHealing)
                // Unset the previousPlayer
                adjacentPlayer.previousPlayer = nil
            }
        }
        
        // Unset visited
        player.visited = false
    }
}
