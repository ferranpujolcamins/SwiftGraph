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

extension Algorithm {
    enum MarkAsVisited {
        case onPop
        case onPush
    }
}

struct Algorithm {
    let name: String

    let createContainer: String

    let markAsVisitedOnPush: Bool

    var context = Context()

    var specializations: [SpecializationWithContext] = []

    init(name: String,
         createContainer: String,
         markAsVisited: MarkAsVisited,
         pushToContainer: @escaping (String) -> String,
         specializations: [Specialization] ) {

        self.name = name
        self.createContainer = createContainer
        markAsVisitedOnPush = markAsVisited == .onPush

        let ext = Extension()
        ext.registerFilter("PUSH_TO_CONTAINER") { (anyValue) -> Any? in
            guard let value = anyValue as? String else {
                return anyValue
            }

            return pushToContainer(value)
        }
        context.push(ext)
        context.push(self.asDict())

        self.specializations = specializations.map({ spec in
            return SpecializationWithContext(specialization: spec, context: context)
        })
    }

    func asDict() -> [String: Any] {
        return [
            "algorithm" : self
        ]
    }
}

extension Algorithm {
    func render() -> String {
        let fileLoader = FileSystemLoader(paths: [Path(templatesPath)])
        let env = Environment(
            loader: fileLoader
        )
        let template = try! env.loadTemplate(name: "algorithm.swift.stencil")
        return try! template.render(self.asDict())
    }
}
