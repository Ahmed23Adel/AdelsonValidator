//
//  File.swift
//  AdelsonValidator
//
//  Created by ahmed on 06/07/2025.
//

import Foundation
@testable import AdelsonValidator

import XCTest

class StringContainsNLowerCharsTests: XCTestCase {
    
    // MARK: - Initialization Tests
    
    func testInitializationWithValidN() {
        // Arrange & Act
        let validator = StringContainsNLowerChars(n: 3)
        
        // Assert
        XCTAssertEqual(validator.n, 3, "n should be set to 3")
        XCTAssertEqual(validator.input, "", "input should be initialized to empty string")
        XCTAssertNil(validator.error, "error should be nil initially")
    }
    
    func testInitializationWithZeroN() {
        // Arrange & Act
        let validator = StringContainsNLowerChars(n: 0)
        
        // Assert
        XCTAssertEqual(validator.n, 0, "n should be set to 0")
        XCTAssertEqual(validator.input, "", "input should be initialized to empty string")
        XCTAssertNil(validator.error, "error should be nil initially")
    }
    
    func testInitializationWithNegativeN() {
        // Arrange & Act
        let validator = StringContainsNLowerChars(n: -1)
        
        // Assert
        XCTAssertEqual(validator.n, -1, "n should be set to -1")
        XCTAssertEqual(validator.input, "", "input should be initialized to empty string")
        XCTAssertNil(validator.error, "error should be nil initially")
    }
    
    // MARK: - setInput Tests
    
    func testSetInputWithValidString() {
        // Arrange
        var validator = StringContainsNLowerChars(n: 3)
        
        // Act
        validator.setInput(input: "Hello")
        
        // Assert
        XCTAssertEqual(validator.input, "Hello", "input should be updated to 'Hello'")
    }
    
    func testSetInputWithEmptyString() {
        // Arrange
        var validator = StringContainsNLowerChars(n: 3)
        validator.setInput(input: "test") // Set non-empty first
        
        // Act
        validator.setInput(input: "")
        
        // Assert
        XCTAssertEqual(validator.input, "", "input should be updated to empty string")
    }
    
    // MARK: - check() Method Tests
    
    func testCheckWithExactMatch() {
        // Arrange
        var validator = StringContainsNLowerChars(n: 3)
        validator.setInput(input: "abc")
        
        // Act
        let result = validator.check()
        
        // Assert
        XCTAssertTrue(result, "check() should return true for exact match")
        XCTAssertNil(validator.error, "error should be nil for successful check")
    }
    
    func testCheckWithMoreThanRequired() {
        // Arrange
        var validator = StringContainsNLowerChars(n: 3)
        validator.setInput(input: "abcde")
        
        // Act
        let result = validator.check()
        
        // Assert
        XCTAssertTrue(result, "check() should return true when more than required")
        XCTAssertNil(validator.error, "error should be nil for successful check")
    }
    
    func testCheckWithLessThanRequired() {
        // Arrange
        var validator = StringContainsNLowerChars(n: 3)
        validator.setInput(input: "ab")
        
        // Act
        let result = validator.check()
        
        // Assert
        XCTAssertFalse(result, "check() should return false when less than required")
        XCTAssertNotNil(validator.error, "error should be set for failed check")
        XCTAssertTrue(validator.error is StringContainsNLowerCharsError, "error should be of correct type")
    }
    
    func testCheckWithNoLowercaseChars() {
        // Arrange
        var validator = StringContainsNLowerChars(n: 1)
        validator.setInput(input: "ABC123")
        
        // Act
        let result = validator.check()
        
        // Assert
        XCTAssertFalse(result, "check() should return false with no lowercase chars")
        XCTAssertNotNil(validator.error, "error should be set for failed check")
    }
    
    func testCheckWithMixedCase() {
        // Arrange
        var validator = StringContainsNLowerChars(n: 2)
        validator.setInput(input: "AbCdE")
        
        // Act
        let result = validator.check()
        
        // Assert
        XCTAssertTrue(result, "check() should return true with mixed case having enough lowercase")
        XCTAssertNil(validator.error, "error should be nil for successful check")
    }
    
