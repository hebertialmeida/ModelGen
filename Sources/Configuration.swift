//
//  Configuration.swift
//  ModelGen
//
//  Created by Heberti Almeida on 2017-08-03.
//  Copyright © 2017 ModelGen. All rights reserved.
//

import Foundation

struct Configuration {
  let spec: String?
  let template: String?
  let language: String?
  let output: String?

  init?(dictionary: [String: Any]) {
    self.spec = dictionary["spec"] as? String
    self.template = dictionary["template"] as? String
    self.language = dictionary["language"] as? String
    self.output = dictionary["output"] as? String
  }
}
