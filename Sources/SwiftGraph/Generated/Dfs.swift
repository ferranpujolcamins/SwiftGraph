struct Dfs<G: Graph> {
    typealias V = G.V
    typealias E = G.E

    public init(on graph: G) {
        self.graph = graph
    }

    public let graph: G

    func from(_ initalVertexIndex: Int, goalTest: (Int) -> Bool, reducer: G.Reducer) -> Int? {
        if goalTest(initalVertexIndex) {
            return initalVertexIndex
        }

        var visited: [Bool] = [Bool](repeating: false, count: graph.vertexCount)
        let container = Stack<E>()

        visited[initalVertexIndex] = true
        let neighbours = graph.edgesForIndex(initalVertexIndex)
        for e in neighbours {
            if !visited[e.v] {
                container.push(e)
            }
        }

        while !container.isEmpty {
            let edge: E = container.pop()
            let v = edge.v
            if visited[v] {
                continue
            }
            let shouldVisitNeighbours = reducer(edge)
            if goalTest(v) {
                return v
            }
            if shouldVisitNeighbours {
                visited[v] = true
                let neighbours = graph.edgesForIndex(v)
                for e in neighbours {
                    if !visited[e.v] {
                        container.push(e)
                    }
                }
            }
        }
        return nil // no route found
    }

    func from(_ initalVertexIndex: Int, reducer: G.Reducer) -> Int? {
        var visited: [Bool] = [Bool](repeating: false, count: graph.vertexCount)
        let container = Stack<E>()

        visited[initalVertexIndex] = true
        let neighbours = graph.edgesForIndex(initalVertexIndex)
        for e in neighbours {
            if !visited[e.v] {
                container.push(e)
            }
        }

        while !container.isEmpty {
            let edge: E = container.pop()
            let v = edge.v
            if visited[v] {
                continue
            }
            let shouldVisitNeighbours = reducer(edge)

            if shouldVisitNeighbours {
                visited[v] = true
                let neighbours = graph.edgesForIndex(v)
                for e in neighbours {
                    if !visited[e.v] {
                        container.push(e)
                    }
                }
            }
        }
        return nil // no route found
    }
}
