//
//  MD5Tests.swift
//  AdventSupport
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

@testable import AdventSupport
import XCTest

class MD5_Tests: XCTestCase {

    func testShortString() {
        XCTAssertEqual(md5(string: "hashtest"),
                       [0x49, 0x38, 0x52, 0x78, 0x62, 0x70, 0xB6, 0x8E, 0x18, 0x2d, 0x6e, 0xb9, 0x39, 0xb1, 0xF8, 0x02])
    }

    func testFile() {
        let testBundle = Bundle(for: MD5_Tests.self)
        let path = testBundle.url(forResource: "md5", withExtension: "swift")
        XCTAssertNotNil(path)

        let contents = try? Data(contentsOf: path!)
        XCTAssertNotNil(contents)

        var array: [UInt8] = [UInt8](repeating: 0, count: contents!.count)
        array.withUnsafeMutableBufferPointer { _ = contents!.copyBytes(to: $0) }
        XCTAssertEqual(md5(bytes: array),
                       [0xa8, 0xb4, 0x37, 0xe3, 0x51, 0x16, 0x66, 0x1d, 0x26, 0xa9, 0xd8, 0x67, 0xcf, 0xe4, 0xe7, 0xa3])
    }

}
