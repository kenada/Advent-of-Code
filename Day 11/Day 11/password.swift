//
//  password.swift
//  Day 11
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

struct Password {

    private static let countMax: Int = 8
    private static let goodCharacters: NSRegularExpression = try! NSRegularExpression(pattern: "[a-z]{\(countMax)}")

    let value: String

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
        value = string
    }

    func next() -> Password {
        let result = value.unicodeScalars.reversed().reduce((result: "", carry: true)) { (x: (result: String, carry: Bool), digit) in
            if x.carry {
                if digit == UnicodeScalar(0x7A) { // ASCII 0x7A = z
                    return (result: "a" + x.result, carry: true)
                } else {
                    return (result: String(UnicodeScalar(digit.value + 1)!) + x.result, carry: false)
                }
            } else {
                return (result: String(digit) + x.result, carry: false)
            }
        }
        return try! Password(string: result.0)
    }

}

private func hasStraight(_ string: String) -> Bool {
    let range = NSMakeRange(0, string.utf16.count)
    return string.unicodeScalars.enumerated().reduce(false) { (result, x: (index: Int, digit: UnicodeScalar)) in
        if result {
            return result
        } else {
            var scalars = String.UnicodeScalarView()
            scalars.append(UnicodeScalar(x.digit.value)!)
            scalars.append(UnicodeScalar(x.digit.value+1)!)
            scalars.append(UnicodeScalar(x.digit.value+2)!)
            let regex = try! NSRegularExpression(pattern: String(scalars))
            return regex.matches(in: string, range: range).count != 0
        }
    }
}

extension Password {
    private static let validityChecks: [(String) -> Bool] = [
        hasStraight,
        { let regex = try! NSRegularExpression(pattern: "[iol]") // does not contain ‘i’, ‘o’, or ‘l’
            return {
                regex.matches(in: $0, range: NSMakeRange(0, $0.utf16.count)).count == 0
            }
        }(),
        { let regex = try! NSRegularExpression(pattern: "([a-z])\\1[a-z]*([a-z])\\2") // two non-overlapping pairs
            return {
                regex.matches(in: $0, range: NSMakeRange(0, $0.utf16.count)).count != 0
            }
        }()
    ]
    var isValid: Bool {
        return Password.validityChecks.reduce(true) { (result, check) in
            return result && check(self.value)
        }
    }
}

enum PasswordError: Error {
    case tooShort, tooLong, invalidCharacters
}
