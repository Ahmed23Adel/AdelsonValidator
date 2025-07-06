//
//  File.swift
//  AdelsonValidator
//
//  Created by ahmed on 06/07/2025.
//

import Foundation
@testable import AdelsonValidator

import XCTest

class StringContainsNSpecialCharsTests: XCTestCase {
    
    // MARK: - Basic Validation Tests
    
    func testBasicValidationWithExactSpecialCharCount() {
        // TC001: Verify basic validation with exact special char count
        // Arrange
        var validator = StringContainsNSpecialChars(n: 3)
        
        // Act
        validator.setInput(input: "abc!@#")
        let result = validator.check()
        
        // Assert
        XCTAssertTrue(result, "Should return true when string contains exactly the required number of special characters")
        XCTAssertNil(validator.getError(), "Error should be nil for successful validation")
    }
    
    func testValidationWithMoreSpecialCharsThanRequired() {
        // TC002: Verify validation with more special chars than required
        // Arrange
        var validator = StringContainsNSpecialChars(n: 2)
        
        // Act
        validator.setInput(input: "a!b@c#d$")
        let result = validator.check()
        
        // Assert
        XCTAssertTrue(result, "Should return true when string contains more than required number of special characters")
        XCTAssertNil(validator.getError(), "Error should be nil for successful validation")
    }
    
    func testValidationFailureWithFewerSpecialChars() {
        // TC003: Verify validation failure with fewer special chars
        // Arrange
        var validator = StringContainsNSpecialChars(n: 4)
        
        // Act
        validator.setInput(input: "abc!@")
        let result = validator.check()
        
        // Assert
        XCTAssertFalse(result, "Should return false when string contains fewer than required number of special characters")
        XCTAssertNotNil(validator.getError(), "Error should be set for failed validation")
    }
    
    func testValidationWithNoSpecialChars() {
        // TC004: Verify validation failure with no special chars
        // Arrange
        var validator = StringContainsNSpecialChars(n: 1)
        
        // Act
        validator.setInput(input: "abc123")
        let result = validator.check()
        
        // Assert
        XCTAssertFalse(result, "Should return false when string contains no special characters")
        XCTAssertNotNil(validator.getError(), "Error should be set when no special characters found")
    }
    
    // MARK: - Edge Cases
    
    func testValidationWithOnlySpecialChars() {
        // TC005: Verify validation with only special chars
        // Arrange
        var validator = StringContainsNSpecialChars(n: 3)
        
        // Act
        validator.setInput(input: "!@#$%")
        let result = validator.check()
        
        // Assert
        XCTAssertTrue(result, "Should return true when string contains only special characters and meets requirement")
    }
    
    func testValidationWithEmptyString() {
        // TC006: Verify validation with empty string
        // Arrange
        var validator = StringContainsNSpecialChars(n: 1)
        
        // Act
        validator.setInput(input: "")
        let result = validator.check()
        
        // Assert
        XCTAssertFalse(result, "Should return false for empty string when special characters are required")
        XCTAssertNotNil(validator.getError(), "Error should be set for empty string validation failure")
    }
    
    func testValidationWithZeroRequirement() {
        // TC007: Verify validation with zero requirement
        // Arrange
        var validator = StringContainsNSpecialChars(n: 0)
        
        // Act
        validator.setInput(input: "abc")
        let result = validator.check()
        
        // Assert
        XCTAssertTrue(result, "Should return true when zero special characters are required")
    }
    
    func testValidationWithSingleSpecialCharacter() {
        // TC008: Verify validation with single special character
        // Arrange
        var validator = StringContainsNSpecialChars(n: 1)
        
        // Act
        validator.setInput(input: "!")
        let result = validator.check()
        
        // Assert
        XCTAssertTrue(result, "Should return true for single special character when one is required")
    }
    
    // MARK: - Boundary Tests
    
