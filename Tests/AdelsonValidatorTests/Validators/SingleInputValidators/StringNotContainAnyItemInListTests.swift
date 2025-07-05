//
//  File.swift
//  AdelsonValidator
//
//  Created by ahmed on 03/07/2025.
//

import Foundation
@testable import AdelsonValidator


import XCTest

import XCTest

// MARK: - Test Class
class StringNotContainAnyItemInListTests: XCTestCase {
    
    // MARK: - TC1: Valid String Passes Validation
    func testValidStringPassesValidation() {
        // Arrange: Set up validator with valid input that doesn't contain forbidden items
        var validator = StringNotContainAnyInList(input: "hello", notContained: ["world", "test"])
        
        // Act: Execute validation
        let result = validator.check()
        
        // Assert: Verify validation passes and no error is set
        XCTAssertTrue(result, "Valid string should pass validation")
        XCTAssertNil(validator.getError(), "No error should be set for valid input")
    }
    
    // MARK: - TC2: String Containing Forbidden Item Fails
    func testStringContainingForbiddenItemFails() {
        // Arrange: Set up validator with input containing a forbidden substring
        var validator = StringNotContainAnyInList(input: "hello world", notContained: ["world"])
        
        // Act: Execute validation
        let result = validator.check()
        
        // Assert: Verify validation fails and error is set
        XCTAssertFalse(result, "String containing forbidden item should fail validation")
        XCTAssertNotNil(validator.getError(), "Error should be set for invalid input")
        XCTAssertTrue(validator.getError() is StringNotContainAnyInListError, "Error should be of correct type")
    }
    
    // MARK: - TC3: Multiple Forbidden Items Detection
    func testMultipleForbiddenItemsDetection() {
        // Arrange: Set up validator with input containing one of multiple forbidden items
        var validator = StringNotContainAnyInList(input: "test hello", notContained: ["world", "test"])
        
        // Act: Execute validation
        let result = validator.check()
        
        // Assert: Verify validation fails when any forbidden item is found
        XCTAssertFalse(result, "String containing any forbidden item should fail validation")
        XCTAssertNotNil(validator.getError(), "Error should be set when forbidden item is found")
    }
    
    // MARK: - TC4: Case-Sensitive Matching
    func testCaseSensitiveMatching() {
        // Arrange: Set up validator with different case strings
        var validator = StringNotContainAnyInList(input: "Hello", notContained: ["hello"])
        
        // Act: Execute validation
        let result = validator.check()
        
        // Assert: Verify case-sensitive matching (Hello != hello)
        XCTAssertTrue(result, "Case-sensitive matching should treat 'Hello' and 'hello' as different")
        XCTAssertNil(validator.getError(), "No error should be set for case-different strings")
    }
    
    // MARK: - TC5: Partial String Matching
    func testPartialStringMatching() {
        // Arrange: Set up validator where input contains forbidden substring
        var validator = StringNotContainAnyInList(input: "testing", notContained: ["test"])
        
        // Act: Execute validation
        let result = validator.check()
        
        // Assert: Verify partial matching works (testing contains test)
        XCTAssertFalse(result, "Partial string matching should detect 'test' in 'testing'")
        XCTAssertNotNil(validator.getError(), "Error should be set for partial match")
    }
    
    // MARK: - TC6: Empty Input String
    func testEmptyInputString() {
        // Arrange: Set up validator with empty input string
        var validator = StringNotContainAnyInList(input: "", notContained: ["test"])
        
        // Act: Execute validation
        let result = validator.check()
        
        // Assert: Verify empty string passes validation
        XCTAssertTrue(result, "Empty string should pass validation")
        XCTAssertNil(validator.getError(), "No error should be set for empty input")
    }
    
