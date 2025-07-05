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
class AllOfSameValueTests: XCTestCase {
    
    // MARK: - TC01: Empty Array Validation
    func testEmptyArrayValidation() {
        // Arrange: Create validator with empty array
        var validator = AllOfSameValue()
        
        // Act: Check validation
        let result = validator.check()
        
        // Assert: Empty array should be considered valid
        XCTAssertTrue(result, "Empty array should pass validation")
        XCTAssertNil(validator.error, "Error should be nil for empty array")
    }
    
    // MARK: - TC02: Single Element Validation
    func testSingleElementValidation() {
        // Arrange: Create validator with single element
        var validator = AllOfSameValue(inputs: ["test"])
        
        // Act: Check validation
        let result = validator.check()
        
        // Assert: Single element should always pass
        XCTAssertTrue(result, "Single element should pass validation")
        XCTAssertNil(validator.error, "Error should be nil for single element")
    }
    
    // MARK: - TC03: Identical Elements Validation
    func testIdenticalElementsValidation() {
        // Arrange: Create validator with identical elements
        var validator = AllOfSameValue(inputs: ["apple", "apple", "apple"])
        
        // Act: Check validation
        let result = validator.check()
        
        // Assert: Identical elements should pass
        XCTAssertTrue(result, "Identical elements should pass validation")
        XCTAssertNil(validator.error, "Error should be nil for identical elements")
    }
    
    // MARK: - TC04: Different Elements Validation
    func testDifferentElementsValidation() {
        // Arrange: Create validator with different elements
        var validator = AllOfSameValue(inputs: ["apple", "banana"])
        
        // Act: Check validation
        let result = validator.check()
        
        // Assert: Different elements should fail
        XCTAssertFalse(result, "Different elements should fail validation")
        XCTAssertNotNil(validator.error, "Error should be set for different elements")
    }
    
    // MARK: - TC05: Error State After Failed Validation
    func testErrorStateAfterFailedValidation() {
        // Arrange: Create validator with different elements
        var validator = AllOfSameValue(inputs: ["a", "b"])
        
        // Act: Perform validation
        let result = validator.check()
        
        // Assert: Error should be properly set
        XCTAssertFalse(result, "Validation should fail")
        XCTAssertNotNil(validator.error, "Error should be set after failed validation")
        
        // Verify error type
        if let error = validator.error as? AllOfSameValueError {
            XCTAssertEqual(error, AllOfSameValueError.inputsHaveDifferentValues, "Should have correct error type")
        } else {
            XCTFail("Error should be of type AllOfSameValueError")
        }
    }
    
    // MARK: - TC06: Error Clearing When Inputs Reset
    func testErrorClearingWhenInputsReset() {
        // Arrange: Create validator and set it to fail
        var validator = AllOfSameValue(inputs: ["different", "values"])
        _ = validator.check() // This will set error
        
        // Act: Reset inputs to valid values
        validator.setInputs(inputs: ["same", "same"])
        
        // Assert: Error should be cleared
        XCTAssertNil(validator.error, "Error should be cleared when inputs are reset")
        
        // Verify validation now passes
        let result = validator.check()
        XCTAssertTrue(result, "Validation should pass after reset")
    }
    
    // MARK: - TC07: CheckAndExec Success Path
    func testCheckAndExecSuccessPath() {
        // Arrange: Create validator with valid inputs
        var validator = AllOfSameValue(inputs: ["test", "test"])
        var successCalled = false
        var failCalled = false
        
        // Act: Execute checkAndExec
        validator.checkAndExec(
            onSuccess: { successCalled = true },
            onFail: { failCalled = true }
        )
        
        // Assert: Only success callback should be called
        XCTAssertTrue(successCalled, "Success callback should be called for valid inputs")
        XCTAssertFalse(failCalled, "Fail callback should not be called for valid inputs")
    }
    
    // MARK: - TC08: CheckAndExec Failure Path
    func testCheckAndExecFailurePath() {
        // Arrange: Create validator with invalid inputs
        var validator = AllOfSameValue(inputs: ["a", "b"])
        var successCalled = false
        var failCalled = false
        
        // Act: Execute checkAndExec
        validator.checkAndExec(
            onSuccess: { successCalled = true },
            onFail: { failCalled = true }
        )
        
        // Assert: Only fail callback should be called
        XCTAssertFalse(successCalled, "Success callback should not be called for invalid inputs")
        XCTAssertTrue(failCalled, "Fail callback should be called for invalid inputs")
        XCTAssertNotNil(validator.error, "Error should be saved after failed checkAndExec")
    }
    
    // MARK: - TC09: ThrowableCheck Exception Path
    func testThrowableCheckExceptionPath() {
        // Arrange: Create validator with invalid inputs
        var validator = AllOfSameValue(inputs: ["x", "y"])
        
        // Act & Assert: ThrowableCheck should throw
        XCTAssertThrowsError(try validator.ThrowableCheck()) { error in
            XCTAssertTrue(error is AllOfSameValueError, "Should throw AllOfSameValueError")
            if let specificError = error as? AllOfSameValueError {
                XCTAssertEqual(specificError, AllOfSameValueError.inputsHaveDifferentValues, "Should throw correct error type")
            }
        }
        
        // Verify error is saved
        XCTAssertNotNil(validator.error, "Error should be saved after ThrowableCheck")
    }
    
