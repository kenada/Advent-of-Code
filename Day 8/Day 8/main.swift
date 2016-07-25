//
//  main.swift
//  Day 8
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

let input = try! String(contentsOfFile: "day 8 input.txt")

// Part 1
let difference = input.characters.split(separator: "\n").reduce(0) { acc, x in
    let str = String(x[x.index(after: x.startIndex) ..<  x.index(before: x.endIndex)])
    return acc + (str.literalSize - str.size)
}
print("Difference: \(difference)")


let difference2 = input.characters.split(separator: "\n").reduce(0) { acc, x in
    let s = String(x[x.index(after: x.startIndex) ..<  x.index(before: x.endIndex)])
    let encodedSize = String(xmasEncode: s).literalSize
    let literalSize = String(s).literalSize
    return acc + (encodedSize - literalSize)
}
print("Difference: \(difference2)")
