//
//  solution.swift
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

typealias City = String
typealias Stops = [City]
typealias Routes = [Route: Int]

struct Route: Hashable {
    var start: String
    var end: String

    var hashValue: Int {
        return self.start.hashValue ^ self.end.hashValue
    }

    init(_ start: City, _ end: City) {
        self.start = min(start, end)
        self.end = max(start, end)
    }
}

func ==(_ lhs: Route, _ rhs: Route) -> Bool {
    return lhs.start == rhs.start && lhs.end == rhs.end
}

func distance(via cities: Stops, following routes: Routes) -> Int? {
    let stops = zip(cities, cities[1..<cities.count])
    let distances = stops.lazy.flatMap { routes[Route($0.0, $0.1)] }
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
    let route = Route(String(elements[0]), String(elements[2]))
    return Int(String(elements[4])).map { (route, $0) }
}
