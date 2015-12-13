//
//  main.swift
//  Day 1
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

func floorNumberGivenFloor(floor: Int, direction ch: Character) -> Int {
    switch ch {
    case "(":
        return floor + 1
    case ")":
        return floor - 1
    default:
        return floor
    }
}

func floorFromInstructions(instructions: String) -> Int {
    return instructions.characters.reduce(0, combine: floorNumberGivenFloor)
}

func basementPositionFromInstructions(instructions: String) -> Int? {
    typealias MapState = (floor: Int, position: Int, foundPosition: Int?)
    let initialState: MapState = (0, 1, nil)
    return instructions.characters.reduce(initialState) { (state, direction) in
        let newFloor = floorNumberGivenFloor(state.floor, direction: direction)
        let foundPosition: Int? = (state.foundPosition == nil && newFloor < 0) ? state.position : state.foundPosition
        return (newFloor, state.position + 1, foundPosition)
    }.foundPosition
}

if let instructions = try? String(contentsOfFile: "instructions.txt", encoding: NSUTF8StringEncoding) {
    print("Santa should go to floor \(floorFromInstructions(instructions))")
    if let basementPosition = basementPositionFromInstructions(instructions) {
        print("Santa entered the basement at position \(basementPosition)")
    } else {
        print("Santa did not enter the basement")
    }
} else {
    print("Data file missing")
}