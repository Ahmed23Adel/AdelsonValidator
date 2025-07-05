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

class AllOfSameLenTests: XCTestCase {
    
    // MARK: - Test Cases
    
    // TC001: Verify empty array validation passes
    func testEmptyArrayValidation() {
        // Arrange
        var validator = AllOfSameLen()
        
        // Act
        let result = validator.check()
        
        // Assert
        XCTAssertTrue(result, "Empty array should pass validation")
        XCTAssertNil(validator.error, "No error should be set for empty array")
    }
    
    // TC002: Verify single string validation passes
    func testSingleStringValidation() {
        // Arrange
        var validator = AllOfSameLen(inputs: ["hello"])
        
        // Act
        let result = validator.check()
        
        // Assert
        XCTAssertTrue(result, "Single string should always pass validation")
        XCTAssertNil(validator.error, "No error should be set for single string")
    }
    
    // TC003: Verify multiple strings of same length pass
    func testMultipleStringsOfSameLength() {
        // Arrange
        var validator = AllOfSameLen(inputs: ["abc", "def", "ghi"])
        
        // Act
        let result = validator.check()
        
        // Assert
        XCTAssertTrue(result, "Strings of same length should pass validation")
        XCTAssertNil(validator.error, "No error should be set for valid inputs")
    }
    
    // TC004: Verify strings of different lengths fail
    func testStringsOfDifferentLengths() {
        // Arrange
        var validator = AllOfSameLen(inputs: ["a", "bb", "ccc"])
        
        // Act
        let result = validator.check()
        
        // Assert
        XCTAssertFalse(result, "Strings of different lengths should fail validation")
        XCTAssertNotNil(validator.error, "Error should be set for invalid inputs")
    }
    
    // TC005: Verify empty strings validation
    func testEmptyStringsValidation() {
        // Arrange
        var validator = AllOfSameLen(inputs: ["", "", ""])
        
        // Act
        let result = validator.check()
        
        // Assert
        XCTAssertTrue(result, "Empty strings of same length (0) should pass validation")
        XCTAssertNil(validator.error, "No error should be set for valid empty strings")
    }
    
    // TC006: Verify mixed empty and non-empty strings fail
    func testMixedEmptyAndNonEmptyStrings() {
        // Arrange
        var validator = AllOfSameLen(inputs: ["", "a"])
        
        // Act
        let result = validator.check()
        
        // Assert
        XCTAssertFalse(result, "Mixed empty and non-empty strings should fail validation")
        XCTAssertNotNil(validator.error, "Error should be set for mixed length strings")
    }
    
    // TC007: Verify very long strings of same length
    func testVeryLongStringsOfSameLength() {
        // Arrange
        let longString1 = String(repeating: "a", count: 1000)
        let longString2 = String(repeating: "b", count: 1000)
        var validator = AllOfSameLen(inputs: [longString1, longString2])
        
        // Act
        let result = validator.check()
        
        // Assert
        XCTAssertTrue(result, "Very long strings of same length should pass validation")
        XCTAssertNil(validator.error, "No error should be set for valid long strings")
    }
    
    // TC008: Verify error is set when validation fails
    func testErrorIsSetWhenValidationFails() {
        // Arrange
        var validator = AllOfSameLen(inputs: ["a", "bb"])
        
        // Act
        let result = validator.check()
        
        // Assert
        XCTAssertFalse(result, "Validation should fail")
        XCTAssertNotNil(validator.error, "Error should be set after failed validation")
        
        // Verify the specific error type
        if let error = validator.error as? AllOfSameLenError {
            XCTAssertEqual(error, AllOfSameLenError.inputsHaveDifferentLengths, "Should set correct error type")
        } else {
            XCTFail("Error should be of type AllOfSameLenError")
        }
    }
    
    // TC009: Verify error is cleared when inputs are reset
    func testErrorIsClearedWhenInputsAreReset() {
        // Arrange
        var validator = AllOfSameLen(inputs: ["a", "bb"])
        
        // Act
        _ = validator.check() // This should set an error
        validator.setInputs(inputs: ["abc", "def"]) // This should clear the error
        
        // Assert
        XCTAssertNil(validator.error, "Error should be cleared when inputs are reset")
    }
    
    // TC010: Verify checkAndExec calls success callback
    func testCheckAndExecCallsSuccessCallback() {
        // Arrange
        var validator = AllOfSameLen(inputs: ["abc", "def"])
        var successCalled = false
        var failureCalled = false
        
        // Act
        validator.checkAndExec(
            onSuccess: { successCalled = true },
            onFail: { failureCalled = true }
        )
        
        // Assert
        XCTAssertTrue(successCalled, "Success callback should be called for valid inputs")
        XCTAssertFalse(failureCalled, "Failure callback should not be called for valid inputs")
    }
    
    // TC011: Verify checkAndExec calls failure callback
    func testCheckAndExecCallsFailureCallback() {
        // Arrange
        var validator = AllOfSameLen(inputs: ["a", "bb"])
        var successCalled = false
        var failureCalled = false
        
        // Act
        validator.checkAndExec(
            onSuccess: { successCalled = true },
            onFail: { failureCalled = true }
        )
        
        // Assert
        XCTAssertFalse(successCalled, "Success callback should not be called for invalid inputs")
        XCTAssertTrue(failureCalled, "Failure callback should be called for invalid inputs")
        XCTAssertNotNil(validator.error, "Error should be saved when failure callback is called")
    }
    
