//
//  main.swift
//  ModelGen
//
//  Created by Heberti Almeida on 2017-05-10.
//  Copyright © 2017 ModelGen. All rights reserved.
//

import Foundation
import Commander
import PathKit

// MARK: - Options

let specOption = Option<Path>("spec", default: Path(), flag: "s", description: "The spec folder or file path e.g: ./specs or user.json", validator: pathExists)
let templateOption = Option<String>("template", default: "", flag: "t", description: "The path of the template to use for code generation.")
let languageOption = Option<String>("language", default: Language.swift.rawValue, flag: "l", description: "The output language e.g: swift")
let outputOption = Option<OutputDestination>("output", default: .console, flag: "o", description: "The path to the file to generate (Omit to generate to stdout)")

// MARK: - Version

let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "0.3.0"

// MARK: - Main

command(outputOption, templateOption, languageOption, specOption) { output, templatePath, lang, path in
  guard path.string.isEmpty else {
    do {
      try parse(output: output, template: templatePath, lang: lang, path: path)
    } catch {
      printError(error.localizedDescription)
    }
    return
  }

  let yamlPath = Path(".modelgen.yml")

  do {
    let yamlContents = try yamlPath.read(.utf8)
    let dict = try YamlParser.parse(yamlContents)
    guard let config = Configuration(dictionary: dict) else {
      printError("Error creating configuration")
      exit(1)
    }

    guard let configSpec = config.spec else {
      printError(YamlParserError.missingSpecPath.localizedDescription)
      exit(1)
    }

    guard let configTemplate = config.template else {
      printError(YamlParserError.missingTemplate.localizedDescription)
      exit(1)
    }

    var configOutput: OutputDestination {
      guard let output = config.output else {
        return .console
      }
      return OutputDestination.file(Path(output))
    }

    try render(output: configOutput, template: configTemplate, lang: config.language ?? Language.swift.rawValue, path: Path(configSpec))
    exit(0)
  } catch {
    printError(error.localizedDescription)
  }

}.run("ModelGen v\(version)")
