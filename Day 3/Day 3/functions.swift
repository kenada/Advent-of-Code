//
//  functions.swift
//  Day 3
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

import Foundation

extension CGPoint: Hashable {
    public var hashValue: Int {
        return self.x.hashValue << 16 | self.y.hashValue
    }
}

func +(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
    return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
}

func +=(inout lhs: CGPoint, rhs: CGPoint) {
    lhs = lhs + rhs
}

func interpret(direction: Character) -> CGPoint {
    switch direction {
    case "<":
        return CGPoint(x: -1, y: 0)
    case "^":
        return CGPoint(x: 0, y: +1)
    case "v":
        return CGPoint(x: 0, y: -1)
    case ">":
        return CGPoint(x: +1, y: 0)
    default:
        return CGPoint()
    }
}

func housesVisited<S: SequenceType where S.Generator.Element == Character>(directions: S) -> Set<CGPoint> {
    var currentPosition = CGPoint(x: 0, y: 0)
    var housesVisited = Set(arrayLiteral: currentPosition)
    for direction in directions {
        currentPosition += interpret(direction)
        housesVisited.insert(currentPosition)
    }
    return housesVisited
}

func countHousesVisited(directions: String, roboSanta: Bool = false) -> Int {
    let chs = directions.characters
    if roboSanta {
        let santa = zip(chs, Range(start: 0, end: chs.count)).filter { $0.1 % 2 == 0 }.map { $0.0 }
        let robo = zip(chs, Range(start: 0, end: chs.count)).filter { $0.1 % 2 != 0 }.map { $0.0 }
        return housesVisited(santa).union(housesVisited(robo)).count
    } else {
        return housesVisited(chs).count
    }
}