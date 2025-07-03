//
//  File.swift
//  AdelsonValidator
//
//  Created by ahmed on 03/07/2025.
//

import Foundation
@testable import AdelsonValidator


import XCTest

// MARK: - Test Class
class StringNotContainAnyItemInListTests: XCTestCase {
    
    // MARK: - TC001: Valid string passes validation
    func testValidStringPassesValidation() {
        // Arrange
        var validator = StringNotContainAnyInList(input: "hello world", notContained: ["foo", "bar"])
        
        // Act
        let result = validator.check()
        
        // Assert
        XCTAssertTrue(result, "Valid string should pass validation")
        XCTAssertNil(validator.getError(), "No error should be set for valid input")
    }
    
    // MARK: - TC002: String containing forbidden item fails
    func testStringContainingForbiddenItemFails() {
        // Arrange
        var validator = StringNotContainAnyInList(input: "hello foo world", notContained: ["foo", "bar"])
        
        // Act
        let result = validator.check()
        
        // Assert
        XCTAssertFalse(result, "String containing forbidden item should fail validation")
        XCTAssertNotNil(validator.getError(), "Error should be set for invalid input")
        XCTAssertTrue(validator.getError() is StringNotContainAnyInListError, "Error should be of correct type")
    }
    
    // MARK: - TC003: Empty string passes with non-empty forbidden list
    func testEmptyStringPassesWithNonEmptyForbiddenList() {
        // Arrange
        var validator = StringNotContainAnyInList(input: "", notContained: ["foo", "bar"])
        
        // Act
        let result = validator.check()
        
        // Assert
        XCTAssertTrue(result, "Empty string should pass validation")
        XCTAssertNil(validator.getError(), "No error should be set for empty input")
    }
    
    // MARK: - TC004: Non-empty string passes with empty forbidden list
    func testNonEmptyStringPassesWithEmptyForbiddenList() {
        // Arrange
        var validator = StringNotContainAnyInList(input: "hello world", notContained: [])
        
        // Act
        let result = validator.check()
        
        // Assert
        XCTAssertTrue(result, "String should pass validation with empty forbidden list")
        XCTAssertNil(validator.getError(), "No error should be set when forbidden list is empty")
    }
    
    // MARK: - TC005: Empty string passes with empty forbidden list
    func testEmptyStringPassesWithEmptyForbiddenList() {
        // Arrange
        var validator = StringNotContainAnyInList(input: "", notContained: [])
        
        // Act
        let result = validator.check()
        
        // Assert
        XCTAssertTrue(result, "Empty string should pass validation with empty forbidden list")
        XCTAssertNil(validator.getError(), "No error should be set for empty inputs")
    }
    
    // MARK: - TC006: String containing multiple forbidden items fails
    func testStringContainingMultipleForbiddenItemsFails() {
        // Arrange
        var validator = StringNotContainAnyInList(input: "foo bar baz", notContained: ["foo", "bar"])
        
        // Act
        let result = validator.check()
        
        // Assert
        XCTAssertFalse(result, "String containing multiple forbidden items should fail")
        XCTAssertNotNil(validator.getError(), "Error should be set for invalid input")
    }
    
    // MARK: - TC007: Case-sensitive matching
    func testCaseSensitiveMatching() {
        // Arrange
        var validator = StringNotContainAnyInList(input: "Hello", notContained: ["hello"])
        
        // Act
        let result = validator.check()
        
        // Assert
        XCTAssertTrue(result, "Case-sensitive matching should allow 'Hello' when 'hello' is forbidden")
        XCTAssertNil(validator.getError(), "No error should be set for case-sensitive mismatch")
    }
    
    // MARK: - TC008: Partial substring matching
    func testPartialSubstringMatching() {
        // Arrange
        var validator = StringNotContainAnyInList(input: "foobar", notContained: ["foo"])
        
        // Act
        let result = validator.check()
        
        // Assert
        XCTAssertFalse(result, "Partial substring matching should detect 'foo' in 'foobar'")
        XCTAssertNotNil(validator.getError(), "Error should be set for substring match")
    }
    
    // MARK: - TC009: checkAndExec calls onSuccess when valid
    func testCheckAndExecCallsOnSuccessWhenValid() {
        // Arrange
        var validator = StringNotContainAnyInList(input: "hello", notContained: ["world"])
        var onSuccessCalled = false
        var onFailCalled = false
        
        // Act
        validator.checkAndExec(
            onSuccess: { onSuccessCalled = true },
            onFail: { onFailCalled = true }
        )
        
        // Assert
        XCTAssertTrue(onSuccessCalled, "onSuccess should be called for valid input")
        XCTAssertFalse(onFailCalled, "onFail should not be called for valid input")
        XCTAssertNil(validator.getError(), "No error should be set for valid input")
    }
    
    // MARK: - TC010: checkAndExec calls onFail when invalid
    func testCheckAndExecCallsOnFailWhenInvalid() {
        // Arrange
        var validator = StringNotContainAnyInList(input: "hello world", notContained: ["world"])
        var onSuccessCalled = false
        var onFailCalled = false
        
        // Act
        validator.checkAndExec(
            onSuccess: { onSuccessCalled = true },
            onFail: { onFailCalled = true }
        )
        
        // Assert
        XCTAssertFalse(onSuccessCalled, "onSuccess should not be called for invalid input")
        XCTAssertTrue(onFailCalled, "onFail should be called for invalid input")
        XCTAssertNotNil(validator.getError(), "Error should be set for invalid input")
    }
    
