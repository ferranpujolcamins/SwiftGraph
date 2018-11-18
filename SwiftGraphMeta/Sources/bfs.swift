//
//  bfs.swift
//  SwiftGraphMeta
//
//  Created by Ferran Pujol Camins on 18/11/2018.
//

let bfs = Algorithm(
    name: "Bfs",
    createContainer: "Queue<E>()",
    markAsVisited: .onPush,
    pushToContainer: {
        return "container.push(\($0))"
    },
    specializations: [
        Specialization(
            signature: "from(_ initalVertexIndex: Int, goalTest: (Int) -> Bool, reducer: G.Reducer) -> Int?",
            setup: "",
            reducer: .prunning({
                return "reducer(\($0))"
            }),
            goalTest: {
                return """
                if goalTest(\($0)) {
                    return \($0)
                }
                """
            },
            retrn: "return nil"
        ),
        Specialization(
            signature: "from(index initalVertexIndex: Int, goalTest: (Int) -> Bool) -> [E]",
            setup: "var pathDict:[Int: E] = [:]",
            reducer: .nonPrunning({ _ in "pathDict[edge.v] = edge" }),
            goalTest: {
                return """
                if goalTest(\($0)) {
                return pathDictToPath(from: initalVertexIndex, to: \($0), pathDict: pathDict) as! [E]
                }
                """
            },
            retrn: """
                    return []
                   """
        )
    ]
)
