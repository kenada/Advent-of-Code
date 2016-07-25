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

class Day_7_Lexer_Tests: XCTestCase {
    
    func testLiteralStore() {
        Day_7_Lexer_Tests.testParse("1 -> b", expectedResults: .number(1), .assignment, .wire("b"))
    }
    
    func testWireCopy() {
        Day_7_Lexer_Tests.testParse("a -> b", expectedResults: .wire("a"), .assignment, .wire("b"))
    }
    
    func testNot() {
        Day_7_Lexer_Tests.testParse("NOT a -> b", expectedResults: .not, .wire("a"), .assignment, .wire("b"))
    }
    
    func testAnd() {
        Day_7_Lexer_Tests.testParse("1 AND b -> b", expectedResults: .number(1), .and, .wire("b"), .assignment, .wire("b"))
    }
    
    func testOr() {
        Day_7_Lexer_Tests.testParse("a OR 2 -> b",
            expectedResults: .wire("a"), .or, .number(2), .assignment, .wire("b"))
    }
    
    func testLeftShift() {
        Day_7_Lexer_Tests.testParse("c LSHIFT d -> b", expectedResults: .wire("c"), .leftShift, .wire("d"), .assignment, .wire("b"))
    }
    
    func testRightShift() {
        Day_7_Lexer_Tests.testParse("1 RSHIFT 2 -> q",
            expectedResults: .number(1), .rightShift, .number(2), .assignment, .wire("q"))
    }
    
    func parseFailure() {
        Day_7_Lexer_Tests.testParse("fsldfjasldfk333j", expectedResults: .wire("fsldfjasldfk333j"))
    }
    
    static func testParse(_ input: String, expectedResults: Symbol...) {
        let result = lex(input: input)
        XCTAssertEqual(result.count, expectedResults.count, "lengths match")
        for (symbol, expectedSymbol) in zip(result, expectedResults) {
            XCTAssertEqual(symbol, expectedSymbol, "symbol sequences match")
        }
    }
    
}

class Day_7_Parser_Tests: XCTestCase {
    
    func testLiteral() {
        Day_7_Parser_Tests.test([.number(1), .assignment, .wire("b")],
            expectedResults: .store(wire: "b", expression: .literal(1)))
    }
    
    func testWire() {
        Day_7_Parser_Tests.test([.wire("a"), .assignment, .wire("b")],
            expectedResults: .store(wire: "b", expression: .reference("a")))
    }

    func testAnd() {
        Day_7_Parser_Tests.test([.number(1), .and, .wire("b"), .assignment, .wire("b")],
            expectedResults: .store(wire: "b", expression: .and(.literal(1), .reference("b"))))
    }
    
    func testOr() {
        Day_7_Parser_Tests.test([.wire("a"), .or, .number(2), .assignment, .wire("b")],
            expectedResults: .store(wire: "b", expression: .or(.reference("a"), .literal(2))))
    }
    
    func testNot() {
        Day_7_Parser_Tests.test([.not, .wire("a"), .assignment, .wire("b")],
            expectedResults: .store(wire: "b", expression: .not(.reference("a"))))
    }
    
    func testLeftShift() {
        Day_7_Parser_Tests.test([.wire("c"), .leftShift, .wire("d"), .assignment, .wire("b")],
            expectedResults: .store(wire: "b", expression: .leftShift(.reference("c"), .reference("d"))))
    }
    
    func testRightShift() {
        Day_7_Parser_Tests.test([.number(1), .rightShift, .number(2), .assignment, .wire("q")],
            expectedResults: .store(wire: "q", expression: .rightShift(.literal(1), .literal(2))))
    }
    
    func testInvalidAssignment() {
        Day_7_Parser_Tests.testParseError(input: .number(1), .assignment, .number(1),
            expectedException: .invalidAssignment)
    }
    
    func testExpectedAssignment() {
        Day_7_Parser_Tests.testParseError(input: .number(1), .and, .number(2), expectedException: .expectedAssignment)
    }
    
    func testExpectedOperator() {
        Day_7_Parser_Tests.testParseError(input: .number(1), expectedException: .expectedOperator)
    }
    
    func testUnexpectedSymbol() {
        Day_7_Parser_Tests.testParseError(input: .number(1), .and, .number(1), .assignment, .wire("a"), .number(5),
            expectedException: .unexpectedSymbol)
    }
    
    func testMissingValue() {
        Day_7_Parser_Tests.testParseError(input: .number(5), .assignment, expectedException: .missingValue)
    }
    
    func testExpectedLiteralOrWire() {
        Day_7_Parser_Tests.testParseError(input: .assignment, expectedException: .expectedLiteralOrWire)
    }
    
