//
//  support.swift
//  Day 12
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

public func sum(jsonObject: Any, ignoring: ([String: Any]) -> Bool) -> Double {
    switch jsonObject {
    case let dict as [String: Any]:
        if !ignoring(dict) {
            return dict.values.reduce(0.0) { $0 + sum(jsonObject: $1, ignoring: ignoring) }
        } else {
            return 0.0
        }
    case let obj as [Any]:
        return obj.reduce(0.0) { $0 + sum(jsonObject: $1, ignoring: ignoring) }
    case let dbl as Double:
        return dbl
    default:
        return 0.0
    }
}

public func sum(jsonObject: Any) -> Double {
    return sum(jsonObject: jsonObject) { _ in return false }
}

public func hasRedProperty(_ dict: [String: Any]) -> Bool {
    return dict.values.reduce(false) { $0 || ($1 as? String ?? "") == "red" }
}
