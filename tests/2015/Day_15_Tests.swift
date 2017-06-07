//
//  Day_15_Tests.swift
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

class Day_15_Tests: XCTestCase {

    func testSolution() {
        let ingredients = [
            Ingredient(name: "Butterscotch", capacity: -1, durability: -2, flavor:  6, texture:  3, calories: 8),
            Ingredient(name: "Cinnamon", capacity:  2, durability:  3, flavor: -2, texture: -1, calories: 3)
        ]
        let expectedResults = [
            ingredients[0]: 44,
            ingredients[1]: 56
        ]
        let solution = findingBestCookie(for: ingredients, teaspoons: 100)
        for (ingredient, quantity) in expectedResults {
            let solutionQuantity = solution[ingredient]
            XCTAssertNotNil(solutionQuantity)
            if let solutionQuantity = solutionQuantity {
                XCTAssertEqual(solutionQuantity, quantity)
            }
        }
    }

    func testParsing() {
        let ingredients = [
            "Butterscotch: capacity -1, durability -2, flavor 6, texture 3, calories 8",
            "Cinnamon: capacity 2, durability 3, flavor -2, texture -1, calories 3",
            "A man, a plan, a canal, Panama",
            "Cinnamon: capacity 2, durability 🤔, flavor -2, texture -1, calories 3",
        ]
        let expectedResults = [
            Ingredient(name: "Butterscotch", capacity: -1, durability: -2, flavor:  6, texture:  3, calories: 8),
            Ingredient(name: "Cinnamon", capacity:  2, durability:  3, flavor: -2, texture: -1, calories: 3),
            nil,
            nil
        ]
        for (test, result) in zip(ingredients, expectedResults) {
            let ingredient = Ingredient(from: test)
            switch (ingredient, result) {
            case let (.some(ingredient), .some(result)):
                XCTAssertEqual(ingredient.name,       result.name)
                XCTAssertEqual(ingredient.capacity,   result.capacity)
                XCTAssertEqual(ingredient.durability, result.durability)
                XCTAssertEqual(ingredient.flavor,     result.flavor)
                XCTAssertEqual(ingredient.texture,    result.texture)
                XCTAssertEqual(ingredient.calories,   result.calories)
            case (.none, .none):
                XCTAssertTrue(true, "Both are nil")
            default:
                XCTAssertFalse(true, "\(String(describing: ingredient)) ≠ \(String(describing: result))")
            }
        }
    }

}
