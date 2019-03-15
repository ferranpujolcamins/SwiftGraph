//
//  ArrayMutateTests.swift
//  SwiftGraphTests
//
//  Copyright (c) 2019 Ferran Pujol Camins
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

class ArrayMutateTests: XCTestCase {

    func testMutate() {
        var array = Array(repeating: 0, count: 3)
        array.mutate { (index, element: inout Int) in
            if index > 0 {
                element = element + 1
            }
        }
        XCTAssertEqual(array, [0, 1, 1])
    }

    func testNestedMutate() {
        var array = Array(repeating: Array(repeating: 0, count: 3), count: 3)
        array.mutate { (i, row) in
            row.mutate { (j, element) in
                element = element + 3*i + j
            }
        }
        XCTAssertEqual(array, [
            [0, 1, 2],
            [3, 4, 5],
            [6, 7, 8]
        ])
    }
}
