//
//  vm.swift
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

public class VirtualMachine {
    
    public func reset() {
        self.core = [:]
    }
    
    public func execute<Program: SequenceType where Program.Generator.Element == Statement>(program: Program) {
        for case let .Store(wire, expression) in program {
            self.core[wire] = expression.evaluate(self.core)
        }
    }
    
    public private(set) var core: [Wire: UInt16] = [:]
    
}

private extension Expression {
    
    func evaluate(core: [Wire: UInt16]) -> UInt16 {
        switch self {
        case let .And(lhs, rhs):
            return lhs.evaluate(core) & rhs.evaluate(core)
        case let .Or(lhs, rhs):
            return lhs.evaluate(core) | rhs.evaluate(core)
        case let .Not(exp):
            return ~exp.evaluate(core)
        case let .LeftShift(lhs, rhs):
            return lhs.evaluate(core) << rhs.evaluate(core)
        case let .RightShift(lhs, rhs):
            return lhs.evaluate(core) >> rhs.evaluate(core)
        case let Literal(num):
            return num
        case let Reference(wire):
            if let num = core[wire] {
                return num
            } else {
                fatalError("“\(wire)” does not exist")
            }
        }
    }
    
}