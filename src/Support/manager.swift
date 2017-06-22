//
//  manager.swift
//  AdventSupport
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

import Foundation

/// Solutions to Advent of Code problems implement this protocol to be discovered by the main driver program.
/// `part1(input:)` and `part2(input:)` are not guaranteed to be called in any order or even at all.
@objc public protocol Solution {
    @objc init()
    /// An identifier by which the solution is known. Used to invoke the solution from the command-line.
    @objc var name: String { get }
    /// Invoked to display the solution to the first part of the Advent of Code problem.
    @objc func part1(input: String)
    /// Invoked to display the solution to the second part of the Advent of Code problem.
    @objc func part2(input: String)
}

public enum SolutionManager {
    public static var solutions: [String: Solution] = {
        let classCount = objc_getClassList(nil, 0)
        var classes = [AnyClass?](repeating: nil, count: Int(classCount))
        classes.withUnsafeMutableBufferPointer { body in
            let autoptr = AutoreleasingUnsafeMutablePointer<AnyClass>(body.baseAddress)
            _ = objc_getClassList(autoptr, classCount)
        }

        var result: [String: Solution] = [:]
        for case let .some(solution) in classes where class_conformsToProtocol(solution, Solution.self) {
            let impl = (solution as! Solution.Type).init()
            result[impl.name] = impl
        }
        return result
    }()
}
