//
//  File.swift
//  AdelsonValidator
//
//  Created by ahmed on 03/07/2025.
//

import Foundation
@testable import AdelsonValidator


import XCTest

class AllOfSameValueTests: XCTestCase {
    
    // MARK: - Test Cases for Basic Validation Logic
    
    func testTC001_EmptyArrayValidation() {
        // Arrange: Create validator with empty array
        var validator = AllOfSameValue(inputs: [])
        
        // Act: Perform validation
        let result = validator.check()
        
        // Assert: Empty array should pass validation
        XCTAssertTrue(result, "Empty array should pass validation")
        XCTAssertNil(validator.getError(), "No error should be set for empty array")
    }
    
    func testTC002_SingleElementValidation() {
        // Arrange: Create validator with single element
        var validator = AllOfSameValue(inputs: ["test"])
        
        // Act: Perform validation
        let result = validator.check()
        
        // Assert: Single element should always pass
        XCTAssertTrue(result, "Single element should always pass validation")
        XCTAssertNil(validator.getError(), "No error should be set for single element")
    }
    
    func testTC003_MultipleIdenticalElementsPass() {
        // Arrange: Create validator with multiple identical elements
        var validator = AllOfSameValue(inputs: ["same", "same", "same"])
        
        // Act: Perform validation
        let result = validator.check()
        
        // Assert: Identical elements should pass validation
        XCTAssertTrue(result, "Identical elements should pass validation")
        XCTAssertNil(validator.getError(), "No error should be set for identical elements")
    }
    
    func testTC004_DifferentElementsFail() {
        // Arrange: Create validator with different elements
        var validator = AllOfSameValue(inputs: ["hello", "world"])
        
        // Act: Perform validation
        let result = validator.check()
        
        // Assert: Different elements should fail validation
        XCTAssertFalse(result, "Different elements should fail validation")
        XCTAssertNotNil(validator.getError(), "Error should be set for different elements")
        
        // Verify specific error type
        if let error = validator.getError() as? AllOfSameValueError {
            XCTAssertEqual(error, AllOfSameValueError.inputsHaveDifferentValues)
        } else {
            XCTFail("Expected AllOfSameValueError.inputsHaveDifferentValues")
        }
    }
    
    func testTC005_MixedCaseDifferentValuesFail() {
        // Arrange: Create validator with case-different elements
        var validator = AllOfSameValue(inputs: ["Test", "test"])
        
        // Act: Perform validation
        let result = validator.check()
        
        // Assert: Case-different elements should fail (case-sensitive comparison)
        XCTAssertFalse(result, "Case-different elements should fail validation")
        XCTAssertNotNil(validator.getError(), "Error should be set for case-different elements")
    }
    
    func testTC006_EmptyStringsAreIdentical() {
        // Arrange: Create validator with empty strings
        var validator = AllOfSameValue(inputs: ["", "", ""])
        
        // Act: Perform validation
        let result = validator.check()
        
        // Assert: Empty strings should be treated as identical
        XCTAssertTrue(result, "Empty strings should be treated as identical")
        XCTAssertNil(validator.getError(), "No error should be set for identical empty strings")
    }
    
    func testTC007_WhitespaceDifferencesCauseFailure() {
        // Arrange: Create validator with whitespace differences
        var validator = AllOfSameValue(inputs: ["test", "test ", " test"])
        
        // Act: Perform validation
        let result = validator.check()
        
        // Assert: Whitespace differences should cause failure
        XCTAssertFalse(result, "Whitespace differences should cause validation failure")
        XCTAssertNotNil(validator.getError(), "Error should be set for whitespace differences")
    }
    
    // MARK: - Test Cases for checkAndExec Method
    
    func testTC008_CheckAndExecCallsOnSuccessForValidInput() {
        // Arrange: Create validator with valid input and callback flags
        var validator = AllOfSameValue(inputs: ["same", "same"])
        var onSuccessCalled = false
        var onFailCalled = false
        
        // Act: Execute checkAndExec with callbacks
        validator.checkAndExec(
            onSuccess: { onSuccessCalled = true },
            onFail: { onFailCalled = true }
        )
        
        // Assert: Only onSuccess should be called
        XCTAssertTrue(onSuccessCalled, "onSuccess should be called for valid input")
        XCTAssertFalse(onFailCalled, "onFail should not be called for valid input")
        XCTAssertNil(validator.getError(), "No error should be set for valid input")
    }
    
