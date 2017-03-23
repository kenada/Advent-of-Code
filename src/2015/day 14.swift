//
//  day 14.swift
//  Advent of Code 2015
//
// Copyright © 2017 Randy Eckenrode
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

struct Reindeer {
    let name: String
    let topSpeed: Int
    let duration: Int
    let restingTime: Int

    enum FlightStatus {
        case flying, resting
    }

    func status(at time: Int) -> FlightStatus {
        let rem = time % (self.duration + self.restingTime)
        if rem <= self.duration {
            return .flying
        } else {
            return .resting
        }
    }

    func distanceFlown(at time: Int) -> Int {
        let fullFlights = time / (self.duration + self.restingTime)
        let partialFlightTime = min(time % (self.duration + self.restingTime), self.duration)
        return fullFlights * self.topSpeed * self.duration + partialFlightTime * self.topSpeed
    }
}

private let regex = try! NSRegularExpression(pattern:
    "([^ ]+) can fly ([\\d]+) km/s for ([\\d]+) seconds, but then must rest for ([\\d]+) seconds.")

extension Reindeer {
    init?(string: String) {
        let input = string as NSString
        guard let match = regex.firstMatch(in: string, options: [], range: NSMakeRange(0, input.length)) else {
            return nil
        }
        guard match.numberOfRanges == 5 else { return nil }

        let name = input.substring(with: match.rangeAt(1))

        guard let topSpeed = Int(input.substring(with: match.rangeAt(2))) else { return nil }

        guard let duration = Int(input.substring(with: match.rangeAt(3))) else { return nil }

        guard let restingTime = Int(input.substring(with: match.rangeAt(4))) else { return nil }

        self.init(name: name, topSpeed: topSpeed, duration: duration, restingTime: restingTime)
    }
}

// MARK: - Solution

class Day14: Solution {
    required init() {}

    var name = "Day 14"

    func part1(input: String) {
        let reindeer = input.lines.flatMap(Reindeer.init(string:))
        let maxDistance = reindeer.reduce(-1) { (maxDistance, reindeer) in
            return max(maxDistance, reindeer.distanceFlown(at: 2503))
        }
        print("The distance traveled by the winning reindeer: \(maxDistance)")
    }
    
    func part2(input: String) {
        
    }
    
}
