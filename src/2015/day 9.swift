//
//  day 9.swift
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

typealias City = String
typealias Stops = [City]
typealias Routes = [Route: Int]
typealias Route = Pair<City>

extension Pair where Element: Comparable {
    init(start: Element, end: Element) {
        self.first = min(start, end)
        self.second = max(start, end)
    }

    var start: Element { return self.first }
    var end: Element { return self.second }
}

func distance(via cities: Stops, following routes: Routes) -> Int? {
    let stops = zip(cities, cities[1..<cities.count])
    let distances = stops.lazy.flatMap { routes[Pair(start: $0.0, end: $0.1)] }
    return distances.reduce(nil) { return ($0 ?? 0) + $1 }
}

func shortestDistance(via stops: Stops, following routes: Routes) -> Int? {
    let possibleRoutes = stops.permutations
    let curriedDistance = { distance(via: $0, following: routes) }
    return possibleRoutes.flatMap(curriedDistance).min()
}

func longestDistance(via stops: Stops, following routes: Routes) -> Int? {
    let possibleRoutes = stops.permutations
    let curriedDistance = { distance(via: $0, following: routes) }
    return possibleRoutes.flatMap(curriedDistance).max()
}

func parsed(text: String) -> (Route, Int)? {
    let elements = text.characters.words
    guard elements.count == 5 else { return nil }
    let route = Route(start: String(elements[0]), end: String(elements[2]))
    return Int(String(elements[4])).map { (route, $0) }
}

// MARK: - Solution

class Day9: Solution {
    required init() {}

    var name = "Day 9"

    func part1(input: String) {
        let (routes, stops) = Day9.load(input: input)
        let shortest = shortestDistance(via: stops, following: routes)!
        print("Shortest distance: \(shortest)")
    }

    func part2(input: String) {
        let (routes, stops) = Day9.load(input: input)
        let longest = longestDistance(via: stops, following: routes)!
        print("Longest distance: \(longest)")
    }

    private class func load(input: String) -> (routes: Routes, stops: Stops) {
        let lines = input.characters.split(separator: "\n").lazy.map(String.init)
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
        return (routes, stops)
    }
}
