//
//  day 12.swift
//  Advent of Code 2015
//
// Copyright © 2016 Randy Eckenrode
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

func sum(jsonObject: JSON, ignoring: ([String: JSON]) -> Bool) -> Double {
    switch jsonObject {
    case let .object(dict):
        if !ignoring(dict) {
            return dict.values.reduce(0) { $0 + sum(jsonObject: $1, ignoring: ignoring) }
        } else {
            return 0
        }
    case let .array(arr):
        return arr.reduce(0) { $0 + sum(jsonObject: $1, ignoring: ignoring) }
    case .boolean:
        return 0
    case let .number(num):
        return num
    default:
        return 0
    }
}

func sum(jsonObject: JSON) -> Double {
    return sum(jsonObject: jsonObject) { _ in return false }
}

func hasRedProperty(_ dict: [String: JSON]) -> Bool {
    return dict.values.reduce(false) { (acc, val) in
        let string: String
        switch val {
        case let .string(str):
            string = str
        default:
            string = ""
        }
        return acc || string == "red"
    }
}

// MARK: - Solution

class Day12: Solution {
    required init() {}

    var name = "Day 12"

    func part1(input: String) {
        Day12.processJson(string: input) {
            print("Some of all numbers in the document: \(String(format: "%.0f", sum(jsonObject: $0)))")
        }
    }

    func part2(input: String) {
        Day12.processJson(string: input) {
            print("Some of all numbers in the document, ignoring objects with red properties: \(String(format: "%.0f", sum(jsonObject: $0, ignoring: hasRedProperty)))")
        }
    }

    private class func processJson(string: String, f: (JSON) -> Void) {
        guard let data = string.data(using: .utf8) else {
            print("Data not found")
            return
        }
        let decoder = JSONDecoder()
        guard let doc = try? decoder.decode(JSON.self, from: data) else {
            print("Document count not be read")
            return
        }
        f(doc)
    }
}
