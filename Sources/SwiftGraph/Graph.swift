//
//  Graph.swift
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

/// The protocol for all graphs.
/// You should generally use one of its two canonical class implementations,
/// `UnweightedGraph` and `WeightedGraph`.
///
/// Vertices are stored in the `vertices` array. Each vertex can be identified by it's index in the array.
/// Some operations change the indexes of the vertices, such as `removeVertex(_: V)`.
///
/// A graph can have directed edges, undirected edges or a mixture of both.
/// For each edge in the graph we store one copy of the corresponding `Edge` object in the `allEdges` array
/// (no matter if the edge is directed or indirected, we store only one copy of the `Edge` object).
///
/// `incidenceLists` is a list of lists where we keep indices of edges (the index of an edge indicates the position of the edge in the `allEdges` array).
/// The ith list in `incidenceLists` holds the list of edges for the ith vertex of the graph (the vertex with index `i`).
/// This list holds the indices of the following edges:
/// - Directed edges that start at the ith vertex.
/// - Undirected edges that are incident to the ith vertex.
/// The ith vertex of the graph (the vertex with index `i`), The ith element of `incidenceLists` is an array containing the
/// indices of the edges that originate at the vertex with index `i`.
public protocol Graph: class, CustomStringConvertible, Collection {
    associatedtype V: Equatable
    associatedtype E: Edge & Equatable

    var vertices: [V] { get set }
    var incidenceLists: [[Int]] { get set }
    var allEdges: [E] { get set }

    init(vertices: [V])
    func addEdge(_ e: E)
}

extension Graph {
    /// How many vertices are in the graph?
    public var vertexCount: Int {
        return vertices.count
    }
    
    /// How many edges are in the graph?
    public var edgeCount: Int {
        return allEdges.count
    }
    
    /// Get a vertex by its index.
    ///
    /// - parameter index: The index of the vertex.
    /// - returns: The vertex at i.
    public func vertexAtIndex(_ index: Int) -> V {
        return vertices[index]
    }
    
    /// Find the first occurence of a vertex if it exists.
    ///
    /// - parameter vertex: The vertex you are looking for.
    /// - returns: The index of the vertex. Return nil if it can't find it.
    
    public func indexOfVertex(_ vertex: V) -> Int? {
        if let i = vertices.index(of: vertex) {
            return i
        }
        return nil;
    }
    
    /// Find all of the neighbors of a vertex at a given index.
    ///
    /// - parameter index: The index for the vertex to find the neighbors of.
    /// - returns: An array of the neighbor vertices.
    public func neighborsForIndex(_ index: Int) -> [V] {
        return edgesForIndex(index).map { self.vertices[$0.v] }
    }
    
    /// Find all of the neighbors of a given Vertex.
    ///
    /// - parameter vertex: The vertex to find the neighbors of.
    /// - returns: An optional array of the neighbor vertices.
    public func neighborsForVertex(_ vertex: V) -> [V]? {
        if let i = indexOfVertex(vertex) {
            return neighborsForIndex(i)
        }
        return nil
    }
    
    /// Find all of the edges of a vertex at a given index.
    ///
    /// - parameter index: The index for the vertex to find the children of.
    public func edgesForIndex(_ index: Int) -> [E] {
        return incidenceLists[index].map { allEdges[$0] }
    }
    
    /// Find all of the edges of a given vertex.
    ///
    /// - parameter vertex: The vertex to find the edges of.
    public func edgesForVertex(_ vertex: V) -> [E]? {
        if let i = indexOfVertex(vertex) {
            return edgesForIndex(i)
        }
        return nil
    }
    
    /// Find the first occurence of a vertex.
    ///
    /// - parameter vertex: The vertex you are looking for.
    public func vertexInGraph(vertex: V) -> Bool {
        if let _ = indexOfVertex(vertex) {
            return true
        }
        return false
    }
    
    /// Add a vertex to the graph.
    ///
    /// - parameter v: The vertex to be added.
    /// - returns: The index where the vertex was added.
    public func addVertex(_ v: V) -> Int {
        vertices.append(v)
        incidenceLists.append([Int]())
        return vertices.count - 1
    }

