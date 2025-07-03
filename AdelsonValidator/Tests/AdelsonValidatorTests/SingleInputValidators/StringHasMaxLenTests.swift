//
//  File.swift
//  AdelsonValidator
//
//  Created by ahmed on 03/07/2025.
//

import Foundation
@testable import AdelsonValidator

import XCTest

class StringHasMaxLenTests: XCTestCase {
    
    // MARK: - TC1: Valid string within max length
    func testValidStringWithinMaxLength() {
        // Arrange
        var validator = StringHasMaxLen(input: "hello", maxLen: 10)
        
        // Act
        let result = validator.check()
        
        // Assert
        XCTAssertTrue(result, "String 'hello' should be valid with max length 10")
        XCTAssertNil(validator.getError(), "No error should be present for valid input")
    }
    
    // MARK: - TC2: Valid string exactly at max length
    func testValidStringExactlyAtMaxLength() {
        // Arrange
        var validator = StringHasMaxLen(input: "hello", maxLen: 5)
        
        // Act
        let result = validator.check()
        
        // Assert
        XCTAssertTrue(result, "String 'hello' should be valid with max length 5 (exact boundary)")
        XCTAssertNil(validator.getError(), "No error should be present for boundary valid input")
    }
    
    // MARK: - TC3: Invalid string exceeding max length
    func testInvalidStringExceedingMaxLength() {
        // Arrange
        var validator = StringHasMaxLen(input: "hello world", maxLen: 5)
        
        // Act
        let result = validator.check()
        
        // Assert
        XCTAssertFalse(result, "String 'hello world' should be invalid with max length 5")
        XCTAssertNotNil(validator.getError(), "Error should be present for invalid input")
        
        // Verify specific error type
        if let error = validator.getError() as? StringHasMaxLenError {
            XCTAssertEqual(error, StringHasMaxLenError.providedInputIsGreaterThanMinLen)
        } else {
            XCTFail("Expected StringHasMaxLenError but got different error type")
        }
    }
    
    // MARK: - TC4: Empty string with positive max length
    func testEmptyStringWithPositiveMaxLength() {
        // Arrange
        var validator = StringHasMaxLen(input: "", maxLen: 5)
        
        // Act
        let result = validator.check()
        
        // Assert
        XCTAssertTrue(result, "Empty string should be valid with positive max length")
        XCTAssertNil(validator.getError(), "No error should be present for empty valid input")
    }
    
    // MARK: - TC5: Empty string with zero max length
    func testEmptyStringWithZeroMaxLength() {
        // Arrange
        var validator = StringHasMaxLen(input: "", maxLen: 0)
        
        // Act
        let result = validator.check()
        
        // Assert
        XCTAssertTrue(result, "Empty string should be valid with zero max length")
        XCTAssertNil(validator.getError(), "No error should be present for empty string with zero max length")
    }
    
    // MARK: - TC6: Non-empty string with zero max length
    func testNonEmptyStringWithZeroMaxLength() {
        // Arrange
        var validator = StringHasMaxLen(input: "a", maxLen: 0)
        
        // Act
        let result = validator.check()
        
        // Assert
        XCTAssertFalse(result, "Non-empty string should be invalid with zero max length")
        XCTAssertNotNil(validator.getError(), "Error should be present for non-empty string with zero max length")
    }
    
    // MARK: - TC7: checkAndExec with valid input
    func testCheckAndExecWithValidInput() {
        // Arrange
        var validator = StringHasMaxLen(input: "test", maxLen: 10)
        var successCalled = false
        var failCalled = false
        
        // Act
        validator.checkAndExec(
            onSuccess: { successCalled = true },
            onFail: { failCalled = true }
        )
        
        // Assert
        XCTAssertTrue(successCalled, "Success callback should be called for valid input")
        XCTAssertFalse(failCalled, "Fail callback should not be called for valid input")
        XCTAssertNil(validator.getError(), "No error should be present after successful validation")
    }
    
    // MARK: - TC8: checkAndExec with invalid input
    func testCheckAndExecWithInvalidInput() {
        // Arrange
        var validator = StringHasMaxLen(input: "too long", maxLen: 3)
        var successCalled = false
        var failCalled = false
        
        // Act
        validator.checkAndExec(
            onSuccess: { successCalled = true },
            onFail: { failCalled = true }
        )
        
        // Assert
        XCTAssertFalse(successCalled, "Success callback should not be called for invalid input")
        XCTAssertTrue(failCalled, "Fail callback should be called for invalid input")
        XCTAssertNotNil(validator.getError(), "Error should be saved after failed validation")
    }
    
