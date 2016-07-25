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
    case assignment
    
    case wire(String)
    case number(UInt16)
    
    case and, or, leftShift, rightShift, not
}

public func ==(lhs: Symbol, rhs: Symbol) -> Bool {
    switch (lhs, rhs) {
    case (.assignment, .assignment):
        return true
    case let (.wire(str1), .wire(str2)) where str1 == str2:
        return true
    case let (.number(num1), .number(num2)) where num1 == num2:
        return true
    case (.and, .and):
        return true
    case (.or, .or):
        return true
    case (.leftShift, .leftShift):
        return true
    case (.rightShift, .rightShift):
        return true
    case (.not, .not):
        return true
    default:
        return false
    }
}

private let whitespace = try! RegularExpression(pattern: "\\s", options: [])
public func lex(input: String) -> [Symbol] {
    let tokens = input.characters.split {
        whitespace.firstMatch(in: String($0), options: [], range: NSMakeRange(0, 1)) != nil
    }
    var result = Array(repeating: Symbol.not, count: tokens.count)
    for (index, token) in tokens.enumerated() {
        switch String(token) {
        case "->":
            result[index] = .assignment
        case "AND":
            result[index] = .and
        case "OR":
            result[index] = .or
        case "NOT":
            result[index] = .not
        case "LSHIFT":
            result[index] = .leftShift
        case "RSHIFT":
            result[index] = .rightShift
        case let sym:
            if let num = UInt16(sym) {
                result[index] = .number(num)
            } else {
                result[index] = .wire(sym)
            }
        }
    }
    return result
}

public enum ParseError: ErrorProtocol {
    case expectedAssignment
    case expectedLiteralOrWire
    case expectedOperator
    case invalidAssignment
    case unexpectedSymbol
    case missingValue
}

public func parse(symbols: [Symbol]) throws -> Statement {
    var seq = symbols.makeIterator()
    
    let expression = try parseExpression(&seq)
    try parseAssignment(&seq)
    let wire = try parseWire(&seq)
    
    if seq.next() != nil {
        throw ParseError.unexpectedSymbol
    }
    
    return .store(wire: wire, expression: expression)
}

// statement ::= expression -> wire
// expression ::=  NOT value | value OP value | value
// value ::= number | wire

private func parseExpression(_ seq: inout Array<Symbol>.Iterator) throws -> Expression {
    let originalSeq = seq
    guard let symbol = seq.next() else {
        throw ParseError.missingValue
    }
    switch symbol {
    case .not:
        return .not(try parseValue(&seq))
    default:
        seq = originalSeq
        let lhs = try parseValue(&seq)
        var peekOperator = seq
        if peekOperator.next() == .assignment {
            return lhs
        } else {
            let op = try parseOperator(&seq)
            let rhs = try parseValue(&seq)
            return op(lhs, rhs)
        }
    }
}

private func parseValue(_ seq: inout Array<Symbol>.Iterator) throws -> Expression {
    guard let symbol = seq.next() else {
        throw ParseError.expectedLiteralOrWire
    }
    switch symbol {
    case let .number(num):
        return .literal(num)
    case let .wire(wire):
        return .reference(wire)
    default:
        throw ParseError.expectedLiteralOrWire
    }
}

private func parseOperator(_ seq: inout Array<Symbol>.Iterator) throws -> (Expression, Expression) -> Expression {
    guard let symbol = seq.next() else {
        throw ParseError.expectedOperator
    }
    switch symbol {
    case .and:
        return Expression.and
    case .or:
        return Expression.or
    case .leftShift:
        return Expression.leftShift
    case .rightShift:
        return Expression.rightShift
    default:
        throw ParseError.expectedOperator
    }
}

private func parseAssignment(_ seq: inout Array<Symbol>.Iterator) throws {
    let symbol = seq.next()
    if symbol == nil || symbol != .assignment {
        throw ParseError.expectedAssignment
    }
}

private func parseWire(_ seq: inout Array<Symbol>.Iterator) throws -> Wire {
    guard let symbol = seq.next() else {
        throw ParseError.missingValue
    }
    if case let .wire(name) = symbol {
        return Wire(name)
    } else {
        throw ParseError.invalidAssignment
    }
}
