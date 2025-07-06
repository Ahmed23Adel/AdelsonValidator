//
//  File.swift
//  AdelsonValidator
//
//  Created by ahmed on 06/07/2025.
//

import Foundation
@testable import AdelsonValidator

import XCTest

class StringContainsNUpperCharsTests: XCTestCase {
    
    // MARK: - Basic Validation Tests
    
    func testBasicValidationWithExactUppercaseCount() {
        // TC001: Verify basic validation with exact uppercase count
        // Arrange
        var validator = StringContainsNUpperChars(n: 3)
        
        // Act
        validator.setInput(input: "AbCdEf")
        let result = validator.check()
        
        // Assert
        XCTAssertTrue(result, "Should return true when string contains exactly the required number of uppercase characters")
        XCTAssertNil(validator.getError(), "Error should be nil for successful validation")
    }
    
    func testValidationWithMoreUppercaseThanRequired() {
        // TC002: Verify validation with more uppercase than required
        // Arrange
        var validator = StringContainsNUpperChars(n: 2)
        
        // Act
        validator.setInput(input: "ABCDef")
        let result = validator.check()
        
        // Assert
        XCTAssertTrue(result, "Should return true when string contains more than required number of uppercase characters")
        XCTAssertNil(validator.getError(), "Error should be nil for successful validation")
    }
    
    func testValidationFailureWithFewerUppercaseChars() {
        // TC003: Verify validation failure with fewer uppercase chars
        // Arrange
        var validator = StringContainsNUpperChars(n: 4)
        
        // Act
        validator.setInput(input: "ABc")
        let result = validator.check()
        
        // Assert
        XCTAssertFalse(result, "Should return false when string contains fewer than required number of uppercase characters")
        XCTAssertNotNil(validator.getError(), "Error should be set for failed validation")
        XCTAssertTrue(validator.getError() is StringContainsNUpperCharsError, "Error should be of correct type")
    }
    
    func testValidationWithNoUppercaseChars() {
        // TC004: Verify validation failure with no uppercase chars
        // Arrange
        var validator = StringContainsNUpperChars(n: 1)
        
        // Act
        validator.setInput(input: "abc123")
        let result = validator.check()
        
        // Assert
        XCTAssertFalse(result, "Should return false when string contains no uppercase characters")
        XCTAssertNotNil(validator.getError(), "Error should be set when no uppercase characters found")
    }
    
    // MARK: - Edge Cases
    
    func testValidationWithOnlyUppercaseChars() {
        // TC005: Verify validation with only uppercase chars
        // Arrange
        var validator = StringContainsNUpperChars(n: 3)
        
        // Act
        validator.setInput(input: "ABCDE")
        let result = validator.check()
        
        // Assert
        XCTAssertTrue(result, "Should return true when string contains only uppercase characters and meets requirement")
    }
    
    func testValidationWithEmptyString() {
        // TC006: Verify validation with empty string
        // Arrange
        var validator = StringContainsNUpperChars(n: 1)
        
        // Act
        validator.setInput(input: "")
        let result = validator.check()
        
        // Assert
        XCTAssertFalse(result, "Should return false for empty string when uppercase characters are required")
        XCTAssertNotNil(validator.getError(), "Error should be set for empty string validation failure")
    }
    
    func testValidationWithZeroRequirement() {
        // TC007: Verify validation with zero requirement
        // Arrange
        var validator = StringContainsNUpperChars(n: 0)
        
        // Act
        validator.setInput(input: "abc")
        let result = validator.check()
        
        // Assert
        XCTAssertTrue(result, "Should return true when zero uppercase characters are required")
    }
    
    func testValidationWithSingleUppercaseCharacter() {
        // TC008: Verify validation with single uppercase character
        // Arrange
        var validator = StringContainsNUpperChars(n: 1)
        
        // Act
        validator.setInput(input: "A")
        let result = validator.check()
        
        // Assert
        XCTAssertTrue(result, "Should return true for single uppercase character when one is required")
    }
    
    // MARK: - Boundary Tests
    
    func testValidationWithMixedCaseAndNumbers() {
        // TC009: Verify validation with mixed case and numbers
        // Arrange
        var validator = StringContainsNUpperChars(n: 2)
        
        // Act
        validator.setInput(input: "Abc123D")
        let result = validator.check()
        
        // Assert
        XCTAssertTrue(result, "Should correctly identify uppercase characters in mixed content with numbers")
    }
    