    /// Add an edge to the graph.
    ///
    /// - parameter e: The edge to add.
    /// - parameter directed: If false, undirected edges are created.
    ///                       If true, a reversed edge is also created.
    ///                       Default is false.
    public func addEdge(_ e: E) {
        allEdges.append(e)
        let index = allEdges.count - 1
        incidenceLists[e.u].append(index)
        if !e.directed && e.u != e.v {
            incidenceLists[e.v].append(index)
        }
    }
/*
    /// Removes all directed edges from index 'from' to index 'to' and all undirected edges from index 'from' to index 'to'.
    ///
    /// Directed edges from index 'to' to index 'from' won't be deleted.
    ///
    /// - parameter from: The starting vertex's index.
    /// - parameter to: The ending vertex's index.
    /// - parameter bidirectional: Remove edges coming back (to -> from)
    public func removeAllEdges(from: Int, to: Int, bidirectional: Bool = true) {
        incidenceLists[from].removeAll(where: { $0.v == to })
        
        if bidirectional {
            edges[to].removeAll(where: { $0.v == from })
        }
    }
    
    /// Removes all edges in both directions between two vertices.
    ///
    /// - parameter from: The starting vertex.
    /// - parameter to: The ending vertex.
    /// - parameter bidirectional: Remove edges coming back (to -> from)
    public func removeAllEdges(from: V, to: V, bidirectional: Bool = true) {
        if let u = indexOfVertex(from) {
            if let v = indexOfVertex(to) {
                removeAllEdges(from: u, to: v, bidirectional: bidirectional)
            }
        }
    }
    
    /// Remove the first edge found to be equal to *e*
    ///
    /// - parameter e: The edge to remove.
    public func removeEdge(_ e: E) {
        if let index = edges[e.u].firstIndex(where: { $0 == e }) {
            edges[e.u].remove(at: index)
        }
    }
    
    /// Removes a vertex at a specified index, all of the edges attached to it, and renumbers the indexes of the rest of the edges.
    ///
    /// - parameter index: The index of the vertex.
    public func removeVertexAtIndex(_ index: Int) {
        //remove all edges ending at the vertex, first doing the ones below it
        //renumber edges that end after the index
        for j in 0..<index {
            var toRemove: [Int] = [Int]()
            for l in 0..<edges[j].count {
                if edges[j][l].v == index {
                    toRemove.append(l)
                    continue
                }
                if edges[j][l].v > index {
                    edges[j][l].v -= 1
                }
            }
            for f in toRemove.reversed() {
                edges[j].remove(at: f)
            }
        }
        
        //remove all edges after the vertex index wise
        //renumber all edges after the vertex index wise
        for j in (index + 1)..<edges.count {
            var toRemove: [Int] = [Int]()
            for l in 0..<edges[j].count {
                if edges[j][l].v == index {
                    toRemove.append(l)
                    continue
                }
                edges[j][l].u -= 1
                if edges[j][l].v > index {
                    edges[j][l].v -= 1
                }
            }
            for f in toRemove.reversed() {
                edges[j].remove(at: f)
            }
        }
        //println(self)
        //remove the actual vertex and its edges
        edges.remove(at: index)
        vertices.remove(at: index)
    }
    
    /// Removes the first occurence of a vertex, all of the edges attached to it, and renumbers the indexes of the rest of the edges.
    ///
    /// - parameter vertex: The vertex to be removed..
    public func removeVertex(_ vertex: V) {
        if let i = indexOfVertex(vertex) {
            removeVertexAtIndex(i)
        }
    }
*/
    /// Check whether an edge is in the graph or not.
    ///
    /// - parameter edge: The edge to find in the graph.
    /// - returns: True if the edge exists, and false otherwise.
    public func edgeExists(_ edge: E) -> Bool {
        return allEdges.contains(edge)
    }

    /// Check whether a vertex A can be reached from another vertex B through a path with only one edge.
    ///
    /// This will happen when there is an undirected edge between A and B, or a directed edge from A to B.
    ///
    /// - Parameters:
    ///   - initialIndex: The index of the initial vertex.
    ///   - terminalIndex: The index of the terminal vertex.
    /// - Returns: Returns true if the vertex with `terminalIndex` can be reached from the vertex with `initialIndex` through a 1-path.
    public func vertex(withIndex initialIndex: Int, isAdjacentTo terminalIndex: Int) -> Bool {
        return edgesForIndex(initialIndex).contains(where: {
            ($0.u == initialIndex && $0.v == terminalIndex) || ($0.u == terminalIndex && $0.v == initialIndex)
        })
    }

    /// Check whether a vertex A can be reached from another vertex B through a path with only one edge.
    ///
    /// This will happen when there is an undirected edge between A and B, or a directed edge from A to B.
    /// If the graph has more than one vertex equal to `initialVertex` or `terminalVertex`, this method
    /// compares the first occurence of each. If either `initialVertex` or `terminalVertex` are not found, `false` is returned.
    ///
    /// - Parameters:
    ///   - initialIndex: The initial vertex.
    ///   - terminalIndex: The terminal vertex.
    /// - Returns: Returns true if the `terminalVertex` can be reached from the `initialVertex` through a 1-path.
    public func vertex(_ initialVertex: V, isAdjacentTo terminalVertex: V) -> Bool {
        if let initialIndex = indexOfVertex(initialVertex),
            let terminalIndex = indexOfVertex(terminalVertex) {

            return vertex(withIndex: initialIndex, isAdjacentTo: terminalIndex)
        }
        return false
    }
    
    // MARK: Implement Printable protocol
    public var description: String {
        var d: String = ""
        for i in 0..<vertices.count {
            d += "\(vertices[i]) -> \(neighborsForIndex(i))\n"
        }
        return d
    }
    
    // MARK: Implement CollectionType
    
    public var startIndex: Int {
        return 0
    }
    
    public var endIndex: Int {
        return vertexCount
    }
    
    public func index(after i: Int) -> Int {
        return i + 1
    }
    
    /// The same as vertexAtIndex() - returns the vertex at index
    ///
    ///
    /// - Parameter index: The index of vertex to return.
    /// - returns: The vertex at index.
    public subscript(i: Int) -> V {
        return vertexAtIndex(i)
    }
}

