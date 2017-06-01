//
//  Utils.swift
//  ModelGen
//
//  Created by Heberti Almeida on 2017-05-10.
//  Copyright © 2017 ModelGen. All rights reserved.
//

import Commander
import PathKit

// MARK: Validators

func checkPath(type: String, assertion: @escaping (Path) -> Bool) -> ((Path) throws -> Path) {
  return { (path: Path) throws -> Path in
    guard assertion(path) else { throw ArgumentError.invalidType(value: path.description, type: type, argument: nil) }
    return path
  }
}
let pathExists = checkPath(type: "path") { $0.exists }
let fileExists = checkPath(type: "file") { $0.isFile }
let dirExists  = checkPath(type: "directory") { $0.isDirectory }

let pathsExist = { (paths: [Path]) throws -> [Path] in try paths.map(pathExists) }
let filesExist = { (paths: [Path]) throws -> [Path] in try paths.map(fileExists) }
let dirsExist = { (paths: [Path]) throws -> [Path] in try paths.map(dirExists) }

// MARK: Path as Input Argument

extension Path: ArgumentConvertible {
  public init(parser: ArgumentParser) throws {
    guard let path = parser.shift() else {
      throw ArgumentError.missingValue(argument: nil)
    }
    self = Path(path)
  }
}

// MARK: Output (Path or Console) Argument

enum OutputDestination: ArgumentConvertible {
  case console
  case file(Path)

  init(parser: ArgumentParser) throws {
    guard let path = parser.shift() else {
      throw ArgumentError.missingValue(argument: nil)
    }
    self = .file(Path(path))
  }
  var description: String {
    switch self {
    case .console: return "(stdout)"
    case .file(let path): return path.description
    }
  }

  func write(content: String, onlyIfChanged: Bool = false) {
    switch self {
    case .console:
      print(content)
    case .file(let path):
      do {
        if try onlyIfChanged && path.exists && path.read(.utf8) == content {
          return print("✅  Unchanged: \(path)")
        }
        try path.write(content)
        print("✅  Generated: \(path)")
      } catch let error {
        printError(error.localizedDescription, showFile: true)
      }
    }
  }
}

/// Validate a template path
///
/// - Parameter template: String template path
/// - Returns: Typed valid Path
/// - Throws: TemplateError
func validate(_ template: String) throws -> Path {
  guard !template.isEmpty else {
    throw TemplateError.noTemplateProvided
  }
  let templatePath = Path(template)
  guard templatePath.isFile else {
    throw TemplateError.templatePathNotFound(path: templatePath)
  }
  return templatePath
}
