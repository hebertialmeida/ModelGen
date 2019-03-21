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
        let schema = decodeProperty(property)

        XCTAssertEqual(schema.type, "integer")
    }

    func testSchemaPropertyFormatURI() {
        let property = """
        {"type": "string", "format": "uri"}
        """
        let schema = decodeProperty(property)

        XCTAssertEqual(schema.type, "string")
        XCTAssertEqual(schema.format, "uri")
    }

    func testSchemaPropertyFormatDate() {
        let property = """
        {"type": "string", "format": "date"}
        """
        let schema = decodeProperty(property)

        XCTAssertEqual(schema.type, "string")
        XCTAssertEqual(schema.format, "date")
    }

    func testSchemaPropertyRef() {
        let property = """
        {"$ref": "post.json"}
        """
        let schema = decodeProperty(property)

        XCTAssertEqual(schema.ref, "post.json")
    }

    func testSchemaPropertyItems() {
        let property = """
        {
            "type": "array",
            "items": {"type": "integer"}
        }
        """
        let schema = decodeProperty(property)

        XCTAssertEqual(schema.type, "array")
        XCTAssertEqual(schema.items?.type, "integer")
    }

    func testSchemaPropertyAdditionalProperties() {
        let property = """
        {
            "type": "object",
            "additionalProperties": {"type": "integer"}
        }
        """
        let schema = decodeProperty(property)

        XCTAssertEqual(schema.type, "object")
        XCTAssertEqual(schema.additionalProperties?.type, "integer")
    }

    // MARK: Helpers

    func decodeProperty(_ string: String) -> SchemaProperty {
        let data = string.data(using: .utf8)!
        let json = try! JSONSerialization.jsonObject(with: data, options: []) as! JSON
        return try! SchemaProperty(from: json)
    }
}