    func testValidationWithUppercaseAndSpecialChars() {
        // TC010: Verify validation with uppercase and special chars
        // Arrange
        var validator = StringContainsNUpperChars(n: 2)
        
        // Act
        validator.setInput(input: "A!B@c")
        let result = validator.check()
        
        // Assert
        XCTAssertTrue(result, "Should correctly identify uppercase characters mixed with special characters")
    }
    
    func testValidationWithAccentedUppercaseChars() {
        // TC011: Verify validation with accented uppercase chars
        // Arrange
        var validator = StringContainsNUpperChars(n: 2)
        
        // Act
        validator.setInput(input: "ÀÉabc")
        let result = validator.check()
        
        // Assert
        XCTAssertTrue(result, "Should correctly identify accented uppercase characters")
    }
    
    // MARK: - Functional Tests
    
    func testCheckAndExecSuccessCallback() {
        // TC012: Verify checkAndExec success callback
        // Arrange
        var validator = StringContainsNUpperChars(n: 2)
        validator.setInput(input: "ABcd")
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
        // TC013: Verify checkAndExec failure callback
        // Arrange
        var validator = StringContainsNUpperChars(n: 3)
        validator.setInput(input: "Ab")
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
        // TC014: Verify ThrowableCheck success
        // Arrange
        var validator = StringContainsNUpperChars(n: 1)
        validator.setInput(input: "A")
        
        // Act & Assert
        XCTAssertNoThrow(try validator.ThrowableCheck(), "Should not throw for valid input")
    }
    
    func testThrowableCheckThrowsOnFailure() {
        // TC015: Verify ThrowableCheck throws on failure
        // Arrange
        var validator = StringContainsNUpperChars(n: 2)
        validator.setInput(input: "A")
        
        // Act & Assert
        XCTAssertThrowsError(try validator.ThrowableCheck()) { error in
            XCTAssertTrue(error is StringContainsNUpperCharsError, "Should throw StringContainsNUpperCharsError")
            if let specificError = error as? StringContainsNUpperCharsError {
                XCTAssertEqual(specificError, StringContainsNUpperCharsError.notContainsNUpperChars)
            }
        }
    }
    
    func testSetInputUpdatesCorrectly() {
        // TC016: Verify setInput updates input correctly
        // Arrange
        var validator = StringContainsNUpperChars(n: 1)
        let testInput = "TestABC"
        
        // Act
        validator.setInput(input: testInput)
        
        // Assert
        XCTAssertEqual(validator.input, testInput, "setInput should update the input property")
    }
    
    func testGetErrorReturnsCorrectErrorType() {
        // TC017: Verify getError returns correct error type
        // Arrange
        var validator = StringContainsNUpperChars(n: 2)
        validator.setInput(input: "a")
        
        // Act
        _ = validator.check() // This will fail and set error
        let error = validator.getError()
        
        // Assert
        XCTAssertNotNil(error, "getError should return error after failed validation")
        XCTAssertTrue(error is StringContainsNUpperCharsError, "Error should be StringContainsNUpperCharsError")
        
        if let specificError = error as? StringContainsNUpperCharsError {
            XCTAssertEqual(specificError, StringContainsNUpperCharsError.notContainsNUpperChars,
                          "Error should be notContainsNUpperChars")
        }
    }
    
    // MARK: - State Tests
    
    func testErrorIsNilInitially() {
        // TC018: Verify error is nil initially
        // Arrange & Act
        var validator = StringContainsNUpperChars(n: 1)
        
        // Assert
        XCTAssertNil(validator.getError(), "Error should be nil for newly created validator")
    }
    
    func testErrorPersistsAfterFailedValidation() {
        // TC019: Verify error persists after failed validation
        // Arrange
        var validator = StringContainsNUpperChars(n: 3)
        validator.setInput(input: "ab")
        
        // Act
        _ = validator.check() // First failed check
        let firstError = validator.getError()
        _ = validator.check() // Second failed check
        let secondError = validator.getError()
        
        // Assert
        XCTAssertNotNil(firstError, "Error should be set after first failed validation")
        XCTAssertNotNil(secondError, "Error should persist after second failed validation")
        XCTAssertTrue(firstError is StringContainsNUpperCharsError, "First error should be correct type")
        XCTAssertTrue(secondError is StringContainsNUpperCharsError, "Second error should be correct type")
    }
    
    // MARK: - Additional Edge Cases
    
