//
//  Day_11_Tests.swift
//  Day 11 Tests
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

import XCTest

class Day_11_Tests: XCTestCase {

    func testFilter() {
        let tests = [
            (password: try! Password(string: "hijklmmn"), expectedResult: false),
            (password: try! Password(string: "abbceffg"), expectedResult: false),
            (password: try! Password(string: "abbcegjk"), expectedResult: false),
            (password: try! Password(string: "abcdffaa"), expectedResult: true),
            (password: try! Password(string: "ghjaabcc"), expectedResult: true),
            ]
        tests.forEach { (x: (password: Password, expectedResult: Bool)) in
            XCTAssertEqual(x.password.isValid, x.expectedResult, "\(x.password.value)")
        }
    }

    func testPasswordIncrement() {
        let tests = [
            (password: try! Password(string: "aaaaaaaa"), expectedResult: "aaaaaaab"),
            (password: try! Password(string: "aaaaaaaz"), expectedResult: "aaaaaaba"),
            (password: try! Password(string: "aaaaaazz"), expectedResult: "aaaaabaa"),
            (password: try! Password(string: "aaaaazzz"), expectedResult: "aaaabaaa"),
            (password: try! Password(string: "aaaazzzz"), expectedResult: "aaabaaaa"),
            (password: try! Password(string: "aaazzzzz"), expectedResult: "aabaaaaa"),
            (password: try! Password(string: "aazzzzzz"), expectedResult: "abaaaaaa"),
            (password: try! Password(string: "azzzzzzz"), expectedResult: "baaaaaaa"),
            (password: try! Password(string: "zzzzzzzz"), expectedResult: "aaaaaaaa"),
            (password: try! Password(string: "deadbeaf"), expectedResult: "deadbeag"),
            ]
        tests.forEach { (x: (password: Password, expectedResult: String)) in
            XCTAssertEqual(x.password.next().value, x.expectedResult)
        }
    }

    func testNextValidPassword() {
        let tests = [
            (password: try! Password(string: "abcdefgh"), expectedResult: "abcdffaa"),
            (password: try! Password(string: "ghijklmn"), expectedResult: "ghjaabcc"),
            ]
        tests.forEach { (x: (password: Password, expectedResult: String)) in
            XCTAssertEqual(x.password.nextValidPassword().value, x.expectedResult)
        }
    }

    func testGoodPasswords() {
        let input = [
            "hijklmmn",
            "abbceffg",
            "abbcegjk",
            "abcdffaa",
            "ghjaabcc",
            ]
        input.forEach { string in
            do {
                let password = try Password(string: string)
                XCTAssertEqual(password.value, string)
            } catch {
                XCTFail("Failed to create Password object.")
            }
        }
    }

    func testShortPasswords() {
        let input = [
            "a",
            "ab",
            "abc",
            "abcd",
            "abcde",
            "abcdef",
            "abcdefg",
            ]
        input.forEach { string in
            do {
                XCTAssertThrowsError(try Password(string: string)) { error in
                    let pwerror = error as? PasswordError
                    XCTAssertNotNil(pwerror)
                    XCTAssertEqual(pwerror!, PasswordError.tooShort)
                }
            } catch {
                XCTFail()
            }
        }
    }

    func testLongPasswords() {
        let input = [
            "abcdefghi",
            "abcdefghij",
            "abcdefghijk",
            "abcdefghijkl",
            "abcdefghijklm",
            "abcdefghijklmn",
            "abcdefghijklmno",
            "abcdefghijklmnop",
            ]
        input.forEach { string in
            do {
                XCTAssertThrowsError(try Password(string: string)) { error in
                    let pwerror = error as? PasswordError
                    XCTAssertNotNil(pwerror)
                    XCTAssertEqual(pwerror!, PasswordError.tooLong)
                }
            } catch {
                XCTFail()
            }
        }
    }

    func testInvalidPasswords() {
        let input = [
            "😑😑😑😑😑😑😑😑",
            "29383233"
        ]
        input.forEach { string in
            do {
                XCTAssertThrowsError(try Password(string: string)) { error in
                    let pwerror = error as? PasswordError
                    XCTAssertNotNil(pwerror)
                    XCTAssertEqual(pwerror!, PasswordError.invalidCharacters)
                }
            } catch {
                XCTFail()
            }
        }
    }
    
}
