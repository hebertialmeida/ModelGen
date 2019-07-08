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
    case set
    case string
    case integer
    case number
    case boolean
    case binary
}

extension SchemaType {
    var asBaseType: BaseType {
        switch self {
        case .object:
            return .dictionary
        case .array:
            return .array
        case .set:
            return .set
        case .string:
            return .string
        case .integer:
            return .integer
        case .number:
            return .float
        case .boolean:
            return .boolean
        case .binary:
            return .binary
        }
    }
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
            return String(format: language.typeFor(baseType: schemaType.asBaseType), try matchTypeFor(items, language: language))
        case .array, .set:
            guard let items = property.items else {
                throw SchemaError.missingItems
            }
            return String(format: language.typeFor(baseType: schemaType.asBaseType), try matchTypeFor(items, language: language))
        case .string:
            guard let format = property.format, let stringFormat = StringFormatType(rawValue: format) else {
                return language.typeFor(baseType: schemaType.asBaseType)
            }
            return language.typeFor(baseType: stringFormat.asBaseType)
        case .integer, .number, .boolean, .binary:
            return language.typeFor(baseType: schemaType.asBaseType)
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
            return try matchPackageTypeFor(items, language: language) + language.packageFor(baseType: schemaType.asBaseType)
        case .array, .set:
            guard let items = property.items else {
                throw SchemaError.missingItems
            }
            return try matchPackageTypeFor(items, language: language) + language.packageFor(baseType: schemaType.asBaseType)
        case .string:
            guard let format = property.format, let stringFormat = StringFormatType(rawValue: format) else {
                return language.packageFor(baseType: schemaType.asBaseType)
            }
            return language.packageFor(baseType: stringFormat.asBaseType)
        case .integer, .number, .boolean, .binary:
            return language.packageFor(baseType: schemaType.asBaseType)
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
        case .object, .array, .set, .integer, .number, .boolean, .binary:
            return language.isPrimitiveTypeFor(baseType: schemaType.asBaseType)
        case .string:
            guard let format = property.format, let stringFormat = StringFormatType(rawValue: format) else {
                return language.isPrimitiveTypeFor(baseType: schemaType.asBaseType)
            }
            return language.isPrimitiveTypeFor(baseType: stringFormat.asBaseType)
        }
    }
}
