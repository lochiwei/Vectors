// protocol Vector

/*
 TODO: Todo List
 ( ) more general vectors allowing variable length of elements
 (v) merge Vector2D, Vector3D, Vector4D into a universal Vector protocol?
 (v) vector subscript?
 ( ) allow vector addition with different dimensions?
 (v) merge CGFloat, Float -> RealNumber (protocol)?
 ( ) RealVector expressible by [Float] and [CGFloat] ...
 
 History:
 - 2018.03.23: version 1.0
 - 2018.07.07: add Vector4D
 */

import UIKit
import SceneKit

// MARK: - protocol Field
public protocol Field {
    static var zero:Self { get } // element 0
    //static var one:Self { get }  // element 1
    static func + (a:Self, b:Self) -> Self
    static func - (a:Self, b:Self) -> Self
    static func * (a:Self, b:Self) -> Self
    static func / (a:Self, b:Self) -> Self
}

// MARK: - extension Field

extension Field {
    // additive inverse
    public static prefix func - (a:Self) -> Self {
        return Self.zero - a
    }
}

// MARK: - protocol Real Number: Field
public protocol RealNumber: Field {
    var realValue: Float { get set }
    init(_ a:Float)
}

// 讓不同類別的 RealNumber 可以做四則運算
public func + <U:RealNumber, V:RealNumber>(a:U, b:V) -> U {
    return U.init(a.realValue + b.realValue)
}

public func - <U:RealNumber, V:RealNumber>(a:U, b:V) -> U {
    return U.init(a.realValue - b.realValue)
}

public func * <U:RealNumber, V:RealNumber>(a:U, b:V) -> U {
    return U.init(a.realValue * b.realValue)
}

public func / <U:RealNumber, V:RealNumber>(a:U, b:V) -> U {
    return U.init(a.realValue / b.realValue)
}


// MARK: - Vector (protocol)
public protocol Vector: ExpressibleByArrayLiteral {
    
    associatedtype Scalar:Field
    
    static var dimension: Int { get }
    var coordinates: [Scalar] { get set }
    
    init()
    init(arrayLiteral: Scalar...)
    
    static func + (u:Self, v:Self) -> Self   // vector addition
    static prefix func - (u:Self) -> Self    // additive inverse
    static func * (a:Scalar, v:Self) -> Self // scalar multiplication
    
    subscript(i:Int) -> Scalar { get set }
}

// MARK: - extension Vector

extension Vector {
    
    public subscript(i:Int) -> Scalar {
        get {
            return coordinates[i]
        }
        set {
            var coords = self.coordinates
            coords[i] = newValue
            self = Self.init()
            self.coordinates = coords
        }
    }
    
    // default +
    public static func + (u:Self, v:Self) -> Self {
        var coords = [Scalar]()
        for i in 0...(Self.dimension - 1) {
            coords.append(u[i] + v[i])
        }
        var vec = Self.init()
        vec.coordinates = coords
        return vec
    }
    
    // default -v
    static public prefix func - (u:Self) -> Self {
        var coords = [Scalar]()
        for i in 0...(Self.dimension - 1) {
            coords.append(-u[i])
        }
        var vec = Self.init()
        vec.coordinates = coords
        return vec
    }
    
    // default *
    public static func * (a:Scalar, v:Self) -> Self {
        var coords = [Scalar]()
        for i in 0...(Self.dimension - 1) {
            coords.append(a * v[i])
        }
        var vec = Self.init()
        vec.coordinates = coords
        return vec
    }
    
    // default operations
    public static func - (u:Self, v:Self) -> Self { return u + (-v) }
    public static func * (v:Self, a:Scalar) -> Self { return a * v }
    public static func += (u:inout Self, v:Self) { u = u + v }
    public static func -= (u:inout Self, v:Self) { u = u - v }
    public static func *= (u:inout Self, a:Scalar) { u = u * a }
    
    // default initializers
    public init(arrayLiteral elements: Scalar...) {
        var coords = elements
        if coords.count < Self.dimension {
            let n = Self.dimension - coords.count
            for _ in 1...n { coords.append(.zero) }
        }
        self.init()
        self.coordinates = coords
    }
    
    public init<V:Vector>(_ v:V) where V.Scalar == Scalar {
        self.init()
        self.coordinates = v.coordinates
    }
}


// 讓不同型別的向量可以相加
// U + V -> U
public func + <U:Vector, V:Vector>(u:U, v:V) -> U where U.Scalar == V.Scalar {
    return u + U.init(v)
}

// MARK: - Real Vector
public protocol RealVector: Vector where Scalar: RealNumber {
    
}

extension RealVector {
    // let RealVector can initialize with another (different type) RealVector
    public init<V:RealVector>(_ v:V) {
        var coords = [Self.Scalar]()
        for i in 0...(Self.dimension - 1) {
            coords.append(Self.Scalar.init(v[i].realValue))
        }
        self.init()
        self.coordinates = coords
    }
}

// MARK: - RealNumber (conforming types)

// CGFloat as vector scalars
extension CGFloat: RealNumber {
    public static let zero: CGFloat = 0
    public var realValue: Float {
        get { return Float(self) }
        set { self = CGFloat(newValue) }
    }
}

// Float as vector scalars
extension Float: RealNumber {
    public static let zero: Float = 0
    public var realValue: Float {
        get { return self }
        set { self = newValue }
    }
}

// MARK: -  RealVector (Conforming Types)

// CGPoint
extension CGPoint: RealVector {
    
    public typealias Scalar = CGFloat
    public static var dimension: Int { return 2 }
    
    public var coordinates: [CGFloat] {
        get { return [x, y] }
        set {
            let n = newValue.count
            x = n > 0 ? newValue[0] : 0
            y = n > 1 ? newValue[1] : 0
        }
        
    }
}

// CGVector
extension CGVector: RealVector {
    
    public typealias Scalar = CGFloat
    public static var dimension: Int { return 2 }
    
    public var coordinates: [CGFloat] {
        get { return [dx, dy] }
        set {
            let n = newValue.count
            dx = n > 0 ? newValue[0] : 0
            dy = n > 1 ? newValue[1] : 0
        }
    }
}// end: extension CGVector

// CGSize as Vector
extension CGSize: RealVector {
    
    public typealias Scalar = CGFloat
    public static var dimension: Int { return 2 }
    
    public var coordinates: [CGFloat] {
        get { return [width, height] }
        set {
            let n = newValue.count
            width = n > 0 ? newValue[0] : 0
            height = n > 1 ? newValue[1] : 0
        }
    }
}


// SCNVector3 as Vector
extension SCNVector3: RealVector {
    
    public typealias Scalar = Float // scalar field
    public static var dimension: Int { return 3 }
    
    public var coordinates: [Float] {
        get { return [x, y, z] }
        set {
            let n = newValue.count
            x = n > 0 ? newValue[0] : 0
            y = n > 1 ? newValue[1] : 0
            z = n > 2 ? newValue[2] : 0
        }
        
    }
}

// SCNVector4 as Vector4D
extension SCNVector4: RealVector {
    
    public typealias Scalar = Float // scalar field
    public static var dimension: Int { return 4 }
    
    public var coordinates: [Float] {
        get { return [x, y, z, w] }
        set {
            let n = newValue.count
            x = n > 0 ? newValue[0] : 0
            y = n > 1 ? newValue[1] : 0
            z = n > 2 ? newValue[2] : 0
            w = n > 3 ? newValue[3] : 0
        }
        
    }
}
