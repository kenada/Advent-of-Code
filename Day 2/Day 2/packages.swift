//
//  packages.swift
//  Day 2
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

public extension Box {
    var Slack: Int {
        return min(Length * Width, Length * Height, Width * Height)
    }
    
    var RibbonLength: Int {
        return min(2 * Length + 2 * Width, 2 * Length + 2 * Height, 2 * Width + 2 * Height)
    }
}

public func readPackages(url: NSURL) -> [Box] {
    guard let rawData = try? String(contentsOfURL: url, encoding: NSUTF8StringEncoding).characters.split("\n") else {
        return []
    }
    return rawData
        .lazy
        .map { (line) -> Box? in
            let dims = line.split("x")
            if dims.count != 3 {
                return nil
            }
            let components = dims.map { Int(String($0)) }
            guard let l = components[0], w = components[1], h = components[2] else {
                return nil
            }
            return Box(Length: l, Width: w, Height: h)
        }
        .filter { $0 != nil }
        .map { $0! }
}