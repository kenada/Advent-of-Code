//
//  day 7.swift
//  Advent of Code 2015
//
// Copyright © 2016 Randy Eckenrode
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
import Foundation

// MARK: - Parser

enum Symbol: Equatable {
    case assignment
    
    case wire(String)
    case number(UInt16)
    
    case and, or, leftShift, rightShift, not
}

func ==(lhs: Symbol, rhs: Symbol) -> Bool {
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

private let whitespace = try! NSRegularExpression(pattern: "\\s", options: [])
func lex(input: String) -> [Symbol] {
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

enum ParseError: Error {
    case expectedAssignment
    case expectedLiteralOrWire
    case expectedOperator
    case invalidAssignment
    case unexpectedSymbol
    case missingValue
}

func parse(symbols: [Symbol]) throws -> Statement {
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

// MARK: - Statements

enum Expression: Equatable {
    indirect case
    and(Expression, Expression),
    or(Expression, Expression),
    not(Expression),
    leftShift(Expression, Expression),
    rightShift(Expression, Expression)
    case literal(UInt16), reference(Wire)
}

func ==(lhs: Expression, rhs: Expression) -> Bool {
    switch (lhs, rhs) {
    case let (.and(lhs_lexp, lhs_rexp), .and(rhs_lexp, rhs_rexp)):
        return lhs_lexp == rhs_lexp && lhs_rexp == rhs_rexp
    case let (.or(lhs_lexp, lhs_rexp), .or(rhs_lexp, rhs_rexp)):
        return lhs_lexp == rhs_lexp && lhs_rexp == rhs_rexp
    case let (.not(lhs_exp), .not(rhs_exp)):
        return lhs_exp == rhs_exp
    case let (.leftShift(lhs_lexp, lhs_rexp), .leftShift(rhs_lexp, rhs_rexp)):
        return lhs_lexp == rhs_lexp && lhs_rexp == rhs_rexp
    case let (.rightShift(lhs_lexp, lhs_rexp), .rightShift(rhs_lexp, rhs_rexp)):
        return lhs_lexp == rhs_lexp && lhs_rexp == rhs_rexp
    case let (.literal(lhs_num), .literal(rhs_num)):
        return lhs_num == rhs_num
    case let (.reference(lhs_sym), .reference(rhs_sym)):
        return lhs_sym == rhs_sym
    default:
        return false
    }
}

enum Statement {
    case store(wire: Wire, expression: Expression)
}

typealias Wire = String

// MARK: - Virtual Machine

class VirtualMachine {

    func reset() {
        self.core = [:]
        self.memo = [:]
    }

    func load<Program: Sequence>(program: Program) where Program.Iterator.Element == Statement {
        for case let .store(wire, expression) in program {
            self.core[wire] = expression
        }
        self.memo = [:]
    }

    private var core: [Wire: Expression] = [:]
    private var memo: [Wire: UInt16] = [:]

    var gates: [Wire] { return Array(self.core.keys) }

    func read(wire: Wire) -> UInt16? {
        return self.core[wire]?.evaluate(self.core, memo: &self.memo)
    }

}

private extension Expression {

    func evaluate(_ core: [Wire: Expression], memo: inout [Wire: UInt16]) -> UInt16 {
        switch self {
        case let .and(lhs, rhs):
            return lhs.evaluate(core, memo: &memo) & rhs.evaluate(core, memo: &memo)
        case let .or(lhs, rhs):
            return lhs.evaluate(core, memo: &memo) | rhs.evaluate(core, memo: &memo)
        case let .not(exp):
            return ~exp.evaluate(core, memo: &memo)
        case let .leftShift(lhs, rhs):
            return lhs.evaluate(core, memo: &memo) << rhs.evaluate(core, memo: &memo)
        case let .rightShift(lhs, rhs):
            return lhs.evaluate(core, memo: &memo) >> rhs.evaluate(core, memo: &memo)
        case let .literal(num):
            return num
        case let .reference(wire):
            if let num = core[wire] {
                if let memoizedNum = memo[wire] {
                    return memoizedNum
                } else {
                    let m = num.evaluate(core, memo: &memo)
                    memo[wire] = m
                    return m
                }
            } else {
                fatalError("“\(wire)” does not exist")
            }
        }
    }

}

// MARK: - Solution

class Day7: Solution {
    required init() {}

    var name = "Day 7"

    func part1(input: String) {
        let program = Day7.load(input: input)

        let vm = VirtualMachine()
        vm.load(program: program)

        print("a: \(vm.read(wire: "a")!)")
    }

    func part2(input: String) {
        let program = Day7.load(input: input)

        let vm = VirtualMachine()
        vm.load(program: program)

        let a = vm.read(wire: "a")!
        let newProgram = [try! parse(symbols: lex(input: "\(a) -> b"))]
        vm.load(program: newProgram)

        print("a: \(vm.read(wire: "a")!)")
    }

    private class func load(input: String) -> [Statement] {
        let program = input.characters.split(separator: "\n").map { line -> Statement in
            let line = String(line)
            do {
                let statement = try parse(symbols: lex(input: line))
                return statement
            } catch ParseError.expectedAssignment {
                fatalError("\(line)\n\n\tExpected assignment statement but something else (or nothing) found.")
            } catch ParseError.expectedLiteralOrWire {
                fatalError("\(line)\n\n\tExpected literal or wire but something else (or nothing) found.")
            } catch ParseError.expectedOperator {
                fatalError("\(line)\n\n\tExpected operator but something else (or nothing) found.")
            } catch ParseError.invalidAssignment {
                fatalError("\(line)\n\n\tTarget of assignment is not a wire")
            } catch ParseError.unexpectedSymbol {
                fatalError("\(line)\n\n\tUnexpected symbol found at the end of the line. Please remove.")
            } catch ParseError.missingValue {
                fatalError("\(line)\n\n\tValue or wire expected but not found.")
            } catch {
                fatalError()
            }
        }
        return program
    }
}
