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
    private(set) var parsed: [String: Any]!

    override func setUp() {
        yaml = """
        ---
        spec: ../Specs/
        output: ./Model/
        template: template.stencil
        language: swift # Only swift is supported right know
        """

        parsed = try! YamlParser.parse(yaml)
    }

    func testYamlParserSpec() {
        XCTAssertEqual(parsed["spec"] as? String, "../Specs/")
    }

    func testYamlParserOutput() {
        XCTAssertEqual(parsed["output"] as? String, "./Model/")
    }

    func testYamlParserTemplate() {
        XCTAssertEqual(parsed["template"] as? String, "template.stencil")
    }

    func testYamlParserLanguage() {
        XCTAssertEqual(parsed["language"] as? String, "swift")
    }
}
