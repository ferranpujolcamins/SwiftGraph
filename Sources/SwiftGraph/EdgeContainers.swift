//
//  EdgeContainers.swift
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

public protocol NeighboursVisitor {
    associatedtype C: EdgeContainer
    associatedtype G: Graph where G.E == C.E
    static func visitNeighboursFIFO(v: Int,
                                    graph: G,
                                    container: C,
                                    visitOrder: ([G.E]) -> [G.E],
                                    visited: inout [Bool])
}

public enum FIFONeighboursVisitor<C: EdgeContainer, G: Graph>: NeighboursVisitor where G.E == C.E {
    public static func visitNeighboursFIFO(v: Int,
                                           graph: G,
                                           container: C,
                                           visitOrder: ([C.E]) -> [C.E],
                                           visited: inout [Bool]) {
        let neighbours = visitOrder(graph.edgesForIndex(v))
        for i in 0..<neighbours.count {
            let e = neighbours[i]
            if !visited[e.v] {
                container.push(e)
                visited[e.v] = true
            }
        }
    }
}

public enum LIFONeighboursVisitor<C: EdgeContainer, G: Graph>: NeighboursVisitor where G.E == C.E {
    public static func visitNeighboursFIFO(v: Int,
                                           graph: G,
                                           container: C,
                                           visitOrder: ([C.E]) -> [C.E],
                                           visited: inout [Bool]) {
        let neighbours = visitOrder(graph.edgesForIndex(v))
        visited[v] = true
        for i in stride(from: neighbours.count-1, to: -1, by: -1) {
            let e = neighbours[i]
            if !visited[e.v] {
                container.push(e)
            }
        }
    }
}


/// An abstract edge container used to store the discovered edges whose destination vertex still
/// has to be visited.
public protocol EdgeContainer {
    associatedtype E
    associatedtype Visitor: NeighboursVisitor where Visitor.C == Self

    /// Indicates wheter this container is a first-in-first-out container or a
    /// last-in-first-out container.
    ///
    /// This property indicates in which order the discovered vertices need to be added
    /// to the container container.
    ///
    /// If true, the container is a first-in-first-out container and
    /// the vertices that must be visited first, must be added first.
    /// If false, the container is a last-in-first-out container and
    /// the vertices that must be visited first, must be added last.
    static var isFIFO: Bool { get }

    init()
    func push(_ e: E)
    func pop() -> E
    var isEmpty: Bool { get }
}

/// Implements a stack - helper class that uses an array internally.
public class Stack<T, G: Graph>: EdgeContainer where T == G.E {
    public typealias E = T
    public typealias Visitor = LIFONeighboursVisitor<Stack<T, G>, G>


    private var container: [T] = [T]()

    public static var isFIFO: Bool { get { return false } }

    public required init() {}
    public var isEmpty: Bool { return container.isEmpty }
    public func push(_ thing: T) { container.append(thing) }
    public func pop() -> T { return container.removeLast() }
}

/// Implements a queue - helper class that uses an array internally.
public class Queue<T: Equatable>: EdgeContainer {
    public typealias Visitor = FIFONeighboursVisitor

    private var container = [T]()
    private var head = 0

    public static var isFIFO: Bool { get { return true } }

    public required init() {}

    public var isEmpty: Bool {
        return count == 0
    }

    public func push(_ element: T) {
        container.append(element)
    }

    public func pop() -> T {
        let element = container[head]
        head += 1

        // If queue has more than 50 elements and more than 50% of allocated elements are popped.
        // Don't calculate the percentage with floating point, it decreases the performance considerably.
        if container.count > 50 && head * 2 > container.count {
            container.removeFirst(head)
            head = 0
        }

        return element
    }

    public var front: T {
        return container[head]
    }

    public var count: Int {
        return container.count - head
    }

    public func contains(_ thing: T) -> Bool {
        let content = container.dropFirst(head)
        if content.firstIndex(of: thing) != nil {
            return true
        }
        return false
    }
}

