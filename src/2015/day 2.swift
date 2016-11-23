//
//  day 2.swift
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

struct Box {
    var length: Int
    var width: Int
    var height: Int

    var surfaceArea: Int {
        return 2 * (length * width + length * height + width * height)
    }
    var volume: Int {
        return length * width * height
    }
}

extension Box {
    var slack: Int {
        return min(length * width, length * height, width * height)
    }
    
    var ribbonLength: Int {
        return min(2 * length + 2 * width, 2 * length + 2 * height, 2 * width + 2 * height)
    }
}

func parse(string: String) -> [Box] {
    let rawData = string.characters.split(separator: "\n")
    return rawData
        .lazy
        .map { (line) -> Box? in
            let dims = line.split(separator: "x")
            if dims.count != 3 {
                return nil
            }
            let components = dims.map { Int(String($0)) }
            guard let l = components[0], let w = components[1], let h = components[2] else {
                return nil
            }
            return Box(length: l, width: w, height: h)
        }
        .filter { $0 != nil }
        .map { $0! }
}

// MARK: - Solution

class Day2: Solution {
    required init() {}

    var name = "Day 2"

    func part1(input: String) {
        let boxes = parse(string: input)
        let sqFeet = boxes.reduce(0) { $0 + $1.surfaceArea + $1.slack }
        print("The elves should order \(sqFeet) square feet of wrapping paper.")
    }

    func part2(input: String) {
        let boxes = parse(string: input)
        let ribbonLength = boxes.reduce(0) { $0 + $1.ribbonLength + $1.volume }
        print("The elves should order \(ribbonLength) feet of ribbon.")
    }
}
