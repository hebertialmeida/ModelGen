//
//  BaseModel.swift
//  ModelGen
//
//  Created by Heberti Almeida on 2017-08-04.
//  Copyright © 2017 ModelGen. All rights reserved.
//

import RocketData
import Unbox
import Wrap

/// This is the base model protocol for Model objects.
public protocol BaseModel: Model, Unboxable, WrapCustomizable {
    
    /// Mapping between client and server property. keys are client names and values are JSON names eg: "authorId: "author_id"
    static var propertyMapping: [String: String]? { get }
}

extension BaseModel {

    /// Default description of a Model
    public var description: String { return String(describing: self) }

    /// Default property mapping is nil (I'd do an optional get-only var protocol requirement but the language doesn't allow it)
    public static var propertyMapping: [String: String]? { return nil }

    // MARK: Raw Representable

    public var rawValue: [String: Any] {
        return wrap(context: self, dateFormatter: Date.serverDateFormatter()) as! [String: Any]
    }

    public init(rawValue: [String: Any]) throws {
        self = try unbox(dictionary: rawValue)
    }

    // MARK: Wrap Customizable
    
    public func keyForWrapping(propertyName: String) -> String? {
        return Self.propertyMapping?[propertyName] ?? propertyName
    }
}
