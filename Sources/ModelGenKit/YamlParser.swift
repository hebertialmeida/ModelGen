//
//  YamlParser.swift
//  ModelGen
//
//  Created by Heberti Almeida on 2017-08-03.
//  Copyright © 2017 ModelGen. All rights reserved.
//

import Foundation
import Yams

public struct YamlParser {
    public static func parse(_ yaml: String) throws -> [String: Any] {
        guard
            let load = try? Yams.load(yaml: yaml, .default, Constructor.default),
            let dic = load as? [String: Any]
        else {
            throw YamlParserError.invalidFile
        }

        return dic
    }
}
