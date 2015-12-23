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

import Foundation

private let regex =
    try! NSRegularExpression(pattern: "(turn on|turn off|toggle)\\s+(\\d+)\\s*,(\\d+)\\s+through\\s(\\d+)\\s*,(\\d+)",
    options: [])

public enum LightGridCommand: Equatable {
    case TurnOn(area: Rect), TurnOff(area: Rect), Toggle(area: Rect)
    
    init?(command: String) {
        let nsCommand = command as NSString
        guard let parsed =
                regex.firstMatchInString(command, options: [], range: NSMakeRange(0, nsCommand.length)) else {
            return nil
        }
        guard let x0 = Int(nsCommand.substringWithRange(parsed.rangeAtIndex(2))) else {
            return nil
        }
        guard let y0 = Int(nsCommand.substringWithRange(parsed.rangeAtIndex(3))) else {
            return nil
        }
        guard let x1 = Int(nsCommand.substringWithRange(parsed.rangeAtIndex(4))) else {
            return nil
        }
        guard let y1 = Int(nsCommand.substringWithRange(parsed.rangeAtIndex(5))) else {
            return nil
        }
        switch nsCommand.substringWithRange(parsed.rangeAtIndex(1)) {
        case "turn on":
            self = .TurnOn(area: Rect(x: x0, y: y0, width: x1 - x0 + 1, height: y1 - y0 + 1))
        case "turn off":
            self = .TurnOff(area: Rect(x: x0, y: y0, width: x1 - x0 + 1, height: y1 - y0 + 1))
        case "toggle":
            self = .Toggle(area: Rect(x: x0, y: y0, width: x1 - x0 + 1, height: y1 - y0 + 1))
        default:
            return nil
        }
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