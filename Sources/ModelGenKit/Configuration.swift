//
//  Configuration.swift
//  ModelGen
//
//  Created by Heberti Almeida on 2017-08-03.
//  Copyright © 2017 ModelGen. All rights reserved.
//

import Foundation

public struct Configuration: Codable {
    public let spec: String?
    public let template: String?
    public let language: String?
    public let output: String?
}
