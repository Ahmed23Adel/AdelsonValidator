//
//  File.swift
//  AdelsonValidator
//
//  Created by ahmed on 03/07/2025.
//

import Foundation
@testable import AdelsonValidator

import XCTest


class AllOfSameLenTests: XCTestCase {
    
    // MARK: - Test Cases for Basic Validation
    
    func testTC01_EmptyArray() {
        // Arrange: Create validator with empty array
        var validator = AllOfSameLen(inputs: [])
        
        // Act: Perform validation
        let result = validator.check()
        
        // Assert: Should return true for empty array (vacuous truth)
        XCTAssertTrue(result, "Empty array should pass validation (vacuous truth)")
        XCTAssertNil(validator.getError(), "No error should be set for empty array")
    }
    
    func testTC02_SingleString() {
        // Arrange: Create validator with single string
        var validator = AllOfSameLen(inputs: ["hello"])
        
        // Act: Perform validation
        let result = validator.check()
        
        // Assert: Should return true for single string
        XCTAssertTrue(result, "Single string should always pass validation")
        XCTAssertNil(validator.getError(), "No error should be set for valid case")
    }
    
    func testTC03_TwoStringsOfSameLength() {
        // Arrange: Create validator with two strings of equal length
        var validator = AllOfSameLen(inputs: ["hello", "world"])
        
        // Act: Perform validation
        let result = validator.check()
        
        // Assert: Should return true for strings of same length
        XCTAssertTrue(result, "Two strings of same length should pass validation")
        XCTAssertNil(validator.getError(), "No error should be set for valid case")
    }
    
    func testTC04_MultipleStringsOfSameLength() {
        // Arrange: Create validator with multiple strings of equal length
        var validator = AllOfSameLen(inputs: ["cat", "dog", "pig"])
        
        // Act: Perform validation
        let result = validator.check()
        
        // Assert: Should return true for all strings of same length
        XCTAssertTrue(result, "Multiple strings of same length should pass validation")
        XCTAssertNil(validator.getError(), "No error should be set for valid case")
    }
    
    func testTC05_StringsWithDifferentLengths() {
        // Arrange: Create validator with strings of different lengths
        var validator = AllOfSameLen(inputs: ["hello", "hi"])
        
        // Act: Perform validation
        let result = validator.check()
        
        // Assert: Should return false and set error
        XCTAssertFalse(result, "Strings of different lengths should fail validation")
        XCTAssertNotNil(validator.getError(), "Error should be set for invalid case")
        
        // Verify specific error type
        if let error = validator.getError() as? AllOfSameLenError {
            XCTAssertEqual(error, AllOfSameLenError.inputsHaveDifferentLengths)
        } else {
            XCTFail("Expected AllOfSameLenError.inputsHaveDifferentLengths")
        }
    }
    
    func testTC06_MixedLengthStrings() {
        // Arrange: Create validator with strings of various lengths
        var validator = AllOfSameLen(inputs: ["a", "bb", "ccc"])
        
        // Act: Perform validation
        let result = validator.check()
        
        // Assert: Should return false and set error
        XCTAssertFalse(result, "Mixed length strings should fail validation")
        XCTAssertNotNil(validator.getError(), "Error should be set for invalid case")
    }
    
    func testTC07_EmptyStrings() {
        // Arrange: Create validator with empty strings
        var validator = AllOfSameLen(inputs: ["", "", ""])
        
        // Act: Perform validation
        let result = validator.check()
        
        // Assert: Should return true for all empty strings
        XCTAssertTrue(result, "All empty strings should pass validation")
        XCTAssertNil(validator.getError(), "No error should be set for valid case")
    }
    
    func testTC08_MixOfEmptyAndNonEmpty() {
        // Arrange: Create validator with mix of empty and non-empty strings
        var validator = AllOfSameLen(inputs: ["", "hello"])
        
        // Act: Perform validation
        let result = validator.check()
        
        // Assert: Should return false and set error
        XCTAssertFalse(result, "Mix of empty and non-empty strings should fail validation")
        XCTAssertNotNil(validator.getError(), "Error should be set for invalid case")
    }
    
    // MARK: - Test Cases for checkAndExec Method
    
    func testTC09_CheckAndExecWithValidInputs() {
        // Arrange: Create validator with valid inputs and success/fail flags
        var validator = AllOfSameLen(inputs: ["abc", "def"])
        var successCalled = false
        var failCalled = false
        
        // Act: Execute checkAndExec
        validator.checkAndExec(
            onSuccess: { successCalled = true },
            onFail: { failCalled = true }
        )
        
        // Assert: Only success should be called
        XCTAssertTrue(successCalled, "onSuccess should be called for valid inputs")
        XCTAssertFalse(failCalled, "onFail should not be called for valid inputs")
        XCTAssertNil(validator.getError(), "No error should be set for valid case")
    }
    
