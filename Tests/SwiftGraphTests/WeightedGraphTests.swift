//
//  WeightedGraphTests.swift
//  SwiftGraphTests
//
//  Created by Ferran Pujol Camins on 05/03/2019.
//  Copyright © 2019 Oak Snow Consulting. All rights reserved.
//

import XCTest
import SwiftGraph

class WeightedGraphTests: XCTestCase {

    func testEdgeExistsDirected() {
        let g = WeightedGraph<String, String>(vertices: ["A", "B"])
        g.addEdge(from: "A", to: "B", weight: "AB", directed: true)
        XCTAssertTrue(g.vertex("A", isAdjacentTo: "B"))
        XCTAssertFalse(g.vertex("B", isAdjacentTo: "A"))
        XCTAssertTrue(g.vertex("A", isAdjacentTo: "B", havingWeight: "AB"))
        XCTAssertFalse(g.vertex("A", isAdjacentTo: "B", havingWeight: "X"))
        XCTAssertFalse(g.vertex("B", isAdjacentTo: "A", havingWeight: "AB"))
        XCTAssertFalse(g.vertex("B", isAdjacentTo: "A", havingWeight: "X"))
        XCTAssertFalse(g.vertex("A", isAdjacentTo: "Y", havingWeight: "AB"))
        XCTAssertFalse(g.vertex("X", isAdjacentTo: "Y", havingWeight: "AB"))
    }

    func testEdgeExistsUndirected() {
        let g = WeightedGraph<String, String>(vertices: ["A", "B"])
        g.addEdge(from: "A", to: "B", weight: "AB", directed: false)
        XCTAssertTrue(g.vertex("A", isAdjacentTo: "B"))
        XCTAssertTrue(g.vertex("B", isAdjacentTo: "A"))
        XCTAssertTrue(g.vertex("A", isAdjacentTo: "B", havingWeight: "AB"))
        XCTAssertFalse(g.vertex("A", isAdjacentTo: "B", havingWeight: "X"))
        XCTAssertTrue(g.vertex("B", isAdjacentTo: "A", havingWeight: "AB"))
        XCTAssertFalse(g.vertex("B", isAdjacentTo: "A", havingWeight: "X"))
        XCTAssertFalse(g.vertex("A", isAdjacentTo: "Y", havingWeight: "AB"))
        XCTAssertFalse(g.vertex("X", isAdjacentTo: "Y", havingWeight: "AB"))
    }

    func testWeightsDirected() {
        let g = WeightedGraph<String, String>(
            vertices: ["A", "B", "C"]
        )
        g.addEdge(from: "A", to: "B", weight: "AB", directed: true)
        g.addEdge(from: "B", to: "C", weight: "BC", directed: true)
        g.addEdge(from: "A", to: "B", weight: "AB2", directed: true)
        g.addEdge(from: "B", to: "C", weight: "BC", directed: true)

        XCTAssertEqual(g.edgeCount, 4, "Wrong number of edges.")
        XCTAssertTrue(arraysHaveSameElements(
            g.weights(from: "A", to: "B"),
            ["AB", "AB2"]
        ), "Edges from same vertices but different value must both be in the graph.")
        XCTAssertTrue(arraysHaveSameElements(
            g.weights(from: "B", to: "A"),
            []
        ))
        XCTAssertTrue(arraysHaveSameElements(
            g.weights(from: "B", to: "C"),
            ["BC", "BC"]
        ), "Duplicated edge 'BC' must appear twice.")
        XCTAssertTrue(arraysHaveSameElements(
            g.weights(from: "C", to: "B"),
            []
        ))
    }

    func testWeightsUndirected() {
        let g = WeightedGraph<String, String>(
            vertices: ["A", "B", "C"]
        )
        g.addEdge(from: "A", to: "B", weight: "AB", directed: false)
        g.addEdge(from: "B", to: "C", weight: "BC", directed: false)
        g.addEdge(from: "A", to: "B", weight: "AB2", directed: false)
        g.addEdge(from: "B", to: "C", weight: "BC", directed: false)

        XCTAssertEqual(g.edgeCount, 4, "Wrong number of edges.")
        XCTAssertTrue(arraysHaveSameElements(
            g.weights(from: "A", to: "B"),
            ["AB", "AB2"]
        ), "Edges from same vertices but different value must both be in the graph.")
        XCTAssertTrue(arraysHaveSameElements(
            g.weights(from: "B", to: "A"),
            ["AB", "AB2"]
        ), "Edges from same vertices but different value must both be in the graph.")
        XCTAssertTrue(arraysHaveSameElements(
            g.weights(from: "B", to: "C"),
            ["BC", "BC"]
        ), "Duplicated edge 'BC' must appear twice.")
        XCTAssertTrue(arraysHaveSameElements(
            g.weights(from: "C", to: "B"),
            ["BC", "BC"]
        ), "Duplicated edge 'BC' must appear twice.")
    }
}