    func testCheckWithSpecialCharacters() {
        // Arrange
        var validator = StringContainsNLowerChars(n: 2)
        validator.setInput(input: "a!b@c#")
        
        // Act
        let result = validator.check()
        
        // Assert
        XCTAssertTrue(result, "check() should return true ignoring special characters")
        XCTAssertNil(validator.error, "error should be nil for successful check")
    }
    
    func testCheckWithUnicodeLowercase() {
        // Arrange
        var validator = StringContainsNLowerChars(n: 2)
        validator.setInput(input: "café")
        
        // Act
        let result = validator.check()
        
        // Assert
        XCTAssertTrue(result, "check() should return true with unicode lowercase chars")
        XCTAssertNil(validator.error, "error should be nil for successful check")
    }
    
    func testCheckWithZeroRequirement() {
        // Arrange
        var validator = StringContainsNLowerChars(n: 0)
        validator.setInput(input: "ABC")
        
        // Act
        let result = validator.check()
        
        // Assert
        XCTAssertTrue(result, "check() should return true when n=0")
        XCTAssertNil(validator.error, "error should be nil for successful check")
    }
    
    func testCheckWithoutSetInput() {
        // Arrange
        var validator = StringContainsNLowerChars(n: 1)
        // Not calling setInput - using default empty string
        
        // Act
        let result = validator.check()
        
        // Assert
        XCTAssertFalse(result, "check() should return false with default empty input")
        XCTAssertNotNil(validator.error, "error should be set for failed check")
    }
    
    // MARK: - checkAndExec Tests
    
    func testCheckAndExecSuccessPath() {
        // Arrange
        var validator = StringContainsNLowerChars(n: 2)
        validator.setInput(input: "hello")
        var successCalled = false
        var failCalled = false
        
        // Act
        validator.checkAndExec(
            onSuccess: { successCalled = true },
            onFail: { failCalled = true }
        )
        
        // Assert
        XCTAssertTrue(successCalled, "onSuccess should be called")
        XCTAssertFalse(failCalled, "onFail should not be called")
        XCTAssertNil(validator.error, "error should be nil for successful check")
    }
    
    func testCheckAndExecFailurePath() {
        // Arrange
        var validator = StringContainsNLowerChars(n: 2)
        validator.setInput(input: "H")
        var successCalled = false
        var failCalled = false
        
        // Act
        validator.checkAndExec(
            onSuccess: { successCalled = true },
            onFail: { failCalled = true }
        )
        
        // Assert
        XCTAssertFalse(successCalled, "onSuccess should not be called")
        XCTAssertTrue(failCalled, "onFail should be called")
        XCTAssertNotNil(validator.error, "error should be set for failed check")
    }
    
    // MARK: - ThrowableCheck Tests
    
    func testThrowableCheckSuccess() {
        // Arrange
        var validator = StringContainsNLowerChars(n: 2)
        validator.setInput(input: "hello")
        
        // Act & Assert
        XCTAssertNoThrow(try validator.ThrowableCheck(), "ThrowableCheck should not throw for valid input")
        XCTAssertNil(validator.error, "error should be nil for successful check")
    }
    
    func testThrowableCheckFailure() {
        // Arrange
        var validator = StringContainsNLowerChars(n: 2)
        validator.setInput(input: "H")
        
        // Act & Assert
        XCTAssertThrowsError(try validator.ThrowableCheck(), "ThrowableCheck should throw for invalid input") { error in
            XCTAssertTrue(error is StringContainsNLowerCharsError, "Thrown error should be of correct type")
            if let specificError = error as? StringContainsNLowerCharsError {
                XCTAssertEqual(specificError, StringContainsNLowerCharsError.notContainsNLowerChars, "Should throw correct error case")
            }
        }
        XCTAssertNotNil(validator.error, "error should be set after failed check")
    }
    
    // MARK: - getError Tests
    