    func testValidationWithWhitespaceCharacters() {
        // TC009: Verify validation with whitespace characters
        // Arrange
        var validator = StringContainsNSpecialChars(n: 2)
        
        // Act
        validator.setInput(input: "a b\tc") // space and tab
        let result = validator.check()
        
        // Assert
        XCTAssertTrue(result, "Should correctly identify whitespace characters as special characters")
    }
    
    func testValidationWithCommonPunctuation() {
        // TC010: Verify validation with common punctuation
        // Arrange
        var validator = StringContainsNSpecialChars(n: 3)
        
        // Act
        validator.setInput(input: "Hello, World!") // comma, space, exclamation
        let result = validator.check()
        
        // Assert
        XCTAssertTrue(result, "Should correctly identify punctuation and spaces as special characters")
    }
    
    func testValidationWithUnicodeSpecialChars() {
        // TC011: Verify validation with Unicode special chars
        // Arrange
        var validator = StringContainsNSpecialChars(n: 2)
        
        // Act
        validator.setInput(input: "test©®")
        let result = validator.check()
        
        // Assert
        XCTAssertTrue(result, "Should correctly identify Unicode special characters")
    }
    
    // MARK: - Functional Tests
    
    func testCheckAndExecSuccessCallback() {
        // TC012: Verify checkAndExec success callback
        // Arrange
        var validator = StringContainsNSpecialChars(n: 2)
        validator.setInput(input: "ab!@")
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
        var validator = StringContainsNSpecialChars(n: 3)
        validator.setInput(input: "ab!")
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
        var validator = StringContainsNSpecialChars(n: 1)
        validator.setInput(input: "a!")
        
        // Act & Assert
        XCTAssertNoThrow(try validator.ThrowableCheck(), "Should not throw for valid input")
    }
    
    func testThrowableCheckThrowsOnFailure() {
        // TC015: Verify ThrowableCheck throws on failure
        // Arrange
        var validator = StringContainsNSpecialChars(n: 2)
        validator.setInput(input: "a!")
        
        // Act & Assert
        XCTAssertThrowsError(try validator.ThrowableCheck()) { error in
            // Note: This test will currently fail due to the bug in saveError()
            // The error will be StringContainsNNumbersError instead of StringContainsNSpecialCharsError
            XCTAssertTrue(error is StringContainsNSpecialCharsError, "Should throw StringContainsNSpecialCharsError")
        }
    }
    
    func testSetInputUpdatesCorrectly() {
        // TC016: Verify setInput updates input correctly
        // Arrange
        var validator = StringContainsNSpecialChars(n: 1)
        let testInput = "test!@#"
        
        // Act
        validator.setInput(input: testInput)
        
        // Assert
        XCTAssertEqual(validator.input, testInput, "setInput should update the input property")
    }
    
    // MARK: - Bug Detection Tests
    
    func testGetErrorReturnsCorrectErrorType() {
        // TC017: Verify getError returns correct error type
        // This test will FAIL due to the bug in saveError() method
        // The bug: saveError() sets StringContainsNNumbersError instead of StringContainsNSpecialCharsError
        
        // Arrange
        var validator = StringContainsNSpecialChars(n: 2)
        validator.setInput(input: "a")
        
        // Act
        _ = validator.check() // This will fail and set error
        let error = validator.getError()
        
        // Assert
        XCTAssertNotNil(error, "getError should return error after failed validation")
        
        // This assertion will FAIL due to the bug
        XCTAssertTrue(error is StringContainsNSpecialCharsError,
                     "Error should be StringContainsNSpecialCharsError, but got \(type(of: error))")
        
    }
    
    func testSaveErrorBugDetection() {
        // Additional test to explicitly detect the saveError() bug
        // Arrange
        var validator = StringContainsNSpecialChars(n: 5)
        validator.setInput(input: "abc")
        
        // Act
        _ = validator.check() // This will fail and call saveError()
        
        // Assert - This will show the bug
        if let error = validator.getError() {
            XCTAssertTrue(error is StringContainsNSpecialCharsError,
                          "Bug confirmed: saveError() sets wrong error type")
            
        } else {
            XCTFail("Error should be set after failed validation")
        }
    }
    
