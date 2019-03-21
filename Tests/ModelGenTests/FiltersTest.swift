//
//  FiltersTest.swift
//  ModelGenTests
//
//  Created by Heberti Almeida on 2019-03-20.
//

import XCTest
@testable import ModelGenKit

class FiltersTest: XCTestCase {

    func testFilterTitleCase() {
        let filter = titlecase("titlecase")
        XCTAssertEqual(filter, "Titlecase")
    }

    func testFixVariableNameUnderline() {
        let filter = fixVariableName("property_name")
        XCTAssertEqual(filter, "propertyName")
    }

    func testFixVariableNameDash() {
        let filter = fixVariableName("property-name")
        XCTAssertEqual(filter, "propertyName")
    }

    func testReplacesKeywordClass() {
        let filter = replaceKeywords("class")
        XCTAssertEqual(filter, "classProperty")
    }

    func testReplacesKeywordStruct() {
        let filter = replaceKeywords("struct")
        XCTAssertEqual(filter, "structProperty")
    }

    func testReplacesKeywordEnum() {
        let filter = replaceKeywords("enum")
        XCTAssertEqual(filter, "enumProperty")
    }

    func testReplacesKeywordInternal() {
        let filter = replaceKeywords("internal")
        XCTAssertEqual(filter, "internalProperty")
    }

    func testReplacesKeywordDefault() {
        let filter = replaceKeywords("default")
        XCTAssertEqual(filter, "defaultValue")
    }
}
