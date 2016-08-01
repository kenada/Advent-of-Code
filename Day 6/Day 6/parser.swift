//
//  parser.swift
//  Day 6
//
// Copyright © 2015–2016 Randy Eckenrode
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
    try! RegularExpression(pattern: "(turn on|turn off|toggle)\\s+(\\d+)\\s*,(\\d+)\\s+through\\s(\\d+)\\s*,(\\d+)",
    options: [])

public enum LightGridCommand: Equatable {
    case turnOn(area: Rect), turnOff(area: Rect), toggle(area: Rect)
    
    init?(command: String) {
        let nsCommand = command as NSString
        guard let parsed =
                regex.firstMatch(in: command, options: [], range: NSMakeRange(0, nsCommand.length)) else {
            return nil
        }
        guard let x0 = Int(nsCommand.substring(with: parsed.range(at: 2))) else {
            return nil
        }
        guard let y0 = Int(nsCommand.substring(with: parsed.range(at: 3))) else {
            return nil
        }
        guard let x1 = Int(nsCommand.substring(with: parsed.range(at: 4))) else {
            return nil
        }
        guard let y1 = Int(nsCommand.substring(with: parsed.range(at: 5))) else {
            return nil
        }
        switch nsCommand.substring(with: parsed.range(at: 1)) {
        case "turn on":
            self = .turnOn(area: Rect(x: x0, y: y0, width: x1 - x0 + 1, height: y1 - y0 + 1))
        case "turn off":
            self = .turnOff(area: Rect(x: x0, y: y0, width: x1 - x0 + 1, height: y1 - y0 + 1))
        case "toggle":
            self = .toggle(area: Rect(x: x0, y: y0, width: x1 - x0 + 1, height: y1 - y0 + 1))
        default:
            return nil
        }
    }
}

public func ==(lhs: LightGridCommand, rhs: LightGridCommand) -> Bool {
    switch (lhs, rhs) {
    case let (.turnOn(area), .turnOn(expectedArea)):
        return area == expectedArea
    case let (.toggle(area), .toggle(expectedArea)):
        return area == expectedArea
    case let (.turnOff(area), .turnOff(expectedArea)):
        return area == expectedArea
    default:
        return false
    }
}
