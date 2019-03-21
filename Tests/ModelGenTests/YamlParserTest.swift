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
        let parsed = try? YamlParser.parse(yaml)
        XCTAssertNotNil(parsed)
    }

    func testYamlParserSpec() {
        let parsed = try? YamlParser.parse(yaml)
        XCTAssertEqual(parsed?["spec"] as? String, "../Specs/")
    }

    func testYamlParserOutput() {
        let parsed = try? YamlParser.parse(yaml)
        XCTAssertEqual(parsed?["output"] as? String, "./Model/")
    }

    func testYamlParserTemplate() {
        let parsed = try? YamlParser.parse(yaml)
        XCTAssertEqual(parsed?["template"] as? String, "template.stencil")
    }

    func testYamlParserLanguage() {
        let parsed = try? YamlParser.parse(yaml)
        XCTAssertEqual(parsed?["language"] as? String, "swift")
    }
}
