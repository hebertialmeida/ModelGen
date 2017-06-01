//
//  JSON.swift
//  ModelGen
//
//  Created by Heberti Almeida on 2017-05-10.
//  Copyright © 2017 ModelGen. All rights reserved.
//

import Commander
import PathKit
import StencilSwiftKit
import SwiftGenKit

var jsonAbsolutePath = Path()
var currentFile = Path()

fileprivate let fileArguments = Argument<Path>("FILE", description: ".json file to parse.", validator: fileExists)
fileprivate let dirArguments = Argument<Path>("DIR", description: "A directory with .json files to parse.", validator: dirExists)

let fileCommand = command(outputOption, templatePathOption, langOption, fileArguments) { output, templatePath, lang, path in
  do {
    try parseObject(output: output, template: templatePath, lang: lang, path: path)
  } catch let error {
    printError(error.localizedDescription, showFile: true)
  }
  printSuccess("Finished generation.")
}

let dirCommand = command(outputOption, templatePathOption, langOption, dirArguments) { output, templatePath, lang, path in
  let paths = try path.children().filter { $0.extension == "json" }

  paths.forEach { path in
    do {
      try parseObject(output: output, template: templatePath, lang: lang, path: path)
    } catch let error {
      printError(error.localizedDescription, showFile: true)
    }
  }
  printSuccess("Finished generation of \(paths.count) files.")
}

func parseObject(output: OutputDestination, template: String, lang: String, path: Path) throws {
  let parser = JSONFileParser()
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
      throw JSONError.missingTitle
    }
    let finalPath = Path(output.description) + "\(title.uppercaseFirst() + language.fileExtension)"
    finalOutput = .file(finalPath)
    finalOutput.write(content: rendered, onlyIfChanged: true)
  } catch let error {
    printError(error.localizedDescription, showFile: true, file: path.description)
  }
}
