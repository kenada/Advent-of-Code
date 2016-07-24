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
    var slack: Int {
        return min(length * width, length * height, width * height)
    }
    
    var ribbonLength: Int {
        return min(2 * length + 2 * width, 2 * length + 2 * height, 2 * width + 2 * height)
    }
}

public func load(contentsOf url: URL) -> [Box] {
    // HACK: Advent of Code requires you to be logged in to download your input. Prior to El Capitan,
    // this would just work. Under El Capitan, cookie storage is no longer shared between applications.
    // This reads the cookies from the (formerly) shared storage and injects them into the application’s
    // cookie jar. Of course, this will fail if you’re not logged into Advent of Code in Safari.
//    let cookieStorage = HTTPCookieStorage.sharedCookieStorage(forGroupContainerIdentifier: "Cookies")
//    let cookies = cookieStorage.cookies(for: URL(string: "http://adventofcode.com/day/2/input")!)
//    
//    if let aocCookies = cookies {
//        let storage = HTTPCookieStorage.shared
//        for cookie in aocCookies {
//            storage.setCookie(cookie)
//        }
//    }

    guard let rawData = try? String(contentsOf: url, encoding: .utf8).characters.split(separator: "\n") else {
        return []
    }
    return rawData
        .lazy
        .map { (line) -> Box? in
            let dims = line.split(separator: "x")
            if dims.count != 3 {
                return nil
            }
            let components = dims.map { Int(String($0)) }
            guard let l = components[0], let w = components[1], let h = components[2] else {
                return nil
            }
            return Box(length: l, width: w, height: h)
        }
        .filter { $0 != nil }
        .map { $0! }
}
