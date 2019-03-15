//
//  EdgeRepresentationTests.swift
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

class EdgeRepresentationTests: XCTestCase {

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
    func testTwoUndirectedEdgesRepresentation() {
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

    func testRepresentationAfterRemoveDirectedEdge() {
        let g = UnweightedGraph(vertices: ["A", "B", "C"])
        g.addEdge(from: "A", to: "B", directed: true)
        g.addEdge(from: "B", to: "C", directed: true)

        XCTAssertEqual(g.incidenceLists, [[0], [1], []])
        XCTAssertEqual(g.allEdges, [
            UnweightedEdge(u: 0, v: 1, directed: true),
            UnweightedEdge(u: 1, v: 2, directed: true)
        ])

        g.removeEdge(UnweightedEdge(u: 0, v: 1, directed: true))
        XCTAssertEqual(g.incidenceLists, [[], [0], []])
        XCTAssertEqual(g.allEdges, [
            UnweightedEdge(u: 1, v: 2, directed: true)
        ])
    }

    func testRepresentationAfterRemoveUndirectedEdge() {
        let g = UnweightedGraph(vertices: ["A", "B", "C"])
        g.addEdge(from: "A", to: "B", directed: false)
        g.addEdge(from: "B", to: "C", directed: false)

        XCTAssertEqual(g.incidenceLists, [[0], [0, 1], [1]])
        XCTAssertEqual(g.allEdges, [
            UnweightedEdge(u: 0, v: 1, directed: false),
            UnweightedEdge(u: 1, v: 2, directed: false)
        ])

        g.removeEdge(UnweightedEdge(u: 0, v: 1, directed: false))
        XCTAssertEqual(g.incidenceLists, [[], [0], [0]])
        XCTAssertEqual(g.allEdges, [
            UnweightedEdge(u: 1, v: 2, directed: false)
        ])
    }

    func testRepresentationAfterRemoveDuplicatedDirectedEdge() {
        let g = UnweightedGraph(vertices: ["A", "B", "C"])
        g.addEdge(from: "A", to: "B", directed: true)
        g.addEdge(from: "A", to: "B", directed: true)
        g.addEdge(from: "B", to: "C", directed: true)

        XCTAssertEqual(g.incidenceLists, [[0, 1], [2], []])
        XCTAssertEqual(g.allEdges, [
            UnweightedEdge(u: 0, v: 1, directed: true),
            UnweightedEdge(u: 0, v: 1, directed: true),
            UnweightedEdge(u: 1, v: 2, directed: true)
        ])

        g.removeEdge(UnweightedEdge(u: 0, v: 1, directed: true))
        XCTAssertEqual(g.incidenceLists, [[0], [1], []])
        XCTAssertEqual(g.allEdges, [
            UnweightedEdge(u: 0, v: 1, directed: true),
            UnweightedEdge(u: 1, v: 2, directed: true)
        ])
    }

    func testRepresentationAfterRemoveDuplicatedUndirectedEdge() {
        let g = UnweightedGraph(vertices: ["A", "B", "C"])
        g.addEdge(from: "A", to: "B", directed: false)
        g.addEdge(from: "A", to: "B", directed: false)
        g.addEdge(from: "B", to: "C", directed: false)

        XCTAssertEqual(g.incidenceLists, [[0, 1], [0, 1, 2], [2]])
        XCTAssertEqual(g.allEdges, [
            UnweightedEdge(u: 0, v: 1, directed: false),
            UnweightedEdge(u: 0, v: 1, directed: false),
            UnweightedEdge(u: 1, v: 2, directed: false)
        ])

        g.removeEdge(UnweightedEdge(u: 0, v: 1, directed: false))
        XCTAssertEqual(g.incidenceLists, [[0], [0, 1], [1]])
        XCTAssertEqual(g.allEdges, [
            UnweightedEdge(u: 0, v: 1, directed: false),
            UnweightedEdge(u: 1, v: 2, directed: false)
        ])
    }
}
