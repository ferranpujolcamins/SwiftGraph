//
//  Specialization.swift
//  SwiftGraphMeta
//
//  Created by Ferran Pujol Camins on 18/11/2018.
//

import Stencil
import PathKit

extension Specialization {
    enum Reducer {
        case prunning((String) -> String)
        case nonPrunning((String) -> String)

        var closure: (String) -> String {
            switch self {
            case .prunning(let closure):
                return closure
            case .nonPrunning(let closure):
                return closure
            }
        }
    }
}

struct Specialization {
    let signature: String
    let setup: String
    let reducer: Reducer
    let goalTest: (String) -> String
    let retrn: String
}

struct SpecializationWithContext {
    let signature: String
    let setup: String
    let prunningReducer: Bool
    let goalTest: (String) -> String
    let retrn: String

    var context: Context

    init(specialization: Specialization, context: Context) {
        self.signature = specialization.signature
        self.setup = specialization.setup
        if case .prunning = specialization.reducer {
            self.prunningReducer = true
        } else {
            self.prunningReducer = false
        }
        self.goalTest = specialization.goalTest
        self.retrn = specialization.retrn

        self.context = context
        let ext = Extension()
        ext.registerFilter("GOAL_TEST", filter: { (anyValue) -> Any? in
            guard let value = anyValue as? String else {
                return anyValue
            }

            return specialization.goalTest(value)
        })

        ext.registerFilter("REDUCER", filter: { (anyValue) -> Any? in
            guard let value = anyValue as? String else {
                return anyValue
            }

            return specialization.reducer.closure(value)
        })

        self.context.push(ext)
        self.context.push(asDict())
        self.render()
    }

    var rendered: String = ""

    func asDict() -> [String: Any] {
        return [
            "specialization" : self
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
