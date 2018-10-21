// beak: davecom/SwiftGraph @ branch:master

import Foundation
import SwiftGraph

/// This file defines a CLI to be used with Beak (https://github.com/yonaskolb/Beak)

/// Constructs an undirected UnweightedGraph isomorphic to a complete graph with Int vertices.
///
/// - Parameter size: The number of vertices of the graph
public func completeGraph(size: Int) {
    let g0 = CompleteGraph.build(withVertices: Array(0..<size))
    let g = CodableUnweightedGraph<Int>()
    g.vertices = g0.vertices
    g.edges = g0.edges

    print(graph: g)
}

/// Constructs an undirected UnweightedGraph isomorphic to a star graph with Int vertices.
///
/// - Parameter size: The number of vertices of the graph
public func starGraph(size: Int) {
    let g0 = StarGraph.build(withCenter: 0, andLeafs: Array(1..<size))
    let g = CodableUnweightedGraph<Int>()
    g.vertices = g0.vertices
    g.edges = g0.edges

    print(graph: g)
}

/// Constructs an undirected UnweightedGraph isomorphic to a path graph with Int vertices.
///
/// - Parameter size: The number of vertices of the graph
public func pathGraph(size: Int) {
    let g = CodableUnweightedGraph<Int>(withPath: Array(0..<size))
    print(graph: g)
}

private func print<V: Equatable>(graph g: CodableUnweightedGraph<V>) {
    do {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted

        let data = try encoder.encode(g)

        print(String(data: data, encoding: .utf8)!)
    } catch {
        print("Error generating graph")
    }
}
