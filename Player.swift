//
//  Player.swift
//  chain-heal
//
//  Created by Kyle Bashour on 12/7/15.
//  Copyright © 2015 Kyle Bashour. All rights reserved.
//

import Foundation

/// A class for holding a player with all its info
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
    
    /// For debugging: allows you to see the name and all adjacent players
    var description: String {
        
        var string = "\(name)\n"
        
        for player in self.adjacentPlayers {
            string += "    \(player.name)\n"
        }
        
        return string
    }
    
    /**
     Create a player with PP, a position (as a Point) and a name.
     
     - parameter maxPP:     The maximum PP this player can be healed to
     - parameter currentPP: The current PP of the player
     - parameter position:  The position (Point holds an x and y value)
     - parameter name:      The Player name
     
     - returns: A Player object instantiated with the given arguments
     */
    init(maxPP: Int, currentPP: Int, position: Point, name: String) {
        self.maxPP = maxPP
        self.currentPP = currentPP
        self.position = position
        self.name = name
    }

    /**
     Heals the player and returns how much the player was healed.
     
     - parameter potential: The potential healing power
     
     - returns: How much the player was able to heal themselves
     */
    func heal(potential: Int) -> Int {
        healing = min(potential, maxPP - currentPP)
        return healing
    }
}
