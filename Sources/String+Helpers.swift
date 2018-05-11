//
//  String+Helpers.swift
//  ModelGen
//
//  Created by Heberti Almeida on 2017-05-15.
//  Copyright © 2017 ModelGen. All rights reserved.
//

import Foundation

// Extension for string to provide helper method to generate names.
extension String {

  /// Fetches the first character of the string.
  var first: String {
    return String(prefix(1))
  }

  /**
   Makes the first character upper case.
   */

  /// Makes the first character upper case.
  ///
  /// - Returns: String with the first character upper case.
  @discardableResult func uppercaseFirst() -> String {
    return first.uppercased() + String(dropFirst())
  }

  /// Makes the first character lowercase.
  ///
  /// - Returns: String with the first character lowercase.
  @discardableResult func lowerCaseFirst() -> String {
    return first.lowercased() + String(dropFirst())
  }

  /// Replaces occurrence of multiple strings with a single string.
  ///
  /// - Parameters:
  ///   - strings: String to replace.
  ///   - replacementString: String to replace with.
  mutating func replaceOccurrencesOfStringsWithString(_ strings: [String], _ replacementString: String) {
    for string in strings {
      self = replacingOccurrences(of: string, with: replacementString)
    }
  }

  /// Removes whitespace and newline at the ends.
  mutating func trim() {
    self = trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
  }

  /// Appends an optional to the string.
  ///
  /// - Parameter prefix: String to append.
  mutating func appendPrefix(_ prefix: String?) {
    if let prefix = prefix {
      self = prefix + self
    }
  }
}
