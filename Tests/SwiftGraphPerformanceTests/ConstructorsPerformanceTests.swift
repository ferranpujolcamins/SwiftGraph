//
//  ConstructorsPerformanceTests.swift
//  SwiftGraphTests
//
//  Copyright (c) 2018 Ferran Pujol Camins
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

import XCTest
@testable import SwiftGraph

class ConstructorsPerformanceTests: XCTestCase {
    func testStarGraphConstructor() {
        self.measure {
            _ = StarGraph.build(withCenter: 0, andLeafs: Array(1...999999))
        }
    }

    func testCompleteGraphConstructor() {
        self.measure {
            _ = CompleteGraph.build(withVertices: Array(0...1999))
        }
    }

    static var allTests = [
        ("testStarGraphConstructor", testStarGraphConstructor),
        ("testCompleteGraphConstructor", testCompleteGraphConstructor),
    ]
}