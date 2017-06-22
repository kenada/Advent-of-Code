//
//  Day_14_Tests.swift
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

@testable import Advent_of_Code_2015
import XCTest

class Day_14_Tests: XCTestCase {

    func testFlightStatus() {
        let data = [
            Reindeer(name: "Comet", topSpeed: 14, duration: 10, restingTime: 127),
            Reindeer(name: "Dancer", topSpeed: 16, duration: 11, restingTime: 162)
        ]
        let expectedResults: [[(time: Int, status: Reindeer.FlightStatus)]] = [
            [
                (time:    1, status: .flying),
                (time:   10, status: .flying),
                (time:   11, status: .resting),
                (time:   12, status: .resting),
                (time:  138, status: .flying),
                (time:  174, status: .resting),
                (time: 1000, status: .resting)
            ],
            [
                (time:    1, status: .flying),
                (time:   10, status: .flying),
                (time:   11, status: .flying),
                (time:   12, status: .resting),
                (time:  138, status: .resting),
                (time:  174, status: .flying),
                (time: 1000, status: .resting)
            ]
        ]
        zip(data, expectedResults).forEach {
            let reindeer = $0.0, expectedResults = $0.1
            expectedResults.forEach { let (time, status) = $0; return
                XCTAssertEqual(reindeer.status(at: time), status, "time: \(time)")
            }
        }
    }

    func testDistance() {
        let data = [
            Reindeer(name: "Comet", topSpeed: 14, duration: 10, restingTime: 127),
            Reindeer(name: "Dancer", topSpeed: 16, duration: 11, restingTime: 162)
        ]
        let expectedResults = [
            [
                (time:    1, distance: 14),
                (time:   10, distance: 140),
                (time:   11, distance: 140),
                (time:   12, distance: 140),
                (time:  138, distance: 154),
                (time:  174, distance: 280),
                (time: 1000, distance: 1120)
            ],
            [
                (time:    1, distance: 16),
                (time:   10, distance: 160),
                (time:   11, distance: 176),
                (time:   12, distance: 176),
                (time:  138, distance: 176),
                (time:  174, distance: 192),
                (time: 1000, distance: 1056)
            ]
        ]
        zip(data, expectedResults).forEach {
            let reindeer = $0.0, expectedResults = $0.1
            expectedResults.forEach { let (time, distance) = $0; return
                XCTAssertEqual(reindeer.distanceFlown(at: time), distance, "time: \(time)")
            }
        }
    }

    func testParsing() {
        let input = [
            "Comet can fly 14 km/s for 10 seconds, but then must rest for 127 seconds.",
            "Dancer can fly 16 km/s for 11 seconds, but then must rest for 162 seconds."
        ]
        input.forEach { line in
            XCTAssertNotNil(Reindeer(string: line))
        }
    }

    func testWinningScore() {
        let data = [
            Reindeer(name: "Comet", topSpeed: 14, duration: 10, restingTime: 127),
            Reindeer(name: "Dancer", topSpeed: 16, duration: 11, restingTime: 162)
        ]
        let expectedScore = 689
        XCTAssertEqual(winningScore(for: data, timeLimit: 1000), expectedScore)
    }
}
