//
//  JsonParser.swift
//  ModelGen
//
//  Created by Heberti Almeida on 2017-05-10.
//  Copyright © 2017 ModelGen. All rights reserved.
//

import Foundation
import StencilSwiftKit
import PathKit

public typealias JSON = [String: Any]

public final class JsonParser {
    public var json: JSON = [:]
    public var properties = [SchemaProperty]()

    public init() {}

    public func parseFile(at path: Path) throws {
        currentFile = path
        do {
            guard let json = try JSONSerialization.jsonObject(with: try path.read(), options: []) as? JSON else {
                throw JsonParserError.invalidFile(reason: "Invalid structure.")
            }
            self.json = json
        } catch let error as JsonParserError {
            throw error
        } catch let error {
            throw JsonParserError.invalidFile(reason: error.localizedDescription)
        }
    }
}

// MARK: Parser

public func render(output: OutputDestination, template: String, lang: String, path: Path) throws {
    guard path.isDirectory else {
        do {
            try parse(output: output, template: template, lang: lang, path: path)
        } catch let error {
            printError(error.localizedDescription, showFile: true)
        }
        printSuccess("Finished generation.")
        exit(0)
    }

    let paths = try path.children().filter { $0.extension == "json" }
    paths.forEach { path in
        do {
            try parse(output: output, template: template, lang: lang, path: path)
        } catch let error {
            printError(error.localizedDescription, showFile: true)
        }
    }
    printSuccess("Finished generation of \(paths.count) files.")
}

/// Parse specs and generate files based on json
///
/// - Parameters:
///   - output: Output destination of generated files
///   - template: Stencil template
///   - lang: Language to generate files
///   - path: Spec path, folder or file.json
/// - Throws: Error if something happens
public func parse(output: OutputDestination, template: String, lang: String, path: Path) throws {
    let parser = JsonParser()
    var finalOutput = output
    jsonAbsolutePath = Path(NSString(string: path.description).deletingLastPathComponent)

    do {
        try parser.parseFile(at: path)

        let language = Language(rawValue: lang) ?? .swift
        let tempatePath = try validate(template)
        let template = try StencilSwiftTemplate(templateString: tempatePath.read(), environment: stencilSwiftEnvironment())
        let context = try parser.stencilContextFor(language)
        let enriched = try StencilContext.enrich(context: context, parameters: [])
        let rendered = try template.render(enriched)

        let out = Path(output.description)
        guard out.isDirectory else {
            output.write(content: rendered, onlyIfChanged: true)
            return
        }
        guard let title = parser.json["title"] as? String else {
            throw JsonParserError.missingTitle
        }
        
        let packagePath: String
        switch language {
        case .swift, .objc:
            packagePath = ""
        case .kotlin:
            guard let package = parser.json["package"] as? String else {
                throw JsonParserError.missingPackage
            }
            
            packagePath = package.replacingOccurrences(of: ".", with: Path.separator) + Path.separator
        }
        
        let finalPath = Path(output.description) + packagePath + "\(title.uppercaseFirst() + language.fileExtension)"
        
        finalOutput = .file(path: finalPath)
        finalOutput.write(content: rendered, onlyIfChanged: true)
    } catch let error {
        printError(error.localizedDescription, showFile: true, file: path.description)
    }
}
