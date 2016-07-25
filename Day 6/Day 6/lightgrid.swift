//
//  lightgrid.swift
//  Day 6
//
// Copyright (c) 2015 Randy Eckenrode
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

public struct Point: Equatable {
    var x: Int
    var y: Int
}

public func ==(lhs: Point, rhs: Point) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y
}

public struct Rect: Equatable {
    var origin: Point
    var size: Size
}

public func ==(lhs: Rect, rhs: Rect) -> Bool {
    return lhs.origin == rhs.origin && lhs.size == rhs.size
}

public extension Rect {
    init(x: Int, y: Int, width: Int, height: Int) {
        self.init(origin: Point(x: x, y: y), size: Size(width: width, height: height))
    }
}

public struct Size: Equatable {
    var width: Int
    var height: Int
}

public func ==(lhs: Size, rhs: Size) -> Bool {
    return lhs.width == rhs.width && lhs.height == rhs.height
}

public class LightGrid<T, Ops: ToggleOps where Ops.Element == T> {
    
    var grid: [[T]]
    let ops: Ops
    
    private init(size: Size, ops: Ops) {
        grid = Array(repeating: Array(repeating: ops.defaultMake(), count: size.height), count: size.width)
        self.ops = ops
    }
    
    subscript(x x: Int, y y: Int) -> T {
        get {
            return grid[x][y]
        }
        set(newValue) {
            grid[x][y] = newValue
        }
    }
    
    subscript(row row: Int, column column: Int) -> T {
        get {
            return self[x: column, y: row]
        }
        set(newValue) {
            self[x: column, y: row] = newValue
        }
    }
    
    func turnOn(_ rect: Rect) {
        for x in 0 ..< rect.size.width {
            for y in 0 ..< rect.size.height {
                self[x: x + rect.origin.x, y: y + rect.origin.y] =
                    ops.on(self[x: x + rect.origin.x, y: y + rect.origin.y])
            }
        }
    }
    
    func turnOff(_ rect: Rect) {
        for x in 0 ..< rect.size.width {
            for y in 0 ..< rect.size.height {
                self[x: x + rect.origin.x, y: y + rect.origin.y] =
                    ops.off(self[x: x + rect.origin.x, y: y + rect.origin.y])
            }
        }
    }
    
    func toggle(_ rect: Rect) {
        for x in 0 ..< rect.size.width {
            for y in 0 ..< rect.size.height {
                self[x: x + rect.origin.x, y: y + rect.origin.y] =
                    ops.toggle(self[x: x + rect.origin.x, y: y + rect.origin.y])
            }
        }
    }
    
    var aggregate: Int {
        let lazyFmap = grid.lazy.flatMap { $0 }
        return lazyFmap.reduce(0, combine: ops.aggregate)
    }
}

public protocol ToggleOps {
    associatedtype Element
    func on(_ input: Element) -> Element
    func off(_ input: Element) -> Element
    func toggle(_ input: Element) -> Element
    func defaultMake() -> Element
    func aggregate(_ acc: Int, input: Element) -> Int
}

public struct BoolToggleOps: ToggleOps {
    public func on(_: Bool) -> Bool {
        return true
    }
    public func off(_: Bool) -> Bool {
        return false
    }
    public func toggle(_ input: Bool) -> Bool {
        return !input
    }
    public func defaultMake() -> Bool {
        return false
    }
    public func aggregate(_ acc: Int, input: Bool) -> Int {
        return acc + (input ? 1 : 0)
    }
}

public struct IntToggleOps: ToggleOps {
    public func on(_ input: Int) -> Int {
        return input + 1
    }
    public func off(_ input: Int) -> Int {
        return max(0, input - 1)
    }
    public func toggle(_ input: Int) -> Int {
        return input + 2
    }
    public func defaultMake() -> Int {
        return 0
    }
    public func aggregate(_ acc: Int, input: Int) -> Int {
        return acc + input
    }
}

public class BoolLightGrid: LightGrid<Bool, BoolToggleOps> {
    public init(size: Size) {
        super.init(size: size, ops: BoolToggleOps())
    }
    public convenience init(width: Int, height: Int) {
        self.init(size: Size(width: width, height: height))
    }
}

public class IntLightGrid: LightGrid<Int, IntToggleOps> {
    public init(size: Size) {
        super.init(size: size, ops: IntToggleOps())
    }
    public convenience init(width: Int, height: Int) {
        self.init(size: Size(width: width, height: height))
    }
}
