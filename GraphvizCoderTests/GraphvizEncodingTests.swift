//
//  GraphvizEncodingTests.swift
//  GraphvizEncodingTests
//
//  Created by Ferran Pujol Camins on 11/03/2019.
//  Copyright © 2019 Oak Snow Consulting. All rights reserved.
//

import XCTest
import SwiftGraph
@testable import GraphvizCoder

class GraphvizEncodingTests: XCTestCase {

    var encoder: GraphvizEncoder!

    override func setUp() {
        self.encoder = GraphvizEncoder()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testEncodeEmptyGraph() {
        let g: CodableUnweightedGraph<String> = CodableUnweightedGraph(vertices: ["A"])
        let str = try! GraphvizEncoder.encode(g)
        print(str)
    }

    func testEncodeOneVertexGraph() {
        let g: CodableUnweightedGraph<String> = CodableUnweightedGraph(vertices: ["A"])
        let str = try! GraphvizEncoder.encode(g)
        let graphviz = str
        let expectedGraphviz = """
        digraph {
            0 [label="A"]


        }
        """
        XCTAssertEqual(graphviz, expectedGraphviz)
    }

    func testEncodeOneEdgeGraph() {
        let g: CodableUnweightedGraph<String> = CodableUnweightedGraph(vertices: ["A", "B"])
        g.addEdge(from: "A", to: "B", directed: true)
        let str = try! GraphvizEncoder.encode(g)
        let graphviz = str
        let expectedGraphviz = """
        digraph {
            0 [label="A"]
            1 [label="B"]

            0 -> 0
        }
        """
        XCTAssertEqual(graphviz, expectedGraphviz)
    }
}
