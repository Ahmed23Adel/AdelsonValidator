//
//  File.swift
//  AdelsonValidator
//
//  Created by ahmed on 06/07/2025.
//

import Foundation
@testable import AdelsonValidator
import XCTest

class StringContainsNNumbersTests: XCTestCase {
    
    // MARK: - Basic Validation Tests
    
    func testBasicValidationWithExactNumberCount() {
        // TC001: Verify basic validation with exact number count
        // Arrange
        var validator = StringContainsNNumbers(n: 3)
        
        // Act
        validator.setInput(input: "abc123")
        let result = validator.check()
        
        // Assert
        XCTAssertTrue(result, "Should return true when string contains exactly the required number of digits")
        XCTAssertNil(validator.getError(), "Error should be nil for successful validation")
    }
    
    func testValidationWithMoreNumbersThanRequired() {
        // TC002: Verify validation with more numbers than required
        // Arrange
        var validator = StringContainsNNumbers(n: 2)
        
        // Act
        validator.setInput(input: "a1b2c3d4")
        let result = validator.check()
        
        // Assert
        XCTAssertTrue(result, "Should return true when string contains more than required number of digits")
        XCTAssertNil(validator.getError(), "Error should be nil for successful validation")
    }
    
    func testValidationFailureWithFewerNumbers() {
        // TC003: Verify validation failure with fewer numbers
        // Arrange
        var validator = StringContainsNNumbers(n: 4)
        
        // Act
        validator.setInput(input: "abc12")
        let result = validator.check()
        
        // Assert
        XCTAssertFalse(result, "Should return false when string contains fewer than required number of digits")
        XCTAssertNotNil(validator.getError(), "Error should be set for failed validation")
        XCTAssertTrue(validator.getError() is StringContainsNNumbersError, "Error should be of correct type")
    }
    
    func testValidationWithNoNumbers() {
        // TC004: Verify validation failure with no numbers in string
        // Arrange
        var validator = StringContainsNNumbers(n: 1)
        
        // Act
        validator.setInput(input: "abcdef")
        let result = validator.check()
        
        // Assert
        XCTAssertFalse(result, "Should return false when string contains no digits")
        XCTAssertNotNil(validator.getError(), "Error should be set when no digits found")
    }
    
    // MARK: - Edge Cases
    
    func testValidationWithOnlyNumbers() {
        // TC005: Verify validation with only numbers
        // Arrange
        var validator = StringContainsNNumbers(n: 3)
        
        // Act
        validator.setInput(input: "12345")
        let result = validator.check()
        
        // Assert
        XCTAssertTrue(result, "Should return true when string contains only digits and meets requirement")
    }
    
    func testValidationWithEmptyString() {
        // TC006: Verify validation with empty string
        // Arrange
        var validator = StringContainsNNumbers(n: 1)
        
        // Act
        validator.setInput(input: "")
        let result = validator.check()
        
        // Assert
        XCTAssertFalse(result, "Should return false for empty string when digits are required")
        XCTAssertNotNil(validator.getError(), "Error should be set for empty string validation failure")
    }
    
    func testValidationWithZeroRequirement() {
        // TC007: Verify validation with zero requirement
        // Arrange
        var validator = StringContainsNNumbers(n: 0)
        
        // Act
        validator.setInput(input: "abc")
        let result = validator.check()
        
        // Assert
        XCTAssertTrue(result, "Should return true when zero digits are required")
    }
    
    func testValidationWithSingleCharacterNumber() {
        // TC008: Verify validation with single character number
        // Arrange
        var validator = StringContainsNNumbers(n: 1)
        
        // Act
        validator.setInput(input: "5")
        let result = validator.check()
        
        // Assert
        XCTAssertTrue(result, "Should return true for single digit when one digit is required")
    }
    
    func testValidationWithMixedSpecialCharacters() {
        // TC009: Verify validation with mixed special characters
        // Arrange
        var validator = StringContainsNNumbers(n: 2)
        
        // Act
        validator.setInput(input: "a!1@2#")
        let result = validator.check()
        
        // Assert
        XCTAssertTrue(result, "Should correctly identify digits among special characters")
    }
    
    // MARK: - Functional Tests
    
    func testCheckAndExecSuccessCallback() {
        // TC010: Verify checkAndExec success callback
        // Arrange
        var validator = StringContainsNNumbers(n: 2)
        validator.setInput(input: "ab12")
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
    }
    
