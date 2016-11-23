//
//  Day_12_Tests.swift
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
import Foundation
import XCTest

class Day_12_Tests: XCTestCase {

    func testSumFilter() {
        let cases = [
            (json: "[ \"hello\", 3, true ]", expectedResult: 3.0),
            (json: "{ \"someKey\": 42.0, \"anotherKey\": { \"someNestedKey\": true } }", expectedResult: 42),
            (json: "[1, 2, 3]", expectedResult: 6),
            (json: "{\"a\": 2, \"b\": 4}", expectedResult: 6),
            (json: "[[[3]]]", expectedResult: 3),
            (json: "{\"a\": { \"b\": 4 }, \"c\": -1 }", expectedResult: 3),
            (json: "{\"a\": [-1, 1]}", expectedResult: 0),
            (json: "[-1, {\"a\": 1}]", expectedResult: 0),
            (json: "[]", expectedResult: 0),
            (json: "{}", expectedResult: 0)
        ]
        cases.forEach { testCase in
            let jsonData = testCase.json.data(using: String.Encoding.utf8)
            XCTAssertNotNil(jsonData)

            let jsonObject = try? JSONSerialization.jsonObject(with: jsonData!)
            XCTAssertNotNil(jsonObject)

            XCTAssertEqual(sum(jsonObject: jsonObject!), testCase.expectedResult)
        }
    }

    func testSumFilterIgnoring() {
        let cases = [
            (json: "[ \"hello\", 3, true ]", expectedResult: 3.0),
            (json: "{ \"someKey\": 42.0, \"anotherKey\": { \"someNestedKey\": true } }", expectedResult: 42),
            (json: "[1, 2, 3]", expectedResult: 6),
            (json: "[1, {\"c\": \"red\", \"b\": 2}, 3]", expectedResult: 4),
            (json: "{\"d\": \"red\", \"e\": [1, 2, 3, 4], \"f\": 5}", expectedResult: 0),
            (json: "[1, \"red\", 5]", expectedResult: 6)
        ]
        cases.forEach { testCase in
            let jsonData = testCase.json.data(using: String.Encoding.utf8)
            XCTAssertNotNil(jsonData)

            let jsonObject = try? JSONSerialization.jsonObject(with: jsonData!)
            XCTAssertNotNil(jsonObject)

            XCTAssertEqual(sum(jsonObject: jsonObject!, ignoring: hasRedProperty), testCase.expectedResult)
        }
    }
    
}
