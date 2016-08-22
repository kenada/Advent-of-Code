//
//  main.swift
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
import Foundation

let contents = try! String(contentsOf: URL(fileURLWithPath: "day 9 input.txt"))
let lines = contents.characters.split(separator: "\n").lazy.map(String.init)
let routes: Routes = {
    let routes = lines.lazy.map(parsed(text:))
    var map: Routes = [:]
    routes.forEach { _ = $0.map { map[$0.0] = $0.1 } }
    return map
}()
let stops: Stops = {
    var set: Set<City> = []
    routes.keys.forEach { route in
        set.insert(route.start)
        set.insert(route.end)
    }
    return Array(set)
}()

let longest = longestDistance(via: stops, following: routes)!
let shortest = shortestDistance(via: stops, following: routes)!

print("Shortest distance: \(shortest)")
print("Longest distance: \(longest)")