    // MARK: - TC10: ThrowableCheck Success Path
    func testThrowableCheckSuccessPath() {
        // Arrange: Create validator with valid inputs
        var validator = AllOfSameValue(inputs: ["same", "same"])
        
        // Act & Assert: ThrowableCheck should not throw
        XCTAssertNoThrow(try validator.ThrowableCheck(), "ThrowableCheck should not throw for valid inputs")
    }
    
    // MARK: - TC11: GetError Returns Correct Error Type
    func testGetErrorReturnsCorrectErrorType() {
        // Arrange: Create validator and make it fail
        var validator = AllOfSameValue(inputs: ["diff", "erent"])
        _ = validator.check()
        
        // Act: Get error
        let returnedError = validator.getError()
        
        // Assert: Error should be correct type
        XCTAssertNotNil(returnedError, "getError should return non-nil error")
        XCTAssertTrue(returnedError is AllOfSameValueError, "getError should return AllOfSameValueError")
        if let specificError = returnedError as? AllOfSameValueError {
            XCTAssertEqual(specificError, AllOfSameValueError.inputsHaveDifferentValues, "Should return correct error case")
        }
    }
    
    // MARK: - TC12: Case Sensitivity
    func testCaseSensitivity() {
        // Arrange: Create validator with different cases
        var validator = AllOfSameValue(inputs: ["Test", "test"])
        
        // Act: Check validation
        let result = validator.check()
        
        // Assert: Different cases should fail validation
        XCTAssertFalse(result, "Different cases should fail validation (case sensitive)")
        XCTAssertNotNil(validator.error, "Error should be set for case differences")
    }
    
    // MARK: - TC13: Whitespace Handling
    func testWhitespaceHandling() {
        // Arrange: Create validator with whitespace differences
        var validator = AllOfSameValue(inputs: ["test ", "test"])
        
        // Act: Check validation
        let result = validator.check()
        
        // Assert: Whitespace differences should fail validation
        XCTAssertFalse(result, "Whitespace differences should fail validation")
        XCTAssertNotNil(validator.error, "Error should be set for whitespace differences")
    }
    
    // MARK: - TC14: Empty String Handling
    func testEmptyStringHandling() {
        // Arrange: Create validator with empty strings
        var validator = AllOfSameValue(inputs: ["", ""])
        
        // Act: Check validation
        let result = validator.check()
        
        // Assert: Empty strings should be considered equal
        XCTAssertTrue(result, "Empty strings should be considered equal")
        XCTAssertNil(validator.error, "Error should be nil for identical empty strings")
    }
    
    // MARK: - TC15: Large Array Performance
    func testLargeArrayPerformance() {
        // Arrange: Create validator with large array of identical values
        let largeArray = Array(repeating: "identical", count: 1000)
        var validator = AllOfSameValue(inputs: largeArray)
        
        // Act: Measure performance
        measure {
            let result = validator.check()
            XCTAssertTrue(result, "Large array of identical values should pass")
        }
        
        // Assert: Should handle large arrays efficiently
        XCTAssertNil(validator.error, "Error should be nil for large identical array")
    }
    
    // MARK: - Additional Edge Cases
    
    // Test mixed empty and non-empty strings
    func testMixedEmptyAndNonEmptyStrings() {
        // Arrange: Create validator with mixed empty and non-empty
        var validator = AllOfSameValue(inputs: ["", "test"])
        
        // Act: Check validation
        let result = validator.check()
        
        // Assert: Should fail validation
        XCTAssertFalse(result, "Mixed empty and non-empty strings should fail")
        XCTAssertNotNil(validator.error, "Error should be set for mixed empty/non-empty")
    }
    
    // Test state preservation across multiple checks
    func testStatePreservationAcrossChecks() {
        // Arrange: Create validator with invalid inputs
        var validator = AllOfSameValue(inputs: ["a", "b"])
        
        // Act: Check multiple times
        let result1 = validator.check()
        let result2 = validator.check()
        
        // Assert: Results should be consistent
        XCTAssertFalse(result1, "First check should fail")
        XCTAssertFalse(result2, "Second check should fail")
        XCTAssertNotNil(validator.error, "Error should persist across checks")
    }
    
    // Test initialization states
    func testInitializationStates() {
        // Test parameterized init
        let validator1 = AllOfSameValue(inputs: ["test"])
        XCTAssertEqual(validator1.inputs.count, 1, "Parameterized init should set inputs")
        XCTAssertNil(validator1.error, "Initial error should be nil")
        
        // Test default init
        let validator2 = AllOfSameValue()
        XCTAssertEqual(validator2.inputs.count, 0, "Default init should create empty inputs")
        XCTAssertNil(validator2.error, "Initial error should be nil")
    }
}