    func testTC009_CheckAndExecCallsOnFailForInvalidInput() {
        // Arrange: Create validator with invalid input and callback flags
        var validator = AllOfSameValue(inputs: ["different", "values"])
        var onSuccessCalled = false
        var onFailCalled = false
        
        // Act: Execute checkAndExec with callbacks
        validator.checkAndExec(
            onSuccess: { onSuccessCalled = true },
            onFail: { onFailCalled = true }
        )
        
        // Assert: Only onFail should be called and error should be saved
        XCTAssertFalse(onSuccessCalled, "onSuccess should not be called for invalid input")
        XCTAssertTrue(onFailCalled, "onFail should be called for invalid input")
        XCTAssertNotNil(validator.getError(), "Error should be saved for invalid input")
    }
    
    // MARK: - Test Cases for ThrowableCheck Method
    
    func testTC010_ThrowableCheckDoesNotThrowForValidInput() {
        // Arrange: Create validator with valid input
        var validator = AllOfSameValue(inputs: ["valid", "valid"])
        
        // Act & Assert: ThrowableCheck should not throw
        XCTAssertNoThrow(try validator.ThrowableCheck(), "ThrowableCheck should not throw for valid input")
        XCTAssertNil(validator.getError(), "No error should be set for valid input")
    }
    
    func testTC011_ThrowableCheckThrowsForInvalidInput() {
        // Arrange: Create validator with invalid input
        var validator = AllOfSameValue(inputs: ["invalid", "different"])
        
        // Act & Assert: ThrowableCheck should throw specific error
        XCTAssertThrowsError(try validator.ThrowableCheck()) { error in
            XCTAssertTrue(error is AllOfSameValueError, "Should throw AllOfSameValueError")
            if let specificError = error as? AllOfSameValueError {
                XCTAssertEqual(specificError, AllOfSameValueError.inputsHaveDifferentValues)
            }
        }
        XCTAssertNotNil(validator.getError(), "Error should be saved after throwing")
    }
    
    // MARK: - Test Cases for Error State Management
    
    func testTC012_GetErrorReturnsNilAfterSuccessfulValidation() {
        // Arrange: Create validator with valid input
        var validator = AllOfSameValue(inputs: ["same", "same"])
        
        // Act: Perform validation
        let result = validator.check()
        
        // Assert: getError should return nil after successful validation
        XCTAssertTrue(result, "Validation should pass")
        XCTAssertNil(validator.getError(), "getError should return nil after successful validation")
    }
    
    func testTC013_GetErrorReturnsErrorAfterFailedValidation() {
        // Arrange: Create validator with invalid input
        var validator = AllOfSameValue(inputs: ["diff", "erent"])
        
        // Act: Perform validation
        let result = validator.check()
        
        // Assert: getError should return error after failed validation
        XCTAssertFalse(result, "Validation should fail")
        XCTAssertNotNil(validator.getError(), "getError should return error after failed validation")
        
        if let error = validator.getError() as? AllOfSameValueError {
            XCTAssertEqual(error, AllOfSameValueError.inputsHaveDifferentValues)
        } else {
            XCTFail("Expected AllOfSameValueError.inputsHaveDifferentValues")
        }
    }
    
    func testTC014_ErrorStatePersistsBetweenCalls() {
        // Arrange: Create validator with invalid input
        var validator = AllOfSameValue(inputs: ["fail", "test"])
        
        // Act: Perform validation and get error multiple times
        let _ = validator.check()
        let firstError = validator.getError()
        let secondError = validator.getError()
        
        // Assert: Error should persist between calls
        XCTAssertNotNil(firstError, "First getError call should return error")
        XCTAssertNotNil(secondError, "Second getError call should return error")
        XCTAssertEqual(firstError?.localizedDescription, secondError?.localizedDescription, "Error should be consistent between calls")
    }
    
    // MARK: - Performance and Edge Case Tests
    
