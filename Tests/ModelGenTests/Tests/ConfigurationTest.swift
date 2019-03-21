//
//  ConfigurationTest.swift
//  ModelGenTests
//
//  Created by Heberti Almeida on 2019-03-20.
//

import XCTest
@testable import ModelGenKit

class ConfigurationTest: XCTestCase {

    private(set) var dictionary: [String: Any]!

    override func setUp() {
        dictionary = [
            "spec": "../Specs/",
            "output": "./Model/",
            "template": "template.stencil",
            "language": "swift"
        ]
    }

    func testInitConfiguration() {
        XCTAssertNoThrow(try Configuration(from: dictionary))
    }

    func testInitInvalidConfiguration() {
        let invalidDictionary = ["spec": 1]

        XCTAssertThrowsError(try Configuration(from: invalidDictionary))
    }

    func testConfigurationSpec() {
        XCTAssertEqual(try Configuration(from: dictionary).spec, "../Specs/")
    }

    func testConfigurationOutput() {
        XCTAssertEqual(try Configuration(from: dictionary).output, "./Model/")
    }

    func testConfigurationTemplate() {
        XCTAssertEqual(try Configuration(from: dictionary).template, "template.stencil")
    }

    func testConfigurationLanguage() {
        XCTAssertEqual(try Configuration(from: dictionary).language, "swift")
    }
}
