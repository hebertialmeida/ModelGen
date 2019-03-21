//
//  YamlParserTest.swift
//  ModelGenTests
//
//  Created by Heberti Almeida on 2019-03-20.
//

import XCTest
@testable import ModelGenKit

class YamlParserTest: XCTestCase {

    private(set) var yaml: String!

    override func setUp() {
        yaml = """
        ---
        spec: ../Specs/
        output: ./Model/
        template: template.stencil
        language: swift # Only swift is supported right know
        """
    }

    func testParserInit() {
        XCTAssertNoThrow(try YamlParser.parse(yaml))
    }

    func testParserInvalidInit() {
        let invalidYaml = """
        \\
        spec: ../Specs/
        """

        XCTAssertThrowsError(try YamlParser.parse(invalidYaml), type: YamlParserError.invalidFile)
    }

    func testYamlParserSpec() {
        XCTAssertEqual(try YamlParser.parse(yaml)["spec"] as? String, "../Specs/")
    }

    func testYamlParserOutput() {
        XCTAssertEqual(try YamlParser.parse(yaml)["output"] as? String, "./Model/")
    }

    func testYamlParserTemplate() {
        XCTAssertEqual(try YamlParser.parse(yaml)["template"] as? String, "template.stencil")
    }

    func testYamlParserLanguage() {
        XCTAssertEqual(try YamlParser.parse(yaml)["language"] as? String, "swift")
    }
}
