//
//  main.swift
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

let input = try! String(contentsOfFile: "day 7 input.txt")

let program = input.characters.split("\n").map { line -> Statement in
    let line = String(line)
    do {
        let statement = try parse(lex(line))
        return statement
    } catch ParseError.ExpectedAssignment {
        fatalError("\(line)\n\n\tExpected assignment statement but something else (or nothing) found.")
    } catch ParseError.ExpectedLiteralOrWire {
        fatalError("\(line)\n\n\tExpected literal or wire but something else (or nothing) found.")
    } catch ParseError.ExpectedOperator {
        fatalError("\(line)\n\n\tExpected operator but something else (or nothing) found.")
    } catch ParseError.InvalidAssignment {
        fatalError("\(line)\n\n\tTarget of assignment is not a wire")
    } catch ParseError.UnexpectedSymbol {
        fatalError("\(line)\n\n\tUnexpected symbol found at the end of the line. Please remove.")
    } catch ParseError.MissingValue {
        fatalError("\(line)\n\n\tValue or wire expected but not found.")
    } catch {
        fatalError()
    }
}

let vm = VirtualMachine()
vm.load(program)

let a = vm.read("a")
print("a: \(a)")