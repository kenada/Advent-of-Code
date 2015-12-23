//
//  parser.swift
//  Day 6
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

public enum LightGridCommand: Equatable {
    case TurnOn(area: Rect), TurnOff(area: Rect), Toggle(area: Rect)
    
    init?(command: String) {
        return nil
    }
}

public func ==(lhs: LightGridCommand, rhs: LightGridCommand) -> Bool {
    switch (lhs, rhs) {
    case let (.TurnOn(area), .TurnOn(expectedArea)):
        return area == expectedArea
    case let (.Toggle(area), .Toggle(expectedArea)):
        return area == expectedArea
    case let (.TurnOff(area), .TurnOff(expectedArea)):
        return area == expectedArea
    default:
        return false
    }
}