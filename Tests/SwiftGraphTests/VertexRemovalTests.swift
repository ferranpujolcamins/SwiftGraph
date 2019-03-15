//
//  VertexRemovalTests.swift
//  SwiftGraphTests
//
//  Created by Ferran Pujol Camins on 15/03/2019.
//  Copyright © 2019 Oak Snow Consulting. All rights reserved.
//

import XCTest
import SwiftGraph

class VertexRemovalTests: XCTestCase {

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

    func testCounts() {
        let g: UnweightedGraph<String> = UnweightedGraph<String>()
        _ = g.addVertex("Atlanta")
        _ = g.addVertex("New York")
        _ = g.addVertex("Miami")
        g.addEdge(from: "Atlanta", to: "New York", directed: true)
        g.addEdge(from: "Miami", to: "Atlanta", directed: true)
        g.addEdge(from: "New York", to: "Miami", directed: true)
        g.addEdge(from: "Atlanta", to: "Miami", directed: true)
        XCTAssertEqual(g.vertexCount, 3, "3 total vertices")
        XCTAssertEqual(g.edgeCount, 4, "4 total edges")
        g.removeVertex("Atlanta")
        XCTAssertEqual(g.vertexCount, 2, "2 total vertices")
        XCTAssertEqual(g.edgeCount, 1, "1 total edges")
    }

    func testFirstVertexRemoval() {
        let g: UnweightedGraph<String> = UnweightedGraph<String>()
        _ = g.addVertex("Atlanta")
        _ = g.addVertex("New York")
        _ = g.addVertex("Miami")
        g.addEdge(from: "Atlanta", to: "New York")
        g.addEdge(from: "Miami", to: "Atlanta")
        g.addEdge(from: "New York", to: "Miami")
        g.removeVertex("Atlanta")
        XCTAssertEqual(g.vertices, ["New York", "Miami"])
        XCTAssertEqual(g.allEdges, [
            UnweightedEdge(u: 0, v: 1, directed: false),
        ])
        XCTAssertEqual(g.incidenceLists, [
            [0],
            [0]
        ])
    }
}
