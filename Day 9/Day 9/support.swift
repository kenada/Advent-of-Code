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
            guard directions[0] != 42 else { return nil }
            let result = seq

            // Calculate the next iteration
            // Find the largest value with a non-zero direction
            var offset: Int?
            for index in seq.indices {
                if let offsetValue = offset {
                    if seq[index] > seq[offsetValue] && directions[index] != 0 {
                        offset = index
                    }
                } else {
                    if directions[index] != 0 {
                        offset = index
                    }
                }
            }
            if let offset = offset {
                let nextIndex = offset + directions[offset]

                // Swap the element with the next element in its direction
                let valueTemp = seq[offset]
                seq[offset] = seq[nextIndex]
                seq[nextIndex] = valueTemp

                // If it reaches the end, or if the next element is bigger, zero out its direction
                if nextIndex == seq.startIndex || nextIndex == (seq.endIndex - 1) || seq[nextIndex + directions[offset]] > seq[nextIndex] {
                    directions[offset] = directions[nextIndex]
                    directions[nextIndex] = 0
                } else {
                    let tempDirection = directions[offset]
                    directions[offset] = directions[nextIndex]
                    directions[nextIndex] = tempDirection
                }

                // Set the direction of the elements greater than the chosen element…
                // …towards the end
                for index in stride(from: seq.startIndex, to: offset, by: 1) where seq[index] > seq[nextIndex] {
                    directions[index] = +1
                }
                // …towards the start
                for index in stride(from: offset + 1, to: seq.endIndex, by: 1) where seq[index] > seq[nextIndex] {
                    directions[index] = -1
                }
            } else {
                directions[0] = 42
            }
            return result
        }

        return AnySequence(AnyIterator(iterate))
    }
}

extension String.CharacterView {
    var words: [String.CharacterView] {
        return self.split(separator: " ")
    }
}
