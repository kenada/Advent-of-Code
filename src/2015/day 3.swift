//
//  day 3.swift
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

// MARK: - Solution

class Day3: Solution {
    required init() {}

    var name = "Day 3"

    func part1(input: String) {
        let housesVisited = countOfHousesVisited(following: input.characters)
        print("Santa visited \(housesVisited) unique houses")
    }

    func part2(input: String) {
        let housesVisitedTogetehr = countOfHousesVisited(following: input.characters, withRoboSanta: true)
        print("Santa and RoboSanta visited \(housesVisitedTogetehr) unique houses together")
    }
}
