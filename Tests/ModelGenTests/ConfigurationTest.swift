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
        let config = Configuration(dictionary: dictionary)
        XCTAssertNotNil(config)
    }

    func testConfigurationSpec() {
        let config = Configuration(dictionary: dictionary)
        XCTAssertEqual(config?.spec, "../Specs/")
    }

    func testConfigurationOutput() {
        let config = Configuration(dictionary: dictionary)
        XCTAssertEqual(config?.output, "./Model/")
    }

    func testConfigurationTemplate() {
        let config = Configuration(dictionary: dictionary)
        XCTAssertEqual(config?.template, "template.stencil")
    }

    func testConfigurationLanguage() {
        let config = Configuration(dictionary: dictionary)
        XCTAssertEqual(config?.language, "swift")
    }
}
