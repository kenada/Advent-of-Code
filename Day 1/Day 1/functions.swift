//
//  functions.swift
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

typealias Floor = Int
typealias Direction = Character

func from(string: String) -> AnySequence<Direction> {
    return AnySequence(string.characters)
}

func moved(from floor: Floor, following ch: Direction) -> Floor {
    switch ch {
    case "(":
        return floor + 1
    case ")":
        return floor - 1
    default:
        return floor
    }
}

enum EndCondition {
    case finished, enteredBasement
}

func followed<T: Sequence>(directions: T, until: EndCondition) -> Floor? where T.Iterator.Element == Direction {
    switch until {
    case .finished:
        return directions.reduce(0, combine: moved)
    case .enteredBasement:
        typealias MapState = (floor: Int, position: Int, foundPosition: Int?)
        let initialState: MapState = (0, 1, nil)
        return directions.reduce(initialState) { (state, direction) in
            let newFloor = moved(from: state.floor, following: direction)
            let foundPosition: Int? = (state.foundPosition == nil && newFloor < 0) ? state.position : state.foundPosition
            return (newFloor, state.position + 1, foundPosition)
            }.foundPosition
    }
}

