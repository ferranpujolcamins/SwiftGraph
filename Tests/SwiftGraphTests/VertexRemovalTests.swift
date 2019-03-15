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
}
