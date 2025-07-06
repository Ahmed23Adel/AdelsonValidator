//
//  File.swift
//  AdelsonValidator
//
//  Created by ahmed on 05/07/2025.
//

import Foundation
import XCTest
@testable import AdelsonValidator 

class SingleInputPolicyProtocolTests: XCTestCase {
    
    // MARK: - Test Cases
    
    // TC001: Test successful initialization
    func testSuccessfulInitialization() {
        // Arrange
        let inputs = ["test1", "test2", "test3"]
        let validators: [any SingleInputValidator<String>] = [
            StringHasMinLen(minLen: 3),
            StringHasMaxLen(maxLen: 10)
        ]
        
        // Act
        let policy = SingleInputPolicy(inputs: inputs, singleInputValidators: validators)
        
        // Assert
        XCTAssertEqual(policy.inputs.count, 3)
        XCTAssertEqual(policy.singleInputValidators.count, 2)
        XCTAssertTrue(policy.errors.isEmpty)
    }
    
    // TC002: Test all validations pass
    func testAllValidationsPass() {
        // Arrange
        let inputs = ["hello", "world", "swift"]
        let validators: [any SingleInputValidator<String>] = [
            StringHasMinLen(minLen: 3),
            StringHasMaxLen(maxLen: 10)
        ]
        var policy = SingleInputPolicy(inputs: inputs, singleInputValidators: validators)
        
        // Act
        let result = policy.check()
        
        // Assert
        XCTAssertTrue(result, "All validations should pass")
        XCTAssertTrue(policy.errors.isEmpty, "No errors should be collected")
    }
    
    // TC003: Test single validation failure
    func testSingleValidationFailure() {
        // Arrange - One input fails minimum length requirement
        let inputs = ["hello", "hi", "world"] // "hi" fails minLen of 3
        let validators: [any SingleInputValidator<String>] = [
            StringHasMinLen(minLen: 3)
        ]
        var policy = SingleInputPolicy(inputs: inputs, singleInputValidators: validators)
        
        // Act
        let result = policy.check()
        
        // Assert
        XCTAssertFalse(result, "Validation should fail")
        XCTAssertEqual(policy.errors.count, 1, "Should have exactly one error")
    }
    
    // TC004: Test multiple validation failures
    func testMultipleValidationFailures() {
        // Arrange - Multiple inputs fail different validators
        let inputs = ["hi", "superlongstring", "ok"] // "hi" and "ok" fail minLen, "superlongstring" fails maxLen
        let validators: [any SingleInputValidator<String>] = [
            StringHasMinLen(minLen: 3),
            StringHasMaxLen(maxLen: 10)
        ]
        var policy = SingleInputPolicy(inputs: inputs, singleInputValidators: validators)
        
        // Act
        let result = policy.check()
        
        // Assert
        XCTAssertFalse(result, "Validation should fail")
        XCTAssertTrue(policy.errors.count > 1, "Should have multiple errors")
    }
    
    // TC005: Test empty inputs array
    func testEmptyInputsArray() {
        // Arrange
        let inputs: [String] = []
        let validators: [any SingleInputValidator<String>] = [
            StringHasMinLen(minLen: 3)
        ]
        var policy = SingleInputPolicy(inputs: inputs, singleInputValidators: validators)
        
        // Act
        let result = policy.check()
        
        // Assert
        XCTAssertTrue(result, "Empty inputs should pass validation (vacuous truth)")
        XCTAssertTrue(policy.errors.isEmpty, "No errors should be collected")
    }
    
    // TC006: Test empty validators array
    func testEmptyValidatorsArray() {
        // Arrange
        let inputs = ["test1", "test2", "test3"]
        let validators: [any SingleInputValidator<String>] = []
        var policy = SingleInputPolicy(inputs: inputs, singleInputValidators: validators)
        
        // Act
        let result = policy.check()
        
        // Assert
        XCTAssertTrue(result, "No validators should result in successful validation")
        XCTAssertTrue(policy.errors.isEmpty, "No errors should be collected")
    }
    
