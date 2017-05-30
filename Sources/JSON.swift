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

let fileCommand = command(outputOption, templatePathOption, paramsOption, Argument<Path>("FILE", description: ".json file to parse.", validator: fileExists)) { output, templatePath, parameters, path in
    do {
      try parseObject(output: output, template: templatePath, parameters: parameters, path: path)
    } catch let error {
      printError(string: "error: \(error.localizedDescription)")
    }
}

let dirCommand = command(outputOption, templatePathOption, paramsOption, Argument<Path>("DIR", description: "A directory with .json files to parse.", validator: dirExists)) { output, templatePath, parameters, path in
  let paths = try path.children().filter { $0.extension == "json" }

  paths.forEach { path in
    do {
      try parseObject(output: output, template: templatePath, parameters: parameters, path: path)
    } catch let error {
      printError(string: "error: \(error.localizedDescription)")
    }
  }
}

func parseObject(output: OutputDestination, template: String, parameters: [String], path: Path) throws {
  let parser = JSONFileParser()
  var finalOutput = output

  do {
    jsonAbsolutePath = Path(NSString(string: path.description).deletingLastPathComponent)
    try parser.parseFile(at: path)

    let tempatePath = try validate(template)
    let template = try StencilSwiftTemplate(templateString: tempatePath.read(), environment: stencilSwiftEnvironment())
    let context = try parser.stencilContext()
    let enriched = try StencilContext.enrich(context: context, parameters: parameters)
    let rendered = try template.render(enriched)

    let out = Path(output.description)
    guard out.isDirectory else {
      output.write(content: rendered, onlyIfChanged: true)
      return
    }
    guard let title = parser.json["title"] as? String else {
      throw JSONFileParserError.missingTitle
    }
    let finalPath = Path(output.description) + "\(title.uppercaseFirst()).swift"
    finalOutput = .file(finalPath)
    finalOutput.write(content: rendered, onlyIfChanged: true)
  } catch let error {
    printError(string: "error: \(error.localizedDescription)")
  }
}
