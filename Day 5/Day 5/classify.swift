//
//  classify.swift
//  Day 5
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

func makeRegexCheck(pattern: String) -> String -> Bool {
    let regex = try! NSRegularExpression(pattern: pattern, options: [])
    return { (string: String) -> Bool in
        let range = NSMakeRange(0, (string as NSString).length)
        return regex.firstMatchInString(string, options: [], range: range) == nil
    }
}

private let nicenessChecksV1 = [
    makeRegexCheck("[aeiou]+[^aeiou]*[aeiou]+[^aeiou]*[aeiou]+"),
    makeRegexCheck("(\\w)\\1"),
    { (string: String) -> Bool in return (string as NSString).containsString("ab") },
    { (string: String) -> Bool in return (string as NSString).containsString("cd") },
    { (string: String) -> Bool in return (string as NSString).containsString("pq") },
    { (string: String) -> Bool in return (string as NSString).containsString("xy") },
]

private let nicenessChecksV2 = [
    makeRegexCheck("(\\w\\w).*\\1"),
    makeRegexCheck("(\\w)\\w\\1")
    
]

enum NaughtyOrNice {
    case Naughty
    case Nice
    
    init(string: String, improvedChecks: Bool = false) {
        let nicenessChecks: [(String -> Bool)]
        if improvedChecks {
            nicenessChecks = nicenessChecksV2
        } else {
            nicenessChecks = nicenessChecksV1
        }
        self = Nice
        for p in nicenessChecks {
            if p(string) {
                self = Naughty
                break
            }
        }
    }
}