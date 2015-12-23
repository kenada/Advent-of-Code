//
//  Day_6_Tests.swift
//  Day 6 Tests
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

class Day_6_LightGrid_Tests: XCTestCase {
    
    var grid: LightGrid!
    
    override func setUp() {
        grid = LightGrid(width: 1000, height: 1000)
    }
    
    func testTurnOn() {
        let area = Rect(x: 0, y: 0, width: 1000, height: 1000)
        grid.draw(area, op: .SourceOver)
        XCTAssertEqual(grid.lightCount, 1000000)
    }
    
    func testToggle() {
        let area = Rect(x: 0, y: 0, width: 1000, height: 1)
        grid.draw(area, op: .Xor)
        XCTAssertEqual(grid.lightCount, 1000)
    }
    
    func testTurnOff() {
        let area = Rect(x: 499, y: 499, width: 1, height: 1)
        grid.draw(area, op: .Clear)
        XCTAssertEqual(grid.lightCount, 1)
    }
    
}

class Day_6_Parser_Tests: XCTestCase {
    
    func testParser() {
        let cases = [
            (string: "turn on 0,0 through 999,999",
                expectedResult: LightGridCommand.TurnOn(area: Rect(x: 0, y: 0, width: 1000, height: 1000))),
            (string: "toggle 0,0 through 999,0",
                expectedResult: .Toggle(area: Rect(x: 0, y: 0, width: 1000, height: 1))),
            (string: "turn off 499,499 through 500,500",
                expectedResult: .TurnOff(area: Rect(x: 499, y: 499, width: 1, height: 1)))
        ]
        for `case` in cases {
            let command = LightGridCommand(command: `case`.string)
            XCTAssertEqual(command, `case`.expectedResult, "parsing input: \(`case`.string)")
        }
    }
    
}