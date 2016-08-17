//
//  Day_4_Tests.swift
//  Day 4 Tests
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

import Foundation
import XCTest

class Day_4_Tests: XCTestCase {
    
    func testMD5() {
        XCTAssertEqual(md5(string: "hashtest"),
            [0x49, 0x38, 0x52, 0x78, 0x62, 0x70, 0xB6, 0x8E, 0x18, 0x2d, 0x6e, 0xb9, 0x39, 0xb1, 0xF8, 0x02])
        
        let testBundle = Bundle(for: Day_4_Tests.self)
        let path = testBundle.url(forResource: "md5.swift", withExtension: "txt")
        XCTAssertNotNil(path)
        
        let contents = try? Data(contentsOf: path!)
        XCTAssertNotNil(contents)

        var array: [UInt8] = [UInt8](repeating: 0, count: contents!.count)
        array.withUnsafeMutableBufferPointer { _ = contents!.copyBytes(to: $0) }
        XCTAssertEqual(md5(bytes: array),
            [0xDC, 0x48, 0x18, 0x92, 0x22, 0x21, 0x89, 0x6A, 0xBF, 0xBE, 0x58, 0xCC, 0xC3, 0xD0, 0xDA, 0x44])
    }
    
    func testPart1() {
        let cases = [
            (secret: "abcdef", expectedResult: 609043),
            (secret: "pqrstuv", expectedResult: 1048970)
        ]
        
        for `case` in cases {
            XCTAssertEqual(matching(hash: `case`.secret, withLeadingZeroes: 5).value, `case`.expectedResult, "finding hash for: \(`case`.secret)")
        }
    }
    
}
