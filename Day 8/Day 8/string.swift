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
        
        var index = self.characters.startIndex
        while (index < self.characters.endIndex) {
            switch self.characters[index] {
            case "\\":
                switch self.characters[index.successor()] {
                case "\"":
                    result += "\""
                    index = index.successor()
                case "\\":
                    result += "\\"
                    index = index.successor()
                case "x":
                    var hexNum = ""
                    hexNum.append(self.characters[index.successor().successor()])
                    hexNum.append(self.characters[index.successor().successor().successor()])
                    if let value = Int(hexNum, radix: 16) {
                        result.append(Character(UnicodeScalar(value)))
                        index = index.successor().successor().successor()
                    } else {
                        result.append(self.characters[index])
                    }
                default:
                    result.append(self.characters[index])
                }
            default:
                result.append(self.characters[index])
            }
            index = index.successor()
        }
        
        return result
    }
    
    public var literalSize: Int {
        return self.unicodeScalars.count + 2
    }
    
    public var size: Int {
        return self.escaped.unicodeScalars.count
    }
    
}