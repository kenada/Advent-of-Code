//
//  pair.swift
//  AdventSupport
//
// Copyright © 2017 Randy Eckenrode
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

public enum JSON: Decodable {
    case boolean(Bool)
    case number(Double)
    case string(String)
    case null
    indirect case array([JSON])
    indirect case object([String: JSON])

    public init(from decoder: Decoder) throws {
        do {
            let container = try decoder.singleValueContainer()
            do {
                self = .boolean(try container.decode(Bool.self))
            } catch DecodingError.valueNotFound {
                self = .null
            } catch DecodingError.typeMismatch {
                do {
                    self = .number(try container.decode(Double.self))
                } catch DecodingError.typeMismatch {
                    do {
                        self = .string(try container.decode(String.self))
                    } catch DecodingError.typeMismatch {
                        throw DecodingError.typeMismatch(JSON.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Encoded payload does not contain an expected primitive type (boolean, number, string, or null)"))
                    }
                }
            }
        } catch let DecodingError.typeMismatch(type, context) {
            guard type != JSON.self else {
                throw DecodingError.typeMismatch(type, context)
            }
            do {
                let container = try decoder.container(keyedBy: JSONCodingKeys.self)
                var dict: [String: JSON] = [:]
                for key in container.allKeys {
                    dict[key.stringValue] = try JSON(from: container.superDecoder(forKey: key))
                }
                self = .object(dict)
            } catch DecodingError.typeMismatch {
                do {
                    var container = try decoder.unkeyedContainer()
                    var arr: [JSON] = []
                    while !container.isAtEnd {
                        do {
                            arr.append(try JSON(from: container.superDecoder()))
                        } catch DecodingError.valueNotFound {
                            _ = try container.decodeIfPresent(Bool.self)
                            arr.append(.null)
                        }
                    }
                    self = .array(arr)
                } catch DecodingError.typeMismatch {
                    throw DecodingError.typeMismatch(JSON.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Encoded payload does not contain JSON"))
                }
            }
        }
    }
}

private struct JSONCodingKeys: CodingKey {
    var stringValue: String

    init?(stringValue: String) {
        self.stringValue = stringValue
    }

    var intValue: Int?

    init?(intValue: Int) {
        self.init(stringValue: "\(intValue)")
        self.intValue = intValue
    }
}
