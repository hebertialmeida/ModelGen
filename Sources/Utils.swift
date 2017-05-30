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

func printError(string: String) {
  fputs("\(string)\n", stderr)
}

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
          return print("Not writing the file as content is unchanged")
        }
        try path.write(content)
        print("✅  Generated: \(path)")
      } catch let e as NSError {
        printError(string: "❌  error: \(e)")
      }
    }
  }
}

// MARK: Template

enum TemplateError: Error {
  case templatePathNotFound(path: Path)
  case noTemplateProvided

  var localizedDescription: String {
    switch self {
    case .templatePathNotFound(let path):
      return "Template not found at path \(path.description)."
    case .noTemplateProvided:
      return "A template must be chosen either via its name using the '-t' / '--template' option" +
      " or via its path using the '-p' / '--templatePath' option.\n" +
      "There's no 'default' template anymore: you can still access a bundled template but " +
      "you have to explicitly specify its name using '-t'.\n" +
      "To list all the available named templates, you can use the 'swiftgen templates list' command."
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
