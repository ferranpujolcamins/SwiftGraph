//
//  Dfs.swift
//  SwiftGraph
//
//  Copyright (c) 2018 Ferran Pujol Camins
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

import Stencil
import PathKit

struct Algorithm {
    let name: String
    
    let specializations: [Specialization]

    func asDict() -> [String: Any] {
        return [
            "algorithm" : self
        ]
    }
}

struct Specialization {
    let signature: String

    let ext: Extension

    init(signature: String, goalTest: @escaping (String) -> String) {
        self.signature = signature
        ext = Extension()
        ext.registerFilter("GOAL_TEST", filter: { (anyValue) -> Any? in
            guard let value = anyValue as? String else {
                return anyValue
            }

            return goalTest(value)
        })

        rendered = render()
    }

    var rendered: String! = nil

    func asDict() -> [String: Any] {
        return [
            "specialization" : self
        ]
    }
}

let dfs = Algorithm(
    name: "Dfs",
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


extension Algorithm {
    func render() -> String {
        let fileLoader = FileSystemLoader(paths: [Path(templatesPath)])
        let env = Environment(
            loader: fileLoader
        )
        let template = try! env.loadTemplate(name: "algorithm.swifttemplate")
        return try! template.render(self.asDict())
    }
}

extension Specialization {
    func render() -> String {
        let fileLoader = FileSystemLoader(paths: [Path(templatesPath)])
        let env = Environment(
            loader: fileLoader,
            extensions: [ ext ]
        )
        let template = try! env.loadTemplate(name: "specialization.swifttemplate")
        return try! template.render(self.asDict())
    }
}