    func testCheckAndExecFailureCallback() {
        // TC011: Verify checkAndExec failure callback
        // Arrange
        var validator = StringContainsNNumbers(n: 3)
        validator.setInput(input: "ab1")
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
    
    func testThrowableCheckSuccess() {
        // TC012: Verify ThrowableCheck success
        // Arrange
        var validator = StringContainsNNumbers(n: 1)
        validator.setInput(input: "a1")
        
        // Act & Assert
        XCTAssertNoThrow(try validator.ThrowableCheck(), "Should not throw for valid input")
    }
    
    func testThrowableCheckThrowsOnFailure() {
        // TC013: Verify ThrowableCheck throws on failure
        // Arrange
        var validator = StringContainsNNumbers(n: 2)
        validator.setInput(input: "a1")
        
        // Act & Assert
        XCTAssertThrowsError(try validator.ThrowableCheck()) { error in
            XCTAssertTrue(error is StringContainsNNumbersError, "Should throw StringContainsNNumbersError")
            if let specificError = error as? StringContainsNNumbersError {
                XCTAssertEqual(specificError, StringContainsNNumbersError.notContainsNNumbers)
            }
        }
    }
    
    func testSetInputUpdatesCorrectly() {
        // TC014: Verify setInput updates input correctly
        // Arrange
        var validator = StringContainsNNumbers(n: 1)
        let testInput = "test123"
        
        // Act
        validator.setInput(input: testInput)
        
        // Assert
        XCTAssertEqual(validator.input, testInput, "setInput should update the input property")
    }
    
    func testGetErrorReturnsCorrectError() {
        // TC015: Verify getError returns correct error
        // Arrange
        var validator = StringContainsNNumbers(n: 2)
        validator.setInput(input: "a")
        
        // Act
        _ = validator.check() // This will fail and set error
        let error = validator.getError()
        
        // Assert
        XCTAssertNotNil(error, "getError should return error after failed validation")
        XCTAssertTrue(error is StringContainsNNumbersError, "Error should be of correct type")
    }
    
    // MARK: - State Tests
    
    func testErrorIsNilInitially() {
        // TC016: Verify error is nil initially
        // Arrange & Act
        var validator = StringContainsNNumbers(n: 1)
        
        // Assert
        XCTAssertNil(validator.getError(), "Error should be nil for newly created validator")
    }
    
    func testErrorPersistsAfterFailedValidation() {
        // TC017: Verify error persists after failed validation
        // Arrange
        var validator = StringContainsNNumbers(n: 3)
        validator.setInput(input: "ab")
        
        // Act
        _ = validator.check() // First failed check
        let firstError = validator.getError()
        _ = validator.check() // Second failed check
        let secondError = validator.getError()
        
        // Assert
        XCTAssertNotNil(firstError, "Error should be set after first failed validation")
        XCTAssertNotNil(secondError, "Error should persist after second failed validation")
        XCTAssertTrue(firstError is StringContainsNNumbersError, "First error should be correct type")
        XCTAssertTrue(secondError is StringContainsNNumbersError, "Second error should be correct type")
    }
    
    // MARK: - Boundary Tests
    
    func testLargeNumberRequirement() {
        // TC019: Verify large number requirement
        // Arrange
        var validator = StringContainsNNumbers(n: 100)
        let inputWith50Numbers = String(repeating: "a1", count: 50) // Creates "a1a1a1..." with 50 numbers
        
        // Act
        validator.setInput(input: inputWith50Numbers)
        let result = validator.check()
        
        // Assert
        XCTAssertFalse(result, "Should return false when string has fewer numbers than large requirement")
        XCTAssertNotNil(validator.getError(), "Error should be set for failed validation")
    }
    
    func testVeryLongStringWithSufficientNumbers() {
        // TC020: Verify very long string with sufficient numbers
        // Arrange
        var validator = StringContainsNNumbers(n: 5)
        let longStringWith10Numbers = String(repeating: "abcde", count: 200) + "1234567890" // 1000+ chars with 10 numbers
        
        // Act
        validator.setInput(input: longStringWith10Numbers)
        let result = validator.check()
        
        // Assert
        XCTAssertTrue(result, "Should return true for very long string with sufficient numbers")
    }
    
    // MARK: - Bug Detection Tests
    
    func testCheckMethodCallsaveErrorOnFailure() {
        // This test verifies that check() properly calls saveError() on failure
        // This is important because the current implementation has a bug where
        // check() calls saveError() twice on failure (once in the else block, once in saveError())
        
        // Arrange
        var validator = StringContainsNNumbers(n: 5)
        validator.setInput(input: "abc")
        
        // Act
        let result = validator.check()
        
        // Assert
        XCTAssertFalse(result, "Should return false for insufficient numbers")
        XCTAssertNotNil(validator.getError(), "Error should be set after failed validation")
    }
    
    func testValidationWithNegativeRequirement() {
        // Edge case: What happens with negative n?
        // Arrange
        var validator = StringContainsNNumbers(n: -1)
        validator.setInput(input: "abc123")
        
        // Act
        let result = validator.check()
        
        // Assert
        XCTAssertTrue(result, "Should return true when negative numbers are required (any count >= -1)")
    }
    
    func testInputNotSetBeforeCheck() {
        // Test the behavior mentioned in the comment: checking before setInput
        // Arrange
        var validator = StringContainsNNumbers(n: 1)
        // Note: Not calling setInput, so input remains ""
        
        // Act
        let result = validator.check()
        
        // Assert
        XCTAssertFalse(result, "Should return false when checking empty default input")
        XCTAssertNotNil(validator.getError(), "Error should be set for failed validation")
    }
}

// MARK: - Test Extensions for Additional Validation

extension StringContainsNNumbersTests {
    
    func testProtocolConformance() {
        // Verify that StringContainsNNumbers properly conforms to SingleInputValidator
        let validator = StringContainsNNumbers(n: 1)
        
        // These should compile without issues if protocol conformance is correct
        XCTAssertTrue(validator.input is String, "Input should be String type")
        XCTAssertTrue(validator.error == nil, "Error should be nil initially")
    }
    
    func testAllProtocolMethodsAreImplemented() {
        // Verify all protocol methods work
        var validator = StringContainsNNumbers(n: 2)
        
        // Test all protocol methods
        validator.setInput(input: "test123")
        let checkResult = validator.check()
        let error = validator.getError()
        
        validator.checkAndExec(onSuccess: {}, onFail: {})
        
        do {
            try validator.ThrowableCheck()
        } catch {
            // Expected for this test case
        }
        
        // If we reach here, all methods are implemented
        XCTAssertTrue(true, "All protocol methods should be callable")
    }
}

// MARK: - Performance Tests

extension StringContainsNNumbersTests {
    
    func testPerformanceWithLargeString() {
        // Test performance with a very large string
        let largeString = String(repeating: "a1", count: 10000) // 20,000 characters
        var validator = StringContainsNNumbers(n: 100)
        
        measure {
            validator.setInput(input: largeString)
            _ = validator.check()
        }
    }
}
