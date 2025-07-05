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
class StringHasMaxLenTests: XCTestCase {
    
    // MARK: - TC001: Valid string within max length
    func testValidStringWithinMaxLength() {
        // Arrange
        var validator = StringHasMaxLen(input: "hello", maxLen: 10)
        
        // Act
        let result = validator.check()
        
        // Assert
        XCTAssertTrue(result, "Valid string within max length should pass validation")
        XCTAssertNil(validator.getError(), "No error should be present for valid input")
    }
    
    // MARK: - TC002: String exactly at max length
    func testStringExactlyAtMaxLength() {
        // Arrange
        var validator = StringHasMaxLen(input: "hello", maxLen: 5)
        
        // Act
        let result = validator.check()
        
        // Assert
        XCTAssertTrue(result, "String exactly at max length should pass validation")
        XCTAssertNil(validator.getError(), "No error should be present for boundary case")
    }
    
    // MARK: - TC003: String exceeding max length
    func testStringExceedingMaxLength() {
        // Arrange
        var validator = StringHasMaxLen(input: "hello world", maxLen: 5)
        
        // Act
        let result = validator.check()
        
        // Assert
        XCTAssertFalse(result, "String exceeding max length should fail validation")
        XCTAssertNotNil(validator.getError(), "Error should be present for invalid input")
        XCTAssertTrue(validator.getError() is StringHasMaxLenError, "Error should be of correct type")
    }
    
    // MARK: - TC004: Empty string with positive max length
    func testEmptyStringWithPositiveMaxLength() {
        // Arrange
        var validator = StringHasMaxLen(input: "", maxLen: 5)
        
        // Act
        let result = validator.check()
        
        // Assert
        XCTAssertTrue(result, "Empty string should pass validation when max length is positive")
        XCTAssertNil(validator.getError(), "No error should be present for empty string")
    }
    
    // MARK: - TC005: Empty string with zero max length
    func testEmptyStringWithZeroMaxLength() {
        // Arrange
        var validator = StringHasMaxLen(input: "", maxLen: 0)
        
        // Act
        let result = validator.check()
        
        // Assert
        XCTAssertTrue(result, "Empty string should pass validation when max length is zero")
        XCTAssertNil(validator.getError(), "No error should be present for empty string at boundary")
    }
    
    // MARK: - TC006: Non-empty string with zero max length
    func testNonEmptyStringWithZeroMaxLength() {
        // Arrange
        var validator = StringHasMaxLen(input: "a", maxLen: 0)
        
        // Act
        let result = validator.check()
        
        // Assert
        XCTAssertFalse(result, "Non-empty string should fail validation when max length is zero")
        XCTAssertNotNil(validator.getError(), "Error should be present for this edge case")
    }
    
    // MARK: - TC007: Initialize with input constructor
    func testInitializeWithInputConstructor() {
        // Arrange & Act
        let validator = StringHasMaxLen(input: "test", maxLen: 10)
        
        // Assert
        XCTAssertEqual(validator.input, "test", "Input should be initialized correctly")
        XCTAssertNil(validator.error, "No error should be present initially")
    }
    
    // MARK: - TC008: Initialize with maxLen-only constructor
    func testInitializeWithMaxLenOnlyConstructor() {
        // Arrange & Act
        let validator = StringHasMaxLen(maxLen: 5)
        
        // Assert
        XCTAssertEqual(validator.input, "", "Input should be empty string by default")
        XCTAssertNil(validator.error, "No error should be present initially")
    }
    
    // MARK: - TC009: setInput updates input and clears error
    func testSetInputUpdatesInputAndClearsError() {
        // Arrange
        var validator = StringHasMaxLen(input: "toolongstring", maxLen: 5)
        _ = validator.check() // This will set an error
        
        // Act
        validator.setInput(input: "short")
        
        // Assert
        XCTAssertEqual(validator.input, "short", "Input should be updated")
        XCTAssertNil(validator.error, "Error should be cleared after setInput")
    }
    
    // MARK: - TC010: checkAndExec calls onSuccess for valid input
    func testCheckAndExecCallsOnSuccessForValidInput() {
        // Arrange
        var validator = StringHasMaxLen(input: "valid", maxLen: 10)
        var successCalled = false
        var failCalled = false
        
        // Act
        validator.checkAndExec(
            onSuccess: { successCalled = true },
            onFail: { failCalled = true }
        )
        
        // Assert
        XCTAssertTrue(successCalled, "onSuccess should be called for valid input")
        XCTAssertFalse(failCalled, "onFail should not be called for valid input")
    }
    
    // MARK: - TC011: checkAndExec calls onFail for invalid input
    func testCheckAndExecCallsOnFailForInvalidInput() {
        // Arrange
        var validator = StringHasMaxLen(input: "this string is too long", maxLen: 5)
        var successCalled = false
        var failCalled = false
        
        // Act
        validator.checkAndExec(
            onSuccess: { successCalled = true },
            onFail: { failCalled = true }
        )
        
        // Assert
        XCTAssertFalse(successCalled, "onSuccess should not be called for invalid input")
        XCTAssertTrue(failCalled, "onFail should be called for invalid input")
        XCTAssertNotNil(validator.getError(), "Error should be saved after failed check")
    }
    
