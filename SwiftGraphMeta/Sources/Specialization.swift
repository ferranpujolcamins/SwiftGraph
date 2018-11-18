//
//  Specialization.swift
//  SwiftGraphMeta
//
//  Created by Ferran Pujol Camins on 18/11/2018.
//

import Stencil
import PathKit

struct Specialization {
    let signature: String
    let goalTest: (String) -> String
}

struct SpecializationWithContext {
    let specialization: Specialization

    var context: Context

    init(specialization: Specialization, context: Context) {
        self.specialization = specialization
        self.context = context
        let ext = Extension()
        ext.registerFilter("GOAL_TEST", filter: { (anyValue) -> Any? in
            guard let value = anyValue as? String else {
                return anyValue
            }

            return specialization.goalTest(value)
        })

        self.context.push(ext)
        self.context.push(asDict())
        self.render()
    }

    var rendered: String = ""

    func asDict() -> [String: Any] {
        return [
            "specialization" : specialization
        ]
    }
}

extension SpecializationWithContext {
    mutating func render() {
        let fileLoader = FileSystemLoader(paths: [Path(templatesPath)])
        let env = Environment(
            loader: fileLoader,
            extensions: context.extensions
        )
        let template = try! env.loadTemplate(name: "specialization.swift.stencil")
        rendered = try! template.render(context.flatten())
    }
}
