//
//  main.swift
//  Day 2
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

import Foundation

let boxes = load(contentsOf: URL(fileURLWithPath: "packages.txt",
                                 relativeTo: URL(fileURLWithPath: FileManager.default.currentDirectoryPath)))

let sqFeet = boxes.reduce(0) { $0 + $1.surfaceArea + $1.slack }
let ribbonLength = boxes.reduce(0) { $0 + $1.ribbonLength + $1.volume }

print("The elves should order \(sqFeet) square feet of wrapping paper.")
print("The elves should order \(ribbonLength) feet of ribbon.")
