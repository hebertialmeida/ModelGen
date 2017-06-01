//
//  JSONFileParser.swift
//  ModelGen
//
//  Created by Heberti Almeida on 2017-05-10.
//  Copyright © 2017 ModelGen. All rights reserved.
//

import Foundation
import PathKit

public typealias JSON = [String: Any]

public final class JSONFileParser {
  public var json: JSON = [:]
  public var properties = [SchemaProperty]()

  public init() {}

  public func parseFile(at path: Path) throws {
    currentFile = path
    do {
      guard let json = try JSONSerialization.jsonObject(with: try path.read(), options: []) as? JSON else {
        throw JSONError.invalidFile(file: path.string, reason: "Invalid structure.")
      }
      self.json = json
    } catch let error as JSONError {
      throw error
    } catch let error {
      throw JSONError.invalidFile(file: path.string, reason: error.localizedDescription)
    }
  }
}
