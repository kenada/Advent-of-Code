//
//  parser.swift
//  Day 7
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

public enum Symbol: Equatable {
    case Assignment
    
    case Wire(String)
    case Number(UInt16)
    
    case And, Or, LeftShift, RightShift, Not
}

public func ==(lhs: Symbol, rhs: Symbol) -> Bool {
    switch (lhs, rhs) {
    case (.Assignment, .Assignment):
        return true
    case let (.Wire(str1), .Wire(str2)) where str1 == str2:
        return true
    case let (.Number(num1), .Number(num2)) where num1 == num2:
        return true
    case (.And, .And):
        return true
    case (.Or, .Or):
        return true
    case (.LeftShift, .LeftShift):
        return true
    case (.RightShift, .RightShift):
        return true
    case (.Not, .Not):
        return true
    default:
        return false
    }
}

let whitespace = try! NSRegularExpression(pattern: "\\s", options: [])
func lex(input: String) -> [Symbol] {
    let tokens = input.characters.split {
        whitespace.firstMatchInString(String($0), options: [], range: NSMakeRange(0, 1)) != nil
    }
    var result = Array(count: tokens.count, repeatedValue: Symbol.Not)
    for (index, token) in tokens.enumerate() {
        switch String(token) {
        case "->":
            result[index] = .Assignment
        case "AND":
            result[index] = .And
        case "OR":
            result[index] = .Or
        case "NOT":
            result[index] = .Not
        case "LSHIFT":
            result[index] = .LeftShift
        case "RSHIFT":
            result[index] = .RightShift
        case let sym:
            if let num = UInt16(sym) {
                result[index] = .Number(num)
            } else {
                result[index] = .Wire(sym)
            }
        }
    }
    return result
}