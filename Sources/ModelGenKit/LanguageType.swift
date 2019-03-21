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

    var fileExtension: String {
        switch self {
        case .swift:
            return ".swift"
        case .objc:
            return ".m"
        }
    }
}

protocol LanguageType {
    associatedtype OutType
    static func match(baseType: BaseType) -> OutType
}

enum SwiftType: String, LanguageType {
    case dictionary = "[String: %@]"
    case array = "[%@]"
    case string = "String"
    case integer = "Int"
    case float = "Float"
    case boolean = "Bool"
    case uri = "URL"
    case date = "Date"

    static func match(baseType: BaseType) -> SwiftType {
        switch baseType {
        case .dictionary:
            return .dictionary
        case .array:
            return .array
        case .string:
            return .string
        case .integer:
            return .integer
        case .float:
            return .float
        case .boolean:
            return .boolean
        case .uri:
            return .uri
        case .date:
            return .date
        }
    }
}

enum ObjcType: String, LanguageType {
    case dictionary = "NSDictionary<NSString *, %@>"
    case array = "NSArray<%@> *"
    case string = "NSString *"
    case integer = "NSNumber *"
    case float = "double"
    case boolean = "BOOL"
    case uri = "NSURL *"
    case date = "NSDate *"

    static func match(baseType: BaseType) -> ObjcType {
        switch baseType {
        case .dictionary:
            return .dictionary
        case .array:
            return .array
        case .string:
            return .string
        case .integer:
            return .integer
        case .float:
            return .float
        case .boolean:
            return .boolean
        case .uri:
            return .uri
        case .date:
            return .date
        }
    }
}
