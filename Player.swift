import Foundation

class Player: CustomStringConvertible {

    let position: Point
    let name: String

    let maxPP: Int
    let currentPP: Int
    var healing = 0
    var bestHealing = 0
    
    var adjacentPlayers = [Player]()
    var visited = false
    var previousPlayer: Player?
    
    var description: String {
        
        var string = "\(name)\n"
        
        for player in self.adjacentPlayers {
            string += "    \(player.name)\n"
        }
        
        return string
    }
    
    init(maxPP: Int, currentPP: Int, position: Point, name: String) {
        self.maxPP = maxPP
        self.currentPP = currentPP
        self.position = position
        self.name = name
    }

    // Heals and returns the used potential
    func heal(potential: Int) -> Int {
        
        healing = min(potential, maxPP - currentPP)
        
        return healing
    }
}