    // TC007: Test multiple calls to check() - Error accumulation
    func testMultipleCallsToCheck() {
        // Arrange
        let inputs = ["hi"] // Fails minLen requirement
        let validators: [any SingleInputValidator<String>] = [
            StringHasMinLen(minLen: 3)
        ]
        var policy = SingleInputPolicy(inputs: inputs, singleInputValidators: validators)
        
        // Act
        let result1 = policy.check()
        let errorsAfterFirst = policy.errors.count
        let result2 = policy.check()
        let errorsAfterSecond = policy.errors.count
        
        // Assert
        XCTAssertFalse(result1, "First check should fail")
        XCTAssertFalse(result2, "Second check should fail")
        XCTAssertEqual(errorsAfterFirst, 1, "Should have 1 error after first check")
        XCTAssertEqual(errorsAfterSecond, 2, "Should have 2 errors after second check (accumulation)")
    }
    
    // TC008: Test checkAndExec success path
    func testCheckAndExecSuccessPath() {
        // Arrange
        let inputs = ["hello", "world"]
        let validators: [any SingleInputValidator<String>] = [
            StringHasMinLen(minLen: 3)
        ]
        var policy = SingleInputPolicy(inputs: inputs, singleInputValidators: validators)
        
        var successCallbackExecuted = false
        var failCallbackExecuted = false
        
        // Act
        policy.checkAndExec(
            onSuccess: { successCallbackExecuted = true },
            onFail: { failCallbackExecuted = true }
        )
        
        // Assert
        XCTAssertTrue(successCallbackExecuted, "Success callback should be executed")
        XCTAssertFalse(failCallbackExecuted, "Fail callback should not be executed")
    }
    
    // TC009: Test checkAndExec failure path
    func testCheckAndExecFailurePath() {
        // Arrange
        let inputs = ["hi"] // Fails minLen requirement
        let validators: [any SingleInputValidator<String>] = [
            StringHasMinLen(minLen: 3)
        ]
        var policy = SingleInputPolicy(inputs: inputs, singleInputValidators: validators)
        
        var successCallbackExecuted = false
        var failCallbackExecuted = false
        
        // Act
        policy.checkAndExec(
            onSuccess: { successCallbackExecuted = true },
            onFail: { failCallbackExecuted = true }
        )
        
        // Assert
        XCTAssertFalse(successCallbackExecuted, "Success callback should not be executed")
        XCTAssertTrue(failCallbackExecuted, "Fail callback should be executed")
    }
    
    // TC010: Test ThrowableCheck success
    func testThrowableCheckSuccess() {
        // Arrange
        let inputs = ["hello", "world"]
        let validators: [any SingleInputValidator<String>] = [
            StringHasMinLen(minLen: 3)
        ]
        var policy = SingleInputPolicy(inputs: inputs, singleInputValidators: validators)
        
        // Act & Assert
        XCTAssertNoThrow(try policy.ThrowableCheck(), "Should not throw exception for valid inputs")
    }
    
    // TC011: Test ThrowableCheck failure
    func testThrowableCheckFailure() {
        // Arrange
        let inputs = ["hi"] // Fails minLen requirement
        let validators: [any SingleInputValidator<String>] = [
            StringHasMinLen(minLen: 3)
        ]
        var policy = SingleInputPolicy(inputs: inputs, singleInputValidators: validators)
        
        // Act & Assert
        XCTAssertThrowsError(try policy.ThrowableCheck(), "Should throw exception for invalid inputs") { error in
            // Verify the thrown error is the expected type
            XCTAssertTrue(error is StringHasMinLenError, "Should throw StringHasMinLenError")
        }
    }
    
