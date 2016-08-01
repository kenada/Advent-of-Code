//
//  md5.swift
//  Day 4
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

func md5(bytes: [UInt8]) -> [UInt8] {
    var state = CC_MD5_CTX()
    withUnsafeMutablePointer(&state) { _ = CC_MD5_Init($0) }
    withUnsafeMutablePointer(&state) { _ = CC_MD5_Update($0, bytes, CC_LONG(bytes.count)) }
    
    var digest = Array<UInt8>(repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
    digest.withUnsafeMutableBufferPointer { digestPtr in
        withUnsafeMutablePointer(&state) { _ = CC_MD5_Final(digestPtr.baseAddress, $0) }
    }

    return digest
}

func md5(string: String) -> [UInt8] {
    return md5(bytes: [UInt8](string.utf8))
}
