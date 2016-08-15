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
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
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
            Route(start: "London", end: "Dublin"): 464,
            Route(start: "London", end: "Belfast"): 518,
            Route(start: "Dublin", end: "Belfast"): 141
        ]
        let cases = [
            (stops: ["Dublin", "London", "Belfast"], distance: 982),
            (stops: ["London", "Dublin", "Belfast"], distance: 605),
            (stops: ["London", "Belfast", "Dublin"], distance: 659),
            (stops: ["Dublin", "Belfast", "London"], distance: 659),
            (stops: ["Belfast", "Dublin", "London"], distance: 605),
            (stops: ["Belfast", "London", "Dublin"], distance: 982)
        ]
        for test in cases {
            XCTAssertEqual(distance(via: test.stops, following: distances), test.distance, "\(test.stops)")
        }
    }

    private func verify<Element: Comparable>(source: [Element], expected: [[Element]]) {
        let permutations = source.permutations
        // Verify count
        var count = 0
        let iterator = permutations.makeIterator()
        var element: [Element]?
        repeat {
            element = iterator.next()
            count += 1
        } while element != nil

        // Verify elements
        XCTAssertEqual(expected.count, count, "permutations.count \(count) == 6")
        for (index, permutation) in permutations.enumerated() {
            XCTAssertEqual(permutation, expected[index], "permutation: \(permutation) == expected: \(expected[index])")
        }
    }
}