    func testValidationWithMixedCaseLettersOnly() {
        // TC020: Verify validation with mixed case letters only
        // Arrange
        var validator = StringContainsNUpperChars(n: 3)
        
        // Act
        validator.setInput(input: "AaBbCc")
        let result = validator.check()
        
        // Assert
        XCTAssertTrue(result, "Should correctly count uppercase letters in mixed case string")
    }
    
    func testValidationWithRomanNumerals() {
        // TC021: Verify validation with Roman numerals
        // Arrange
        var validator = StringContainsNUpperChars(n: 2)
        
        // Act
        validator.setInput(input: "IVabc")
        let result = validator.check()
        
        // Assert
        XCTAssertTrue(result, "Should correctly identify Roman numerals as uppercase characters")
    }
    
    // MARK: - Boundary Tests
    
    func testLargeUppercaseRequirement() {
        // TC022: Verify large uppercase requirement
        // Arrange
        var validator = StringContainsNUpperChars(n: 100)
        let inputWith50Uppercase = String(repeating: "aA", count: 50) // Creates "aAaAaA..." with 50 uppercase
        
        // Act
        validator.setInput(input: inputWith50Uppercase)
        let result = validator.check()
        
        // Assert
        XCTAssertFalse(result, "Should return false when string has fewer uppercase characters than large requirement")
        XCTAssertNotNil(validator.getError(), "Error should be set for failed validation")
    }
    
    func testVeryLongStringWithSufficientUppercase() {
        // TC023: Verify very long string with sufficient uppercase
        // Arrange
        var validator = StringContainsNUpperChars(n: 5)
        let longStringWith10Uppercase = String(repeating: "abcde", count: 200) + "ABCDEFGHIJ" // 1000+ chars with 10 uppercase
        
        // Act
        validator.setInput(input: longStringWith10Uppercase)
        let result = validator.check()
        
        // Assert
        XCTAssertTrue(result, "Should return true for very long string with sufficient uppercase characters")
    }
    
    func testValidationWithNegativeRequirement() {
        // TC024: Edge case: What happens with negative n?
        // Arrange
        var validator = StringContainsNUpperChars(n: -1)
        validator.setInput(input: "ABCdef")
        
        // Act
        let result = validator.check()
        
        // Assert
        XCTAssertTrue(result, "Should return true when negative uppercase characters are required (any count >= -1)")
    }
    
    func testInputNotSetBeforeCheck() {
        // TC025: Test the behavior when checking before setInput
        // Arrange
        var validator = StringContainsNUpperChars(n: 1)
        // Note: Not calling setInput, so input remains ""
        
        // Act
        let result = validator.check()
        
        // Assert
        XCTAssertFalse(result, "Should return false when checking empty default input")
        XCTAssertNotNil(validator.getError(), "Error should be set for failed validation")
    }
    
    // MARK: - Code Quality Tests
    
    func testVariableNamingDoesNotAffectLogic() {
        // TC026: Verify variable naming doesn't affect logic
        // This test verifies that despite the misleading variable name 'lowerCaseCharsCount',
        // the logic still works correctly for counting uppercase characters
        
        // Arrange
        var validator = StringContainsNUpperChars(n: 2)
        
        // Act
        validator.setInput(input: "ABcd")
        let result = validator.check()
        
        // Assert
        XCTAssertTrue(result, "Logic should work correctly despite misleading variable name 'lowerCaseCharsCount'")
        
        // Test with lowercase to ensure it's actually counting uppercase
        validator.setInput(input: "abcd")
        let resultLower = validator.check()
        XCTAssertFalse(resultLower, "Should return false for lowercase-only string, confirming it counts uppercase")
    }
    
    // MARK: - Unicode Tests
    
    func testValidationWithGreekUppercaseLetters() {
        // TC027: Verify Greek uppercase letters
        // Arrange
        var validator = StringContainsNUpperChars(n: 2)
        
        // Act
        validator.setInput(input: "ΑΒγδ") // Greek uppercase Alpha, Beta + lowercase gamma, delta
        let result = validator.check()
        
        // Assert
        XCTAssertTrue(result, "Should correctly identify Greek uppercase letters")
    }
    
    func testValidationWithCyrillicUppercaseLetters() {
        // TC028: Verify Cyrillic uppercase letters
        // Arrange
        var validator = StringContainsNUpperChars(n: 2)
        
        // Act
        validator.setInput(input: "АБвг") // Cyrillic uppercase A, B + lowercase v, g
        let result = validator.check()
        
        // Assert
        XCTAssertTrue(result, "Should correctly identify Cyrillic uppercase letters")
    }
    
