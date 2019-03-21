//
//  ErrorTests.swift
//  ModelGenTests
//
//  Created by Heberti Almeida on 2019-03-21.
//

import XCTest
import PathKit
@testable import ModelGenKit

class ErrorTests: XCTestCase {

    // MARK: JSON Parser Errors

    func testJsonParserErrorInvalidFile() {
        XCTAssertEqual(JsonParserError.invalidFile(reason: "Some reason").errorDescription, "Unable to parse file. Some reason")
    }

    func testJsonParserErrorMissingProperties() {
        XCTAssertEqual(JsonParserError.missingProperties.errorDescription, "Missing property \"properties\" on json file")
    }

    func testJsonParserErrorMissingTitle() {
        XCTAssertEqual(JsonParserError.missingTitle.errorDescription, "Missing property \"title\" on json file")
    }

    // MARK: YAML Parser Errors

    func testYamlParserErrorInvalidFile() {
        XCTAssertEqual(YamlParserError.invalidFile.errorDescription, "Unable to parse .yml file")
    }

    func testJsonParserErrorMissingSpecPath() {
        XCTAssertEqual(YamlParserError.missingSpecPath.errorDescription, "You must provide the spec folder or file")
    }

    func testJsonParserErrorMissingTemplate() {
        XCTAssertEqual(YamlParserError.missingTemplate.errorDescription, "You must provide a Stencil template")
    }

    // MARK: Schema Errors

    func testSchemaErrorMissingAdditionalProperties() {
        XCTAssertEqual(SchemaError.missingAdditionalProperties.errorDescription, "Missing \"additionalProperties\" for \"object\" type")
    }

    func testSchemaErrorMissingItems() {
        XCTAssertEqual(SchemaError.missingItems.errorDescription, "Missing property \"items\" for \"array\" type")
    }

    func testSchemaErrorMissingType() {
        XCTAssertEqual(SchemaError.missingType.errorDescription, "Missing type for object")
    }

    func testSchemaErrorInvalidSchemaType() {
        XCTAssertEqual(SchemaError.invalidSchemaType(type: "weidType").errorDescription, "Invalid type: \"weidType\"")
    }

    // MARK: Template Errors

    func testTemplateErrorTemplatePathNotFound() {
        XCTAssertEqual(TemplateError.templatePathNotFound(path: Path("/my-path")).errorDescription, "Template not found at path /my-path.")
    }

    func testTemplateErrorNoTemplateProvided() {
        XCTAssertEqual(TemplateError.noTemplateProvided.errorDescription, "Template not provided. E.g. '-t /path/template.stencil' or '--template /path/template.stencil'")
    }

    // MARK: Ansi

    func testAnsiDescription() {
        XCTAssertEqual(ANSI.black.description, "\u{001B}[30m")
    }

}
