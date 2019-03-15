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

    func testRemoveAllEdges() {
        let graph = UnweightedGraph(vertices: ["0", "1", "2", "3", "4", "5", "6"])

        graph.addEdge(from: "0", to: "1", directed: false)
        graph.addEdge(from: "1", to: "2", directed: false)
        graph.addEdge(from: "2", to: "3", directed: false)
        graph.addEdge(from: "3", to: "2", directed: false)
        graph.addEdge(from: "3", to: "4", directed: false)
        graph.addEdge(from: "4", to: "5", directed: false)

        graph.removeAllEdges(from: 2, to: 3, bidirectional: true)
        XCTAssertFalse(graph.edgeExists(fromIndex: 2, toIndex: 3))
        XCTAssertFalse(graph.edgeExists(fromIndex: 3, toIndex: 2))
    }

    func testCitesInverseAfterRemove() {
        let g: UnweightedGraph<String> = UnweightedGraph<String>()
        _ = g.addVertex("Atlanta")
        _ = g.addVertex("New York")
        _ = g.addVertex("Miami")
        g.addEdge(from: "Atlanta", to: "New York")
        g.addEdge(from: "Miami", to: "Atlanta")
        g.addEdge(from: "New York", to: "Miami")
        g.removeVertex("Atlanta")
        XCTAssertEqual(g.neighborsForVertex("Miami")!, g.neighborsForVertex(g.neighborsForVertex("New York")![0])!, "Miami and New York Connected bi-directionally")
    }

}
