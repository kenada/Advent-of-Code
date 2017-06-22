//
//  day 13.swift
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

typealias Person = String

func happiness(of people: [Person], withRelationships lookup: [Pair<Person>: Int]) -> Int {
    let pairings = pairs(of: people)
    return pairings.reduce(0) { $0 + (lookup[$1] ?? 0) }
}

func pairs(of people: [Person]) -> [Pair<Person>] {
    guard people.count > 1 else { return [] }
    var result = zip(people, people[1..<people.count]).map { Pair.init($0.0, $0.1) }
    result.append(Pair(people.last!, people.first!))
    result.append(contentsOf: result.lazy.map { Pair($0.second, $0.first) })
    return result
}

private let regex =
    try! NSRegularExpression(pattern: "([^ ]+) would (gain|lose) ([\\d]+) happiness units by sitting next to ([^.]+)\\.")

func parsed(ofDay13 input: String) -> (Pair<Person>, Int)? {
    let nsInput = input as NSString

    guard let match = regex.firstMatch(in: input, options: [], range: NSMakeRange(0, nsInput.length)) else {
        return nil
    }

    let gainOrLose = nsInput.substring(with: match.range(at: 2))
    guard gainOrLose == "gain" || gainOrLose == "lose" else {
        return nil
    }

    guard let happiness = Int(nsInput.substring(with: match.range(at: 3))) else {
        return nil
    }

    return (Pair(nsInput.substring(with: match.range(at: 1)), nsInput.substring(with: match.range(at: 4))),
            happiness * (gainOrLose == "gain" ? 1 : -1))
}

// MARK: - Solution

class Day13: Solution {
    required init() {}

    var name = "Day 13"

    func part1(input: String) {
        let (people, mapping) = Day13.reading(input: input)
        Day13.solution(withTable: people, dispositions: mapping, label: "part 1")
    }

    func part2(input: String) {
        var (people, mapping) = Day13.reading(input: input)
        people.forEach { person in
            mapping[Pair("Me", person)] = 0
            mapping[Pair(person, "Me")] = 0
        }
        people.append("Me")
        Day13.solution(withTable: people, dispositions: mapping, label: "part 2")
    }

    private static func reading(input: String) -> ([Person], [Pair<Person>: Int]) {
        let lines = input.lines

        var people: Set<Person> = []
        var mapping: [Pair<Person>: Int] = [:]

        do {
            let parsedLines = lines.flatMap { line -> (Pair<Person>, Int)? in
                let parsedLine = parsed(ofDay13: line)
                _ = parsedLine.map {
                    people.insert($0.0.first)
                    people.insert($0.0.second)
                }
                return parsedLine
            }
            parsedLines.forEach { let (pairing, happiness) = $0; return
                mapping[pairing] = happiness
            }
        }

        return (Array(people), mapping)
    }

    private static func solution(withTable people: [Person], dispositions mapping: [Pair<Person>: Int], label: String) {
        let permutations = people.permutations
        var totalHappiness = Int.min

        permutations.forEach { permutation in
            let permHappiness = happiness(of: permutation, withRelationships: mapping)
            if permHappiness > totalHappiness {
                totalHappiness = permHappiness
            }
        }

        print("The total change in happiness for the best seating arrangement in \(label) is: \(totalHappiness)")
    }

}
