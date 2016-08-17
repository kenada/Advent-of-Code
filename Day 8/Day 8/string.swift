//
//  string.swift
//  Day 8
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

extension String {
    
    public var escaped: String {
        var result = ""
        
        var index = characters.startIndex
        while (index < characters.endIndex) {
            switch characters[index] {
            case "\\":
                switch characters[characters.index(after: index)] {
                case "\"":
                    result += "\""
                    index = characters.index(after: index)
                case "\\":
                    result += "\\"
                    index = characters.index(after: index)
                case "x":
                    var hexNum = ""
                    hexNum.append(characters[characters.index(index, offsetBy: 2)])
                    hexNum.append(characters[characters.index(index, offsetBy: 3)])
                    if let value = Int(hexNum, radix: 16) {
                        result.append(Character(UnicodeScalar(value)!))
                        index = characters.index(index, offsetBy: 3)
                    } else {
                        result.append(characters[index])
                    }
                default:
                    result.append(characters[index])
                }
            default:
                result.append(characters[index])
            }
            index = characters.index(after: index)
        }
        
        return result
    }
    
    public var literalSize: Int {
        return unicodeScalars.count + 2
    }
    
    public var size: Int {
        return escaped.unicodeScalars.count
    }
    
    public init?(xmasEncode str: String) {
        var result = "\\\""
        
        for ch in str.characters {
            switch ch {
            case "\\":
                result += "\\\\"
            case "\"":
                result += "\\\""
            default:
                result.append(ch)
            }
        }
        
        result += "\\\""
        
        self.init(result)
    }
    
}
