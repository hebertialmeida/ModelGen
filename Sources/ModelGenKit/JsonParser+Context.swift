//
//  JsonParser+Context.swift
//  ModelGen
//
//  Created by Heberti Almeida on 2017-05-10.
//  Copyright © 2017 ModelGen. All rights reserved.
//

import Foundation

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

        for (key, value) in items.sorted(by: { $0.key < $1.key }) {
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

        properties = try items.map { try SchemaProperty(from: $0) }
    }

    private func prepareContextFor(_ language: Language) throws {
        guard let items = json["properties"] as? [JSON] else {
            throw JsonParserError.missingProperties
        }

        var required = [String]()

        if let requiredItems = json["required"] as? [String] {
            required = requiredItems
        }

        var imports: [String] = []
        var elements = items
        for index in elements.indices {
            guard let name = elements[index]["name"] as? String else {
                throw JsonParserError.missingProperties
            }

            let property = properties[index]
            elements[index]["type"] = try Schema.matchTypeFor(property, language: language)
            elements[index]["name"] = standardName(name)
            elements[index]["key"] = name
            elements[index]["array"] = property.type == "array"
            elements[index]["nestedObject"] = hasNestedObjects(property)
            elements[index]["required"] = required.contains(name)
            elements[index]["keyPath"] = name.contains(".")
            elements[index]["primitiveType"] = try Schema.isPrimitiveTypeFor(property, language: language)

            imports.append(contentsOf: try Schema.matchPackageTypeFor(property, language: language))

            if let ref = property.ref {
                elements[index]["refType"] = try Schema.matchRefType(ref, language: language)
            }
            if let ref = property.items?.ref {
                elements[index]["refType"] = try Schema.matchRefType(ref, language: language)
            }
        }
        json["properties"] = elements
        json["imports"] = imports.removeDuplicates().sorted(by: { $0 < $1 })
        json["modifiedProperties"] = elements.filter({
            guard let name = $0["name"] as? String, let key = $0["key"] as? String else {
                return false
            }
            return name != key
        })
    }

    private func standardName(_ name: String) -> String {
        let splitedName = name.components(separatedBy: ".")
        guard splitedName.count > 0, let last = splitedName.last else {
            return fixVariableName(name)
        }
        return fixVariableName(last)
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
