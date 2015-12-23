//
//  Day_5_Tests.swift
//  Day 5 Tests
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

import XCTest

class Day_5_Tests: XCTestCase {
    
    func testClassification() {
        let cases: [(input: String, expectedResult: NaughtyOrNice)] = [
            (input: "ugknbfddgicrmopn", expectedResult: .Nice),
            (input: "aaa", expectedResult: .Nice),
            (input: "jchzalrnumimnmhp", expectedResult: .Naughty),
            (input: "haegwjzuvuyypxyu", expectedResult: .Naughty),
            (input: "dvszwmarrgswjxmb", expectedResult: .Naughty)
        ]
        for `case` in cases {
            XCTAssertEqual(NaughtyOrNice(string: `case`.input), `case`.expectedResult,
                "Checking whether \(`case`.input) is naughty or nice")
        }
    }
    
    func testImprovedClassification() {
        let cases: [(input: String, expectedResult: NaughtyOrNice)] = [
            (input: "aabcdefegaa", expectedResult: .Nice),
            (input: "qjhvhtzxzqqjkmpb", expectedResult: .Nice),
            (input: "xxyxx", expectedResult: .Nice),
            (input: "uurcxstgmygtbstg", expectedResult: .Naughty),
            (input: "ieodomkazucvgmuy", expectedResult: .Naughty)
        ]
        for `case` in cases {
            XCTAssertEqual(NaughtyOrNice(string: `case`.input, improvedChecks: true), `case`.expectedResult,
                "Checking whether \(`case`.input) is naughty or nice")
        }
    }
    
}