    // MARK: - TC9: ThrowableCheck with valid input
    func testThrowableCheckWithValidInput() {
        // Arrange
        var validator = StringHasMaxLen(input: "ok", maxLen: 5)
        
        // Act & Assert
        XCTAssertNoThrow(try validator.ThrowableCheck(), "Valid input should not throw an exception")
        XCTAssertNil(validator.getError(), "No error should be present after successful throwable check")
    }
    
    // MARK: - TC10: ThrowableCheck with invalid input
    func testThrowableCheckWithInvalidInput() {
        // Arrange
        var validator = StringHasMaxLen(input: "too long", maxLen: 3)
        
        // Act & Assert
        XCTAssertThrowsError(try validator.ThrowableCheck(), "Invalid input should throw an exception") { error in
            // Verify the thrown error is of correct type
            XCTAssertTrue(error is StringHasMaxLenError, "Thrown error should be StringHasMaxLenError")
            if let specificError = error as? StringHasMaxLenError {
                XCTAssertEqual(specificError, StringHasMaxLenError.providedInputIsGreaterThanMinLen)
            }
        }
        XCTAssertNotNil(validator.getError(), "Error should be saved after failed throwable check")
    }
    
    // MARK: - TC11: getError after failed validation
    func testGetErrorAfterFailedValidation() {
        // Arrange
        var validator = StringHasMaxLen(input: "long", maxLen: 2)
        
        // Act
        _ = validator.check() // This should fail and save error
        let retrievedError = validator.getError()
        
        // Assert
        XCTAssertNotNil(retrievedError, "Error should be retrievable after failed validation")
        XCTAssertTrue(retrievedError is StringHasMaxLenError, "Retrieved error should be of correct type")
    }
    
    // MARK: - TC12: getError before any validation
    func testGetErrorBeforeAnyValidation() {
        // Arrange
        var validator = StringHasMaxLen(input: "test", maxLen: 10)
        
        // Act
        let error = validator.getError()
        
        // Assert
        XCTAssertNil(error, "Error should be nil before any validation is performed")
    }
    
    // MARK: - TC13: Multiple check calls behavior
    func testMultipleCheckCallsBehavior() {
        // Arrange
        var validator = StringHasMaxLen(input: "hello", maxLen: 3)
        
        // Act
        let firstResult = validator.check()
        let secondResult = validator.check()
        let thirdResult = validator.check()
        
        // Assert
        XCTAssertFalse(firstResult, "First check should fail")
        XCTAssertFalse(secondResult, "Second check should fail consistently")
        XCTAssertFalse(thirdResult, "Third check should fail consistently")
        XCTAssertNotNil(validator.getError(), "Error should persist across multiple calls")
    }
    
    // MARK: - TC14: Unicode string validation
    func testUnicodeStringValidation() {
        // Arrange
        var validator = StringHasMaxLen(input: "émojis 🎉", maxLen: 10)
        
        // Act
        let result = validator.check()
        
        // Assert
        XCTAssertTrue(result, "Unicode string should be correctly validated based on character count")
        XCTAssertNil(validator.getError(), "No error should be present for valid unicode input")
        
        // Test edge case with unicode exceeding limit
        var invalidUnicodeValidator = StringHasMaxLen(input: "🎉🎉🎉🎉🎉", maxLen: 3)
        let invalidResult = invalidUnicodeValidator.check()
        XCTAssertFalse(invalidResult, "Unicode string exceeding limit should fail validation")
    }
    
    // MARK: - Additional Edge Cases
    
    func testValidatorStateAfterMultipleOperations() {
        // Test that validator maintains correct state through various operations
        var validator = StringHasMaxLen(input: "test", maxLen: 2)
        
        // First operation - should fail
        let checkResult = validator.check()
        XCTAssertFalse(checkResult)
        XCTAssertNotNil(validator.getError())
        
        // Second operation - should still fail consistently
        var successCalled = false
        var failCalled = false
        validator.checkAndExec(
            onSuccess: { successCalled = true },
            onFail: { failCalled = true }
        )
        XCTAssertFalse(successCalled)
        XCTAssertTrue(failCalled)
        XCTAssertNotNil(validator.getError())
        
        // Third operation - throwable check should throw
        XCTAssertThrowsError(try validator.ThrowableCheck())
    }
    
    func testValidatorWithVeryLargeInput() {
        // Test with a very large string to ensure performance and correctness
        let largeString = String(repeating: "a", count: 10000)
        var validator = StringHasMaxLen(input: largeString, maxLen: 5000)
        
        let result = validator.check()
        XCTAssertFalse(result, "Large string should fail validation when exceeding max length")
        XCTAssertNotNil(validator.getError(), "Error should be present for large invalid input")
    }
}