    // MARK: - TC012: ThrowableCheck succeeds for valid input
    func testThrowableCheckSucceedsForValidInput() {
        // Arrange
        var validator = StringHasMaxLen(input: "valid", maxLen: 10)
        
        // Act & Assert
        XCTAssertNoThrow(try validator.ThrowableCheck(), "ThrowableCheck should not throw for valid input")
    }
    
    // MARK: - TC013: ThrowableCheck throws for invalid input
    func testThrowableCheckThrowsForInvalidInput() {
        // Arrange
        var validator = StringHasMaxLen(input: "this string is way too long", maxLen: 5)
        
        // Act & Assert
        XCTAssertThrowsError(try validator.ThrowableCheck(), "ThrowableCheck should throw for invalid input") { error in
            XCTAssertTrue(error is StringHasMaxLenError, "Thrown error should be of correct type")
        }
    }
    
    // MARK: - TC014: getError returns nil when no error
    func testGetErrorReturnsNilWhenNoError() {
        // Arrange
        var validator = StringHasMaxLen(input: "valid", maxLen: 10)
        
        // Act
        _ = validator.check()
        let error = validator.getError()
        
        // Assert
        XCTAssertNil(error, "getError should return nil when no error exists")
    }
    
    // MARK: - TC015: getError returns error after failed check
    func testGetErrorReturnsErrorAfterFailedCheck() {
        // Arrange
        var validator = StringHasMaxLen(input: "too long string", maxLen: 5)
        
        // Act
        _ = validator.check()
        let error = validator.getError()
        
        // Assert
        XCTAssertNotNil(error, "getError should return error after failed check")
        XCTAssertTrue(error is StringHasMaxLenError, "Error should be of correct type")
    }
    
    // MARK: - TC016: Multiple consecutive checks maintain state
    func testMultipleConsecutiveChecksMaintainState() {
        // Arrange
        var validator = StringHasMaxLen(input: "too long string", maxLen: 5)
        
        // Act
        let firstCheck = validator.check()
        let secondCheck = validator.check()
        let thirdCheck = validator.check()
        
        // Assert
        XCTAssertFalse(firstCheck, "First check should fail")
        XCTAssertFalse(secondCheck, "Second check should fail")
        XCTAssertFalse(thirdCheck, "Third check should fail")
        XCTAssertNotNil(validator.getError(), "Error should be maintained across multiple checks")
    }
    
    // MARK: - TC017: Large string input
    func testLargeStringInput() {
        // Arrange
        let largeString = String(repeating: "a", count: 10000)
        var validator = StringHasMaxLen(input: largeString, maxLen: 5000)
        
        // Act
        let result = validator.check()
        
        // Assert
        XCTAssertFalse(result, "Large string exceeding max length should fail")
        XCTAssertNotNil(validator.getError(), "Error should be present for large invalid input")
    }
    
    // MARK: - Additional Edge Cases
    
    // Test unicode characters
    func testUnicodeCharacters() {
        // Arrange
        var validator = StringHasMaxLen(input: "🚀🌟✨", maxLen: 3)
        
        // Act
        let result = validator.check()
        
        // Assert
        XCTAssertTrue(result, "Unicode characters should be counted correctly")
        XCTAssertNil(validator.getError(), "No error should be present for valid unicode input")
    }
    
    // Test state reset after setInput
    func testStateResetAfterSetInput() {
        // Arrange
        var validator = StringHasMaxLen(input: "invalid long string", maxLen: 5)
        _ = validator.check() // This sets an error
        
        // Act
        validator.setInput(input: "ok")
        let result = validator.check()
        
        // Assert
        XCTAssertTrue(result, "Check should pass after setting valid input")
        XCTAssertNil(validator.getError(), "Error should be cleared after successful check")
    }
    
    // Test error consistency
    func testErrorConsistency() {
        // Arrange
        var validator = StringHasMaxLen(input: "too long", maxLen: 3)
        
        // Act
        _ = validator.check()
        let error1 = validator.getError()
        let error2 = validator.getError()
        
        // Assert
        XCTAssertNotNil(error1, "First getError call should return error")
        XCTAssertNotNil(error2, "Second getError call should return error")
        XCTAssertTrue(type(of: error1!) == type(of: error2!), "Error types should be consistent")
    }
}

// MARK: - Performance Tests
extension StringHasMaxLenTests {
    
    func testPerformanceWithLargeInput() {
        let largeString = String(repeating: "performance", count: 1000)
        var validator = StringHasMaxLen(input: largeString, maxLen: 50000)
        
        measure {
            _ = validator.check()
        }
    }
    
    func testPerformanceWithMultipleChecks() {
        var validator = StringHasMaxLen(input: "test", maxLen: 10)
        
        measure {
            for _ in 0..<1000 {
                _ = validator.check()
            }
        }
    }
}
