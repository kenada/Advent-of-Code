//
//  Day_9_Tests.swift
//  Day 9 Tests
//
//  Copyright © 2016 Randy Eckenrode. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a
//  copy of this software and associated documentation files (the “Software”),
//  to deal in the Software without restriction, including without limitation
//  the rights to use, copy, modify, merge, publish, distribute, sublicense,
//  and/or sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
//  DEALINGS IN THE SOFTWARE.
//


import XCTest

class Day_9_Tests: XCTestCase {
    
    func testPermutations() {
        let src = [1, 2, 3]
        let expected = [
            [1, 2, 3],
            [1, 3, 2],
            [3, 1, 2],
            [3, 2, 1],
            [2, 3, 1],
            [2, 1, 3]
        ]
        verify(source: src, expected: expected)
    }

    func testPermutationCount() {
        let test = [1, 2, 3, 4, 5, 6, 7, 8, 9]
        let count = Array(test.permutations).count
        XCTAssertEqual(test.indices.reduce(1, { ($1 + 1) * $0 }), count)
    }

    func testStringPermutations() {
        let src = ["a", "b"]
        let expected = [
            ["a", "b"],
            ["b", "a"]
        ]
        verify(source: src, expected: expected)
    }

    func testDistance() {
        let distances = [
            Route("London", "Dublin"): 464,
            Route("London", "Belfast"): 518,
            Route("Dublin", "Belfast"): 141
        ]
        let cases: [(stops: [String], distance: Int?)] = [
            (stops: ["Dublin", "London", "Belfast"], distance: 982),
            (stops: ["London", "Dublin", "Belfast"], distance: 605),
            (stops: ["London", "Belfast", "Dublin"], distance: 659),
            (stops: ["Dublin", "Belfast", "London"], distance: 659),
            (stops: ["Belfast", "Dublin", "London"], distance: 605),
            (stops: ["Belfast", "London", "Dublin"], distance: 982),
            (stops: ["A", "B", "C"], distance: nil)
        ]
        for test in cases {
            XCTAssertEqual(distance(via: test.stops, following: distances), test.distance, "\(test.stops)")
        }
    }

    func testShortestDistance() {
        let routes = [
            Route("London", "Dublin"): 464,
            Route("London", "Belfast"): 518,
            Route("Dublin", "Belfast"): 141
        ]
        let cities = [
            "London", "Dublin", "Belfast"
        ]
        let expected = 605
        XCTAssertEqual(shortestDistance(via: cities, following: routes), expected)
    }

    func testLongestDistance() {
        let routes = [
            Route("London", "Dublin"): 464,
            Route("London", "Belfast"): 518,
            Route("Dublin", "Belfast"): 141
        ]
        let cities = [
            "London", "Dublin", "Belfast"
        ]
        let expected = 982
        XCTAssertEqual(longestDistance(via: cities, following: routes), expected)
    }

    func testWords() {
        let test = "The quick brown fox jumped over the lazy dog."
        let expected = [
            "The".characters,
            "quick".characters,
            "brown".characters,
            "fox".characters,
            "jumped".characters,
            "over".characters,
            "the".characters,
            "lazy".characters,
            "dog.".characters
        ]
        let results = test.characters.words
        for (result, expected) in zip(results, expected) {
            XCTAssertEqual(String(result), String(expected))
        }
    }

    func testParsing() {
        let input = [
            "London to Dublin = 464",
            "London to Belfast = 518",
            "Dublin to Belfast = 141",
            "chopped",
            "London to Dublin = foo"
        ]
        let expected: [(route: Route, distance: Int)?] = [
            (route: Route("London", "Dublin"), distance: 464),
            (route: Route("London", "Belfast"), distance: 518),
            (route: Route("Dublin", "Belfast"), distance: 141),
            nil, nil
        ]
        for (string, expected) in zip(input, expected) {
            if let (route, distance) = parsed(text: string) {
                XCTAssertEqual(route, expected!.route)
                XCTAssertEqual(distance, expected!.distance)
            } else {
                XCTAssertNil(expected)
            }
        }
    }

    private func verify<Element: Comparable>(source: [Element], expected: [[Element]]) {
        let permutations = source.permutations

        // Verify count
        let count = Array(permutations).count
        XCTAssertEqual(expected.count, count, "permutations.count \(count) == \(expected.count)")

        // Verify elements
        for (index, permutation) in permutations.enumerated() {
            XCTAssertEqual(permutation, expected[index], "permutation: \(permutation) == expected: \(expected[index])")
        }
    }
}
