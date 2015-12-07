#if os(Linux)
import Glibc
#endif

import Foundation

// Parse the chain info from the commandline args
let chainInfo = ChainInfo(args: Process.arguments)

// Parse the players, then create their adjacent arrays
chainInfo.parsePlayers()
chainInfo.createAdjacentArrays()

// Find the best path
let solution = chainInfo.findBestPath()

// Print the path we found
for player in solution.path {
    print(player.name, player.bestHealing)
}

// Print the total healing
print("Total_Healing \(solution.healing)")
