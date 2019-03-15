//
//  EdgeTests.swift
//  SwiftGraphTests
//
//  Created by Ferran Pujol Camins on 15/03/2019.
//  Copyright © 2019 Oak Snow Consulting. All rights reserved.
//

import XCTest
import SwiftGraph

class EdgeTests: XCTestCase {

    func testDirectedEdgeJoins() {
        let edge = UnweightedEdge(u: 0, v: 1, directed: true)
        XCTAssertTrue(edge.joins(index: 0, toIndex: 1))
        XCTAssertFalse(edge.joins(index: 1, toIndex: 0))
        XCTAssertFalse(edge.joins(index: 1, toIndex: 2))
        XCTAssertFalse(edge.joins(index: 0, toIndex: 2))
        XCTAssertFalse(edge.joins(index: 2, toIndex: 3))
        XCTAssertFalse(edge.joins(index: 0, toIndex: 0))
    }

    func testUndirectedEdgeJoins() {
        let edge = UnweightedEdge(u: 0, v: 1, directed: false)
        XCTAssertTrue(edge.joins(index: 0, toIndex: 1))
        XCTAssertTrue(edge.joins(index: 1, toIndex: 0))
        XCTAssertFalse(edge.joins(index: 1, toIndex: 2))
        XCTAssertFalse(edge.joins(index: 0, toIndex: 2))
        XCTAssertFalse(edge.joins(index: 2, toIndex: 3))
        XCTAssertFalse(edge.joins(index: 0, toIndex: 0))
    }

    func testUnweightedEdgeEquality() {
        let directedOracle = UnweightedEdge(u: 0, v: 1, directed: true)
        let directed = UnweightedEdge(u: 0, v: 1, directed: true)
        let directedReversed = UnweightedEdge(u: 1, v: 0, directed: true)
        let directed2 = UnweightedEdge(u: 0, v: 2, directed: true)
        let directed3 = UnweightedEdge(u: 3, v: 2, directed: true)

        XCTAssertEqual(directedOracle, directed)
        XCTAssertNotEqual(directedOracle, directedReversed)
        XCTAssertNotEqual(directedOracle, directed2)
        XCTAssertNotEqual(directedOracle, directed3)

        let undirectedOracle = UnweightedEdge(u: 0, v: 1, directed: false)
        let undirected = UnweightedEdge(u: 0, v: 1, directed: false)
        let undirectedReversed = UnweightedEdge(u: 1, v: 0, directed: false)
        let undirected2 = UnweightedEdge(u: 0, v: 2, directed: false)
        let undirected3 = UnweightedEdge(u: 3, v: 2, directed: false)

        XCTAssertEqual(undirectedOracle, undirected)
        XCTAssertEqual(undirectedOracle, undirectedReversed)
        XCTAssertNotEqual(undirectedOracle, undirected2)
        XCTAssertNotEqual(undirectedOracle, undirected3)

        XCTAssertNotEqual(directedOracle, undirectedOracle)
    }

    func testWeightedEdgeEquality() {
        let directedOracle = WeightedEdge(u: 0, v: 1, directed: true, weight: 0)
        let directed = WeightedEdge(u: 0, v: 1, directed: true, weight: 0)
        let directedReversed = WeightedEdge(u: 1, v: 0, directed: true, weight: 0)
        let directedDifferentWeight = WeightedEdge(u: 0, v: 1, directed: true, weight: 1)
        let directedLoop = WeightedEdge(u: 0, v: 0, directed: true, weight: 0)
        let directed2 = WeightedEdge(u: 0, v: 2, directed: true, weight: 0)
        let directed3 = WeightedEdge(u: 3, v: 2, directed: true, weight: 0)

        XCTAssertEqual(directedOracle, directed)
        XCTAssertNotEqual(directedOracle, directedReversed)
        XCTAssertNotEqual(directedOracle, directedDifferentWeight)
        XCTAssertNotEqual(directedOracle, directedLoop)
        XCTAssertNotEqual(directedOracle, directed2)
        XCTAssertNotEqual(directedOracle, directed3)

        let undirectedOracle = WeightedEdge(u: 0, v: 1, directed: false, weight: 0)
        let undirected = WeightedEdge(u: 0, v: 1, directed: false, weight: 0)
        let undirectedReversed = WeightedEdge(u: 1, v: 0, directed: false, weight: 0)
        let undirectedDifferentWeight = WeightedEdge(u: 0, v: 1, directed: false, weight: 1)
        let undirectedReversedDifferentWeight = WeightedEdge(u: 1, v: 0, directed: false, weight: 1)
        let undirectedLoop = WeightedEdge(u: 0, v: 0, directed: false, weight: 0)
        let undirected2 = WeightedEdge(u: 0, v: 2, directed: false, weight: 0)
        let undirected3 = WeightedEdge(u: 3, v: 2, directed: false, weight: 0)

        XCTAssertEqual(undirectedOracle, undirected)
        XCTAssertEqual(undirectedOracle, undirectedReversed)
        XCTAssertNotEqual(undirectedOracle, undirectedDifferentWeight)
        XCTAssertNotEqual(undirectedOracle, undirectedReversedDifferentWeight)
        XCTAssertNotEqual(undirectedOracle, undirectedLoop)
        XCTAssertNotEqual(undirectedOracle, undirected2)
        XCTAssertNotEqual(undirectedOracle, undirected3)

        XCTAssertNotEqual(directedOracle, undirectedOracle)
    }
}