    // TC012: Verify ThrowableCheck doesn't throw on success
    func testThrowableCheckDoesNotThrowOnSuccess() {
        // Arrange
        var validator = AllOfSameLen(inputs: ["abc", "def"])
        
        // Act & Assert
        XCTAssertNoThrow(try validator.ThrowableCheck(), "ThrowableCheck should not throw for valid inputs")
    }
    
    // TC013: Verify ThrowableCheck throws on failure
    func testThrowableCheckThrowsOnFailure() {
        // Arrange
        var validator = AllOfSameLen(inputs: ["a", "bb"])
        
        // Act & Assert
        XCTAssertThrowsError(try validator.ThrowableCheck()) { error in
            XCTAssertTrue(error is AllOfSameLenError, "Should throw AllOfSameLenError")
            if let sameLenError = error as? AllOfSameLenError {
                XCTAssertEqual(sameLenError, AllOfSameLenError.inputsHaveDifferentLengths, "Should throw correct error case")
            }
        }
    }
    
    // TC014: Verify getError() returns correct error
    func testGetErrorReturnsCorrectError() {
        // Arrange
        var validator = AllOfSameLen(inputs: ["a", "bb"])
        
        // Act
        _ = validator.check() // This should set an error
        let retrievedError = validator.getError()
        
        // Assert
        XCTAssertNotNil(retrievedError, "getError() should return the error")
        if let error = retrievedError as? AllOfSameLenError {
            XCTAssertEqual(error, AllOfSameLenError.inputsHaveDifferentLengths, "Should return correct error type")
        } else {
            XCTFail("Retrieved error should be of type AllOfSameLenError")
        }
    }
    
    // TC015: Verify getError() returns nil when no error
    func testGetErrorReturnsNilWhenNoError() {
        // Arrange
        var validator = AllOfSameLen(inputs: ["abc", "def"])
        
        // Act
        _ = validator.check() // This should succeed
        let retrievedError = validator.getError()
        
        // Assert
        XCTAssertNil(retrievedError, "getError() should return nil when there's no error")
    }
    
    // TC016: Verify setInputs updates inputs correctly
    func testSetInputsUpdatesInputsCorrectly() {
        // Arrange
        var validator = AllOfSameLen()
        let newInputs = ["test", "data"]
        
        // Act
        validator.setInputs(inputs: newInputs)
        
        // Assert
        XCTAssertEqual(validator.inputs, newInputs, "setInputs should update the inputs property")
    }
    
    // TC017: Verify setInputs clears previous error
    func testSetInputsClearsPreviousError() {
        // Arrange
        var validator = AllOfSameLen(inputs: ["a", "bb"])
        
        // Act
        _ = validator.check() // This should set an error
        validator.setInputs(inputs: ["abc", "def"]) // This should clear the error
        
        // Assert
        XCTAssertNil(validator.error, "setInputs should clear previous error")
    }
    
    // TC018: Verify default initializer
    func testDefaultInitializer() {
        // Arrange & Act
        let validator = AllOfSameLen()
        
        // Assert
        XCTAssertTrue(validator.inputs.isEmpty, "Default initializer should create empty inputs array")
        XCTAssertNil(validator.error, "Default initializer should have no error")
    }
    
    // TC019: Verify parameterized initializer
    func testParameterizedInitializer() {
        // Arrange
        let testInputs = ["hello", "world"]
        
        // Act
        let validator = AllOfSameLen(inputs: testInputs)
        
        // Assert
        XCTAssertEqual(validator.inputs, testInputs, "Parameterized initializer should set inputs correctly")
        XCTAssertNil(validator.error, "Parameterized initializer should have no error initially")
    }
    
    // TC020: Verify multiple consecutive checks
    func testMultipleConsecutiveChecks() {
        // Arrange
        var validator = AllOfSameLen(inputs: ["a", "bb"])
        
        // Act
        let result1 = validator.check()
        let result2 = validator.check()
        
        // Assert
        XCTAssertFalse(result1, "First check should fail")
        XCTAssertFalse(result2, "Second check should also fail")
        XCTAssertNotNil(validator.error, "Error should remain set after multiple checks")
    }
    
    // MARK: - Additional Edge Cases
    
    // Test with single character strings
    func testSingleCharacterStrings() {
        // Arrange
        var validator = AllOfSameLen(inputs: ["a", "b", "c", "d"])
        
        // Act
        let result = validator.check()
        
        // Assert
        XCTAssertTrue(result, "Single character strings should pass validation")
    }
    
    // Test with whitespace strings
    func testWhitespaceStrings() {
        // Arrange
        var validator = AllOfSameLen(inputs: ["   ", "abc", "def"])
        
        // Act
        let result = validator.check()
        
        // Assert
        XCTAssertTrue(result, "Strings with same length including whitespace should pass")
    }
    
    // Test error persistence across multiple operations
    func testErrorPersistenceAcrossOperations() {
        // Arrange
        var validator = AllOfSameLen(inputs: ["a", "bb"])
        
        // Act
        _ = validator.check() // Set error
        _ = validator.getError() // Get error
        let errorAfterGet = validator.error
        
        // Assert
        XCTAssertNotNil(errorAfterGet, "Error should persist across multiple operations")
    }
}
