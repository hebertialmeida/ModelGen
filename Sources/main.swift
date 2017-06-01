//
//  main.swift
//  ModelGen
//
//  Created by Heberti Almeida on 2017-05-10.
//  Copyright © 2017 ModelGen. All rights reserved.
//

import Commander
import PathKit
import Stencil
import StencilSwiftKit
import SwiftGenKit

// MARK: - Common

let templatePathOption = Option<String>("template", "", flag: "t", description: "The path of the template to use for code generation.")
let langOption = Option<String>("lang", "", flag: "l", description: "List of template parameters")
let outputOption = Option(
  "output",
  OutputDestination.console,
  flag: "o",
  description: "The path to the file to generate (Omit to generate to stdout)"
)

// MARK: - Main

let main = Group {
  $0.addCommand("file", "generate models based JSON Spec file", fileCommand)
  $0.addCommand("dir", "generate models based JSON Spec folder", dirCommand)
}

let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "0.0"
let stencilVersion = Bundle(for: Stencil.Template.self).infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0"
let stencilSwiftKitVersion = Bundle(for: StencilSwiftKit.StencilSwiftTemplate.self).infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0"
let swiftGenKitVersion = Bundle(for: SwiftGenKit.AssetsCatalogParser.self).infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0"

main.run("ModelGen v\(version) (" + "Stencil v\(stencilVersion), " + "StencilSwiftKit v\(stencilSwiftKitVersion), " + "SwiftGenKit v\(swiftGenKitVersion))")
