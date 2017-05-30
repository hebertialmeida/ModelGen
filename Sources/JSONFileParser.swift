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

public enum JSONFileParserError: Error {
  case invalidFile(reason: String)
  case missingProperties
  case missingTitle

  public var localizedDescription: String {
    switch self {
    case .invalidFile(reason: let reason):
      return "error: Unable to parse file. \(reason)"
    case .missingProperties:
      return "error: Missing \"properties\" on json file"
    case .missingTitle:
      return "error: Missing \"title\" on json file"
    }
  }
}

public final class JSONFileParser {
  public var json: JSON = [:]
  public var properties = [SchemaProperty]()

  public init() {}

  public func parseFile(at path: Path) throws {
    do {
      guard let json = try JSONSerialization.jsonObject(with: try path.read(), options: []) as? JSON else {
        throw JSONFileParserError.invalidFile(reason: "Invalid structure.")
      }
      self.json = json
    } catch let error as JSONFileParserError {
      throw error
    } catch let error {
      throw JSONFileParserError.invalidFile(reason: error.localizedDescription)
    }
  }
}
