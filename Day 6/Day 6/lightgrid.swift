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

public enum DrawingOperator {
    case Source, SourceAtop, SourceOver, SourceIn, SourceOut
    case Destination, DestinationAtop, DestinationOver, DestinationIn, DestinationOut
    case Clear, Xor
}

public class LightGrid {
    
    let grid: [[Bool]]
    
    init(size: Size) {
        grid = Array(count: size.width, repeatedValue: Array(count: size.height, repeatedValue: false))
    }
    
    convenience init(width: Int, height: Int) {
        self.init(size: Size(width: width, height: height))
    }
    
    subscript(x x: Int, y y: Int) -> Bool {
        return grid[x][y]
    }
    
    subscript(row row: Int, column column: Int) -> Bool {
        return self[x: column, y: row]
    }
    
    func draw(rect: Rect, op: DrawingOperator) {
    }
    
    var lightCount = -1
}