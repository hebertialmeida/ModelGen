//
//  JSONContext.swift
//  ModelGen
//
//  Created by Heberti Almeida on 2017-05-10.
//  Copyright © 2017 ModelGen. All rights reserved.
//

import Foundation

extension JSONFileParser {
  public func stencilContext() throws -> JSON {
    try dicToArray()
    try mapProperties()
    try prepareContext()

    return [
      "spec": json,
      "nestedObjects": hasNestedObjects()
    ]
  }

  // MARK: Prepare JSON to be used by template

  private func dicToArray() throws {
    guard let items = json["properties"] as? JSON else {
      throw JSONFileParserError.missingProperties
    }

    var properties = [JSON]()
    for (key, value) in items {
      guard let value = value as? JSON else {
        throw JSONFileParserError.missingProperties
      }
      var nValue = value
      nValue["name"] = key
      properties.append(nValue)
    }
    json["properties"] = properties
  }

  private func mapProperties() throws {
    guard let items = json["properties"] as? [JSON] else {
      throw JSONFileParserError.missingProperties
    }
    properties = try items.map { try SchemaProperty(dictionary: $0) }
  }

  private func prepareContext() throws {
    guard let items = json["properties"] as? [JSON] else {
      throw JSONFileParserError.missingProperties
    }

    var required = [String]()

    if let requiredItems = json["required"] as? [String] {
      required = requiredItems
    }

    var elements = items
    for index in elements.indices {
      guard let name = elements[index]["name"] as? String else {
        throw JSONFileParserError.missingProperties
      }

      let property = properties[index]
      elements[index]["type"] = try Schema.matchTypeFor(property, language: .swift)
      elements[index]["name"] = fixVariableName(name)
      elements[index]["key"] = name
      elements[index]["required"] = required.contains(name)
      elements[index]["array"] = property.type == "array"
      elements[index]["nestedObject"] = hasNestedObjects(property)
    }
    json["properties"] = elements
  }

  // MARK: Recursively check for nested objects

  private func hasNestedObjects() -> Bool {
    var references = 0
    for property in properties {
      if hasNestedObjects(property) {
        references += 1
      }
    }
    return references > 0
  }

  private func hasNestedObjects(_ property: SchemaProperty) -> Bool {
    if property.ref != nil {
      return true
    }
    if let items = property.items {
      return items.ref != nil ? true : hasNestedObjects(items)
    }
    if let additionalProperties = property.additionalProperties {
      return additionalProperties.ref != nil ? true : hasNestedObjects(additionalProperties)
    }
    return false
  }
}
