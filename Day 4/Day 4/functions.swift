//
//  functions.swift
//  Day 4
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

private func hashToString(hash: [UInt8]) -> String {
    var result = ""
    for octet in hash {
        result.appendContentsOf(String(format: "%02x", octet))
    }
    return result
}

private func countLeadingZeroes(hash: [UInt8]) -> Int {
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

func findHash(secret: String, leadingZeroes: Int = 5) -> (hash: String, value: Int) {
    var x = 0
    repeat {
        let key = "\(secret)\(x)"
        let hash = md5(key)
        if countLeadingZeroes(hash) >= leadingZeroes {
            return (hash: hashToString(hash), value: x)
        }
        x += 1
    } while true
}