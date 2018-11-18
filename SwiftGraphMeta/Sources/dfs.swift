//
//  dfs.swift
//  SwiftGraphMeta
//
//  Created by Ferran Pujol Camins on 18/11/2018.
//

import Foundation


let dfs = Algorithm(
    name: "Dfs",
    createContainer: "Stack<E>()",
    markAsVisited: .onPop,
    pushToContainer: {
        return "container.push(\($0))"
    },
    specializations: [
        Specialization(
            signature: "from(_ initalVertexIndex: Int, goalTest: (Int) -> Bool, reducer: G.Reducer) -> Int?",
            goalTest: {
                return """
                if goalTest(\($0)) {
                    return \($0)
                }
                """
            }
        ),
        Specialization(
            signature: "from(_ initalVertexIndex: Int, reducer: G.Reducer) -> Int?",
            goalTest: { _ in "" }
        )
    ]
)
