//
//  WeightedGraph.swift
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

/// A subclass of Graph that has convenience methods for adding and removing WeightedEdges. All added Edges should have the same generic Comparable type W as the WeightedGraph itself.
open class WeightedGraph<V: Equatable, W: Equatable>: Graph {
    public var vertices = [V]()
    public var incidenceLists = [[Int]]()
    public var allEdges = [WeightedEdge<W>]()
    
    public init() {
    }
    
    required public init(vertices: [V]) {
        for vertex in vertices {
            _ = self.addVertex(vertex)
        }
    }
}

extension Graph where E: WeightedEdgeProtocol {
    public typealias W = E.Weight

    /// Find all of the neighbors of a vertex at a given index.
    ///
    /// - parameter index: The index for the vertex to find the neighbors of.
    /// - returns: An array of tuples including the vertices as the first element and the weights as the second element.
    public func neighborsForIndexWithWeights(_ index: Int) -> [(V, W)] {
        var distanceTuples: [(V, W)] = [(V, W)]();
        for edgeIndex in incidenceLists[index] {
            let edge = allEdges[edgeIndex]
            distanceTuples += [(vertices[edge.v], edge.weight)]
        }
        return distanceTuples;
    }
    
    /// This is a convenience method that adds a weighted edge.
    ///
    /// - parameter from: The starting vertex's index.
    /// - parameter to: The ending vertex's index.
    /// - parameter directed: Is the edge directed? (default false)
    /// - parameter weight: the Weight of the edge to add.
    public func addEdge(fromIndex: Int, toIndex: Int, weight: W, directed: Bool = false) {
        addEdge(E(u: fromIndex, v: toIndex, directed: directed, weight: weight))
    }
    
    /// This is a convenience method that adds a weighted edge between the first occurence of two vertices. It takes O(n) time.
    ///
    /// - parameter from: The starting vertex.
    /// - parameter to: The ending vertex.
    /// - parameter directed: Is the edge directed? (default false)
    /// - parameter weight: the Weight of the edge to add.
    public func addEdge(from: V, to: V, weight: W, directed: Bool = false) {
        if let u = indexOfVertex(from), let v = indexOfVertex(to) {
            addEdge(fromIndex: u, toIndex: v, weight: weight, directed: directed)
        }
    }

    /// Check whether there is an edge from one vertex to another vertex with a specific weight.
    ///
    /// - parameter from: The index of the starting vertex of the edge.
    /// - parameter to: The index of the ending vertex of the edge.
    /// - returns: True if there is an edge from the starting vertex to the ending vertex.
    public func edgeExists(fromIndex: Int, toIndex: Int, withWeight weight: W, directed: Bool) -> Bool {
        return edgeExists(E(u: fromIndex, v: toIndex, directed: directed, weight: weight))
    }

    /// Check whether there is an edge from one vertex to another vertex with a specific weight.
    ///
    /// Note this will look at the first occurence of each vertex.
    /// Also returns false if either of the supplied vertices cannot be found in the graph.
    ///
    /// - parameter from: The starting vertex of the edge.
    /// - parameter to: The ending vertex of the edge.
    /// - returns: True if there is an edge from the starting vertex to the ending vertex.
    public func edgeExists(from: V, to: V, withWeight weight: W, directed: Bool) -> Bool {
        if let u = indexOfVertex(from) {
            if let v = indexOfVertex(to) {
                return edgeExists(fromIndex: u, toIndex: v, withWeight: weight, directed: directed)
            }
        }
        return false
    }

    /// Check whether there is an edge from one vertex to another vertex.
    ///
    /// - parameter from: The index of the starting vertex of the edge.
    /// - parameter to: The index of the ending vertex of the edge.
    /// - returns: True if there is an edge from the starting vertex to the ending vertex.
    public func edgeExists(fromIndex: Int, toIndex: Int) -> Bool {
        return edgesForIndex(fromIndex).map({$0.v}).contains(toIndex)
    }

    /// Check whether there is an edge from one vertex to another vertex.
    ///
    /// Note this will look at the first occurence of each vertex.
    /// Also returns false if either of the supplied vertices cannot be found in the graph.
    ///
    /// - parameter from: The starting vertex of the edge.
    /// - parameter to: The ending vertex of the edge.
    /// - returns: True if there is an edge from the starting vertex to the ending vertex.
    public func edgeExists(from: V, to: V) -> Bool {
        if let u = indexOfVertex(from) {
            if let v = indexOfVertex(to) {
                return edgeExists(fromIndex: u, toIndex: v)
            }
        }
        return false
    }

    /// Returns all the weights associated to the edges between two vertex indices.
    ///
    /// - Parameters:
    ///   - from: The starting vertex index
    ///   - to: The ending vertex index
    /// - Returns: An array with all the weights associated to edges between the provided indexes.
    public func weights(from: Int, to: Int) -> [W] {
        return edgesForIndex(from).filter { $0.v == to }.map { $0.weight }
    }

    /// Returns all the weights associated to the edges between two vertices.
    ///
    /// - Parameters:
    ///   - from: The starting vertex
    ///   - to: The ending vertex
    /// - Returns: An array with all the weights associated to edges between the provided vertices.
    public func weights(from: V, to: V) -> [W] {
        if let u = indexOfVertex(from), let v = indexOfVertex(to) {
            return edgesForIndex(u).filter { $0.v == v }.map { $0.weight }
        }
        return []
    }

    // Implement Printable protocol
    public var description: String {
        var d: String = ""
        for i in 0..<vertices.count {
            d += "\(vertices[i]) -> \(neighborsForIndexWithWeights(i))\n"
        }
        return d
    }
}

public final class CodableWeightedGraph<V: Codable & Equatable, W: Comparable & Numeric & Codable> : WeightedGraph<V, W>, Codable {
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

    public convenience init(fromGraph g: WeightedGraph<V, W>) {
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
