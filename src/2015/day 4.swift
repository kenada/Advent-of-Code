//
//  day 4.swift
//  Advent of Code 2015
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

import AdventSupport
import Foundation

func from(hash: [UInt8]) -> String {
    var result = ""
    for octet in hash {
        result.append(String(format: "%02x", octet))
    }
    return result
}

func countOfLeadingZeroes(_ hash: [UInt8]) -> Int {
    var result = 0
    for octet in hash {
        if octet == 0 {
            result += 2
        } else if (octet & 0xF0) == 0 {
            result += 1
            break
        } else {
            break
        }
    }
    return result
}

func matching(hash secret: String, withLeadingZeroes leadingZeroes: Int) -> (hash: String, value: Int) {
    var x = 0
    repeat {
        let key = "\(secret)\(x)"
        let hash = md5(string: key)
        if countOfLeadingZeroes(hash) >= leadingZeroes {
            return (hash: from(hash: hash), value: x)
        }
        x += 1
    } while true
}

// MARK: - Solution

class Day4: Solution {
    required init() {}

    var name = "Day 4"

    func part1(input: String) {
        let hash = matching(hash: input, withLeadingZeroes: 5)
        print("Santa finds hash “\(hash.hash)” with five leading zeroes and value “\(hash.value)”")
    }

    func part2(input: String) {
        let hash = matching(hash: input, withLeadingZeroes: 6)
        print("Santa finds hash “\(hash.hash)” with six leading zeroes and value “\(hash.value)”")
    }
}
