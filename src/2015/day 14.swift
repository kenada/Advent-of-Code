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

        let name = input.substring(with: match.range(at: 1))

        guard let topSpeed = Int(input.substring(with: match.range(at: 2))) else { return nil }

        guard let duration = Int(input.substring(with: match.range(at: 3))) else { return nil }

        guard let restingTime = Int(input.substring(with: match.range(at: 4))) else { return nil }

        self.init(name: name, topSpeed: topSpeed, duration: duration, restingTime: restingTime)
    }
}

func winningScore(for reindeer: [Reindeer], timeLimit: Int) -> Int {
    var scores: [String: Int] = [:]
    for second in 1...timeLimit {
        var leaders: [String] = []
        let _ = reindeer.reduce(-1) { (maxDistance, reindeer) in
            let maybeMax = reindeer.distanceFlown(at: second)
            if maybeMax == maxDistance {
                leaders.append(reindeer.name)
                return maxDistance
            } else if maybeMax > maxDistance {
                leaders = [reindeer.name]
                return maybeMax
            } else {
                return maxDistance
            }
        }
        for leader in leaders {
            scores[leader] = (scores[leader] ?? 0) + 1
        }
    }
    return scores.reduce(-1) { (score, reindeer: (_: String, score: Int)) in
        return max(score, reindeer.score)
    }
}

// MARK: - Solution

class Day14: Solution {
    static let timeLimit = 2503

    required init() {}

    var name = "Day 14"

    func part1(input: String) {
        let reindeer = input.lines.flatMap(Reindeer.init(string:))
        let maxDistance = reindeer.reduce(-1) { (maxDistance, reindeer) in
            return max(maxDistance, reindeer.distanceFlown(at: Day14.timeLimit))
        }
        print("The distance traveled by the winning reindeer: \(maxDistance)")
    }
    
    func part2(input: String) {
        let reindeer = input.lines.flatMap(Reindeer.init(string:))
        let score = winningScore(for: reindeer, timeLimit: Day14.timeLimit)
        print("The winning score is: \(score)")
    }
    
}