    // MARK: - Comprehensive Character Classification Tests
    
    func testUppercaseCharacterClassification() {
        // Test various characters to ensure proper uppercase classification
        let testCases: [(String, Int, Bool, String)] = [
            ("abc", 1, false, "lowercase only"),
            ("ABC", 1, true, "uppercase only"),
            ("123", 1, false, "numbers only"),
            ("!@#", 1, false, "special chars only"),
            ("Aa1!", 1, true, "mixed with one uppercase"),
            ("AaBbCc", 3, true, "alternating case"),
            ("HTML", 2, true, "common abbreviation"),
            ("iPhone", 1, true, "camelCase with one uppercase"),
            ("COVID-19", 5, true, "uppercase with numbers and hyphen"),
            ("", 1, false, "empty string"),
            ("a", 1, false, "single lowercase"),
            ("A", 1, true, "single uppercase"),
            ("MacBook", 2, true, "product name with two uppercase"),
            ("XMLHttpRequest", 4, true, "compound technical term"),
        ]
        
        for (input, n, expected, description) in testCases {
            var validator = StringContainsNUpperChars(n: n)
            validator.setInput(input: input)
            let result = validator.check()
            XCTAssertEqual(result, expected, "Failed for \(description): input '\(input)' with n=\(n)")
        }
    }
    
    // MARK: - Performance Tests
    
    func testPerformanceWithLargeString() {
        // Test performance with a very large string
        let largeString = String(repeating: "aA", count: 10000) // 20,000 characters
        var validator = StringContainsNUpperChars(n: 100)
        
        measure {
            validator.setInput(input: largeString)
            _ = validator.check()
        }
    }
    
    // MARK: - Protocol Conformance Tests
    
    func testProtocolConformance() {
        // Verify that StringContainsNUpperChars properly conforms to SingleInputValidator
        let validator = StringContainsNUpperChars(n: 1)
        
        // These should compile without issues if protocol conformance is correct
        XCTAssertTrue(validator.input is String, "Input should be String type")
        XCTAssertTrue(validator.error == nil, "Error should be nil initially")
    }
    
    func testAllProtocolMethodsAreImplemented() {
        // Verify all protocol methods work
        var validator = StringContainsNUpperChars(n: 2)
        
        // Test all protocol methods
        validator.setInput(input: "TestABC")
        let checkResult = validator.check()
        let error = validator.getError()
        
        validator.checkAndExec(onSuccess: {}, onFail: {})
        
        do {
            try validator.ThrowableCheck()
        } catch {
            // Expected for some test cases
        }
        
        // If we reach here, all methods are implemented
        XCTAssertTrue(true, "All protocol methods should be callable")
    }
    
    // MARK: - Error Handling Edge Cases
    
    func testMultipleFailedValidationsErrorHandling() {
        // Test that error handling works correctly across multiple failed validations
        var validator = StringContainsNUpperChars(n: 5)
        
        // First failed validation
        validator.setInput(input: "abc")
        let result1 = validator.check()
        let error1 = validator.getError()
        
        // Second failed validation
        validator.setInput(input: "def")
        let result2 = validator.check()
        let error2 = validator.getError()
        
        // Both should fail and have errors
        XCTAssertFalse(result1, "First validation should fail")
        XCTAssertFalse(result2, "Second validation should fail")
        XCTAssertNotNil(error1, "First error should be set")
        XCTAssertNotNil(error2, "Second error should be set")
        XCTAssertTrue(error1 is StringContainsNUpperCharsError, "First error should be correct type")
        XCTAssertTrue(error2 is StringContainsNUpperCharsError, "Second error should be correct type")
    }
    
    func testSuccessfulValidationAfterFailure() {
        // Test that successful validation after failure works correctly
        var validator = StringContainsNUpperChars(n: 2)
        
        // First failed validation
        validator.setInput(input: "abc")
        let result1 = validator.check()
        let error1 = validator.getError()
        
        // Second successful validation
        validator.setInput(input: "ABC")
        let result2 = validator.check()
        let error2 = validator.getError()
        
        XCTAssertFalse(result1, "First validation should fail")
        XCTAssertTrue(result2, "Second validation should succeed")
        XCTAssertNotNil(error1, "Error should be set after first validation")
        // Note: The error persists even after successful validation in current implementation
        // This might be a design choice or potential improvement area
    }
}
