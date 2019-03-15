//
//  Edge.swift
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

/// A protocol that all edges in a graph must conform to.
public protocol Edge: CustomStringConvertible {
    /// The origin vertex of the edge
    var u: Int { get set }  //made modifiable for changing when removing vertices
    /// The destination vertex of the edge
    var v: Int { get set }  //made modifiable for changing when removing vertices

    var directed: Bool { get }

    // Returns an edge with the origin and destination reversed
    func reversed() -> Self
}

public extension Edge {

    /// Checks that this edge connects two vertices.
    ///
    /// This happens when this edge is directed from the initial vertex to the terminal vertex
    /// or this edge is undirected and incident to both vertices.
    ///
    /// - Warning:
    /// `incident(fromIndex: i) && incident(toIndex: j) == true` does not imply
    /// `joins(index: i, toIndex: j) == true`. For example, the undirected edge 0-1, is incident from 0 because you can "walk away from 0 to 1".
    /// It is also incident to 0, because you can "walk back" from 1 to 0 throught the same edge.
    /// However, it is not clearly joining 0 to 0.
    ///
    /// - Parameters:
    ///   - fromIndex: The index of the initial vertex.
    ///   - toIndex: The index of the terminal vertex.
    /// - Returns: True if the initial terminal can be reached from the terminal vertex through this edge only.
    func joins(index fromIndex: Int, toIndex: Int) -> Bool {
        if directed {
            return fromIndex == u && toIndex == v
        }
        return (fromIndex == u && toIndex == v) || (fromIndex == v && toIndex == u)
    }

    /// Checks that this edge is incident to a vertex.
    ///
    /// This happens when one of the following is true:
    /// - This edge is directed and u is equal to the index we are checking to.
    /// - This edge is undirected and u, v or both are equal to the index we are checking to.
    ///
    /// - Parameter fromIndex: The index of the vertex to check incidence to.
    /// - Returns: `true` if the vertex is incident from this edge. `false`otherwise.
    func incident(fromIndex: Int) -> Bool {
        if directed {
            return fromIndex == u
        }
        return fromIndex == u || fromIndex == v
    }

    /// Checks that this edge is incident to a vertex.
    ///
    /// This happens when one of the following is true:
    /// - This edge is directed and v is equal to the index we are checking to.
    /// - This edge is undirected and u, v or both are equal to the index we are checking to.
    ///
    /// - Parameter toIndex: The index of the vertex to check incidence to.
    /// - Returns: `true` if the vertex is incident to this edge. `false`otherwise.
    func incident(toIndex: Int) -> Bool {
        if directed {
            return toIndex == v
        }
        return toIndex == v || toIndex == u
    }
}
