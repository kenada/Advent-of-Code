//
//  runner.swift
//  Advent of Code 2015
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

import AdventSupport
import Cocoa

// As of Swift 3.0, command-line apps cannot link against frameworks. In order to link against a framework,
// I have put the command-line app in a Cocoa application bundle. Unfortunately, this messes up unit testing.
// The unit test runner expects to launch a Cocoa app, introspect its tests, and then run them.
// This null solution kicks off the Cocoa runloop, allowing the test runner to work as expected.
class TestRunner: Solution {

    required init() {}

    var name = "Test Runner"

    func part1(input: String) {}

    func part2(input: String) {
        _ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)
    }

}
