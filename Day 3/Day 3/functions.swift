//
//  functions.swift
//  Day 3
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

import Foundation

extension CGPoint: Hashable {
    public var hashValue: Int {
        return self.x.hashValue << 16 | self.y.hashValue
    }
}

func +(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
    return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
}

func +=(lhs: inout CGPoint, rhs: CGPoint) {
    lhs = lhs + rhs
}

typealias Direction = Character

func next(following direction: Direction) -> CGPoint {
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

func housesVisited<S: Sequence>(following directions: S) -> Set<CGPoint> where S.Iterator.Element == Character {
    var currentPosition = CGPoint(x: 0, y: 0)
    var housesVisited = Set(arrayLiteral: currentPosition)
    for direction in directions {
        currentPosition += next(following: direction)
        housesVisited.insert(currentPosition)
    }
    return housesVisited
}

func countOfHousesVisited<S: Sequence>(following chs: S, withRoboSanta: Bool = false) -> Int where S.Iterator.Element == Character {
    if withRoboSanta {
        let santaDirections = chs.enumerated().filter { $0.0 % 2 == 0 }.map { $0.1 }
        let roboDirections = chs.enumerated().filter { $0.0 % 2 != 0 }.map { $0.1 }
        return housesVisited(following: santaDirections).union(housesVisited(following: roboDirections)).count
    } else {
        return housesVisited(following: chs).count
    }
}
