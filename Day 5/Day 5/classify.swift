//
//  classify.swift
//  Day 5
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

private func regexCheck(_ pattern: String) -> (String) -> Bool {
    let regex = try! RegularExpression(pattern: pattern, options: [])
    return { string in
        let range = NSMakeRange(0, (string as NSString).length)
        return regex.firstMatch(in: string, options: [], range: range) == nil
    }
}

enum NaughtyOrNice {
    case naughty, nice
}

private let nicenessChecks = [
    regexCheck("[aeiou]+[^aeiou]*[aeiou]+[^aeiou]*[aeiou]+"),
    regexCheck("(\\w)\\1"),
    { $0.contains("ab") },
    { $0.contains("cd") },
    { $0.contains("pq") },
    { $0.contains("xy") }
]

private let nicenessChecksV2 = [
    regexCheck("(\\w\\w).*\\1"),
    regexCheck("(\\w)\\w\\1")
]

private func makeNiceness(fromChecks checks: [(String) -> Bool]) -> (string: String) -> NaughtyOrNice {
    return { string in
        checks.reduce(.nice) { result, check in
            if check(string) {
                return .naughty
            } else {
                return result
            }
        }
    }
}

let niceness = makeNiceness(fromChecks: nicenessChecks)
let nicenessV2 = makeNiceness(fromChecks: nicenessChecksV2)
