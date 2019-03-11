import Foundation
import SwiftGraph

/**

 */
public class GraphvizEncoder {
    fileprivate var vertices: String = ""
    fileprivate var edges: String = ""

    var data: String {
        return """
        digraph {
        \(vertices)

        \(edges)
        }
        """
    }

    static func encode(_ value: Encodable) throws -> String {
        let encoder = GraphvizEncoder()
        try! value.encode(to: encoder)
        return encoder.data
    }
}

extension GraphvizEncoder: Encoder {
    public var codingPath: [CodingKey] {
        return []
    }

    public var userInfo: [CodingUserInfoKey : Any] {
        return [:]
    }

    public func container<Key>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> where Key : CodingKey {
        return KeyedEncodingContainer(KeyedContainer(encoder: self, codingPath: codingPath, userInfo: userInfo))
    }

    public func unkeyedContainer() -> UnkeyedEncodingContainer {
        fatalError()
    }

    public func singleValueContainer() -> SingleValueEncodingContainer {
        fatalError()
    }

    func encodeVertices<T: Encodable>(_ vertices: T) throws {
        if let vertices = vertices as? [CustomStringConvertible] {
            self.vertices = vertices.map { String(describing: $0) }
                .enumerated().map { (i, v) in
                    return "    \(i) [label=\"\(v)\"]\n"
                }
                .joined()
        } else {
            fatalError()
        }
    }

    func encodeEdges<T: Encodable>(_ edges: T) throws {
        if let edgeList = edges as? [[CustomStringConvertible]] {
            self.edges = edgeList.joined().map { "    " + String(describing: $0) }.joined()
        } else {
            fatalError()
        }
    }
}

extension GraphvizEncoder {
    class KeyedContainer<Key: CodingKey>: KeyedEncodingContainerProtocol {
        var encoder: GraphvizEncoder
        var codingPath: [CodingKey]
        var userInfo: [CodingUserInfoKey : Any]

        init(encoder: GraphvizEncoder, codingPath: [CodingKey], userInfo: [CodingUserInfoKey : Any]) {
            self.encoder = encoder
            self.codingPath = codingPath
            self.userInfo = userInfo
        }

        func encodeNil(forKey key: Key) throws {

        }

        func encode<T>(_ value: T, forKey key: Key) throws where T : Encodable {
            if key.stringValue == "vertices" {
                try encoder.encodeVertices(value)
            } else if key.stringValue == "edges" {
                try encoder.encodeEdges(value)
            } else {
                fatalError()
            }
        }

        func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type, forKey key: Key) -> KeyedEncodingContainer<NestedKey> where NestedKey : CodingKey {
            return encoder.container(keyedBy: keyType)
        }

        func nestedUnkeyedContainer(forKey key: Key) -> UnkeyedEncodingContainer {
            return encoder.unkeyedContainer()
        }

        func superEncoder() -> Encoder {
            return encoder
        }

        func superEncoder(forKey key: Key) -> Encoder {
            return encoder
        }
    }
}

