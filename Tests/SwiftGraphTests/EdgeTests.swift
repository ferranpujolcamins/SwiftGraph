//
//  EdgeTests.swift
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

class EdgeTests: XCTestCase {

    // Test that we correctly store an undirected edge.
    func testUndirectedEdgeRepresentation() {
        let g = UnweightedGraph<String>(vertices: ["A", "B"])
        g.addEdge(from: "A", to: "B", directed: false)
        XCTAssertEqual(g.allEdges, [UnweightedEdge(u: 0, v: 1, directed: false)])
        XCTAssertEqual(g.incidenceLists, [
            [0],
            [0]
        ])
    }

    // Test that we correctly store a directed edge.
    func testDirectedEdgeRepresentation() {
        let g = UnweightedGraph<String>(vertices: ["A", "B"])
        g.addEdge(from: "A", to: "B", directed: true)
        XCTAssertEqual(g.allEdges, [UnweightedEdge(u: 0, v: 1, directed: true)])
        XCTAssertEqual(g.incidenceLists, [
            [0],
            []
        ])
    }

    // Test that we correctly store two directed edges.
    func testTwoDirectedEdgesRepresentation() {
        let g = UnweightedGraph<String>(vertices: ["A", "B"])
        g.addEdge(from: "A", to: "B", directed: true)
        g.addEdge(from: "A", to: "B", directed: true)
        XCTAssertEqual(g.allEdges, [
            UnweightedEdge(u: 0, v: 1, directed: true),
            UnweightedEdge(u: 0, v: 1, directed: true)
            ])
        XCTAssertEqual(g.incidenceLists, [
            [0, 1],
            []
        ])
    }

    // Test that we correctly store two undirected edges.
    func testTwoUNdirectedEdgesRepresentation() {
        let g = UnweightedGraph<String>(vertices: ["A", "B"])
        g.addEdge(from: "A", to: "B", directed: false)
        g.addEdge(from: "A", to: "B", directed: false)
        XCTAssertEqual(g.allEdges, [
            UnweightedEdge(u: 0, v: 1, directed: false),
            UnweightedEdge(u: 1, v: 0, directed: false)
        ])
        XCTAssertEqual(g.incidenceLists, [
            [0, 1],
            [0, 1]
        ])
    }

    // Test that we correctly store a directed edge and an undirected edge.
    func testDirectedAndUndirectedEdgeRepresentation() {
        let g = UnweightedGraph<String>(vertices: ["A", "B"])
        g.addEdge(from: "A", to: "B", directed: true)
        g.addEdge(from: "A", to: "B", directed: false)
        XCTAssertEqual(g.allEdges, [
            UnweightedEdge(u: 0, v: 1, directed: true),
            UnweightedEdge(u: 1, v: 0, directed: false)
        ])
        XCTAssertEqual(g.incidenceLists, [
            [0, 1],
            [1]
        ])
    }

    // Test that we correctly store an undirected loop.
    func testUndirectedLoopRepresentation() {
        let g = UnweightedGraph<String>(vertices: ["A"])
        g.addEdge(from: "A", to: "A", directed: false)
        XCTAssertEqual(g.allEdges, [UnweightedEdge(u: 0, v: 0, directed: false)])
        XCTAssertEqual(g.incidenceLists, [
            [0]
        ])
    }

    // Test that we correctly store a directed loop.
    func testDirectedLoopRepresentation() {
        let g = UnweightedGraph<String>(vertices: ["A"])
        g.addEdge(from: "A", to: "A", directed: true)
        XCTAssertEqual(g.allEdges, [UnweightedEdge(u: 0, v: 0, directed: true)])
        XCTAssertEqual(g.incidenceLists, [
            [0]
        ])
    }

    // Test that we correctly store two directed loops.
    func testTwoDirectedLoopsRepresentation() {
        let g = UnweightedGraph<String>(vertices: ["A"])
        g.addEdge(from: "A", to: "A", directed: true)
        g.addEdge(from: "A", to: "A", directed: true)
        XCTAssertEqual(g.allEdges, [
            UnweightedEdge(u: 0, v: 0, directed: true),
            UnweightedEdge(u: 0, v: 0, directed: true)
            ])
        XCTAssertEqual(g.incidenceLists, [
            [0, 1],
        ])
    }

    // Test that we correctly store two undirected loops.
    func testTwoUndirectedLoopsRepresentation() {
        let g = UnweightedGraph<String>(vertices: ["A"])
        g.addEdge(from: "A", to: "A", directed: false)
        g.addEdge(from: "A", to: "A", directed: false)
        XCTAssertEqual(g.allEdges, [
            UnweightedEdge(u: 0, v: 0, directed: false),
            UnweightedEdge(u: 0, v: 0, directed: false)
            ])
        XCTAssertEqual(g.incidenceLists, [
            [0, 1]
        ])
    }

    // Test that we correctly store a directed edge and an undirected edge.
    func testDirectedAndUndirectedLoopsRepresentation() {
        let g = UnweightedGraph<String>(vertices: ["A"])
        g.addEdge(from: "A", to: "A", directed: true)
        g.addEdge(from: "A", to: "A", directed: false)
        XCTAssertEqual(g.allEdges, [
            UnweightedEdge(u: 0, v: 0, directed: true),
            UnweightedEdge(u: 0, v: 0, directed: false)
        ])
        XCTAssertEqual(g.incidenceLists, [
            [0, 1]
        ])
    }

    // Test that we correctly check adjacency for an undirected edge.
    func testUndirectedEdgeAdjacency() {
        let g = UnweightedGraph<String>(vertices: ["A", "B"])
        g.addEdge(from: "A", to: "B", directed: false)
        XCTAssertTrue(g.vertex(withIndex: 0, isAdjacentTo: 1))
        XCTAssertTrue(g.vertex(withIndex: 1, isAdjacentTo: 0))
        XCTAssertTrue(g.vertex("A", isAdjacentTo: "B"))
        XCTAssertTrue(g.vertex("B", isAdjacentTo: "A"))
    }

    // Test that we correctly check adjacency for a directed edge.
    func testDirectedEdgeAdjacency() {
        let g = UnweightedGraph<String>(vertices: ["A", "B"])
        g.addEdge(from: "A", to: "B", directed: true)
        XCTAssertTrue(g.vertex(withIndex: 0, isAdjacentTo: 1))
        XCTAssertFalse(g.vertex(withIndex: 1, isAdjacentTo: 0))
        XCTAssertTrue(g.vertex("A", isAdjacentTo: "B"))
        XCTAssertFalse(g.vertex("B", isAdjacentTo: "A"))
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
