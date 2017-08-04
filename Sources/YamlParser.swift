//
//  YamlParser.swift
//  ModelGen
//
//  Created by Heberti Almeida on 2017-08-03.
//  Copyright © 2017 ModelGen. All rights reserved.
//

import Foundation
import Yams

public struct YamlParser {
  public static func parse(_ yaml: String, env: [String: String] = ProcessInfo.processInfo.environment) throws -> [String: Any] {
    do {
      return try Yams.load(yaml: yaml, .default, Constructor.default) as? [String: Any] ?? [:]
    } catch {
      throw YamlParserError.invalidFile(reason: "\(error)")
    }
  }
}