    // MARK: - TC011: ThrowableCheck doesn't throw when valid
    func testThrowableCheckDoesNotThrowWhenValid() {
        // Arrange
        var validator = StringNotContainAnyInList(input: "hello", notContained: ["world"])
        
        // Act & Assert
        XCTAssertNoThrow(try validator.ThrowableCheck(), "ThrowableCheck should not throw for valid input")
        XCTAssertNil(validator.getError(), "No error should be set for valid input")
    }
    
    // MARK: - TC012: ThrowableCheck throws when invalid
    func testThrowableCheckThrowsWhenInvalid() {
        // Arrange
        var validator = StringNotContainAnyInList(input: "hello world", notContained: ["world"])
        
        // Act & Assert
        XCTAssertThrowsError(try validator.ThrowableCheck(), "ThrowableCheck should throw for invalid input") { error in
            XCTAssertTrue(error is StringNotContainAnyInListError, "Thrown error should be of correct type")
        }
        XCTAssertNotNil(validator.getError(), "Error should be set for invalid input")
    }
    
    // MARK: - TC013: getError returns nil when no error
    func testGetErrorReturnsNilWhenNoError() {
        // Arrange
        var validator = StringNotContainAnyInList(input: "hello", notContained: ["world"])
        
        // Act
        _ = validator.check()
        let error = validator.getError()
        
        // Assert
        XCTAssertNil(error, "getError should return nil when validation passes")
    }
    
    // MARK: - TC014: getError returns error after failed check
    func testGetErrorReturnsErrorAfterFailedCheck() {
        // Arrange
        var validator = StringNotContainAnyInList(input: "hello world", notContained: ["world"])
        
        // Act
        _ = validator.check()
        let error = validator.getError()
        
        // Assert
        XCTAssertNotNil(error, "getError should return error after failed validation")
        XCTAssertTrue(error is StringNotContainAnyInListError, "Error should be of correct type")
    }
    
    // MARK: - TC015: Single character strings
    func testSingleCharacterStrings() {
        // Arrange
        var validator = StringNotContainAnyInList(input: "a", notContained: ["a"])
        
        // Act
        let result = validator.check()
        
        // Assert
        XCTAssertFalse(result, "Single character match should fail validation")
        XCTAssertNotNil(validator.getError(), "Error should be set for single character match")
    }
    
    // MARK: - TC016: Special characters and symbols
    func testSpecialCharactersAndSymbols() {
        // Arrange
        var validator = StringNotContainAnyInList(input: "test@#$", notContained: ["@"])
        
        // Act
        let result = validator.check()
        
        // Assert
        XCTAssertFalse(result, "Special character match should fail validation")
        XCTAssertNotNil(validator.getError(), "Error should be set for special character match")
    }
    
    // MARK: - TC017: Multiple calls preserve state
    func testMultipleCallsPreserveState() {
        // Arrange
        var validator = StringNotContainAnyInList(input: "hello world", notContained: ["world"])
        
        // Act
        let firstResult = validator.check()
        let secondResult = validator.check()
        let firstError = validator.getError()
        let secondError = validator.getError()
        
        // Assert
        XCTAssertEqual(firstResult, secondResult, "Multiple calls should return consistent results")
        XCTAssertEqual(firstError?.localizedDescription, secondError?.localizedDescription, "Error state should be preserved")
    }
    
    // MARK: - Additional Edge Cases
    
    // TC018: Test with whitespace-only strings
    func testWhitespaceOnlyStrings() {
        // Arrange
        var validator = StringNotContainAnyInList(input: "   ", notContained: [" "])
        
        // Act
        let result = validator.check()
        
        // Assert
        XCTAssertFalse(result, "Whitespace matching should work correctly")
        XCTAssertNotNil(validator.getError(), "Error should be set for whitespace match")
    }
    
    // TC019: Test with unicode characters
    func testUnicodeCharacters() {
        // Arrange
        var validator = StringNotContainAnyInList(input: "Hello 🌍", notContained: ["🌍"])
        
        // Act
        let result = validator.check()
        
        // Assert
        XCTAssertFalse(result, "Unicode character matching should work correctly")
        XCTAssertNotNil(validator.getError(), "Error should be set for unicode match")
    }
    
    // TC020: Test error state reset on successful validation
    func testErrorStateResetOnSuccessfulValidation() {
        // Arrange
        var validator = StringNotContainAnyInList(input: "hello world", notContained: ["world"])
        
        // Act
        _ = validator.check() // First check fails
        let firstError = validator.getError()
        
        // Change to valid input by creating new validator (simulating state change)
        validator = StringNotContainAnyInList(input: "hello", notContained: ["world"])
        _ = validator.check() // Second check passes
        let secondError = validator.getError()
        
        // Assert
        XCTAssertNotNil(firstError, "First validation should produce error")
        XCTAssertNil(secondError, "Second validation should clear error state")
    }
}
