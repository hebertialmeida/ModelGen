//
//  LanguageType.swift
//  ModelGen
//
//  Created by Heberti Almeida on 2017-05-17.
//  Copyright © 2017 ModelGen. All rights reserved.
//

import Foundation

enum BaseType: Int {
    case dictionary
    case array
    case string
    case integer
    case float
    case boolean
    case uri
    case date
}

public enum Language: String {
    case swift
    case objc
    case kotlin
    case java

    private var languageType: LanguageType.Type {
        switch self {
        case .swift:
            return SwiftType.self
        case .objc:
            return ObjcType.self
        case .kotlin:
            return KotlinType.self
        case .java:
            return JavaType.self
        }
    }

    var fileExtension: String {
        return languageType.fileExtension
    }

    func typeFor(baseType: BaseType) -> String {
        return languageType.match(baseType: baseType)
    }

    func packageFor(baseType: BaseType) -> [String] {
        return languageType.package(baseType: baseType)
    }

    func isPrimitiveTypeFor(baseType: BaseType) -> Bool {
        return languageType.isPrimitiveTypeFor(baseType: baseType)
    }
}

// MARK: LanguageType

protocol LanguageType: AnyObject {
    static var fileExtension: String { get }
    static func match(baseType: BaseType) -> String
    static func package(baseType: BaseType) -> [String]
    static func isPrimitiveTypeFor(baseType: BaseType) -> Bool
}

extension LanguageType {
    static func package(baseType: BaseType) -> [String] {
        return []
    }

    static func isPrimitiveTypeFor(baseType: BaseType) -> Bool {
        return false
    }
}

// MARK: Language Support

final class SwiftType: LanguageType {

    static var fileExtension: String { return ".swift" }

    static func match(baseType: BaseType) -> String {
        switch baseType {
        case .dictionary: return "[AnyHashable: %@]"
        case .array:
            return "[%@]"
        case .string:
            return "String"
        case .integer:
            return "Int"
        case .float:
            return "Float"
        case .boolean:
            return "Bool"
        case .uri:
            return "URL"
        case .date:
            return "Date"
        }
    }
}

final class ObjcType: LanguageType {

    static var fileExtension: String { return ".m" }

    static func match(baseType: BaseType) -> String {
        switch baseType {
        case .dictionary:
            return "NSDictionary<NSString *, %@>"
        case .array:
            return "NSArray<%@> *"
        case .string:
            return "NSString *"
        case .integer:
            return "NSNumber *"
        case .float:
            return "double"
        case .boolean:
            return "BOOL"
        case .uri:
            return "NSURL *"
        case .date:
            return "NSDate *"
        }
    }

    static func isPrimitiveTypeFor(baseType: BaseType) -> Bool {
        switch baseType {
        case .dictionary:
            return false
        case .array:
            return false
        case .string:
            return false
        case .integer:
            return false
        case .float:
            return true
        case .boolean:
            return true
        case .uri:
            return false
        case .date:
            return false
        }
    }
}

final class KotlinType: LanguageType {

    static var fileExtension: String { return ".kt" }

    static func match(baseType: BaseType) -> String {
        switch baseType {
        case .dictionary:
            return "HashMap<String, %@>"
        case .array:
            return "ArrayList<%@>"
        case .string:
            return "String"
        case .integer:
            return "Int"
        case .float:
            return "Float"
        case .boolean:
            return "Boolean"
        case .uri:
            return "Uri"
        case .date:
            return "Date"
        }
    }

    static func package(baseType: BaseType) -> [String] {
        switch baseType {
        case .dictionary:
            return []
        case .array:
            return []
        case .string:
            return []
        case .integer:
            return []
        case .float:
            return []
        case .boolean:
            return []
        case .uri:
            return ["android.net.Uri"]
        case .date:
            return ["java.util.Date"]
        }
    }
}

final class JavaType: LanguageType {

    static var fileExtension: String { return ".java" }

    static func match(baseType: BaseType) -> String {
        switch baseType {
        case .dictionary:
            return "HashMap<String, %@>"
        case .array:
            return "ArrayList<%@>"
        case .string:
            return "String"
        case .integer:
            return "int"
        case .float:
            return "float"
        case .boolean:
            return "boolean"
        case .uri:
            return "Uri"
        case .date:
            return "Date"
        }
    }

    static func package(baseType: BaseType) -> [String] {
        switch baseType {
        case .dictionary:
            return ["java.util.HashMap"]
        case .array:
            return ["java.util.ArrayList"]
        case .string:
            return []
        case .integer:
            return []
        case .float:
            return []
        case .boolean:
            return []
        case .uri:
            return ["android.net.Uri"]
        case .date:
            return ["java.util.Date"]
        }
    }

    static func isPrimitiveTypeFor(baseType: BaseType) -> Bool {
        switch baseType {
        case .dictionary:
            return false
        case .array:
            return false
        case .string:
            return false
        case .integer:
            return true
        case .float:
            return true
        case .boolean:
            return true
        case .uri:
            return false
        case .date:
            return false
        }
    }
}
