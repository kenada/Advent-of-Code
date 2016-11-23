//
//  day 11.swift
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

private func fromUnicodeScalars(_ arr: [UnicodeScalar]) -> String {
    var scalars = String.UnicodeScalarView()
    arr.forEach { scalar in
        scalars.append(scalar)
    }
    return String(scalars)
}

struct Password {

    private static let countMax: Int = 8
    private static let goodCharacters: NSRegularExpression = try! NSRegularExpression(pattern: "[a-z]{\(countMax)}")

    fileprivate let rep: [UnicodeScalar]
    var value: String {
        return fromUnicodeScalars(self.rep)
    }

    init(string: String) throws {
        let count = string.characters.count
        if count.distance(to: Password.countMax) > 0 {
            throw PasswordError.tooShort
        }
        if count.distance(to: Password.countMax) < 0 {
            throw PasswordError.tooLong
        }
        if Password.goodCharacters.matches(in: string, range: NSMakeRange(0, string.utf16.count)).count == 0 {
            throw PasswordError.invalidCharacters
        }
        rep = Array(string.unicodeScalars)
    }

    private init(unicodeScalars: [UnicodeScalar]) {
        rep = unicodeScalars
    }

    func next() -> Password {
        var result = [UnicodeScalar](repeating: UnicodeScalar(0x00), count: self.rep.count)
        let _ = rep.reversed().enumerated().reduce(true) { (carry, x: (index: Int, digit: UnicodeScalar)) in
            if carry {
                if result.count - x.index - 1 < 0 {
                    return false
                } else if x.digit == UnicodeScalar(0x7A) { // ASCII 0x7A = z
                    result[result.count - x.index - 1] = UnicodeScalar(0x61)
                    return true
                } else {
                    result[result.count - x.index - 1] = UnicodeScalar(x.digit.value + 1)!
                    return false
                }
            } else {
                result[result.count - x.index - 1] = x.digit
                return false
            }
        }
        return Password(unicodeScalars: result)
    }

}

private func hasStraight(_ scalars: [UnicodeScalar]) -> Bool {
    return scalars.enumerated().reduce(false) { (result, x: (index: Int, digit: UnicodeScalar)) in
        if result || x.index + 1 >= scalars.count || x.index + 2 >= scalars.count {
            return result
        } else {
            return scalars[x.index + 1].value == scalars[x.index].value + 1
                && scalars[x.index + 2].value == scalars[x.index].value + 2
        }
    }
}

private func lacksExcludedCharacters(_ scalars: [UnicodeScalar]) -> Bool {
    return scalars.reduce(true) { (result, digit) in
        let digits = !(digit == UnicodeScalar(0x69) || digit == UnicodeScalar(0x69) || digit == UnicodeScalar(0x69))
        return result && digits
    }
}

extension Password {
    private static let validityChecks: [([UnicodeScalar]) -> Bool] = [
        lacksExcludedCharacters,
        hasStraight,
        { let regex = try! NSRegularExpression(pattern: "([a-z])\\1[a-z]*([a-z])\\2") // two non-overlapping pairs
            return {
                let str = fromUnicodeScalars($0)
                return regex.matches(in: str, range: NSMakeRange(0, str.utf16.count)).count != 0
            }
        }(),
    ]
    var isValid: Bool {
        return Password.validityChecks.reduce(true) { (result, check) in
            return result && check(self.rep)
        }
    }

    func nextValidPassword() -> Password {
        var candidate = self.next()
        while !candidate.isValid {
            candidate = candidate.next()
        }
        return candidate
    }
}

enum PasswordError: Error {
    case tooShort, tooLong, invalidCharacters
}

// MARK: - Solution

class Day11: Solution {
    required init() {}

    var name = "Day 11"

    func part1(input: String) {
        let password = try! Password(string: input)
        let newPassword = password.nextValidPassword()
        print("Santa’s next password is \(newPassword.value)")
    }

    func part2(input: String) {
        let password = try! Password(string: input)
        let newPassword = password.nextValidPassword().nextValidPassword()
        print("Santa’s next password is \(newPassword.value)")
    }
}
