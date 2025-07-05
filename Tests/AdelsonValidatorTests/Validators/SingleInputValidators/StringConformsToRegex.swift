//
//  File.swift
//  AdelsonValidator
//
//  Created by ahmed on 03/07/2025.
//
@testable import AdelsonValidator
import XCTest
import Foundation

class StringConformsToRegexTests: XCTestCase {
        
    // MARK: - Test Cases
    
    func testTC001_SuccessfulRegexValidation() {
        // Arrange: Set up validator with valid input matching regex
        var validator = StringConfromsToRegex(input: "abc123", regex: "^[a-z]+[0-9]+$")
        
        // Act: Perform validation
        let result = validator.check()
        
        // Assert: Validation should succeed
        XCTAssertTrue(result, "Validation should succeed for matching input")
        XCTAssertNil(validator.error, "Error should be nil for successful validation")
    }
    
    func testTC002_FailedRegexValidation() {
        // Arrange: Set up validator with invalid input not matching regex
        var validator = StringConfromsToRegex(input: "ABC123", regex: "^[a-z]+[0-9]+$")
        
        // Act: Perform validation
        let result = validator.check()
        
        // Assert: Validation should fail
        XCTAssertFalse(result, "Validation should fail for non-matching input")
        XCTAssertNotNil(validator.error, "Error should be set for failed validation")
        
        // Verify error type and content
        if let error = validator.error as? StringConfromsToRegexError {
            switch error {
            case .notConformingToGivenRegex(let regex):
                XCTAssertEqual(regex, "^[a-z]+[0-9]+$", "Error should contain the regex pattern")
            }
        } else {
            XCTFail("Error should be of type StringConfromsToRegexError")
        }
    }
    
    func testTC003_InitializationWithInputAndRegex() {
        // Arrange & Act: Initialize validator with both input and regex
        let validator = StringConfromsToRegex(input: "test", regex: "^test$")
        
        // Assert: Properties should be set correctly
        XCTAssertEqual(validator.input, "test", "Input should be set correctly")
        XCTAssertEqual(validator.regex, "^test$", "Regex should be set correctly")
        XCTAssertNil(validator.error, "Error should be nil on initialization")
    }
    
    func testTC004_InitializationWithRegexOnly() {
        // Arrange & Act: Initialize validator with regex only
        let validator = StringConfromsToRegex(regex: "^test$")
        
        // Assert: Input should be empty, regex should be set
        XCTAssertEqual(validator.input, "", "Input should be empty string")
        XCTAssertEqual(validator.regex, "^test$", "Regex should be set correctly")
        XCTAssertNil(validator.error, "Error should be nil on initialization")
    }
    
    func testTC005_SetInputFunctionality() {
        // Arrange: Initialize validator and set an error state
        var validator = StringConfromsToRegex(input: "invalid", regex: "^valid$")
        _ = validator.check() // This will set an error
        XCTAssertNotNil(validator.error, "Error should be set initially")
        
        // Act: Change input using setInput
        validator.setInput(input: "valid")
        
        // Assert: Input should be updated and error cleared
        XCTAssertEqual(validator.input, "valid", "Input should be updated")
        XCTAssertNil(validator.error, "Error should be cleared when setting new input")
    }
    
    func testTC006_CheckAndExecWithSuccess() {
        // Arrange: Set up validator with valid input
        var validator = StringConfromsToRegex(input: "valid", regex: "^valid$")
        var successCalled = false
        var failCalled = false
        
        // Act: Call checkAndExec with callbacks
        validator.checkAndExec(
            onSuccess: { successCalled = true },
            onFail: { failCalled = true }
        )
        
        // Assert: Success callback should be called
        XCTAssertTrue(successCalled, "Success callback should be called")
        XCTAssertFalse(failCalled, "Fail callback should not be called")
        XCTAssertNil(validator.error, "Error should remain nil")
    }
    
    func testTC007_CheckAndExecWithFailure() {
        // Arrange: Set up validator with invalid input
        var validator = StringConfromsToRegex(input: "invalid", regex: "^valid$")
        var successCalled = false
        var failCalled = false
        
        // Act: Call checkAndExec with callbacks
        validator.checkAndExec(
            onSuccess: { successCalled = true },
            onFail: { failCalled = true }
        )
        
        // Assert: Fail callback should be called
        XCTAssertFalse(successCalled, "Success callback should not be called")
        XCTAssertTrue(failCalled, "Fail callback should be called")
        XCTAssertNotNil(validator.error, "Error should be set")
    }
    
    func testTC008_ThrowableCheckWithValidInput() {
        // Arrange: Set up validator with valid input
        var validator = StringConfromsToRegex(input: "valid", regex: "^valid$")
        
        // Act & Assert: Should not throw
        XCTAssertNoThrow(try validator.ThrowableCheck(), "Should not throw for valid input")
        XCTAssertNil(validator.error, "Error should remain nil")
    }
    
    func testTC009_ThrowableCheckWithInvalidInput() {
        // Arrange: Set up validator with invalid input
        var validator = StringConfromsToRegex(input: "invalid", regex: "^valid$")
        
        // Act & Assert: Should throw
        XCTAssertThrowsError(try validator.ThrowableCheck(), "Should throw for invalid input") { error in
            XCTAssertTrue(error is StringConfromsToRegexError, "Should throw StringConfromsToRegexError")
        }
        XCTAssertNotNil(validator.error, "Error should be set")
    }
    
