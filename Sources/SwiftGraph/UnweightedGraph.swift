//
//  UnweightedGraph.swift
//  SwiftGraph
//
//  Copyright (c) 2014-2016 David Kopec
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

/// A subclass of Graph with some convenience methods for adding and removing UnweightedEdges. WeightedEdges may be added to an UnweightedGraph but their weights will be ignored.
open class UnweightedGraph<V: Equatable>: Graph {
    public var vertices = [V]()
    public var incidenceLists = [[Int]]()
    public var allEdges = [UnweightedEdge]()
    
    public init() {
    }
    
    required public init(vertices: [V]) {
        for vertex in vertices {
            _ = self.addVertex(vertex)
        }
    }
}

extension Graph where E == UnweightedEdge {

    /// Initialize an UnweightedGraph consisting of path.
    ///
    /// The resulting graph has the vertices in path and an edge between
    /// each pair of consecutive vertices in path.
    ///
    /// If path is an empty array, the resulting graph is the empty graph.
    /// If path is an array with a single vertex, the resulting graph has that vertex and no edges.
    ///
    /// - Parameters:
    ///   - path: An array of vertices representing a path.
    ///   - directed: If false, undirected edges are created.
    ///               If true, edges are directed from vertex i to vertex i+1 in path.
    ///               Default is false.
    public init(withPath path: [V], directed: Bool = false) {
        self.init(vertices: path)

        guard path.count >= 2 else {
            return
        }

        for i in 0..<path.count - 1 {
            self.addEdge(fromIndex: i, toIndex: i+1, directed: directed)
        }
    }

    /// Initialize an UnweightedGraph consisting of cycle.
    ///
    /// The resulting graph has the vertices in cycle and an edge between
    /// each pair of consecutive vertices in cycle,
    /// plus an edge between the last and the first vertices.
    ///
    /// If path is an empty array, the resulting graph is the empty graph.
    /// If path is an array with a single vertex, the resulting graph has the vertex
    /// and a single edge to itself if directed is true.
    /// If directed is false the resulting graph has the vertex and two edges to itself.
    ///
    /// - Parameters:
    ///   - cycle: An array of vertices representing a cycle.
    ///   - directed: If false, undirected edges are created.
    ///               If true, edges are directed from vertex i to vertex i+1 in cycle.
    ///               Default is false.
    public init(withCycle cycle: [V], directed: Bool = false) {
        self.init(withPath: cycle, directed: directed)
        if cycle.count > 0 {
            self.addEdge(fromIndex: cycle.count-1, toIndex: 0, directed: directed)
        }
    }
    
    /// This is a convenience method that adds an unweighted edge.
    ///
    /// - parameter from: The starting vertex's index.
    /// - parameter to: The ending vertex's index.
    /// - parameter directed: Is the edge directed? (default `false`)
    public func addEdge(fromIndex: Int, toIndex: Int, directed: Bool = false) {
        addEdge(UnweightedEdge(u: fromIndex, v: toIndex, directed: directed))
    }
    
    /// This is a convenience method that adds an unweighted, undirected edge between the first occurence of two vertices. It takes O(n) time.
    ///
    /// - parameter from: The starting vertex.
    /// - parameter to: The ending vertex.
    /// - parameter directed: Is the edge directed? (default `false`)
    public func addEdge(from: V, to: V, directed: Bool = false) {
        if let u = indexOfVertex(from), let v = indexOfVertex(to) {
            addEdge(UnweightedEdge(u: u, v: v, directed: directed))
        }
    }

    /// Check whether there is an edge from one vertex to another vertex.
    ///
    /// - parameter from: The index of the starting vertex of the edge.
    /// - parameter to: The index of the ending vertex of the edge.
    /// - returns: True if there is an edge from the starting vertex to the ending vertex.
    public func edgeExists(fromIndex: Int, toIndex: Int, directed: Bool) -> Bool {
        return edgeExists(E(u: fromIndex, v: toIndex, directed: directed))
    }
    // TODO: add is directly reachable method or something like this

    /// Check whether there is an edge from one vertex to another vertex.
    ///
    /// Note this will look at the first occurence of each vertex.
    /// Also returns false if either of the supplied vertices cannot be found in the graph.
    ///
    /// - parameter from: The starting vertex of the edge.
    /// - parameter to: The ending vertex of the edge.
    /// - returns: True if there is an edge from the starting vertex to the ending vertex.
    public func edgeExists(from: V, to: V, directed: Bool) -> Bool {
        if let u = indexOfVertex(from) {
            if let v = indexOfVertex(to) {
                return edgeExists(fromIndex: u, toIndex: v, directed: directed)
            }
        }
        return false
    }
}

public final class CodableUnweightedGraph<V: Codable & Equatable> : UnweightedGraph<V>, Codable {
    enum CodingKeys: String, CodingKey {
        case vertices = "vertices"
        case incidenceLists = "incidenceLists"
        case edges = "edges"
    }
    
    override public init() {
        super.init()
    }
    
    required public init(vertices: [V]) {
        super.init(vertices: vertices)
    }

    public convenience init(fromGraph g: UnweightedGraph<V>) {
        self.init()
        vertices = g.vertices
        incidenceLists = g.incidenceLists
        allEdges = g.allEdges
    }
    
    public required init(from decoder: Decoder) throws  {
        super.init()
        let rootContainer = try decoder.container(keyedBy: CodingKeys.self)
        self.vertices = try rootContainer.decode([V].self, forKey: CodingKeys.vertices)
        self.incidenceLists = try rootContainer.decode([[Int]].self, forKey: CodingKeys.incidenceLists)
        self.allEdges = try rootContainer.decode([E].self, forKey: CodingKeys.edges)
    }
    
    public func encode(to encoder: Encoder) throws {
        var rootContainer = encoder.container(keyedBy: CodingKeys.self)
        try rootContainer.encode(self.vertices, forKey: CodingKeys.vertices)
        try rootContainer.encode(self.incidenceLists, forKey: CodingKeys.incidenceLists)
        try rootContainer.encode(self.allEdges, forKey: CodingKeys.edges)
    }
}
