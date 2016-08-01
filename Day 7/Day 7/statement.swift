//
//  statement.swift
//  Day 7
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

public enum Expression: Equatable {
    indirect case
        and(Expression, Expression),
        or(Expression, Expression),
        not(Expression),
        leftShift(Expression, Expression),
        rightShift(Expression, Expression)
    case literal(UInt16), reference(Wire)
}

public func ==(lhs: Expression, rhs: Expression) -> Bool {
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

public enum Statement {
    case store(wire: Wire, expression: Expression)
}

public typealias Wire = String
