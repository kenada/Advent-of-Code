//
//  vm.swift
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

public class VirtualMachine {
    
    public func reset() {
        self.core = [:]
        self.memo = [:]
    }
    
    public func load<Program: Sequence where Program.Iterator.Element == Statement>(program: Program) {
        for case let .store(wire, expression) in program {
            self.core[wire] = expression
        }
        self.memo = [:]
    }
    
    private var core: [Wire: Expression] = [:]
    private var memo: [Wire: UInt16] = [:]
    
    public var gates: [Wire] { return Array(self.core.keys) }
    
    public func read(wire: Wire) -> UInt16? {
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
        case let literal(num):
            return num
        case let reference(wire):
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