    func testTC10_CheckAndExecWithInvalidInputs() {
        // Arrange: Create validator with invalid inputs and success/fail flags
        var validator = AllOfSameLen(inputs: ["a", "bb"])
        var successCalled = false
        var failCalled = false
        
        // Act: Execute checkAndExec
        validator.checkAndExec(
            onSuccess: { successCalled = true },
            onFail: { failCalled = true }
        )
        
        // Assert: Only fail should be called and error should be saved
        XCTAssertFalse(successCalled, "onSuccess should not be called for invalid inputs")
        XCTAssertTrue(failCalled, "onFail should be called for invalid inputs")
        XCTAssertNotNil(validator.getError(), "Error should be saved for invalid case")
    }
    
    // MARK: - Test Cases for ThrowableCheck Method
    
    func testTC11_ThrowableCheckWithValidInputs() {
        // Arrange: Create validator with valid inputs
        var validator = AllOfSameLen(inputs: ["test", "case"])
        
        // Act & Assert: Should not throw any exception
        XCTAssertNoThrow(try validator.ThrowableCheck(), "ThrowableCheck should not throw for valid inputs")
        XCTAssertNil(validator.getError(), "No error should be set for valid case")
    }
    
    func testTC12_ThrowableCheckWithInvalidInputs() {
        // Arrange: Create validator with invalid inputs
        var validator = AllOfSameLen(inputs: ["short", "longer"])
        
        // Act & Assert: Should throw AllOfSameLenError.inputsHaveDifferentLengths
        XCTAssertThrowsError(try validator.ThrowableCheck()) { error in
            XCTAssertTrue(error is AllOfSameLenError, "Should throw AllOfSameLenError")
            if let specificError = error as? AllOfSameLenError {
                XCTAssertEqual(specificError, AllOfSameLenError.inputsHaveDifferentLengths)
            }
        }
        XCTAssertNotNil(validator.getError(), "Error should be saved after throwing")
    }
    
    // MARK: - Test Cases for getError Method
    
    func testTC13_GetErrorAfterValidationFailure() {
        // Arrange: Create validator with invalid inputs
        var validator = AllOfSameLen(inputs: ["a", "bb"])
        
        // Act: Perform validation to set error, then get error
        _ = validator.check()
        let retrievedError = validator.getError()
        
        // Assert: Should return the specific error
        XCTAssertNotNil(retrievedError, "getError should return error after validation failure")
        XCTAssertTrue(retrievedError is AllOfSameLenError, "Should return AllOfSameLenError")
    }
    
    func testTC14_GetErrorBeforeAnyValidation() {
        // Arrange: Create fresh validator instance
        var validator = AllOfSameLen(inputs: ["test"])
        
        // Act: Get error without performing validation
        let retrievedError = validator.getError()
        
        // Assert: Should return nil
        XCTAssertNil(retrievedError, "getError should return nil before any validation")
    }
    
    // MARK: - Test Cases for Multiple Validation Calls
    
    func testTC15_MultipleValidationCalls() {
        // Arrange: Create validator with invalid inputs
        var validator = AllOfSameLen(inputs: ["short", "longer"])
        
        // Act: Call check multiple times
        let result1 = validator.check()
        let result2 = validator.check()
        let result3 = validator.check()
        
        // Assert: Should return consistent results
        XCTAssertFalse(result1, "First validation should fail")
        XCTAssertFalse(result2, "Second validation should fail")
        XCTAssertFalse(result3, "Third validation should fail")
        XCTAssertNotNil(validator.getError(), "Error should remain set")
    }
    
    // MARK: - Edge Cases and Boundary Tests
    
    func testLongStrings() {
        // Arrange: Create validator with very long strings of same length
        let longString1 = String(repeating: "a", count: 1000)
        let longString2 = String(repeating: "b", count: 1000)
        var validator = AllOfSameLen(inputs: [longString1, longString2])
        
        // Act: Perform validation
        let result = validator.check()
        
        // Assert: Should handle long strings correctly
        XCTAssertTrue(result, "Long strings of same length should pass validation")
    }
    
    func testUnicodeStrings() {
        // Arrange: Create validator with Unicode strings
        var validator = AllOfSameLen(inputs: ["🚀🌟", "🎉🎊"])
        
        // Act: Perform validation
        let result = validator.check()
        
        // Assert: Should handle Unicode correctly
        XCTAssertTrue(result, "Unicode strings of same length should pass validation")
    }
    
    func testErrorStateReset() {
        // Arrange: Create validator and cause error
        var validator = AllOfSameLen(inputs: ["a", "bb"])
        _ = validator.check() // This will set error
        
        // Act: Change inputs to valid ones and check again
        validator.inputs = ["xx", "yy"]
        let result = validator.check()
        
        // Assert: Should pass validation but error might still be set
        XCTAssertTrue(result, "Valid inputs should pass validation")
        // Note: This reveals another potential issue - error state isn't cleared on success
    }
}
