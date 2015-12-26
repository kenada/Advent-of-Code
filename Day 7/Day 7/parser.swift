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

private let whitespace = try! NSRegularExpression(pattern: "\\s", options: [])
public func lex(input: String) -> [Symbol] {
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

public enum ParseError: ErrorType {
    case ExpectedAssignment
    case ExpectedLiteralOrWire
    case ExpectedOperator
    case InvalidAssignment
    case UnexpectedSymbol
    case MissingValue
}

public func parse(symbols: [Symbol]) throws -> Statement {
    var seq = symbols.generate()
    
    let expression = try parseExpression(&seq)
    try parseAssignment(&seq)
    let wire = try parseWire(&seq)
    
    if seq.next() != nil {
        throw ParseError.UnexpectedSymbol
    }
    
    return .Store(wire: wire, expression: expression)
}

// statement ::= expression -> wire
// expression ::=  NOT value | value OP value | value
// value ::= number | wire

private func parseExpression(inout seq: Array<Symbol>.Generator) throws -> Expression {
    let originalSeq = seq
    guard let symbol = seq.next() else {
        throw ParseError.MissingValue
    }
    switch symbol {
    case .Not:
        return .Not(try parseValue(&seq))
    default:
        seq = originalSeq
        let lhs = try parseValue(&seq)
        var peekOperator = seq
        if peekOperator.next() == .Assignment {
            return lhs
        } else {
            let op = try parseOperator(&seq)
            let rhs = try parseValue(&seq)
            return op(lhs, rhs)
        }
    }
}

private func parseValue(inout seq: Array<Symbol>.Generator) throws -> Expression {
    guard let symbol = seq.next() else {
        throw ParseError.ExpectedLiteralOrWire
    }
    switch symbol {
    case let .Number(num):
        return .Literal(num)
    case let .Wire(wire):
        return .Reference(wire)
    default:
        throw ParseError.ExpectedLiteralOrWire
    }
}

private func parseOperator(inout seq: Array<Symbol>.Generator) throws -> (Expression, Expression) -> Expression {
    guard let symbol = seq.next() else {
        throw ParseError.ExpectedOperator
    }
    switch symbol {
    case .And:
        return Expression.And
    case .Or:
        return Expression.Or
    case .LeftShift:
        return Expression.LeftShift
    case .RightShift:
        return Expression.RightShift
    default:
        throw ParseError.ExpectedOperator
    }
}

private func parseAssignment(inout seq: Array<Symbol>.Generator) throws {
    let symbol = seq.next()
    if symbol == nil || symbol != .Assignment {
        throw ParseError.ExpectedAssignment
    }
}

private func parseWire(inout seq: Array<Symbol>.Generator) throws -> Wire {
    guard let symbol = seq.next() else {
        throw ParseError.MissingValue
    }
    if case let .Wire(name) = symbol {
        return Wire(name)
    } else {
        throw ParseError.InvalidAssignment
    }
}