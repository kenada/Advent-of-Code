//
//  Day_8_Tests.swift
//  Day 8 Tests
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

class Day_8_Tests: XCTestCase {
    
    func testEscape() {
        let cases = [
            (string: "", expectedString: ""),
            (string: "abc", expectedString: "abc"),
            (string: "aaa\\\"aaa", expectedString: "aaa\"aaa"),
            (string: "\\x27", expectedString: "'")
        ]
        for `case` in cases {
            XCTAssertEqual(`case`.string.escaped, `case`.expectedString, "strings are escaped correctly")
        }
    }
    
    func testEncode() {
        let cases = [
            (string: "", expectedString: "\\\"\\\""),
            (string: "abc", expectedString: "\\\"abc\\\""),
            (string: "aaa\\\"aaa", expectedString: "\\\"aaa\\\\\\\"aaa\\\""),
            (string: "\\x27", expectedString: "\\\"\\\\x27\\\"")
        ]
        for `case` in cases {
            XCTAssertEqual(String(xmasEncode: `case`.string), `case`.expectedString, "strings are encoded correctly")
        }
    }
    
    func testLiteralSize() {
        let cases = [
            (string: "", expectedSize: 2),
            (string: "abc", expectedSize: 5),
            (string: "aaa\\\"aaa", expectedSize: 10),
            (string: "\\x27", expectedSize: 6),
        ]
        for `case` in cases {
            XCTAssertEqual(`case`.string.literalSize, `case`.expectedSize, "expected: \(`case`.string)")
        }
    }
    
    func testStringSize() {
        let cases = [
            (string: "", expectedSize: 0),
            (string: "abc", expectedSize: 3),
            (string: "aaa\"aaa", expectedSize: 7),
            (string: "'", expectedSize: 1),
        ]
        for `case` in cases {
            XCTAssertEqual(`case`.string.escaped.size, `case`.expectedSize, "expected: \(`case`.string)")
        }
    }
    
}
