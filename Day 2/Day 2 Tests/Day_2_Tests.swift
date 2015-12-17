//
//  Day_2_Tests.swift
//  Day 2 Tests
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

class Day_2_Tests: XCTestCase {
    
    func testPackageLoading() {
        // Data URL contents
        // -----------------
        // 5x5x5
        let data = NSURL(string: "data:text/plain;base64,NXg1eDUK")
        XCTAssertNotNil(data)
        
        let boxes = readPackages(data!)
        XCTAssertEqual(boxes.count, 1, "the array of boxes contains one element")
        
        XCTAssertEqual(boxes[0].length, 5, "the box has the expected length")
        XCTAssertEqual(boxes[0].width,  5, "the box has the expected width")
        XCTAssertEqual(boxes[0].height, 5, "the box has the expected height")
    }
    
    func testExcludesIllformedLines() {
        /// Data URL contents
        /// -----------------
        /// 1x2x3
        /// 4x5x6x7
        /// 8x9
        /// 10x11x12
        let data = NSURL(string: "data:text/plain;base64,MXgyeDMKNHg1eDZ4Nwo4eDkKMTB4MTF4MTIK")
        XCTAssertNotNil(data)
        
        let boxes = readPackages(data!)
        XCTAssertEqual(boxes.count, 2, "the array of boxes contains only two elements")
        
        XCTAssertEqual(boxes[0].length, 1, "the first box has the expected length")
        XCTAssertEqual(boxes[0].width,  2, "the first box has the expected width")
        XCTAssertEqual(boxes[0].height, 3, "the first box has the expected height")
        
        XCTAssertEqual(boxes[1].length, 10, "the second box has the expected length")
        XCTAssertEqual(boxes[1].width,  11, "the second box has the expected width")
        XCTAssertEqual(boxes[1].height, 12, "the second box has the expected height")
    }
    
    func testReturnsAnEmptyArrayForAnEmptyFile() {
        let data = NSURL(string: "data:")
        XCTAssertNotNil(data)
        
        let boxes = readPackages(data!)
        XCTAssertTrue(boxes.isEmpty, "the array of boxes is empty")
    }
    
    func testReturnsAnEmptyArrayForABadFile() {
        /// Data URL contents
        /// -----------------
        /// Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor
        /// incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud
        /// exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure
        /// dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla
        /// pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia
        /// deserunt mollit anim id est laborum.
        let data = NSURL(string: "data:text/plain;base64,TG9yZW0gaXBzdW0gZG9sb3Igc2l0IGFtZXQsIGNvbnNlY3RldHVyIGFkaXBpc2NpbmcgZWxpdCwgc2VkIGRvIGVpdXNtb2QgdGVtcG9yCmluY2lkaWR1bnQgdXQgbGFib3JlIGV0IGRvbG9yZSBtYWduYSBhbGlxdWEuIFV0IGVuaW0gYWQgbWluaW0gdmVuaWFtLCBxdWlzIG5vc3RydWQKZXhlcmNpdGF0aW9uIHVsbGFtY28gbGFib3JpcyBuaXNpIHV0IGFsaXF1aXAgZXggZWEgY29tbW9kbyBjb25zZXF1YXQuIER1aXMgYXV0ZSBpcnVyZQpkb2xvciBpbiByZXByZWhlbmRlcml0IGluIHZvbHVwdGF0ZSB2ZWxpdCBlc3NlIGNpbGx1bSBkb2xvcmUgZXUgZnVnaWF0IG51bGxhCnBhcmlhdHVyLiBFeGNlcHRldXIgc2ludCBvY2NhZWNhdCBjdXBpZGF0YXQgbm9uIHByb2lkZW50LCBzdW50IGluIGN1bHBhIHF1aSBvZmZpY2lhCmRlc2VydW50IG1vbGxpdCBhbmltIGlkIGVzdCBsYWJvcnVtLg==")
        XCTAssertNotNil(data)
        
        let boxes = readPackages(data!)
        XCTAssertTrue(boxes.isEmpty, "the array of boxes is empty")
    }
    
    func testSurfaceAreaCalculation() {
        let tests = [
            (box: Box(length: 2, width: 3, height: 4), expectedResult: 52),
            (box: Box(length: 1, width: 1, height: 10), expectedResult: 42)
        ]
        for test in tests {
            XCTAssertEqual(test.box.surfaceArea, test.expectedResult)
        }
    }
    
    func testVolumeCalculation() {
        let tests = [
            (box: Box(length: 2, width: 3, height: 4), expectedResult: 24),
            (box: Box(length: 1, width: 1, height: 10), expectedResult: 10)
        ]
        for test in tests {
            XCTAssertEqual(test.box.volume, test.expectedResult)
        }
    }
    
    func testSlackCalculation() {
        let tests = [
            (box: Box(length: 2, width: 3, height: 4), expectedResult: 6),
            (box: Box(length: 1, width: 1, height: 10), expectedResult: 1)
        ]
        for test in tests {
            XCTAssertEqual(test.box.slack, test.expectedResult)
        }
    }
    
    func testRibbonLengthCalculation() {
        let tests = [
            (box: Box(length: 2, width: 3, height: 4), expectedResult: 10),
            (box: Box(length: 1, width: 1, height: 10), expectedResult: 4)
        ]
        for test in tests {
            XCTAssertEqual(test.box.ribbonLength, test.expectedResult)
        }
    }
    
}
