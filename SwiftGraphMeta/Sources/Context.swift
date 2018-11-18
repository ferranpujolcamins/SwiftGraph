//
//  Context.swift
//  SwiftGraphMeta
//
//  Created by Ferran Pujol Camins on 18/11/2018.
//

import Stencil

struct Context {
    var dictionaries: [[String: Any?]] = []
    var extensions: [Extension] = []

    init() {}

    init(from: Context) {
        dictionaries = from.dictionaries
        extensions = from.extensions
    }

    mutating func push(_ dictionary: [String: Any?]) {
        dictionaries.append(dictionary)
    }

    mutating func push(_ ext: Extension) {
        extensions.append(ext)
    }

    public func flatten() -> [String: Any] {
        var accumulator: [String: Any] = [:]

        for dictionary in dictionaries {
            for (key, value) in dictionary {
                if let value = value {
                    accumulator.updateValue(value, forKey: key)
                }
            }
        }

        return accumulator
    }
}