    // MARK: - State Tests
    
    func testErrorIsNilInitially() {
        // TC018: Verify error is nil initially
        // Arrange & Act
        var validator = StringContainsNSpecialChars(n: 1)
        
        // Assert
        XCTAssertNil(validator.getError(), "Error should be nil for newly created validator")
    }
    
    func testErrorPersistsAfterFailedValidation() {
        // TC019: Verify error persists after failed validation
        // Arrange
        var validator = StringContainsNSpecialChars(n: 3)
        validator.setInput(input: "ab")
        
        // Act
        _ = validator.check() // First failed check
        let firstError = validator.getError()
        _ = validator.check() // Second failed check
        let secondError = validator.getError()
        
        // Assert
        XCTAssertNotNil(firstError, "Error should be set after first failed validation")
        XCTAssertNotNil(secondError, "Error should persist after second failed validation")
    }
    
    // MARK: - Additional Edge Cases
    
    func testValidationWithNewlineAndCarriageReturn() {
        // TC020: Verify validation with newline and carriage return
        // Arrange
        var validator = StringContainsNSpecialChars(n: 2)
        
        // Act
        validator.setInput(input: "a\n\rb") // newline and carriage return
        let result = validator.check()
        
        // Assert
        XCTAssertTrue(result, "Should correctly identify newline and carriage return as special characters")
    }
    
    func testValidationWithMixedAlphanumericAndSpecial() {
        // TC021: Verify validation with mixed alphanumeric and special
        // Arrange
        var validator = StringContainsNSpecialChars(n: 2)
        
        // Act
        validator.setInput(input: "abc123!@def")
        let result = validator.check()
        
        // Assert
        XCTAssertTrue(result, "Should correctly identify special characters in mixed content")
    }
    
    // MARK: - Boundary Tests
    
    func testLargeSpecialCharRequirement() {
        // TC022: Verify large special char requirement
        // Arrange
        var validator = StringContainsNSpecialChars(n: 100)
        let inputWith50SpecialChars = String(repeating: "a!", count: 50) // Creates "a!a!a!..." with 50 special chars
        
        // Act
        validator.setInput(input: inputWith50SpecialChars)
        let result = validator.check()
        
        // Assert
        XCTAssertFalse(result, "Should return false when string has fewer special characters than large requirement")
        XCTAssertNotNil(validator.getError(), "Error should be set for failed validation")
    }
    
    func testVeryLongStringWithSufficientSpecialChars() {
        // TC023: Verify very long string with sufficient special chars
        // Arrange
        var validator = StringContainsNSpecialChars(n: 5)
        let longStringWith10SpecialChars = String(repeating: "abcde", count: 200) + "!@#$%^&*()" // 1000+ chars with 10 special chars
        
        // Act
        validator.setInput(input: longStringWith10SpecialChars)
        let result = validator.check()
        
        // Assert
        XCTAssertTrue(result, "Should return true for very long string with sufficient special characters")
    }
    
    func testValidationWithNegativeRequirement() {
        // TC024: Edge case: What happens with negative n?
        // Arrange
        var validator = StringContainsNSpecialChars(n: -1)
        validator.setInput(input: "abc!@#")
        
        // Act
        let result = validator.check()
        
        // Assert
        XCTAssertTrue(result, "Should return true when negative special characters are required (any count >= -1)")
    }
    
    func testInputNotSetBeforeCheck() {
        // TC025: Test the behavior when checking before setInput
        // Arrange
        var validator = StringContainsNSpecialChars(n: 1)
        // Note: Not calling setInput, so input remains ""
        
        // Act
        let result = validator.check()
        
        // Assert
        XCTAssertFalse(result, "Should return false when checking empty default input")
        XCTAssertNotNil(validator.getError(), "Error should be set for failed validation")
    }
    
    // MARK: - Character Classification Tests
    