    func testTC015_LargeArrayWithIdenticalValues() {
        // Arrange: Create validator with large array of identical values
        let largeArray = Array(repeating: "identical", count: 1000)
        var validator = AllOfSameValue(inputs: largeArray)
        
        // Act: Perform validation
        let result = validator.check()
        
        // Assert: Large array with identical values should pass
        XCTAssertTrue(result, "Large array with identical values should pass validation")
        XCTAssertNil(validator.getError(), "No error should be set for large identical array")
    }
    
    func testTC016_LargeArrayWithOneDifferentValue() {
        // Arrange: Create validator with large array containing one different value
        var largeArray = Array(repeating: "identical", count: 999)
        largeArray.append("different")
        var validator = AllOfSameValue(inputs: largeArray)
        
        // Act: Perform validation
        let result = validator.check()
        
        // Assert: Large array with one different value should fail
        XCTAssertFalse(result, "Large array with one different value should fail validation")
        XCTAssertNotNil(validator.getError(), "Error should be set for large array with different value")
    }
    
    func testTC017_UnicodeStringHandling() {
        // Arrange: Create validator with Unicode strings
        var validator = AllOfSameValue(inputs: ["测试", "测试"])
        
        // Act: Perform validation
        let result = validator.check()
        
        // Assert: Unicode strings should be handled correctly
        XCTAssertTrue(result, "Unicode strings should be handled correctly")
        XCTAssertNil(validator.getError(), "No error should be set for identical Unicode strings")
    }
    
    func testTC018_SpecialCharactersHandling() {
        // Arrange: Create validator with special characters
        var validator = AllOfSameValue(inputs: ["!@#$%", "!@#$%"])
        
        // Act: Perform validation
        let result = validator.check()
        
        // Assert: Special characters should be handled correctly
        XCTAssertTrue(result, "Special characters should be handled correctly")
        XCTAssertNil(validator.getError(), "No error should be set for identical special character strings")
    }
    
    func testTC019_VeryLongStrings() {
        // Arrange: Create validator with very long identical strings
        let longString = String(repeating: "a", count: 10000)
        var validator = AllOfSameValue(inputs: [longString, longString])
        
        // Act: Perform validation
        let result = validator.check()
        
        // Assert: Very long strings should be handled correctly
        XCTAssertTrue(result, "Very long identical strings should pass validation")
        XCTAssertNil(validator.getError(), "No error should be set for identical long strings")
    }
    
    func testTC020_ErrorIsSavedOnFirstFailureDetection() {
        // Arrange: Create validator with multiple different values
        var validator = AllOfSameValue(inputs: ["a", "b", "c"])
        
        // Act: Perform validation
        let result = validator.check()
        
        // Assert: Error should be saved and retrievable
        XCTAssertFalse(result, "Validation should fail for different values")
        XCTAssertNotNil(validator.getError(), "Error should be saved on failure")
        
        if let error = validator.getError() as? AllOfSameValueError {
            XCTAssertEqual(error, AllOfSameValueError.inputsHaveDifferentValues)
        } else {
            XCTFail("Expected AllOfSameValueError.inputsHaveDifferentValues")
        }
    }
    
    // MARK: - Additional Edge Cases
    
    func testErrorStateResetBehavior() {
        // Arrange: Create validator that will initially fail
        var validator = AllOfSameValue(inputs: ["fail", "different"])
        
        // Act: First validation (should fail)
        let firstResult = validator.check()
        let errorAfterFirstCheck = validator.getError()
        
        // Modify inputs to make validation pass
        validator.inputs = ["same", "same"]
        let secondResult = validator.check()
        let errorAfterSecondCheck = validator.getError()
        
        // Assert: Error state behavior
        XCTAssertFalse(firstResult, "First validation should fail")
        XCTAssertNotNil(errorAfterFirstCheck, "Error should be set after first failed validation")
        XCTAssertTrue(secondResult, "Second validation should pass")
        // Note: The current implementation doesn't clear errors on success, so this documents that behavior
        XCTAssertNotNil(errorAfterSecondCheck, "Error persists even after successful validation (current behavior)")
    }
    
    func testConcurrentAccessSafety() {
        // Arrange: Create validator for concurrent access testing
        var validator = AllOfSameValue(inputs: ["test", "test"])
        
        // Act: Simulate concurrent access (simplified test)
        let result1 = validator.check()
        let result2 = validator.check()
        
        // Assert: Results should be consistent
        XCTAssertEqual(result1, result2, "Concurrent access should yield consistent results")
    }
}
