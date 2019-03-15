//
//  UnweightedUniqueElementsGraphTests.swift
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

class UnweightedUniqueElementsGraphHashableTests: XCTestCase {

    func testUniqueVertexAfterInit() {
        let g = UnweightedUniqueElementsGraph<EquatableString>(vertices:["Atlanta", "Atlanta"])
        XCTAssertEqual(g.vertices, ["Atlanta"], "Expected one vertex")
    }

    func testUniqueVertexAfterAddition() {
        let g = UnweightedUniqueElementsGraph<EquatableString>()
        _ = g.addVertex("Atlanta")
        XCTAssertEqual(g.vertices, ["Atlanta"], "Expected one vertex")

        _ = g.addVertex("Atlanta")
        XCTAssertEqual(g.vertices, ["Atlanta"], "Expected one vertex")
    }
    
    func testUniqueUndirectedEdges() {
        let g = UnweightedUniqueElementsGraph<EquatableString>(vertices:["Atlanta", "Chicago"])
        g.addEdge(from: "Atlanta", to: "Chicago", directed: false)
        g.addEdge(from: "Atlanta", to: "Chicago", directed: false)
        XCTAssertTrue(g.vertex("Atlanta", isAdjacentTo: "Chicago"), "Expected an edge from Atlanta to Chicago")
        XCTAssertTrue(g.vertex("Chicago", isAdjacentTo: "Atlanta"), "Expected an edge from Chicago to Atlanta")
        XCTAssertEqual(g.edgeCount, 1, "Expected one edge")
    }

    func testUniqueUndirectedEdges2() {
        let g = UnweightedUniqueElementsGraph<EquatableString>(vertices:["Atlanta", "Boston", "Chicago"])
        g.addEdge(from: "Chicago", to: "Boston", directed: false)
        g.addEdge(from: "Atlanta", to: "Chicago", directed: false)
        XCTAssertTrue(g.vertex("Atlanta", isAdjacentTo: "Chicago"), "Expected an edge from Atlanta to Chicago")
        XCTAssertTrue(g.vertex("Atlanta", isAdjacentTo: "Chicago"), "Expected an edge from Atlanta to Chicago")
        XCTAssertTrue(g.vertex("Chicago", isAdjacentTo: "Atlanta"), "Expected an edge from Chicago to Atlanta")
        XCTAssertTrue(g.vertex("Chicago", isAdjacentTo: "Boston"), "Expected an edge from Chicago to Atlanta")
        XCTAssertTrue(g.vertex("Boston", isAdjacentTo: "Chicago"), "Expected an edge from Chicago to Atlanta")
        XCTAssertEqual(g.edgeCount, 2, "Expected two edges")
    }

    func testUniqueUndirectedLoop() {
        let g = UnweightedUniqueElementsGraph<EquatableString>(vertices:["Atlanta"])
        g.addEdge(from: "Atlanta", to: "Atlanta", directed: false)
        XCTAssertTrue(g.vertex("Atlanta", isAdjacentTo: "Atlanta"), "Expected an edge from Atlanta to Atlanta")
        XCTAssertEqual(g.edgeCount, 1, "Expect one edge")

        g.addEdge(from: "Atlanta", to: "Atlanta", directed: false)
        XCTAssertEqual(g.edgeCount, 1, "Expected one edge")
    }

    func testUniqueUndirectedLoop2() {
        let g = UnweightedUniqueElementsGraph<EquatableString>(vertices:["Atlanta", "Boston"])
        g.addEdge(from: "Atlanta", to: "Boston", directed: false)
        g.addEdge(from: "Atlanta", to: "Atlanta", directed: false)
        XCTAssertTrue(g.vertex("Atlanta", isAdjacentTo: "Atlanta"), "Expected an edge from Atlanta to Atlanta")
        XCTAssertEqual(g.edgeCount, 2, "Expected two edges")

        g.addEdge(from: "Atlanta", to: "Atlanta", directed: false)
        XCTAssertEqual(g.edgeCount, 2, "Expected two edges")
    }

    func testUniqueDirectedEdges() {
        let g = UnweightedUniqueElementsGraph<EquatableString>(vertices:["Atlanta", "Chicago"])
        g.addEdge(from: "Atlanta", to: "Chicago", directed: true)
        g.addEdge(from: "Atlanta", to: "Chicago", directed: true)
        XCTAssertTrue(g.vertex("Atlanta", isAdjacentTo: "Chicago"), "Expected an edge from Atlanta to Chicago")
        XCTAssertEqual(g.edgeCount, 1, "Expected one edges")
    }

