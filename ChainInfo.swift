import Foundation

class ChainInfo {
    
    let initialRange: Int
    let jumpRange: Int
    let numberOfJumps: Int
    let initialPower: Int
    let powerReduction: Double
    
    var bestHealing = 0
    var bestPath = [Player]()
    
    init(initialRange: Int, jumpRange: Int, numberOfJumps: Int, initialPower: Int, powerReduction: Double) {
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
        
        var potential = Double(initialPower)
        
        for _ in 1..<hop {
            potential = potential * (1 - powerReduction)
        }
        
        return Int(round(potential))
    }
}
