//
//  SchemaTests.swift
//  ModelGenTests
//
//  Created by Heberti Almeida on 2019-03-20.
//

import XCTest
@testable import ModelGenKit

class SchemaTests: XCTestCase {

    func testSchemaPropertyType() {
        let property = """
        {"type": "integer"}
        """

        XCTAssertEqual(try decode(property).type, "integer")
    }

    func testSchemaPropertyFormatURI() {
        let property = """
        {"type": "string", "format": "uri"}
        """

        XCTAssertEqual(try decode(property).type, "string")
        XCTAssertEqual(try decode(property).format, "uri")
    }

    func testSchemaPropertyFormatDate() {
        let property = """
        {"type": "string", "format": "date"}
        """

        XCTAssertEqual(try decode(property).type, "string")
        XCTAssertEqual(try decode(property).format, "date")
    }

    func testSchemaPropertyRef() {
        let property = """
        {"$ref": "post.json"}
        """

        XCTAssertEqual(try decode(property).ref, "post.json")
    }

    func testSchemaPropertyItems() {
        let property = """
        {
            "type": "array",
            "items": {"type": "integer"}
        }
        """

        XCTAssertEqual(try decode(property).type, "array")
        XCTAssertEqual(try decode(property).items?.type, "integer")
    }

    func testSchemaPropertyAdditionalProperties() {
        let property = """
        {
            "type": "object",
            "additionalProperties": {"type": "integer"}
        }
        """

        XCTAssertEqual(try decode(property).type, "object")
        XCTAssertEqual(try decode(property).additionalProperties?.type, "integer")
    }

    // MARK: Helpers

    func decode(_ string: String) throws -> SchemaProperty {
        let data = string.data(using: .utf8)!
        let json = try JSONSerialization.jsonObject(with: data, options: []) as! JSON
        return try SchemaProperty(from: json)
    }
}
