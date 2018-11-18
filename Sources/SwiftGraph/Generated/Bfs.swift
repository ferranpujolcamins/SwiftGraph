struct Bfs<G: Graph> {
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
        let container = Queue<E>()

        visited[initalVertexIndex] = true
        let neighbours = graph.edgesForIndex(initalVertexIndex)
        for e in neighbours {
            if !visited[e.v] {
                container.push(e)

                visited[e.v] = true
            }
        }

        while !container.isEmpty {
            let edge: E = container.pop()
            let v = edge.v

            let shouldVisitNeighbours = reducer(edge)

            if goalTest(v) {
                return v
            }

            if shouldVisitNeighbours {
                let neighbours = graph.edgesForIndex(v)
                for e in neighbours {
                    if !visited[e.v] {
                        container.push(e)

                        visited[e.v] = true
                    }
                }
            }
        }
        return nil
    }

    func from(index initalVertexIndex: Int, goalTest: (Int) -> Bool) -> [E] {
        var pathDict: [Int: E] = [:]
        if goalTest(initalVertexIndex) {
            return pathDictToPath(from: initalVertexIndex, to: initalVertexIndex, pathDict: pathDict) as! [E]
        }

        var visited: [Bool] = [Bool](repeating: false, count: graph.vertexCount)
        let container = Queue<E>()

        visited[initalVertexIndex] = true
        let neighbours = graph.edgesForIndex(initalVertexIndex)
        for e in neighbours {
            if !visited[e.v] {
                container.push(e)

                visited[e.v] = true
            }
        }

        while !container.isEmpty {
            let edge: E = container.pop()
            let v = edge.v

            pathDict[edge.v] = edge

            if goalTest(v) {
                return pathDictToPath(from: initalVertexIndex, to: v, pathDict: pathDict) as! [E]
            }

            let neighbours = graph.edgesForIndex(v)
            for e in neighbours {
                if !visited[e.v] {
                    container.push(e)

                    visited[e.v] = true
                }
            }
        }
        return []
    }
}