    func testGetErrorAfterFailedCheck() {
        // Arrange
        var validator = StringContainsNLowerChars(n: 1)
        validator.setInput(input: "A")
        
        // Act
        _ = validator.check() // This will fail
        let error = validator.getError()
        
        // Assert
        XCTAssertNotNil(error, "getError should return error after failed check")
        XCTAssertTrue(error is StringContainsNLowerCharsError, "error should be of correct type")
    }
    
    func testGetErrorAfterSuccessfulCheck() {
        // Arrange
        var validator = StringContainsNLowerChars(n: 1)
        validator.setInput(input: "a")
        
        // Act
        _ = validator.check() // This will succeed
        let error = validator.getError()
        
        // Assert
        XCTAssertNil(error, "getError should return nil after successful check")
    }
    
    // MARK: - Error Persistence Tests
    
    func testErrorPersistenceAcrossMultipleCalls() {
        // Arrange
        var validator = StringContainsNLowerChars(n: 1)
        validator.setInput(input: "A")
        
        // Act
        _ = validator.check() // First failed check
        let firstError = validator.getError()
        _ = validator.check() // Second failed check
        let secondError = validator.getError()
        
        // Assert
        XCTAssertNotNil(firstError, "First error should be set")
        XCTAssertNotNil(secondError, "Second error should be set")
        // Note: Due to the bug in the code, error gets set multiple times
        // This test documents the current behavior
    }
    
    func testErrorStateAfterSuccessfulCheck() {
        // Arrange
        var validator = StringContainsNLowerChars(n: 1)
        validator.setInput(input: "A")
        _ = validator.check() // Failed check - sets error
        
        // Act
        validator.setInput(input: "a")
        let result = validator.check() // Successful check
        
        // Assert
        XCTAssertTrue(result, "Second check should succeed")
        // Note: The current implementation doesn't clear the error on success
        // This test documents the current behavior - error remains set
        XCTAssertNotNil(validator.error, "Error remains set (current behavior)")
    }
    
    // MARK: - Edge Cases and Bug Tests
    
    func testNegativeNRequirement() {
        // Arrange
        var validator = StringContainsNLowerChars(n: -1)
        validator.setInput(input: "hello")
        
        // Act
        let result = validator.check()
        
        // Assert
        XCTAssertTrue(result, "check() should return true when n is negative (any count >= -1)")
        XCTAssertNil(validator.error, "error should be nil for successful check")
    }
    
    func testLargeNRequirement() {
        // Arrange
        var validator = StringContainsNLowerChars(n: 1000)
        validator.setInput(input: "hello")
        
        // Act
        let result = validator.check()
        
        // Assert
        XCTAssertFalse(result, "check() should return false when n is larger than possible")
        XCTAssertNotNil(validator.error, "error should be set for failed check")
    }
    
    func testDoubleErrorSettingBug() {
        // This test documents the bug where saveError() is called twice
        // Arrange
        var validator = StringContainsNLowerChars(n: 1)
        validator.setInput(input: "A")
        
        // Act
        let result = validator.check()
        
        // Assert
        XCTAssertFalse(result, "check() should return false")
        XCTAssertNotNil(validator.error, "error should be set")
        
        // The bug: saveError() is called both in check() method and in the calling context
        // This doesn't cause a functional issue but indicates redundant error setting
    }
}

// MARK: - Performance Tests

extension StringContainsNLowerCharsTests {
    
    func testPerformanceWithLargeString() {
        // Arrange
        let largeString = String(repeating: "abcdefghijklmnopqrstuvwxyz", count: 1000)
        var validator = StringContainsNLowerChars(n: 100)
        validator.setInput(input: largeString)
        
        // Act & Assert
        measure {
            _ = validator.check()
        }
    }
    
    func testPerformanceWithManyValidations() {
        // Arrange
        var validator = StringContainsNLowerChars(n: 5)
        let testInputs = ["hello", "HELLO", "HeLLo", "12345", "abcdef"]
        
        // Act & Assert
        measure {
            for input in testInputs {
                validator.setInput(input: input)
                _ = validator.check()
            }
        }
    }
}
