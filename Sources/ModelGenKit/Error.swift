//
//  Error.swift
//  ModelGen
//
//  Created by Heberti Almeida on 2017-06-01.
//  Copyright © 2017 ModelGen. All rights reserved.
//

import Foundation
import PathKit

public enum JsonParserError: Error, LocalizedError {
    case invalidFile(reason: String)
    case missingProperties
    case missingTitle
    case missingPackage

    public var errorDescription: String? {
        switch self {
        case let .invalidFile(reason):
            return "Unable to parse file. \(reason)"
        case .missingProperties:
            return "Missing property \"properties\" on json file"
        case .missingTitle:
            return "Missing property \"title\" on json file"
        case .missingPackage:
            return "Missing property \"package\" on json file is required in kotlin and java models"
        }
    }
}

public enum YamlParserError: Error, LocalizedError {
    case invalidFile
    case missingSpecPath
    case missingTemplate

    public var errorDescription: String? {
        switch self {
        case .invalidFile:
            return "Unable to parse .yml file"
        case .missingSpecPath:
            return "You must provide the spec folder or file"
        case .missingTemplate:
            return "You must provide a Stencil template"
        }
    }
}

public enum SchemaError: Error, LocalizedError {
    case missingAdditionalProperties
    case missingItems
    case missingType
    case missingPackageForType(type: String)
    case invalidSchemaType(type: String)

    public var errorDescription: String? {
        switch self {
        case .missingAdditionalProperties:
            return "Missing \"additionalProperties\" for \"object\" type"
        case .missingItems:
            return "Missing property \"items\" for \"array\" type"
        case .missingType:
            return "Missing type for object"
        case .missingPackageForType(let type):
            return "Missing package for: \"\(type)\""
        case .invalidSchemaType(let type):
            return "Invalid type: \"\(type)\""
        }
    }
}

public enum TemplateError: Error, LocalizedError {
    case templatePathNotFound(path: Path)
    case noTemplateProvided

    public var errorDescription: String? {
        switch self {
        case .templatePathNotFound(let path):
            return "Template not found at path \(path.description)."
        case .noTemplateProvided:
            return "Template not provided. E.g. '-t /path/template.stencil' or '--template /path/template.stencil'"
        }
    }
}

// MARK: Colored errors support

public enum ANSI: UInt8, CustomStringConvertible {
    case reset = 0

    case black = 30
    case red
    case green
    case yellow
    case blue
    case magenta
    case cyan
    case white
    case `default`

    public var description: String {
        return "\u{001B}[\(self.rawValue)m"
    }
}

func fputs(_ message: String, color: ANSI, shouldExit: Bool = false) {
    fputs("\(color)\(message)\(ANSI.reset)\n", stderr)
    guard shouldExit else { return }
    exit(1)
}

public func printError(_ string: String, showFile: Bool = false, file: String? = nil) {
    let message = showFile ? "❌ \(file ?? currentFile.description): \(string)" : "❌ Error: \(string)"
    fputs(message, color: .red, shouldExit: true)
}

public func printWarning(_ string: String, showFile: Bool = false, file: String? = nil) {
    let message = showFile ? "⚠️ \(file ?? currentFile.description): \(string)" : "⚠️ Warning: \(string)"
    fputs(message, color: .red)
}

public func printSuccess(_ string: String, showFile: Bool = false, file: String? = nil) {
    let message = showFile ? "\(file ?? currentFile.description): \(string)" : string
    fputs(message, color: .green)
}
