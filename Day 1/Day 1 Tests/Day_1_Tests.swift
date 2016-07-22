//
//  Day_1_Tests.swift
//  Day 1 Tests
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

class Day_1_Tests: XCTestCase {
    
    typealias InstructionsCases = (instructions: String, expectedFloor: Floor, expectedBasementPosition: Int?)

    let cases: [InstructionsCases] = [
        (instructions: "(())", expectedFloor: 0, expectedBasementPosition: nil),
        (instructions: "()()", expectedFloor: 0, expectedBasementPosition: nil),
        (instructions: "(((", expectedFloor: 3, expectedBasementPosition: nil),
        (instructions: "(()(()(", expectedFloor: 3, expectedBasementPosition: nil),
        (instructions: "))(((((", expectedFloor: 3, expectedBasementPosition: 1),
        (instructions: "())", expectedFloor: -1, expectedBasementPosition: 3),
        (instructions: "))(", expectedFloor: -1, expectedBasementPosition: 1),
        (instructions: ")))", expectedFloor: -3, expectedBasementPosition: 1),
        (instructions: ")())())", expectedFloor: -3, expectedBasementPosition: 1)
    ]

    
    func testFloorInstructions() {
        cases.forEach { testCase in
            let directions = from(string: testCase.instructions)
            let floor = followed(directions: directions, until: .finished)
            XCTAssert(floor == testCase.expectedFloor,
                "floor: \(floor) == expected \(testCase.expectedFloor)")
        }
    }
    
    func testFloorPosition() {
        cases.forEach { testCase in
            let directions = from(string: testCase.instructions)
            let position = followed(directions: directions, until: .enteredBasement)
            XCTAssert(position == testCase.expectedBasementPosition,
                "position: \(position) == expected: \(testCase.expectedBasementPosition)")
        }
    }
    
}