    func testSpecialCharacterClassification() {
        // Test various characters to ensure proper classification
        let testCases: [(String, Int, Bool, String)] = [
            ("abc", 1, false, "letters only"),
            ("123", 1, false, "numbers only"),
            ("!@#", 1, true, "special chars only"),
            ("a1!", 1, true, "mixed with one special"),
            (".,;:", 2, true, "punctuation marks"),
            ("()[]", 2, true, "brackets"),
            ("{}|\\", 2, true, "braces and symbols"),
            ("+-*/", 2, true, "math operators"),
            ("&%$#", 2, true, "various symbols"),
            ("\"'`", 2, true, "quotes"),
        ]
        
        for (input, n, expected, description) in testCases {
            var validator = StringContainsNSpecialChars(n: n)
            validator.setInput(input: input)
            let result = validator.check()
            XCTAssertEqual(result, expected, "Failed for \(description): input '\(input)' with n=\(n)")
        }
    }
    
    // MARK: - Performance Tests
    
    func testPerformanceWithLargeString() {
        // Test performance with a very large string
        let largeString = String(repeating: "a!", count: 10000) // 20,000 characters
        var validator = StringContainsNSpecialChars(n: 100)
        
        measure {
            validator.setInput(input: largeString)
            _ = validator.check()
        }
    }
    
    // MARK: - Protocol Conformance Tests
    
    func testProtocolConformance() {
        // Verify that StringContainsNSpecialChars properly conforms to SingleInputValidator
        let validator = StringContainsNSpecialChars(n: 1)
        
        // These should compile without issues if protocol conformance is correct
        XCTAssertTrue(validator.input is String, "Input should be String type")
        XCTAssertTrue(validator.error == nil, "Error should be nil initially")
    }
    
    func testAllProtocolMethodsAreImplemented() {
        // Verify all protocol methods work
        var validator = StringContainsNSpecialChars(n: 2)
        
        // Test all protocol methods
        validator.setInput(input: "test!@#")
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
}

// MARK: - Additional Test Suite for Bug Reproduction

class StringContainsNSpecialCharsBugReproductionTests: XCTestCase {
    
    func testBugReproduction_WrongErrorType() {
        // This test specifically reproduces the bug where saveError() sets the wrong error type
        print("=== BUG REPRODUCTION TEST ===")
        
        var validator = StringContainsNSpecialChars(n: 5)
        validator.setInput(input: "test") // This will fail validation
        
        let result = validator.check()
        let error = validator.getError()
        
        print("Validation result: \(result)")
        print("Error type: \(type(of: error))")
        
        if let error = error {
            print("Is StringContainsNSpecialCharsError: \(error is StringContainsNSpecialCharsError)")
            print("Is StringContainsNNumbersError: \(error is StringContainsNNumbersError)")
        }
        
        // This assertion will FAIL, demonstrating the bug
        XCTAssertTrue(error is StringContainsNSpecialCharsError,
                     "BUG DETECTED: saveError() method sets StringContainsNNumbersError instead of StringContainsNSpecialCharsError")
    }
    
    func testCorrectBehaviorAfterBugFix() {
        // This test shows what the correct behavior should be after fixing the bug
        // Currently this test will fail, but it should pass after the bug is fixed
        
        var validator = StringContainsNSpecialChars(n: 3)
        validator.setInput(input: "ab!") // Only 1 special char, needs 3
        
        let result = validator.check()
        let error = validator.getError()
        
        XCTAssertFalse(result, "Should return false when insufficient special characters")
        XCTAssertNotNil(error, "Error should be set")
        
        // After bug fix, this should pass
        if let error = error {
            XCTAssertTrue(error is StringContainsNSpecialCharsError,
                         "Error should be StringContainsNSpecialCharsError")
            
            if let specificError = error as? StringContainsNSpecialCharsError {
                XCTAssertEqual(specificError, StringContainsNSpecialCharsError.notContainsNSpecialChars,
                              "Error should be notContainsNSpecialChars")
            }
        }
    }
}