    // MARK: - TC7: Empty Forbidden List
    func testEmptyForbiddenList() {
        // Arrange: Set up validator with empty forbidden list
        var validator = StringNotContainAnyInList(input: "hello", notContained: [])
        
        // Act: Execute validation
        let result = validator.check()
        
        // Assert: Verify validation passes when no items are forbidden
        XCTAssertTrue(result, "Validation should pass when forbidden list is empty")
        XCTAssertNil(validator.getError(), "No error should be set when no items are forbidden")
    }
    
    // MARK: - TC8: Both Empty
    func testBothEmpty() {
        // Arrange: Set up validator with empty input and empty forbidden list
        var validator = StringNotContainAnyInList(input: "", notContained: [])
        
        // Act: Execute validation
        let result = validator.check()
        
        // Assert: Verify validation passes when both are empty
        XCTAssertTrue(result, "Validation should pass when both input and forbidden list are empty")
        XCTAssertNil(validator.getError(), "No error should be set when both are empty")
    }
    
    // MARK: - TC9: SetInput Resets Error State
    func testSetInputResetsErrorState() {
        // Arrange: Set up validator and make it fail first
        var validator = StringNotContainAnyInList(input: "test hello", notContained: ["test"])
        
        // Act: First validation should fail
        let firstResult = validator.check()
        XCTAssertFalse(firstResult, "First validation should fail")
        XCTAssertNotNil(validator.getError(), "Error should be set after first validation")
        
        // Act: Set new valid input and check again
        validator.setInput(input: "hello world")
        let secondResult = validator.check()
        
        // Assert: Verify error state is reset and validation passes
        XCTAssertTrue(secondResult, "Second validation should pass with valid input")
        XCTAssertNil(validator.getError(), "Error should be cleared after setInput with valid input")
    }
    
    // MARK: - TC10: CheckAndExec Success Callback
    func testCheckAndExecSuccessCallback() {
        // Arrange: Set up validator with valid input and callback flags
        var validator = StringNotContainAnyInList(input: "hello", notContained: ["world"])
        var successCalled = false
        var failCalled = false
        
        // Act: Execute checkAndExec
        validator.checkAndExec(
            onSuccess: { successCalled = true },
            onFail: { failCalled = true }
        )
        
        // Assert: Verify success callback is called, fail callback is not
        XCTAssertTrue(successCalled, "Success callback should be called for valid input")
        XCTAssertFalse(failCalled, "Fail callback should not be called for valid input")
    }
    
    // MARK: - TC11: CheckAndExec Failure Callback
    func testCheckAndExecFailureCallback() {
        // Arrange: Set up validator with invalid input and callback flags
        var validator = StringNotContainAnyInList(input: "hello world", notContained: ["world"])
        var successCalled = false
        var failCalled = false
        
        // Act: Execute checkAndExec
        validator.checkAndExec(
            onSuccess: { successCalled = true },
            onFail: { failCalled = true }
        )
        
        // Assert: Verify fail callback is called, success callback is not
        XCTAssertFalse(successCalled, "Success callback should not be called for invalid input")
        XCTAssertTrue(failCalled, "Fail callback should be called for invalid input")
        XCTAssertNotNil(validator.getError(), "Error should be saved when validation fails")
    }
    
    // MARK: - TC12: ThrowableCheck Throws on Failure
    func testThrowableCheckThrowsOnFailure() {
        // Arrange: Set up validator with invalid input
        var validator = StringNotContainAnyInList(input: "hello world", notContained: ["world"])
        
        // Act & Assert: Verify exception is thrown
        XCTAssertThrowsError(try validator.ThrowableCheck(), "ThrowableCheck should throw for invalid input") { error in
            XCTAssertTrue(error is StringNotContainAnyInListError, "Thrown error should be of correct type")
        }
        
        // Assert: Verify error is saved
        XCTAssertNotNil(validator.getError(), "Error should be saved when ThrowableCheck throws")
    }
    
