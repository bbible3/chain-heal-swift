#if os(Linux)
import Glibc
#endif

import Foundation

struct Point {

    var x: Int
	var y: Int

	func distanceTo(toPoint: Point) -> Double {
        
        let xDistance = x - toPoint.x
        let yDistance = y - toPoint.y
        
        // print(toPoint.x, toPoint.y, x, y, sqrt(Double((xDistance * xDistance) + (yDistance * yDistance))))
		
        return sqrt(Double((xDistance * xDistance) + (yDistance * yDistance)))
	}
}
