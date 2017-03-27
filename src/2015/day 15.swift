//
//  day 15.swift
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
import Darwin
import Foundation

struct Ingredient {
    let name: String
    let capacity: Int
    let durability: Int
    let flavor: Int
    let texture: Int
    let calories: Int
}

private let pattern = try! NSRegularExpression(pattern: "(\\w+): capacity (-?\\d+), durability (-?\\d+), flavor (-?\\d+), texture (-?\\d+), calories (-?\\d+)", options: [])

extension Ingredient {
    init?(from string: String) {
        let nsString = string as NSString
        guard let match = pattern.firstMatch(in: string, options: [], range: NSMakeRange(0, nsString.length)) else {
            return nil
        }

        let name = nsString.substring(with: match.rangeAt(1))
        guard
            let capacity   = Int(nsString.substring(with: match.rangeAt(2))),
            let durability = Int(nsString.substring(with: match.rangeAt(3))),
            let flavor     = Int(nsString.substring(with: match.rangeAt(4))),
            let texture    = Int(nsString.substring(with: match.rangeAt(5))),
            let calories   = Int(nsString.substring(with: match.rangeAt(6))) else {
                return nil
        }
        self.init(name: name, capacity: capacity, durability: durability, flavor: flavor, texture: texture, calories: calories)
    }
}

extension Ingredient: Hashable {
    var hashValue: Int {
        return self.capacity ^ self.durability ^ self.flavor ^ self.texture ^ self.calories
    }

    static func ==(lhs: Ingredient, rhs: Ingredient) -> Bool {
        return lhs.name == rhs.name
            && lhs.capacity == rhs.capacity
            && lhs.durability == rhs.durability
            && lhs.flavor == rhs.flavor
            && lhs.texture == rhs.texture
            && lhs.calories == rhs.calories
    }
}

private func combinedScore<IngredientSequence, DistSequence>(for ingredients: IngredientSequence, distribution teaspoons: DistSequence) -> Int
    where IngredientSequence: Sequence, IngredientSequence.Iterator.Element == Ingredient, DistSequence: Sequence, DistSequence.Iterator.Element == Int {
        let capacity = max(0, zip(ingredients, teaspoons).reduce(0) { $0 + $1.0.capacity  * $1.1 })
        let durability = max(0, zip(ingredients, teaspoons).reduce(0) { $0 + $1.0.durability  * $1.1 })
        let flavor = max(0, zip(ingredients, teaspoons).reduce(0) { $0 + $1.0.flavor  * $1.1 })
        let texture = max(0, zip(ingredients, teaspoons).reduce(0) { $0 + $1.0.texture  * $1.1 })
        return capacity * durability * flavor * texture
}

private func neighbors(for array: [Int], withMaximum max: Int) -> [[Int]] {
    var result: [[Int]] = []
    array.indices.forEach { (index) in
        var neighborBase = array
        neighborBase[index] += 1
        array.indices.lazy.filter({ $0 != index }).forEach { (idx) in
            if neighborBase[idx] > 0 {
                var neighbor = neighborBase
                neighbor[idx] -= 1
                result.append(neighbor)
            }
        }
    }
    return result
}

private func randomSolution(ofElements count: Int, totalling max: Int) -> [Int] {
    var total = 0
    var result = Array(repeating: 0, count: count)
    result.indices.dropLast().forEach { (index) in
        let amount = arc4random_uniform(UInt32(max - total + 1))
        total += Int(amount)
        result[index] = Int(amount)
    }
    result[result.index(before: result.endIndex)] = max - total
    return result
}

func findingBestCookie(for ingredients: [Ingredient], teaspoons: Int) -> [Ingredient: Int] {
    guard ingredients.count > 0 else {
        return [:]
    }
    guard ingredients.count > 1 else {
        return [ingredients[0]: combinedScore(for: ingredients, distribution: [teaspoons])]
    }

    var dist = randomSolution(ofElements: ingredients.count, totalling: teaspoons)

    var score = 0
    while true {
        let candidates = neighbors(for: dist, withMaximum: teaspoons).filter {
            combinedScore(for: ingredients, distribution: $0) >= score
        }
        if candidates.count > 0 {
            dist = candidates[Int(arc4random_uniform(UInt32(candidates.count)))]
            score = combinedScore(for: ingredients, distribution: dist)
        } else {
            break
        }
    }

    var result: [Ingredient: Int] = [:]
    zip(ingredients, dist).forEach { (ingredient, teaspoons) in
        result[ingredient] = teaspoons
    }

    return result
}

// MARK: - Solution

class Day15: Solution {

    public let name = "Day 15"
    let teaspoons = 100

    public required init() {
    }

    public func part1(input: String) {
        let ingredients = input.lines.flatMap(Ingredient.init)

        print("Hrm")
        print(combinedScore(for: ingredients, distribution: [50, 10, 30, 10]))

        let bestCookie = findingBestCookie(for: ingredients, teaspoons: teaspoons)
        print("The best cookie that can be made with these ingredients has the following score and ingredients")
        print("\nScore: \(combinedScore(for: bestCookie.keys, distribution: bestCookie.keys.lazy.flatMap({ bestCookie[$0] })))")
        bestCookie.forEach { (ingredient, quantity) in
            print("\(quantity) teaspoons of \(ingredient.name)")
        }
    }

    public func part2(input: String) {

    }

}
