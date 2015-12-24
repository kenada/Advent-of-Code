//
//  Day_7_Tests.swift
//  Day 7 Tests
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

import XCTest

class Day_7_Parser_Tests: XCTestCase {
    
    
    
}

class Day_7_VM_Tests: XCTestCase {
    
    let vm = VirtualMachine()
    
    override func setUp() {
        vm.reboot()
    }
    
    func testStore() {
        let expectedResults: [String: UInt16] = [
            "x": 123,
            "y": 456
        ]
        let program: [Statement] = [
            .Store(wire: "x", expression: .ValueExpression(.Number(123))),
            .Store(wire: "y", expression: .ValueExpression(.Number(456)))
        ]
        Day_7_VM_Tests.test(program, virtualMachine: vm, expectedResults: expectedResults)
    }
    
    func testAnd() {
        let expectedResults: [String: UInt16] = [
            "x": 1,
            "y": 3,
            "z": 1
        ]
        let program: [Statement] = [
            .Store(wire: "x", expression: .ValueExpression(.Number(1))),
            .Store(wire: "y", expression: .ValueExpression(.Number(3))),
            .Store(wire: "z", expression: .And(.WireRef("x"), .WireRef("y")))
        ]
        Day_7_VM_Tests.test(program, virtualMachine: vm, expectedResults: expectedResults)
    }
    
    func testOr() {
        let expectedResults: [String: UInt16] = [
            "x": 1,
            "y": 2,
            "z": 3
        ]
        let program: [Statement] = [
            .Store(wire: "x", expression: .ValueExpression(.Number(1))),
            .Store(wire: "y", expression: .ValueExpression(.Number(2))),
            .Store(wire: "z", expression: .Or(.WireRef("x"), .WireRef("y")))
        ]
        Day_7_VM_Tests.test(program, virtualMachine: vm, expectedResults: expectedResults)
    }
    
    func testNot() {
        let expectedResults: [String: UInt16] = [
            "x": 1,
            "y": 65534,
        ]
        let program: [Statement] = [
            .Store(wire: "x", expression: .ValueExpression(.Number(1))),
            .Store(wire: "y", expression: .Not(.WireRef("x")))
        ]
        Day_7_VM_Tests.test(program, virtualMachine: vm, expectedResults: expectedResults)
    }
    
    func testLeftShift() {
        let expectedResults: [String: UInt16] = [
            "x": 1,
            "y": 2,
            "z": 4
        ]
        let program: [Statement] = [
            .Store(wire: "x", expression: .ValueExpression(.Number(1))),
            .Store(wire: "y", expression: .ValueExpression(.Number(2))),
            .Store(wire: "z", expression: .LeftShift(.WireRef("x"), .WireRef("y")))
        ]
        Day_7_VM_Tests.test(program, virtualMachine: vm, expectedResults: expectedResults)
    }
    
    func testRightShift() {
        let expectedResults: [String: UInt16] = [
            "x": 4,
            "y": 2,
            "z": 1
        ]
        let program: [Statement] = [
            .Store(wire: "x", expression: .ValueExpression(.Number(4))),
            .Store(wire: "y", expression: .ValueExpression(.Number(2))),
            .Store(wire: "z", expression: .RightShift(.WireRef("x"), .WireRef("y")))
        ]
        Day_7_VM_Tests.test(program, virtualMachine: vm, expectedResults: expectedResults)
    }
    
    static func test<Program: SequenceType where Program.Generator.Element == Statement>(
        program: Program, virtualMachine vm: VirtualMachine, expectedResults: [String: UInt16]) {
            vm.execute(program)
            XCTAssertEqual(vm.core.count, expectedResults.count, "vm.core.count == expectedResults.count")
            for (wire, value) in vm.core {
                XCTAssertEqual(value, expectedResults[wire], "\(wire) value == expectedResults[\(wire)]")
            }
    }
    
}