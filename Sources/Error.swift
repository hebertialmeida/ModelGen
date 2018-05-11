//
//  Error.swift
//  ModelGen
//
//  Created by Heberti Almeida on 2017-06-01.
//  Copyright © 2017 ModelGen. All rights reserved.
//

import Foundation
import PathKit

enum JsonParserError: Error, LocalizedError {
  case invalidFile(reason: String)
  case missingProperties
  case missingTitle

  public var errorDescription: String? {
    switch self {
    case .invalidFile(reason: let reason):
      return "Unable to parse file. \(reason)"
    case .missingProperties:
      return "Missing property \"properties\" on json file"
    case .missingTitle:
      return "Missing property \"title\" on json file"
    }
  }
}

enum YamlParserError: Error, LocalizedError {
  case invalidFile(reason: String)
  case missingSpecPath
  case missingTemplate

  public var errorDescription: String? {
    switch self {
    case .invalidFile(reason: let reason):
      return "Unable to parse file. \(reason)"
    case .missingSpecPath:
      return "You must provide the spec folder or file"
    case .missingTemplate:
      return "You must provide a Stencil template"
    }
  }
}

enum SchemaError: Error, LocalizedError {
  case missingAdditionalProperties
  case missingItems
  case missingType
  case invalidSchemaType(type: String)

  public var errorDescription: String? {
    switch self {
    case .missingAdditionalProperties:
      return "Missing \"additionalProperties\" for \"object\" type"
    case .missingItems:
      return "Missing property \"items\" for \"array\" type"
    case .missingType:
      return "Missing type for object"
    case .invalidSchemaType(let type):
      return "Invalid type: \"\(type)\""
    }
  }
}

enum TemplateError: Error, LocalizedError {
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

enum ANSI: UInt8, CustomStringConvertible {
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

  var description: String {
    return "\u{001B}[\(self.rawValue)m"
  }
}

func printError(_ string: String, showFile: Bool = false, file: String? = nil) {
  guard showFile else {
    let message = "❌  Error: \(string)"
    fputs("\(ANSI.red)\(message)\(ANSI.reset)\n", stderr)
    exit(1)
  }
  let message = "❌  \(file ?? currentFile.description): \(string)"
  fputs("\(ANSI.red)\(message)\(ANSI.reset)\n", stderr)
  exit(1)
}

func printWarning(_ string: String, showFile: Bool = false, file: String? = nil) {
  guard showFile else {
    let message = "⚠️  Warning: \(string)"
    fputs("\(ANSI.red)\(message)\(ANSI.reset)\n", stderr)
    return
  }
  let message = "⚠️  \(file ?? currentFile.description): \(string)"
  fputs("\(ANSI.red)\(message)\(ANSI.reset)\n", stderr)
}

func printSuccess(_ string: String, showFile: Bool = false, file: String? = nil) {
  guard showFile else {
    let message = "\(string)"
    fputs("\(ANSI.green)\(message)\(ANSI.reset)\n", stderr)
    return
  }
  let message = "\(file ?? currentFile.description): \(string)"
  fputs("\(ANSI.green)\(message)\(ANSI.reset)\n", stderr)
}
