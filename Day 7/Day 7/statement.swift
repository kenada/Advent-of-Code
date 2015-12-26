//
//  statement.swift
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

public enum Expression: Equatable {
    indirect case
        And(Expression, Expression),
        Or(Expression, Expression),
        Not(Expression),
        LeftShift(Expression, Expression),
        RightShift(Expression, Expression)
    case Literal(UInt16), Reference(Wire)
}

public func ==(lhs: Expression, rhs: Expression) -> Bool {
    switch (lhs, rhs) {
    case let (.And(lhs_lexp, lhs_rexp), .And(rhs_lexp, rhs_rexp)):
        return lhs_lexp == rhs_lexp && lhs_rexp == rhs_rexp
    case let (.Or(lhs_lexp, lhs_rexp), .Or(rhs_lexp, rhs_rexp)):
        return lhs_lexp == rhs_lexp && lhs_rexp == rhs_rexp
    case let (.Not(lhs_exp), .Not(rhs_exp)):
        return lhs_exp == rhs_exp
    case let (.LeftShift(lhs_lexp, lhs_rexp), .LeftShift(rhs_lexp, rhs_rexp)):
        return lhs_lexp == rhs_lexp && lhs_rexp == rhs_rexp
    case let (.RightShift(lhs_lexp, lhs_rexp), .RightShift(rhs_lexp, rhs_rexp)):
        return lhs_lexp == rhs_lexp && lhs_rexp == rhs_rexp
    case let (.Literal(lhs_num), .Literal(rhs_num)):
        return lhs_num == rhs_num
    case let (.Reference(lhs_sym), .Reference(rhs_sym)):
        return lhs_sym == rhs_sym
    default:
        return false
    }
}

public enum Statement {
    case Store(wire: Wire, expression: Expression)
}

public typealias Wire = String