//
//  Filters.swift
//  ModelGen
//
//  Created by Heberti Almeida on 2017-05-15.
//  Copyright © 2017 ModelGen. All rights reserved.
//

import Foundation

/// Convert string to TitleCase
///
/// - Parameter string: Input string
/// - Returns: Transformed string
func titlecase(_ string: String) -> String {
  guard let first = string.unicodeScalars.first else { return string }
  return String(first).uppercased() + String(string.unicodeScalars.dropFirst())
}

/// Generates/fixes a variable name in sentence case with the first letter as lowercase.
/// Replaces invalid names and swift keywords.
/// Ensures all caps are maintained if previously set in the name.
///
/// - Parameter variableName: Name of the variable in the JSON.
/// - Returns: A generated string representation of the variable name.
func fixVariableName(_ variableName: String) -> String {
  var name = replaceKeywords(variableName)
  name.replaceOccurrencesOfStringsWithString(["-", "_"], " ")
  name.trim()

  var finalVariableName = ""
  for (index, var element) in name.components(separatedBy: " ").enumerated() {
    element = index == 0 ? element.lowerCaseFirst() : element.uppercaseFirst()
    finalVariableName.append(element)
  }
  return finalVariableName
}

/// Cross checks the current name against a possible set of keywords, this list is no where
/// extensive, but it is not meant to be, user should be able to do this in the unlikely
/// case it happens.
///
/// - Parameter currentName: The current name which has to be checked.
/// - Returns: New name for the variable.
func replaceKeywords(_ currentName: String) -> String {
  let keywordsWithReplacements = [
    "class": "classProperty",
    "struct": "structProperty",
    "enum": "enumProperty",
    "internal": "internalProperty",
    "default": "defaultValue"]
  if let value = keywordsWithReplacements[currentName] {
    return value
  }
  return currentName
}