    func testUniqueDirectedLoop() {
        let g = UnweightedUniqueElementsGraph<EquatableString>(vertices:["Atlanta"])
        g.addEdge(from: "Atlanta", to: "Atlanta", directed: true)
        XCTAssertTrue(g.vertex("Atlanta", isAdjacentTo: "Atlanta"), "Expected an edge from Atlanta to Atlanta")
        XCTAssertEqual(g.edgeCount, 1, "Expected one edges")

        g.addEdge(from: "Atlanta", to: "Atlanta", directed: true)
        XCTAssertEqual(g.edgeCount, 1, "Expected one edges")
    }

    func testUniqueDirectedLoop2() {
        let g = UnweightedUniqueElementsGraph<EquatableString>(vertices:["Atlanta", "Boston"])
        g.addEdge(from: "Atlanta", to: "Boston", directed: true)
        g.addEdge(from: "Atlanta", to: "Atlanta", directed: true)
        XCTAssertTrue(g.vertex("Atlanta", isAdjacentTo: "Atlanta"), "Expected an edge from Atlanta to Atlanta")
        XCTAssertEqual(g.edgeCount, 2, "Expected one edges")

        g.addEdge(from: "Atlanta", to: "Atlanta", directed: true)
        XCTAssertEqual(g.edgeCount, 2, "Expected one edges")
    }
    
    func testUniqueEdgesCombined1() {
        let g = UnweightedUniqueElementsGraph<EquatableString>(vertices:["Atlanta", "Chicago"])
        g.addEdge(from: "Atlanta", to: "Chicago", directed: true)
        g.addEdge(from: "Atlanta", to: "Chicago", directed: false)
        XCTAssertTrue(g.vertex("Atlanta", isAdjacentTo: "Chicago"), "Expected an edge from Atlanta to Chicago")
        XCTAssertTrue(g.vertex("Chicago", isAdjacentTo: "Atlanta"), "Expected an edge from Chicago to Atlanta")
        XCTAssertEqual(g.edgeCount, 2, "Expected two edges")
    }

    func testUniqueEdgesCombined2() {
        let g = UnweightedUniqueElementsGraph<EquatableString>(vertices:["Atlanta", "Chicago"])
        g.addEdge(from: "Atlanta", to: "Chicago", directed: true)
        g.addEdge(from: "Chicago", to: "Atlanta", directed: false)
        XCTAssertTrue(g.vertex("Atlanta", isAdjacentTo: "Chicago"), "Expected an edge from Atlanta to Chicago")
        XCTAssertTrue(g.vertex("Chicago", isAdjacentTo: "Atlanta"), "Expected an edge from Chicago to Atlanta")
        XCTAssertEqual(g.edgeCount, 2, "Expected two edges")
    }

    func testUniqueEdgesCombined3() {
        let g = UnweightedUniqueElementsGraph<EquatableString>(vertices:["Atlanta", "Chicago"])
        g.addEdge(from: "Atlanta", to: "Chicago", directed: false)
        g.addEdge(from: "Atlanta", to: "Chicago", directed: true)
        XCTAssertTrue(g.vertex("Atlanta", isAdjacentTo: "Chicago"), "Expected an edge from Atlanta to Chicago")
        XCTAssertTrue(g.vertex("Chicago", isAdjacentTo: "Atlanta"), "Expected an edge from Chicago to Atlanta")
        XCTAssertEqual(g.edgeCount, 2, "Expected two edges")
    }

    func testUniqueEdgesCombined4() {
        let g = UnweightedUniqueElementsGraph<EquatableString>(vertices:["Atlanta", "Chicago"])
        g.addEdge(from: "Atlanta", to: "Chicago", directed: false)
        g.addEdge(from: "Chicago", to: "Atlanta", directed: true)
        XCTAssertTrue(g.vertex("Atlanta", isAdjacentTo: "Chicago"), "Expected an edge from Atlanta to Chicago")
        XCTAssertTrue(g.vertex("Chicago", isAdjacentTo: "Atlanta"), "Expected an edge from Chicago to Atlanta")
        XCTAssertEqual(g.edgeCount, 2, "Expected two edges")
    }
}
