//
//  support.swift
//  Day 9
//
//  Copyright © 2016 Randy Eckenrode. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a
//  copy of this software and associated documentation files (the “Software”),
//  to deal in the Software without restriction, including without limitation
//  the rights to use, copy, modify, merge, publish, distribute, sublicense,
//  and/or sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
//  DEALINGS IN THE SOFTWARE.
//

typealias Direction = Int

extension Array where Element: Comparable {
    /// Based on the Steinhaus-Johnson-Trotter algorithm using Even’s speedup
    /// See: https://en.wikipedia.org/wiki/Steinhaus–Johnson–Trotter_algorithm#Even.27s_speedup
    var permutations: AnySequence<[Element]> {
        guard self.count > 0 else {
            return AnySequence(AnyCollection([]))
        }

        // `seq` is a copy of self, which is mutated in-place by `iterate`
        // `directions` contains the directions in which the elements are currently moving
        var seq = self
        var directions = [Direction](repeating: -1, count: self.count)
        directions[0] = 0

        func iterate() -> [Element]? {
            // Find the largest value with a non-zero direction
            var max: (offset: Int, element: (direction: Direction, value: Element))? = nil
            for index in stride(from: seq.startIndex + 1, to: seq.endIndex, by: 1) {
                if (max != nil && seq[index] > seq[max!.offset]) || (max == nil && directions[index] != 0) {
                    max = (offset: index, element: (direction: directions[index], seq[index]))
                }
            }
            if let max = max {
                // Swap the element with the next element in its direction
                let nextIndex = max.offset + max.element.direction
                let directionTemp = directions[nextIndex]
                let valueTemp = seq[nextIndex]
                if nextIndex == seq.startIndex || nextIndex == seq.endIndex || seq[nextIndex] > max.element.value {
                    seq[nextIndex] = max.element.value
                    directions[nextIndex] = 0
                } else {
                    seq[nextIndex] = max.element.value
                    directions[nextIndex] = max.element.direction
                }
                seq[max.offset] = valueTemp
                directions[max.offset] = directionTemp

                // Set the direction of the elements greater than the chosen element…
                // …towards the end
                for index in stride(from: seq.startIndex, to: max.offset, by: 1) where seq[index] > max.element.value {
                    directions[index] = +1
                }
                // …towards the start
                for index in stride(from: seq.startIndex + 1, to: seq.endIndex, by: 1) where seq[index] > max.element.value {
                    directions[index] = -1
                }

                return seq
            } else {
                return nil
            }
        }

        return AnySequence(AnyIterator(iterate))
    }
}
