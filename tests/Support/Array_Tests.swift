//
//  Array Tests.swift
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

class Array_Tests: XCTestCase {
    
    func testPermutations() {
        let src = [1, 2, 3]
        let expected = [
            [1, 2, 3],
            [1, 3, 2],
            [3, 1, 2],
            [3, 2, 1],
            [2, 3, 1],
            [2, 1, 3]
        ]
        verify(source: src, expected: expected)
    }

    func testPermutationCount() {
        let test = [1, 2, 3, 4, 5, 6, 7, 8, 9]
        let count = Array(test.permutations).count
        XCTAssertEqual(test.indices.reduce(1, { ($1 + 1) * $0 }), count)
    }

    func testStringPermutations() {
        let src = ["a", "b"]
        let expected = [
            ["a", "b"],
            ["b", "a"]
        ]
        verify(source: src, expected: expected)
    }

    private func verify<Element: Comparable>(source: [Element], expected: [[Element]]) {
        let permutations = source.permutations

        // Verify count
        let count = Array(permutations).count
        XCTAssertEqual(expected.count, count, "permutations.count \(count) == \(expected.count)")

        // Verify elements
        for (index, permutation) in permutations.enumerated() {
            XCTAssertEqual(permutation, expected[index], "permutation: \(permutation) == expected: \(expected[index])")
        }
    }
}
