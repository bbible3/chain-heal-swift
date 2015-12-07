#if os(Linux)
import Glibc
#endif

import Foundation

/**
 *  A simple, probably unnecessary, struct for creating a point from two Ints
 */
struct Point {

    var x: Int
	var y: Int

    /**
     Find the distance between two Points
     
     - parameter toPoint: The Point we want the distance to
     
     - returns: The distance between this Point and the given Point
     */
	func distanceTo(toPoint: Point) -> Double {
        
        // Do the math
        
        let xDistance = x - toPoint.x
        let yDistance = y - toPoint.y
        
        return sqrt(Double((xDistance * xDistance) + (yDistance * yDistance)))
	}
}
