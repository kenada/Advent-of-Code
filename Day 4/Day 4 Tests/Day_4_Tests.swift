//
//  Day_4_Tests.swift
//  Day 4 Tests
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

import Foundation
import XCTest

class Day_4_Tests: XCTestCase {
    
    func testMD5() {
        XCTAssertEqual(md5("hashtest"),
            [0x49, 0x38, 0x52, 0x78, 0x62, 0x70, 0xB6, 0x8E, 0x18, 0x2d, 0x6e, 0xb9, 0x39, 0xb1, 0xF8, 0x02])
        
        let testBundle = NSBundle(forClass: Day_4_Tests.self)
        let path = testBundle.pathForResource("md5.swift", ofType: "txt")
        XCTAssertNotNil(path)
        
        let contents = try? String(contentsOfFile: path!)
        XCTAssertNotNil(contents)
        
        XCTAssertEqual(md5(contents!),
            [0xF5, 0xB1, 0xF2, 0x10, 0xAA, 0xE5, 0x65, 0x1E, 0x53, 0x93, 0x33, 0x82, 0xC1, 0xB4, 0x4C, 0x13])
    }
    
    func testPart1() {
        let cases = [
            (secret: "abcdef", expectedResult: 609043),
            (secret: "pqrstuv", expectedResult: 1048970)
        ]
        
        for `case` in cases {
            XCTAssertEqual(findHash(`case`.secret).value, `case`.expectedResult, "finding hash for: \(`case`.secret)")
        }
    }
    
}
