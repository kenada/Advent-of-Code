//
//  String_Tests.swift
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

class String_Tests: XCTestCase {

    func testWords() {
        let test = "The quick brown fox jumped over the lazy dog."
        let expected = [
            "The".characters,
            "quick".characters,
            "brown".characters,
            "fox".characters,
            "jumped".characters,
            "over".characters,
            "the".characters,
            "lazy".characters,
            "dog.".characters
        ]
        let results = test.characters.words
        for (result, expected) in zip(results, expected) {
            XCTAssertEqual(String(result), String(expected))
        }
    }

    func testLines() {
        let test = "A\nB\nC\nD"
        let expected = ["A", "B", "C", "D"]
        let results = test.lines
        for (result, expected) in zip(results, expected) {
            XCTAssertEqual(String(result), String(expected))
        }
    }

}