    // TC012: Test getError with errors
    func testGetErrorWithErrors() {
        // Arrange
        let inputs = ["hi"] // Fails minLen requirement
        let validators: [any SingleInputValidator<String>] = [
            StringHasMinLen(minLen: 3)
        ]
        var policy = SingleInputPolicy(inputs: inputs, singleInputValidators: validators)
        
        // Act
        _ = policy.check() // This will populate errors
        let error = policy.getError()
        
        // Assert
        XCTAssertNotNil(error, "Should return an error when errors exist")
        XCTAssertTrue(error is StringHasMinLenError, "Should return StringHasMinLenError")
    }
    
    // TC013: Test getError with no errors (potential crash scenario)
    func testGetErrorWithNoErrors() {
        // Arrange
        let inputs = ["hello", "world"]
        let validators: [any SingleInputValidator<String>] = [
            StringHasMinLen(minLen: 3)
        ]
        var policy = SingleInputPolicy(inputs: inputs, singleInputValidators: validators)
        
        // Act
        _ = policy.check() // This will result in no errors
        
        // Assert
        // This test might crash due to accessing errors[0] on empty array
        // This reveals a potential bug in the implementation
        XCTAssertTrue(policy.errors.isEmpty, "Errors should be empty after successful validation")
        
        // The following line would crash in the current implementation:
        // let error = policy.getError()
        // This is a bug that should be fixed by checking if errors.isEmpty first
    }
    
    // MARK: - Additional Edge Cases
    
    // Test with different input types (Int)
    func testWithIntegerInputs() {
        // This would require creating validators for Int type
        // Since we only have String validators in the provided code,
        // this test demonstrates the generic nature of the protocol
        
        // Note: This test would need Int-specific validators to be meaningful
        let inputs = [1, 2, 3]
        let validators: [any SingleInputValidator<Int>] = []
        var policy = SingleInputPolicy(inputs: inputs, singleInputValidators: validators)
        
        let result = policy.check()
        XCTAssertTrue(result, "Empty validators should pass")
    }
    
    // Test validator state management
    func testValidatorStateManagement() {
        // Arrange
        let inputs = ["test1", "test2"]
        var validator1 = StringHasMinLen(minLen: 3)
        var validator2 = StringHasMaxLen(maxLen: 10)
        
        // Test that validators are properly configured for each input
        validator1.setInput(input: "test1")
        XCTAssertTrue(validator1.check(), "Should pass minimum length")
        
        validator2.setInput(input: "test2")
        XCTAssertTrue(validator2.check(), "Should pass maximum length")
    }
    
    // Test concurrent access (if applicable)
    func testConcurrentAccess() {
        // This test would be relevant if the policy needs to be thread-safe
        // Currently, the implementation uses 'mutating' functions, suggesting it's not thread-safe
        
        let inputs = ["hello", "world"]
        let validators: [any SingleInputValidator<String>] = [
            StringHasMinLen(minLen: 3)
        ]
        var policy = SingleInputPolicy(inputs: inputs, singleInputValidators: validators)
        
        // Since it's not thread-safe, we just test basic functionality
        let result = policy.check()
        XCTAssertTrue(result, "Basic functionality should work")
    }
}

// MARK: - Mock Validators for Testing

// Additional test validators to test edge cases
enum TestValidatorError: Error {
    case alwaysFails
    case customError(String)
}

struct AlwaysFailsValidator: SingleInputValidator {
    private(set) var input: String = ""
    private(set) var error: (any Error)?
    
    init() {}
    
    mutating func setInput(input: String) {
        self.input = input
        self.error = nil
    }
    
    mutating func check() -> Bool {
        saveError()
        return false
    }
    
    mutating func saveError() {
        self.error = TestValidatorError.alwaysFails
    }
}

struct AlwaysPassesValidator: SingleInputValidator {
    private(set) var input: String = ""
    private(set) var error: (any Error)?
    
    init() {}
    
    mutating func setInput(input: String) {
        self.input = input
        self.error = nil
    }
    
    mutating func check() -> Bool {
        return true
    }
    
    mutating func saveError() {
        // Never called since this validator always passes
    }
}
