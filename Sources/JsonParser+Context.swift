//
//  JsonParser+Context.swift
//  ModelGen
//
//  Created by Heberti Almeida on 2017-05-10.
//  Copyright © 2017 ModelGen. All rights reserved.
//

import Foundation

private let concreteRefTypeSuffix = "Concrete"

extension JsonParser {
	public func stencilContextFor(_ language: Language) throws -> JSON {
		try dicToArray()
		try mapProperties()
		try prepareContextFor(language)

		return [
			"spec": json,
			"nestedObjects": hasNestedObjects()
		]
	}

	// MARK: Prepare JSON to be used by template

	private func dicToArray() throws {
		guard let items = json["properties"] as? JSON else {
			throw JsonParserError.missingProperties
		}

		var properties = [JSON]()
		for (key, value) in items {
			guard let value = value as? JSON else {
				throw JsonParserError.missingProperties
			}
			var nValue = value
			nValue["name"] = key
			properties.append(nValue)
		}
		json["properties"] = properties
	}

	private func mapProperties() throws {
		guard let items = json["properties"] as? [JSON] else {
			throw JsonParserError.missingProperties
		}
		properties = try items.map { try SchemaProperty(dictionary: $0) }
	}

	private func prepareProperties(_ items: [JSON], language: Language) throws -> [JSON] {
		var elements = items
		for index in elements.indices {
			guard let name = elements[index]["name"] as? String else {
				throw JsonParserError.missingProperties
			}

			let property = properties[index]
			let type = try Schema.matchTypeFor(property, language: language)
			elements[index]["type"] = type
			elements[index]["name"] = property.name
			elements[index]["key"] = name

      let isArray: Bool = property.type == "array"
      let concreteRefType: String
      if isArray {
        let elementType = String(String(type.dropFirst()).dropLast())
        elements[index]["elementType"] = elementType
        elements[index]["concreteElementType"] = "\(elementType)\(concreteRefTypeSuffix)"
        concreteRefType = "[\(elementType)\(concreteRefTypeSuffix)]"
      } else {
        concreteRefType = property.ref == nil ? type : "\(type)\(concreteRefTypeSuffix)"
      }

      elements[index]["concreteRefType"] = concreteRefType
			elements[index]["jsonKey"] = property.jsonKey ?? name
			elements[index]["array"] = isArray
			elements[index]["nestedObject"] = hasNestedObjects(property)
			elements[index]["isOptional"] = property.isOptional
			elements[index]["isMutable"] = property.isMutable
			elements[index]["keyPath"] = name.contains(".")

			if let ref = property.ref {
				elements[index]["refType"] = Schema.matchRefType(ref)
			}
			if let ref = property.items?.ref {
				elements[index]["refType"] = Schema.matchRefType(ref)
			}
		}
		return elements
	}

	private func prepareContextFor(_ language: Language) throws {
		guard let items = json["properties"] as? [JSON] else {
			throw JsonParserError.missingProperties
		}
		let elements = try prepareProperties(items, language: language)
		json["concreteRefTypeSuffix"] = concreteRefTypeSuffix
		json["properties"] = elements
		json["customKeyProperties"] = customKeyProperties.map { $0.toJson() }
    json["nonCustomKeyProperties"] = nonCustomKeyProperties.map { $0.toJson() }
    json["nonOptionalProperties"] = nonOptionalProperties.map { $0.toJson() }
    json["optionalProperties"] = optionalProperties.map { $0.toJson() }
    json["immutableProperties"] = immutableProperties.map { $0.toJson() }
    json["mutableProperties"] = mutableProperties.map { $0.toJson() }
		json["modifiedProperties"] = elements.filter({
			guard let name = $0["name"] as? String, let key = $0["key"] as? String else {
				return false
			}
			return name != key
		})
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
