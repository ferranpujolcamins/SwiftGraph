//
//  main.swift
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
import Foundation

guard CommandLine.arguments.count >= 2 else {
    print("Missing templates path argument")
    exit(1)
}

guard CommandLine.arguments.count >= 3 else {
    print("Missing output path argument")
    exit(1)
}

guard CommandLine.arguments.count == 3 else {
    print("Unknown argument. Only two arguments expected.")
    exit(2)
}

let templatesPath = CommandLine.arguments[1]
let outPath = CommandLine.arguments[2]

func write(_ file: GeneratedFile) {
    guard let outputData = file.content.data(using: String.Encoding.utf8) else {
        print("Unable to encode content to UTF8")
        exit(5)
    }

    let filePath = outPath + file.filename

    if FileManager.default.fileExists(atPath: filePath) {
        do {
            try FileManager.default.removeItem(atPath: filePath)
        } catch let error {
            print("Unable to overwrite file at: \(filePath)")
            print(error)
            exit(3)
        }
    }
    FileManager.default.createFile(atPath: filePath, contents: nil, attributes: nil)

    guard let file = FileHandle(forWritingAtPath: filePath) else {
        print("Unable to write at: \(filePath)")
        exit(4)
    }

    file.write(outputData)

    print("File written: \(filePath)")
}

struct GeneratedFile {
    let filename: String
    let content: String
}

let files = [
    GeneratedFile(filename: dfs.name + ".swift", content: dfs.render())
]

files.forEach(write)

exit(0)