    static func test(_ input: [Symbol], expectedResults: Statement) {
        let result = try! parse(symbols: input)
        switch (result, expectedResults) {
        case let (.store(wire, expression), .store(expectedWire, expectedExpression)):
            XCTAssertEqual(wire, expectedWire, "wires match")
            XCTAssertEqual(expression, expectedExpression, "expressions match")
        }
    }
    
    static func testParseError(input: Symbol..., expectedException: ParseError) {
        do {
            _ = try parse(symbols: input)
            XCTAssert(false, "expecting exception")
        } catch let exp as ParseError {
            XCTAssertEqual(exp, expectedException, "expected exception thrown")
        } catch {
            XCTAssert(false, "unexception exception not thrown")
        }
    }
    
}

class Day_7_VM_Tests: XCTestCase {
    
    let vm = VirtualMachine()
    
    override func setUp() {
        vm.reset()
    }
    
    func testStore() {
        let expectedResults: [Wire: UInt16] = [
            "x": 123,
            "y": 456
        ]
        let program: [Statement] = [
            .store(wire: "x", expression: .literal(123)),
            .store(wire: "y", expression: .literal(456))
        ]
        Day_7_VM_Tests.test(program, virtualMachine: vm, expectedResults: expectedResults)
    }
    
    func testAnd() {
        let expectedResults: [Wire: UInt16] = [
            "x": 1,
            "y": 3,
            "z": 1
        ]
        let program: [Statement] = [
            .store(wire: "x", expression: .literal(1)),
            .store(wire: "y", expression: .literal(3)),
            .store(wire: "z", expression: .and(.reference("x"), .reference("y")))
        ]
        Day_7_VM_Tests.test(program, virtualMachine: vm, expectedResults: expectedResults)
    }
    
    func testOr() {
        let expectedResults: [Wire: UInt16] = [
            "x": 1,
            "y": 2,
            "z": 3
        ]
        let program: [Statement] = [
            .store(wire: "x", expression: .literal(1)),
            .store(wire: "y", expression: .literal(2)),
            .store(wire: "z", expression: .or(.reference("x"), .reference("y")))
        ]
        Day_7_VM_Tests.test(program, virtualMachine: vm, expectedResults: expectedResults)
    }
    
    func testNot() {
        let expectedResults: [Wire: UInt16] = [
            "x": 1,
            "y": 65534,
        ]
        let program: [Statement] = [
            .store(wire: "x", expression: .literal(1)),
            .store(wire: "y", expression: .not(.reference("x")))
        ]
        Day_7_VM_Tests.test(program, virtualMachine: vm, expectedResults: expectedResults)
    }
    
    func testLeftShift() {
        let expectedResults: [Wire: UInt16] = [
            "x": 1,
            "y": 2,
            "z": 4
        ]
        let program: [Statement] = [
            .store(wire: "x", expression: .literal(1)),
            .store(wire: "y", expression: .literal(2)),
            .store(wire: "z", expression: .leftShift(.reference("x"), .reference("y")))
        ]
        Day_7_VM_Tests.test(program, virtualMachine: vm, expectedResults: expectedResults)
    }
    
    func testRightShift() {
        let expectedResults: [Wire: UInt16] = [
            "x": 4,
            "y": 2,
            "z": 1
        ]
        let program: [Statement] = [
            .store(wire: "x", expression: .literal(4)),
            .store(wire: "y", expression: .literal(2)),
            .store(wire: "z", expression: .rightShift(.reference("x"), .reference("y")))
        ]
        Day_7_VM_Tests.test(program, virtualMachine: vm, expectedResults: expectedResults)
    }
    
    func testSubExpressions() {
        let expectedResults: [Wire: UInt16] = [
            "q": 3
        ]
        let program: [Statement] = [
            .store(wire: "q", expression: .and(.not(.and(.reference("x"), .reference("y"))),
                .or(.reference("x"), .reference("y")))),
            .store(wire: "x", expression: .literal(5)),
            .store(wire: "y", expression: .literal(6))
        ]
        Day_7_VM_Tests.test(program, virtualMachine: vm, expectedResults: expectedResults)
    }
    
    static func test<Program: Sequence where Program.Iterator.Element == Statement>(
        _ program: Program, virtualMachine vm: VirtualMachine, expectedResults: [Wire: UInt16]) {
            vm.load(program: program)
            for (wire, expectedValue) in expectedResults {
                XCTAssertEqual(vm.read(wire: wire), expectedValue, "\(wire) value == expectedResults[\(wire)]")
            }
    }
    
}