    // MARK: - TC13: ThrowableCheck Doesn't Throw on Success
    func testThrowableCheckDoesntThrowOnSuccess() {
        // Arrange: Set up validator with valid input
        var validator = StringNotContainAnyInList(input: "hello", notContained: ["world"])
        
        // Act & Assert: Verify no exception is thrown
        XCTAssertNoThrow(try validator.ThrowableCheck(), "ThrowableCheck should not throw for valid input")
        
        // Assert: Verify no error is set
        XCTAssertNil(validator.getError(), "No error should be set when ThrowableCheck succeeds")
    }
    
    // MARK: - TC14: GetError Returns Correct Error
    func testGetErrorReturnsCorrectError() {
        // Arrange: Set up validator with invalid input
        var validator = StringNotContainAnyInList(input: "hello world", notContained: ["world"])
        
        // Act: Execute validation to generate error
        let _ = validator.check()
        let retrievedError = validator.getError()
        
        // Assert: Verify correct error is returned
        XCTAssertNotNil(retrievedError, "GetError should return error after failed validation")
        XCTAssertTrue(retrievedError is StringNotContainAnyInListError, "Retrieved error should be of correct type")
        
        // Verify error case
        if let specificError = retrievedError as? StringNotContainAnyInListError {
            XCTAssertEqual(specificError, StringNotContainAnyInListError.StringContainsOneItemOrMoreFromList, "Error should be the correct case")
        }
    }
    
    // MARK: - TC15: Initialization with Input
    func testInitializationWithInput() {
        // Arrange & Act: Create validator with input and forbidden list
        let validator = StringNotContainAnyInList(input: "test", notContained: ["bad"])
        
        // Assert: Verify properties are set correctly
        XCTAssertEqual(validator.input, "test", "Input should be set correctly during initialization")
        XCTAssertEqual(validator.notContained, ["bad"], "NotContained list should be set correctly during initialization")
        XCTAssertNil(validator.error, "Error should be nil after initialization")
    }
    
    // MARK: - TC16: Initialization without Input
    func testInitializationWithoutInput() {
        // Arrange & Act: Create validator without input
        let validator = StringNotContainAnyInList(notContained: ["bad"])
        
        // Assert: Verify properties are set correctly
        XCTAssertEqual(validator.input, "", "Input should be empty string when not provided")
        XCTAssertEqual(validator.notContained, ["bad"], "NotContained list should be set correctly during initialization")
        XCTAssertNil(validator.error, "Error should be nil after initialization")
    }
    
    // MARK: - Additional Edge Cases
    
    // Test with whitespace-only input
    func testWhitespaceOnlyInput() {
        // Arrange: Set up validator with whitespace input
        var validator = StringNotContainAnyInList(input: "   ", notContained: ["test"])
        
        // Act: Execute validation
        let result = validator.check()
        
        // Assert: Verify whitespace passes validation
        XCTAssertTrue(result, "Whitespace-only input should pass validation")
        XCTAssertNil(validator.getError(), "No error should be set for whitespace input")
    }
    
    // Test with special characters
    func testSpecialCharacters() {
        // Arrange: Set up validator with special characters
        var validator = StringNotContainAnyInList(input: "hello@world.com", notContained: ["@"])
        
        // Act: Execute validation
        let result = validator.check()
        
        // Assert: Verify special character matching works
        XCTAssertFalse(result, "Special characters should be matched correctly")
        XCTAssertNotNil(validator.getError(), "Error should be set when special character is found")
    }
    
    // Test with Unicode characters
    func testUnicodeCharacters() {
        // Arrange: Set up validator with Unicode characters
        var validator = StringNotContainAnyInList(input: "hello 🌍 world", notContained: ["🌍"])
        
        // Act: Execute validation
        let result = validator.check()
        
        // Assert: Verify Unicode character matching works
        XCTAssertFalse(result, "Unicode characters should be matched correctly")
        XCTAssertNotNil(validator.getError(), "Error should be set when Unicode character is found")
    }
}
