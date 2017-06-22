//
//  day 6.swift
//  Advent of Code 2015
//
// Copyright © 2015–2016 Randy Eckenrode
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

import AdventSupport
import Foundation

struct Point: Comparable {
    var x: Int
    var y: Int
}

func ==(lhs: Point, rhs: Point) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y
}

func <(lhs: Point, rhs: Point) -> Bool {
    return lhs.x < rhs.x && lhs.y < rhs.y
}

struct Rect: Equatable {
    var origin: Point
    var size: Size

    fileprivate var end: Point {
        return Point(x: origin.x + size.width, y: origin.y + size.height)
    }
}

func ==(lhs: Rect, rhs: Rect) -> Bool {
    return lhs.origin == rhs.origin && lhs.size == rhs.size
}

extension Rect {
    init(x: Int, y: Int, width: Int, height: Int) {
        self.init(origin: Point(x: x, y: y), size: Size(width: width, height: height))
    }
}

struct Size: Equatable {
    var width: Int
    var height: Int
}

func ==(lhs: Size, rhs: Size) -> Bool {
    return lhs.width == rhs.width && lhs.height == rhs.height
}

// MARK: - LightGrid

class LightGrid {
    private var grid: [[Int]]

    init(size: Size) {
        grid = Array(repeating: Array(repeating: 0, count: size.height), count: size.width)
    }

    convenience init(width: Int, height: Int) {
        self.init(size: Size(width: width, height: height))
    }

    var width: Int {
        return grid[0].count
    }
    var height: Int {
        return grid.count
    }

    var lightsOn: Int {
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

    var brightness: Int {
        return grid.reduce(0) { subtotal, column in
            subtotal + column.reduce(0, +)
        }
    }

    subscript(x: Int, y: Int) -> Int {
        get {
            return grid[x][y]
        }
        set(newValue) {
            grid[x][y] = newValue
        }
    }

    subscript(row row: Int, column column: Int) -> Int {
        get {
            return self[column, row]
        }
        set(newValue) {
            self[column, row] = newValue
        }
    }

    func contains(point: Point) -> Bool {
        return 0 <= point.x && point.x < width && 0 <= point.y && point.y < height
    }

    private func modulate(lower: Point, upper: Point, f: (Int) -> Int) {
        for x in lower.x..<upper.x {
            for y in lower.y..<upper.y {
                self[x, y] = f(self[x, y])
            }
        }
    }

    func increaseBrightness(by n: Int, area: Rect) {
        modulate(lower: area.origin, upper: area.end) { $0 + n }
    }

    func decreaseBrightness(by n: Int, area: Rect) {
        modulate(lower: area.origin, upper: area.end) { $0 - n }
    }

    func turnOn(area: Rect) {
        modulate(lower: area.origin, upper: area.end) { _ in 1 }
    }

    func turnOff(area: Rect) {
        modulate(lower: area.origin, upper: area.end) { _ in 0 }
    }

    func toggle(area: Rect) {
        modulate(lower: area.origin, upper: area.end) { value in
            if value != 0 {
                return 0
            } else {
                return 1
            }
        }
    }
}

// MARK: - Parser

private let regex =
    try! NSRegularExpression(pattern: "(turn on|turn off|toggle)\\s+(\\d+)\\s*,(\\d+)\\s+through\\s(\\d+)\\s*,(\\d+)",
                             options: [])

enum LightGridCommand: Equatable {
    case turnOn(area: Rect), turnOff(area: Rect), toggle(area: Rect)

    init?(command: String) {
        let nsCommand = command as NSString
        guard let parsed =
            regex.firstMatch(in: command, options: [], range: NSMakeRange(0, nsCommand.length)) else {
                return nil
        }
        guard let x0 = Int(nsCommand.substring(with: parsed.range(at: 2))) else {
            return nil
        }
        guard let y0 = Int(nsCommand.substring(with: parsed.range(at: 3))) else {
            return nil
        }
        guard let x1 = Int(nsCommand.substring(with: parsed.range(at: 4))) else {
            return nil
        }
        guard let y1 = Int(nsCommand.substring(with: parsed.range(at: 5))) else {
            return nil
        }
        switch nsCommand.substring(with: parsed.range(at: 1)) {
        case "turn on":
            self = .turnOn(area: Rect(x: x0, y: y0, width: x1 - x0 + 1, height: y1 - y0 + 1))
        case "turn off":
            self = .turnOff(area: Rect(x: x0, y: y0, width: x1 - x0 + 1, height: y1 - y0 + 1))
        case "toggle":
            self = .toggle(area: Rect(x: x0, y: y0, width: x1 - x0 + 1, height: y1 - y0 + 1))
        default:
            return nil
        }
    }
}

func ==(lhs: LightGridCommand, rhs: LightGridCommand) -> Bool {
    switch (lhs, rhs) {
    case let (.turnOn(area), .turnOn(expectedArea)):
        return area == expectedArea
    case let (.toggle(area), .toggle(expectedArea)):
        return area == expectedArea
    case let (.turnOff(area), .turnOff(expectedArea)):
        return area == expectedArea
    default:
        return false
    }
}

// MARK: - Solution

class Day6: Solution {
    private static var memo: [String: (bool: LightGrid, int: LightGrid)] = [:]

    required init() {}

    var name = "Day 6"

    func part1(input: String) {
        let grids = Day6.lookup(input)
        print("\(grids.bool.lightsOn) lights are lit")
    }

    func part2(input: String) {
        let grids = Day6.lookup(input)
        print("The total brightness is \(grids.int.brightness)")
    }

    private class func populatedGrids(commands: String) -> (bool: LightGrid, int: LightGrid) {
        let grids = (bool: LightGrid(width: 1000, height: 1000), int: LightGrid(width: 1000, height: 1000))
        for case let command? in commands.characters.split(separator: "\n").lazy.map(String.init).map(LightGridCommand.init) {
            switch command {
            case let .turnOn(area):
                grids.bool.turnOn(area: area)
                grids.int.turnOn(area: area)
            case let .turnOff(area):
                grids.bool.turnOff(area: area)
                grids.int.turnOff(area: area)
            case let .toggle(area):
                grids.bool.toggle(area: area)
                grids.int.increaseBrightness(by: 2, area: area)
            }
        }
        return grids
    }

    private class func lookup(_ str: String) -> (bool: LightGrid, int: LightGrid) {
        let grids: (bool: LightGrid, int: LightGrid)
        if let value = memo[str] {
            grids = value
        } else {
            grids = Day6.populatedGrids(commands: str)
            memo[str] = grids
        }
        return grids
    }
}
