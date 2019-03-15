//
//  AdjacencyTests.swift
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
import SwiftGraph

class AdjacencyTests: XCTestCase {

    // Test that we correctly check adjacency for an undirected edge.
    func testUndirectedEdgeAdjacency() {
        let g = UnweightedGraph<String>(vertices: ["A", "B"])
        g.addEdge(from: "A", to: "B", directed: false)
        XCTAssertTrue(g.vertex(withIndex: 0, isAdjacentTo: 1))
        XCTAssertTrue(g.vertex(withIndex: 1, isAdjacentTo: 0))
        XCTAssertTrue(g.vertex("A", isAdjacentTo: "B"))
        XCTAssertTrue(g.vertex("B", isAdjacentTo: "A"))
        // Test that we don't return false positives
        XCTAssertFalse(g.vertex("A", isAdjacentTo: "Y"))
        XCTAssertFalse(g.vertex("X", isAdjacentTo: "Y"))
    }

    // Test that we correctly check adjacency for a directed edge.
    func testDirectedEdgeAdjacency() {
        let g = UnweightedGraph<String>(vertices: ["A", "B"])
        g.addEdge(from: "A", to: "B", directed: true)
        XCTAssertTrue(g.vertex(withIndex: 0, isAdjacentTo: 1))
        XCTAssertFalse(g.vertex(withIndex: 1, isAdjacentTo: 0))
        XCTAssertTrue(g.vertex("A", isAdjacentTo: "B"))
        XCTAssertFalse(g.vertex("B", isAdjacentTo: "A"))
        // Test that we don't return false positives
        XCTAssertFalse(g.vertex("A", isAdjacentTo: "Y"))
        XCTAssertFalse(g.vertex("X", isAdjacentTo: "Y"))
    }

    // Test that we check adjacency for the first occurrences of repeated vertices.
    func testUndirectedEdgeAdjacencyWithRepeatedVertices() {
        let g = UnweightedGraph<String>(vertices: ["A", "B", "A", "B"])
        g.addEdge(fromIndex: 2, toIndex: 3, directed: true)
        XCTAssertFalse(g.vertex("A", isAdjacentTo: "B"))
        XCTAssertTrue(g.vertex(withIndex: 2, isAdjacentTo: 3))
    }

    // Test that we correctly check adjacency for an undirected loop.
    func testUndirectedLoopAdjacency() {
        let g = UnweightedGraph<String>(vertices: ["A", "B"])
        g.addEdge(from: "A", to: "A", directed: false)
        XCTAssertTrue(g.vertex(withIndex: 0, isAdjacentTo: 0))
        XCTAssertTrue(g.vertex("A", isAdjacentTo: "A"))
    }

    // Test that we correctly check adjacency for a directed loop.
    func testDirectedLoopAdjacency() {
        let g = UnweightedGraph<String>(vertices: ["A", "B"])
        g.addEdge(from: "A", to: "A", directed: true)
        XCTAssertTrue(g.vertex(withIndex: 0, isAdjacentTo: 0))
    }

    // Test that we correctly check adjacency when there are no edges.
    func testAdjacencyWithNoEdges() {
        let g = UnweightedGraph<String>(vertices: ["A", "B"])
        XCTAssertFalse(g.vertex("A", isAdjacentTo: "B"))
        XCTAssertFalse(g.vertex("B", isAdjacentTo: "B"))
    }
}
