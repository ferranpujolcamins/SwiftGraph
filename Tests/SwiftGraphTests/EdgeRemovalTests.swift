//
//  EdgeRemovalTests.swift
//  SwiftGraphTests
//
//  Created by Ferran Pujol Camins on 15/03/2019.
//  Copyright © 2019 Oak Snow Consulting. All rights reserved.
//

import XCTest
import SwiftGraph

class EdgeRemovalTests: XCTestCase {

    func testRemoveDirectedEdge() {
        let g = UnweightedGraph(vertices: ["A", "B", "C"])
        g.addEdge(from: "A", to: "B", directed: true)
        g.addEdge(from: "B", to: "C", directed: true)

        g.removeEdge(UnweightedEdge(u: 0, v: 1, directed: false))
        XCTAssertEqual(g.edgeCount, 2)

        g.removeEdge(UnweightedEdge(u: 0, v: 1, directed: true))
        XCTAssertEqual(g.edgeCount, 1)
    }

    func testRemoveAllEdges() {
        let graph = UnweightedGraph(vertices: ["0", "1", "2", "3", "4", "5", "6"])

        graph.addEdge(from: "0", to: "1", directed: false)
        graph.addEdge(from: "1", to: "2", directed: false)
        graph.addEdge(from: "2", to: "3", directed: false)
        graph.addEdge(from: "3", to: "2", directed: false)
        graph.addEdge(from: "3", to: "4", directed: false)
        graph.addEdge(from: "4", to: "5", directed: false)

        graph.removeAllEdges(from: 2, to: 3, bidirectional: true)
        XCTAssertFalse(graph.vertex(withIndex: 2, isAdjacentTo: 3))
        XCTAssertFalse(graph.vertex(withIndex: 3, isAdjacentTo: 2))
    }
}
