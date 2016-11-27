//
//  Day_10_Tests.swift
//  Advent of Code 2015
//
// Copyright © 2016 Randy Eckenrode
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
import XCTest

class Day_10_Tests: XCTestCase {
    
    public func testTransformed() {
        let cases = [
            (input: [1], expected: [1,1]),
            (input: [1,1], expected: [2,1]),
            (input: [2,1], expected: [1,2,1,1]),
            (input: [1,2,1,1], expected: [1,1,1,2,2,1]),
            (input: [1,1,1,2,2,1], expected: [3,1,2,2,1,1])
        ]
        for testCase in cases {
            XCTAssertEqual(testCase.input.lookedAndSaid, testCase.expected)
        }
    }
    
}
