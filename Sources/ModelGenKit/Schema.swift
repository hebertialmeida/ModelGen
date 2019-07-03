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
}

enum StringFormatType: String {
    case date // Date representation, as defined by RFC 3339, section 5.6.
    case uri  // A universal resource identifier (URI), according to RFC3986.
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
            return matchRefType(ref, language: language)
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

    static func matchRefType(_ ref: String, language: Language) -> String {
        let absolute = NSString(string: jsonAbsolutePath.description).appendingPathComponent(ref)
        let path = Path(absolute)
        let parser = JsonParser()
        do {
            try parser.parseFile(at: path)
        } catch let error {
            printError(error.localizedDescription, showFile: true)
        }

        guard let type = parser.json["title"] as? String else {
            return ""
        }
        
        return type.uppercaseFirst()
    }

    private static func matchTypeFor(_ format: StringFormatType, language: Language) -> String {
        switch format {
        case .uri:
            return typeFor(language, baseType: .uri)
        case .date:
            return typeFor(language, baseType: .date)
        }
    }

    private static func matchTypeFor(_ schemaType: SchemaType, property: SchemaProperty, language: Language) throws -> String {
        switch schemaType {
        case .object:
            guard let items = property.additionalProperties else {
                throw SchemaError.missingAdditionalProperties
            }
            return String(format: typeFor(language, baseType: .dictionary), try matchTypeFor(items, language: language))
        case .array:
            guard let items = property.items else {
                throw SchemaError.missingItems
            }
            return String(format: typeFor(language, baseType: .array), try matchTypeFor(items, language: language))
        case .string:
            guard let format = property.format, let stringFormat = StringFormatType(rawValue: format) else {
                return typeFor(language, baseType: .string)
            }
            return matchTypeFor(stringFormat, language: language)
        case .integer:
            return typeFor(language, baseType: .integer)
        case .number:
            return typeFor(language, baseType: .float)
        case .boolean:
            return typeFor(language, baseType: .boolean)
        }
    }

    private static func typeFor(_ language: Language, baseType: BaseType) -> String {
        switch language {
        case .swift:
            return SwiftType.match(baseType: baseType).rawValue
        case .objc:
            return ObjcType.match(baseType: baseType).rawValue
        case .kotlin:
            return KotlinType.match(baseType: baseType).rawValue
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
        let absolute = NSString(string: jsonAbsolutePath.description).appendingPathComponent(ref)
        let path = Path(absolute)
        let parser = JsonParser()
        do {
            try parser.parseFile(at: path)
        } catch let error {
            printError(error.localizedDescription, showFile: true)
        }
        
        switch language {
        case .swift:
            return []
        case .objc:
            return []
        case .kotlin:
            guard let type = parser.json["title"] as? String else {
                return []
            }
            guard let package = parser.json["package"] as? String else {
                throw SchemaError.missingPackageForType(type: ref)
            }
            return ["\(package).\(type.uppercaseFirst())"]
        }
    }
    
    private static func matchPackageTypeFor(_ format: StringFormatType, language: Language) -> [String] {
        switch format {
        case .uri:
            return packageTypeFor(language, baseType: .uri)
        case .date:
            return packageTypeFor(language, baseType: .date)
        }
    }
    
    private static func matchPackageTypeFor(_ schemaType: SchemaType, property: SchemaProperty, language: Language) throws -> [String] {
        switch schemaType {
        case .object:
            guard let items = property.additionalProperties else {
                throw SchemaError.missingAdditionalProperties
            }
            return try matchPackageTypeFor(items, language: language) + packageTypeFor(language, baseType: .dictionary)
            
        case .array:
            guard let items = property.items else {
                throw SchemaError.missingItems
            }
            return try matchPackageTypeFor(items, language: language) + packageTypeFor(language, baseType: .array)

        case .string:
            guard let format = property.format, let stringFormat = StringFormatType(rawValue: format) else {
                return packageTypeFor(language, baseType: .string)
            }
            return matchPackageTypeFor(stringFormat, language: language)
        case .integer:
            return packageTypeFor(language, baseType: .integer)
        case .number:
            return packageTypeFor(language, baseType: .float)
        case .boolean:
            return packageTypeFor(language, baseType: .boolean)
        }
    }
    
    private static func packageTypeFor(_ language: Language, baseType: BaseType) -> [String] {
        switch language {
        case .swift:
            return SwiftType.package(baseType: baseType)
        case .objc:
            return ObjcType.package(baseType: baseType)
        case .kotlin:
            return KotlinType.package(baseType: baseType)
        }
    }
}