    func testTC010_GetErrorReturnsCorrectError() {
        // Arrange: Set up validator and trigger error
        var validator = StringConfromsToRegex(input: "invalid", regex: "^valid$")
        _ = validator.check() // This will set an error
        
        // Act: Get error
        let retrievedError = validator.getError()
        
        // Assert: Should return the correct error
        XCTAssertNotNil(retrievedError, "getError should return the error")
        XCTAssertTrue(retrievedError is StringConfromsToRegexError, "Should return StringConfromsToRegexError")
    }
    
    func testTC011_EmptyStringValidation() {
        // Arrange: Set up validator for empty string with matching regex
        var validator = StringConfromsToRegex(input: "", regex: "^$")
        
        // Act: Perform validation
        let result = validator.check()
        
        // Assert: Should succeed
        XCTAssertTrue(result, "Empty string should match empty regex")
        XCTAssertNil(validator.error, "Error should be nil")
    }
    
    func testTC012_EmptyStringAgainstNonEmptyRegex() {
        // Arrange: Set up validator for empty string with non-empty regex
        var validator = StringConfromsToRegex(input: "", regex: "^[a-z]+$")
        
        // Act: Perform validation
        let result = validator.check()
        
        // Assert: Should fail
        XCTAssertFalse(result, "Empty string should not match non-empty regex")
        XCTAssertNotNil(validator.error, "Error should be set")
    }
    
    func testTC013_ComplexRegexPattern() {
        // Arrange: Set up validator with email validation regex
        var validator = StringConfromsToRegex(
            input: "user@example.com",
            regex: "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$"
        )
        
        // Act: Perform validation
        let result = validator.check()
        
        // Assert: Should succeed
        XCTAssertTrue(result, "Valid email should match email regex")
        XCTAssertNil(validator.error, "Error should be nil")
    }
    
    func testTC015_SpecialCharactersInInput() {
        // Arrange: Set up validator with special characters
        var validator = StringConfromsToRegex(input: "test!@#$%", regex: "^test!@#\\$%$")
        
        // Act: Perform validation
        let result = validator.check()
        
        // Assert: Should succeed
        XCTAssertTrue(result, "Special characters should match when properly escaped in regex")
        XCTAssertNil(validator.error, "Error should be nil")
    }
    
    func testTC016_MultipleValidationCalls() {
        // Arrange: Set up validator
        var validator = StringConfromsToRegex(input: "test", regex: "^test$")
        
        // Act: Call check multiple times
        let result1 = validator.check()
        let result2 = validator.check()
        let result3 = validator.check()
        
        // Assert: Results should be consistent
        XCTAssertTrue(result1, "First validation should succeed")
        XCTAssertTrue(result2, "Second validation should succeed")
        XCTAssertTrue(result3, "Third validation should succeed")
        XCTAssertNil(validator.error, "Error should remain nil")
    }
    
    func testTC017_ErrorPersistenceAndClearing() {
        // Arrange: Set up validator and cause failure
        var validator = StringConfromsToRegex(input: "invalid", regex: "^valid$")
        _ = validator.check() // This will set an error
        XCTAssertNotNil(validator.error, "Error should be set after failure")
        
        // Act: Change to valid input and check again
        validator.setInput(input: "valid")
        let result = validator.check()
        
        // Assert: Should succeed and error should be cleared
        XCTAssertTrue(result, "Validation should succeed with valid input")
        XCTAssertNil(validator.error, "Error should be cleared after successful validation")
    }
    
    func testTC018_SaveErrorMethodDirectly() {
        // Arrange: Set up validator
        var validator = StringConfromsToRegex(input: "test", regex: "^test$")
        XCTAssertNil(validator.error, "Error should be nil initially")
        
        // Act: Call saveError directly
        validator.saveError()
        
        // Assert: Error should be set
        XCTAssertNotNil(validator.error, "Error should be set after saveError")
        XCTAssertTrue(validator.error is StringConfromsToRegexError, "Should be StringConfromsToRegexError")
    }
    
    // MARK: - Additional Edge Cases
    
    func testUnicodeStringValidation() {
        // Test with Unicode characters
        var validator = StringConfromsToRegex(input: "café", regex: "^café$")
        let result = validator.check()
        XCTAssertTrue(result, "Unicode characters should be handled correctly")
    }
    
    func testVeryLongStringValidation() {
        // Test with very long string
        let longString = String(repeating: "a", count: 10000)
        let longRegex = "^a{10000}$"
        var validator = StringConfromsToRegex(input: longString, regex: longRegex)
        let result = validator.check()
        XCTAssertTrue(result, "Very long strings should be handled correctly")
    }
    
    func testErrorMessageContainsRegex() {
        // Test that error message contains the regex pattern
        var validator = StringConfromsToRegex(input: "test", regex: "^different$")
        _ = validator.check()
        
        if let error = validator.error as? StringConfromsToRegexError {
            switch error {
            case .notConformingToGivenRegex(let regex):
                XCTAssertEqual(regex, "^different$", "Error should contain the original regex")
            }
        } else {
            XCTFail("Error should be StringConfromsToRegexError")
        }
    }
}
