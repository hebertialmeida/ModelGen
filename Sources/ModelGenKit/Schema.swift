//
//  Schema.swift
//  ModelGen
//
//  Created by Heberti Almeida on 2017-05-15.
//  Copyright © 2017 ModelGen. All rights reserved.
//

import Foundation
import PathKit

// MARK: Schema Types

enum SchemaType: String {
    case object
    case array
    case string
    case integer
    case number
    case boolean
    case binary
}

enum StringFormatType: String {
    case date // Date representation, as defined by RFC 3339, section 5.6.
    case uri  // A universal resource identifier (URI), according to RFC3986.

    var asBaseType: BaseType {
        switch self {
        case .date: return .date
        case .uri: return .uri
        }
    }
}

// MARK: Schema

public class SchemaProperty: Codable {
    let type: String?
    let description: String?
    let format: String?
    let ref: String?
    let items: SchemaProperty?
    let additionalProperties: SchemaProperty?

    private enum CodingKeys: String, CodingKey {
        case type
        case description
        case format
        case ref = "$ref"
        case items
        case additionalProperties
    }
}

struct Schema {
    static func matchTypeFor(_ property: SchemaProperty, language: Language) throws -> String {
        // Match reference
        if let ref = property.ref {
            return try matchRefType(ref, language: language)
        }

        // Match type
        guard let type = property.type else {
            throw SchemaError.missingType
        }

        guard let schemaType = SchemaType(rawValue: type) else {
            throw SchemaError.invalidSchemaType(type: type)
        }

        return try matchTypeFor(schemaType, property: property, language: language)
    }

    static func matchRefType(_ ref: String, language: Language) throws -> String {
        let absolute = NSString(string: jsonAbsolutePath.description).appendingPathComponent(ref)
        let path = Path(absolute)
        let parser = JsonParser()
        try parser.parseFile(at: path)

        guard let type = parser.json["title"] as? String else {
            throw JsonParserError.missingTitle
        }

        return type.uppercaseFirst()
    }

    private static func matchTypeFor(_ schemaType: SchemaType, property: SchemaProperty, language: Language) throws -> String {
        switch schemaType {
        case .object:
            guard let items = property.additionalProperties else {
                throw SchemaError.missingAdditionalProperties
            }
            return String(format: language.typeFor(baseType: .dictionary), try matchTypeFor(items, language: language))
        case .array:
            guard let items = property.items else {
                throw SchemaError.missingItems
            }
            return String(format: language.typeFor(baseType: .array), try matchTypeFor(items, language: language))
        case .string:
            guard let format = property.format, let stringFormat = StringFormatType(rawValue: format) else {
                return language.typeFor(baseType: .string)
            }
            return language.typeFor(baseType: stringFormat.asBaseType)
        case .integer:
            return language.typeFor(baseType: .integer)
        case .number:
            return language.typeFor(baseType: .float)
        case .boolean:
            return language.typeFor(baseType: .boolean)
        case .binary:
            return language.typeFor(baseType: .binary)
        }
    }

    static func matchPackageTypeFor(_ property: SchemaProperty, language: Language) throws -> [String] {
        // Match reference
        if let ref = property.ref {
            return try matchPackageRef(ref, language: language)
        }

        // Match type
        guard let type = property.type else {
            throw SchemaError.missingType
        }

        guard let schemaType = SchemaType(rawValue: type) else {
            throw SchemaError.invalidSchemaType(type: type)
        }

        return try matchPackageTypeFor(schemaType, property: property, language: language)
    }

    private static func matchPackageRef(_ ref: String, language: Language) throws -> [String] {
        guard language == .kotlin || language == .java else {
            return []
        }

        let absolute = NSString(string: jsonAbsolutePath.description).appendingPathComponent(ref)
        let path = Path(absolute)
        let parser = JsonParser()
        try parser.parseFile(at: path)

        guard let type = parser.json["title"] as? String else {
            throw JsonParserError.missingTitle
        }

        guard let package = parser.json["package"] as? String else {
            throw SchemaError.missingPackageForType(type: ref)
        }

        return ["\(package).\(type.uppercaseFirst())"]
    }

    private static func matchPackageTypeFor(_ schemaType: SchemaType, property: SchemaProperty, language: Language) throws -> [String] {
        switch schemaType {
        case .object:
            guard let items = property.additionalProperties else {
                throw SchemaError.missingAdditionalProperties
            }
            return try matchPackageTypeFor(items, language: language) + language.packageFor(baseType: .dictionary)
        case .array:
            guard let items = property.items else {
                throw SchemaError.missingItems
            }
            return try matchPackageTypeFor(items, language: language) + language.packageFor(baseType: .array)
        case .string:
            guard let format = property.format, let stringFormat = StringFormatType(rawValue: format) else {
                return language.packageFor(baseType: .string)
            }
            return language.packageFor(baseType: stringFormat.asBaseType)
        case .integer:
            return language.packageFor(baseType: .integer)
        case .number:
            return language.packageFor(baseType: .float)
        case .boolean:
            return language.packageFor(baseType: .boolean)
        case .binary:
            return language.packageFor(baseType: .binary)
        }
    }

    static func isPrimitiveTypeFor(_ property: SchemaProperty, language: Language) throws -> Bool {
        // Match reference
        if property.ref != nil {
            return false
        }

        // Match type
        guard let type = property.type else {
            throw SchemaError.missingType
        }

        guard let schemaType = SchemaType(rawValue: type) else {
            throw SchemaError.invalidSchemaType(type: type)
        }

        return try isPrimitiveTypeFor(schemaType, property: property, language: language)
    }

    private static func isPrimitiveTypeFor(_ schemaType: SchemaType, property: SchemaProperty, language: Language) throws -> Bool {
        switch schemaType {
        case .object:
            return language.isPrimitiveTypeFor(baseType: .dictionary)
        case .array:
            return language.isPrimitiveTypeFor(baseType: .array)
        case .string:
            guard let format = property.format, let stringFormat = StringFormatType(rawValue: format) else {
                return language.isPrimitiveTypeFor(baseType: .string)
            }
            return language.isPrimitiveTypeFor(baseType: stringFormat.asBaseType)
        case .integer:
            return language.isPrimitiveTypeFor(baseType: .integer)
        case .number:
            return language.isPrimitiveTypeFor(baseType: .float)
        case .boolean:
            return language.isPrimitiveTypeFor(baseType: .boolean)
        case .binary:
            return language.isPrimitiveTypeFor(baseType: .binary)
        }
    }
}
