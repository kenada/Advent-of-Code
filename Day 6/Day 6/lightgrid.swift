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

public struct Point: Comparable {
    var x: Int
    var y: Int
}

public func ==(lhs: Point, rhs: Point) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y
}

public func <(lhs: Point, rhs: Point) -> Bool {
    return lhs.x < rhs.x && lhs.y < rhs.y
}

public struct Rect: Equatable {
    var origin: Point
    var size: Size

    private var end: Point {
        return Point(x: origin.x + size.width, y: origin.y + size.height)
    }
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

public class LightGrid {
    private var grid: [[Int]]

    init(size: Size) {
        grid = Array(repeating: Array(repeating: 0, count: size.height), count: size.width)
    }

    convenience init(width: Int, height: Int) {
        self.init(size: Size(width: width, height: height))
    }

    public var width: Int {
        return grid[0].count
    }
    public var height: Int {
        return grid.count
    }

    public var lightsOn: Int {
        return grid.reduce(0) { subtotal, column in
            subtotal + column.reduce(0) { acc, value in
                if value > 0 {
                    return acc + 1
                } else {
                    return acc
                }
            }
        }
    }

    public var brightness: Int {
        return grid.reduce(0) { subtotal, column in
            subtotal + column.reduce(0, combine: +)
        }
    }

    public subscript(x: Int, y: Int) -> Int {
        get {
            return grid[x][y]
        }
        set(newValue) {
            grid[x][y] = newValue
        }
    }

    public subscript(row row: Int, column column: Int) -> Int {
        get {
            return self[column, row]
        }
        set(newValue) {
            self[column, row] = newValue
        }
    }

    public func contains(point: Point) -> Bool {
        return 0 <= point.x && point.x < width && 0 <= point.y && point.y < height
    }

    private func modulate(lower: Point, upper: Point, f: @noescape (Int) -> Int) {
        for x in lower.x..<upper.x {
            for y in lower.y..<upper.y {
                self[x, y] = f(self[x, y])
            }
        }
    }

    public func increaseBrightness(by n: Int, area: Rect) {
        modulate(lower: area.origin, upper: area.end) { $0 + n }
    }

    public func decreaseBrightness(by n: Int, area: Rect) {
        modulate(lower: area.origin, upper: area.end) { $0 - n }
    }

    public func turnOn(area: Rect) {
        modulate(lower: area.origin, upper: area.end) { _ in 1 }
    }

    public func turnOff(area: Rect) {
        modulate(lower: area.origin, upper: area.end) { _ in 0 }
    }

    public func toggle(area: Rect) {
        modulate(lower: area.origin, upper: area.end) { value in
            if value != 0 {
                return 0
            } else {
                return 1
            }
        }
    }
}
