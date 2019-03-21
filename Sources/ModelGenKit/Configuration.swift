//
//  Configuration.swift
//  ModelGen
//
//  Created by Heberti Almeida on 2017-08-03.
//  Copyright © 2017 ModelGen. All rights reserved.
//

import Foundation

public struct Configuration {
    public let spec: String?
    public let template: String?
    public let language: String?
    public let output: String?

    public init?(dictionary: [String: Any]) {
        self.spec = dictionary["spec"] as? String
        self.template = dictionary["template"] as? String
        self.language = dictionary["language"] as? String
        self.output = dictionary["output"] as? String
    }
}
