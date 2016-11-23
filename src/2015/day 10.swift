//
//  day 10.swift
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

extension Sequence where Iterator.Element == Int {
    public var lookedAndSaid: [Int] {
        var result: [Int] = []

        var iterator = self.makeIterator()
        var first = iterator.next()

        while first != nil {
            let iteration = run(first: first!, in: &iterator)
            result.append(iteration.count)
            result.append(iteration.value)
            first = iteration.next
        }

        return result
    }
}

private func run<Iterator: IteratorProtocol>(first: Int, in iterator: inout Iterator) -> (count: Int, value: Iterator.Element, next: Iterator.Element?) where Iterator.Element == Int {
    var count = 1
    let value = first
    var next: Iterator.Element?
    while let curValue = iterator.next() {
        if curValue != value {
            next = curValue
            break
        }
        count += 1
    }
    return (count: count, value: value, next: next)
}

// MARK: - Solution

class Day10: Solution {
    required init() {}

    var name = "Day 10"

    func part1(input: String) {
        var look = input.characters.map { Int(String($0))! }
        (1...40).forEach { _ in
            look = look.lookedAndSaid
        }
        print("The elves will look and say the following number of words (forty iterations): \(look.count)")
    }

    func part2(input: String) {
        var look = input.characters.map {   Int(String($0))! }
        (1...50).forEach { _ in
            look = look.lookedAndSaid
        }
        print("The elves will look and say the following number of words (fifty iterations): \(look.count)")
    }
}
