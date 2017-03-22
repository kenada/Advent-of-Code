//
//  Day_13_Tests.swift
//  Advent of Code 2015
//
// Copyright © 2017 Randy Eckenrode
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

@testable import Advent_of_Code_2015
import AdventSupport
import Foundation
import XCTest

class Day_13_Tests: XCTestCase {

    func testHappiness() {
        let table = [
            "Alice", "David", "Carol", "Bob"
        ]
        let relationships = [
            Pair("Alice", "Bob"): 54,
            Pair("Alice", "Carol"): -79,
            Pair("Alice", "David"): -2,
            Pair("Bob", "Alice"): 83,
            Pair("Bob", "Carol"): -7,
            Pair("Bob", "David"): -63,
            Pair("Carol", "Alice"): -62,
            Pair("Carol", "Bob"): 60,
            Pair("Carol", "David"): 55,
            Pair("David", "Alice"): 46,
            Pair("David", "Bob"): -7,
            Pair("David", "Carol"): 41
        ]

        XCTAssertEqual(happiness(of: table, withRelationships: relationships), 330)
    }

    func testPairing() {
        let table = [
            "Alice", "David", "Carol", "Bob"
        ]
        let result = [
            Pair("Alice", "David"),
            Pair("David", "Alice"),
            Pair("David", "Carol"),
            Pair("Carol", "David"),
            Pair("Carol", "Bob"),
            Pair("Bob", "Carol"),
            Pair("Bob", "Alice"),
            Pair("Alice", "Bob")
        ]

        XCTAssertEqual(pairs(of: table).sorted(), result.sorted())
    }

    func testParsing() {
        let input = [
            "Alice would gain 54 happiness units by sitting next to Bob.",
            "Alice would lose 79 happiness units by sitting next to Carol.",
            "Alice would lose 2 happiness units by sitting next to David.",
            "Bob would gain 83 happiness units by sitting next to Alice.",
            "Bob would lose 7 happiness units by sitting next to Carol.",
            "Bob would lose 63 happiness units by sitting next to David.",
            "Carol would lose 62 happiness units by sitting next to Alice.",
            "Carol would gain 60 happiness units by sitting next to Bob.",
            "Carol would gain 55 happiness units by sitting next to David.",
            "David would gain 46 happiness units by sitting next to Alice.",
            "David would lose 7 happiness units by sitting next to Bob.",
            "David would gain 41 happiness units by sitting next to Carol."
        ]
        let results = [
            (Pair("Alice", "Bob"), 54),
            (Pair("Alice", "Carol"), -79),
            (Pair("Alice", "David"), -2),
            (Pair("Bob", "Alice"), 83),
            (Pair("Bob", "Carol"), -7),
            (Pair("Bob", "David"), -63),
            (Pair("Carol", "Alice"), -62),
            (Pair("Carol", "Bob"), 60),
            (Pair("Carol", "David"), 55),
            (Pair("David", "Alice"), 46),
            (Pair("David", "Bob"), -7),
            (Pair("David", "Carol"), 41)
        ]
        zip(input, results).forEach { (line, result) in
            let parsedLine = parsed(ofDay13: line)
            XCTAssertNotNil(parsedLine)
            if let parsedLine = parsedLine {
                XCTAssertEqual(parsedLine.0.first, result.0.first)
                XCTAssertEqual(parsedLine.0.second, result.0.second)
                XCTAssertEqual(parsedLine.1, result.1)
            }
        }
    }

}
