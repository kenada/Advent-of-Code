//
//  main.swift
//  Day 6
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

let commands = try! String(contentsOfFile: "day6 input.txt")

let boolGrid = LightGrid(width: 1000, height: 1000)
let intGrid = LightGrid(width: 1000, height: 1000)

for case let command? in commands.characters.split(separator: "\n").lazy.map(String.init).map(LightGridCommand.init) {
    switch command {
    case let .turnOn(area):
        boolGrid.turnOn(area: area)
        intGrid.turnOn(area: area)
    case let .turnOff(area):
        boolGrid.turnOff(area: area)
        intGrid.turnOff(area: area)
    case let .toggle(area):
        boolGrid.toggle(area: area)
        intGrid.increaseBrightness(by: 2, area: area)
    }
}

print("\(boolGrid.lightsOn) lights are lit")
print("The total brightness is \(intGrid.brightness)")
