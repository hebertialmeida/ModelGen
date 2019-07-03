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

    private var languageType: LanguageType.Type {
        switch self {
        case .swift:
            return SwiftType.self
        case .objc:
            return ObjcType.self
        case .kotlin:
            return KotlinType.self
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
}

// MARK: LanguageType

protocol LanguageType: AnyObject {
    static var fileExtension: String { get }
    static func match(baseType: BaseType) -> String
    static func package(baseType: BaseType) -> [String]
}

extension LanguageType {
    static func package(baseType: BaseType) -> [String] {
        return []
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

