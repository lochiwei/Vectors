# Vectors

My personal framework for Vectors

Sample code:

```swift
// MARK: - test RealNumber

let c = CGFloat(3) // CGFloat
let f = Float(2)   // Float
let d = 1.5        // Double
let i = 4          // Int

// test operations
i + d  // 5.5
c - f  // 1.0
i * d  // 6.0
i / d  // 2.667

// MARK: - test RealVector

var p: CGPoint = [5, 6]
p.coordinates
CGPoint.dimension

// test init 
p = CGPoint(SCNVector3(1,2,3))                  // init with SCNVector3
p = [CGFloat(1.1), CGFloat(2.2), CGFloat(3.3)]  // init with [CGFloat]
p = [Float(1.2), Float(2.3), Float(3.4)]        // init with [Float]
p = [1.2, 3.4, 5.6]                             // init with [Double]
p = [1, 2, 3]                                   // init with [Int]
p = [3]                                         // Not enough values (rest default to 0)
p = []                                          // init with empty array

// test vector subscript
p[1]      // get: 0.0
p[1] = 3  // set: 3.0
p         // (0.0, 3.0)

// test vector operations
let u: SCNVector3 = [1,2,3]
let v: SCNVector3 = [4,5,6]
var w = SCNVector3(p)        // init with CGPoint

w = -u

w = u + [1,2,3]

w = u + v
w = u - v
w = 2 * u
w = u * 2
w = u / 2

w += 0.5    // (1.0, 1.5, 2.0)
w -= 2      // (-1.0, -0.5, 0)
w *= 4      // (-4, -2, 0)
w /= 2      // (-2, -1, 0)
w += [7,8,9]// (5, 7, 9)

// vector linear combinations
w = 4*u - 3*v    // (-8, -7, -6)

// vector operations of two different conforming types
w + p            // (-8, -4, -6)
w - p            // (-8, -10, -6)
```
