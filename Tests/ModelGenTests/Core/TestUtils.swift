//
//  TestUtils.swift
//  CYaml
//
//  Created by Heberti Almeida on 2019-03-21.
//

import XCTest

func XCTAssertThrowsError<T>(_ expression: @autoclosure () throws -> T, type expectedError: Error) -> () {
    do {
        _ = try expression()
        XCTFail("Expected error \(expectedError), but closure succeeded.")
    } catch expectedError {
        // expected
    } catch {
        XCTFail("Catched error \(error), but not from the expected type \(expectedError).")
    }
}

/// Equatable Error
public func ~=(lhs: Error, rhs: Error) -> Bool {
    return lhs._domain == rhs._domain && lhs._code == rhs._code
}
