import XCTest
import Foundation
@testable import AdelsonValidator

@available(macOS 13.0.0, *)
class MultipleInputPolicyTests: XCTestCase {
    
    // MARK: - Basic Functionality Tests
    
    func testTC01_SuccessfulValidationWithNoValidators() {
        // Arrange: Create policy with no validators
        var policy = MultipleInputPolicy<String>(
            inputs: ["test1", "test2"],
            singleInputValidators: [],
            multipleInputValidators: []
        )
        
        // Act: Run validation
        let result = policy.check()
        
        // Assert: Should pass with no errors
        XCTAssertTrue(result, "Validation should pass when no validators are present")
        XCTAssertTrue(policy.errors.isEmpty, "Errors array should be empty")
    }
    
    func testTC02_SuccessfulValidationWithValidInputs() {
        // Arrange: Create policy with passing validators
        var policy = MultipleInputPolicy<String>(
            inputs: ["hello", "world"],
            singleInputValidators: [
                StringHasMinLen(minLen: 3),
                StringHasMaxLen(maxLen: 10)
            ],
            multipleInputValidators: []
        )
        
        // Act: Run validation
        let result = policy.check()
        
        // Assert: Should pass with no errors
        XCTAssertTrue(result, "Validation should pass when all validators pass")
        XCTAssertTrue(policy.errors.isEmpty, "Errors array should be empty when validation passes")
    }
    
    func testTC03_FailedValidationWithStringHasMaxLen() {
        // Arrange: Create policy with strings that exceed max length
        var policy = MultipleInputPolicy<String>(
            inputs: ["short", "this_is_a_very_long_string_that_exceeds_the_maximum_allowed_length"],
            singleInputValidators: [StringHasMaxLen(maxLen: 10)],
            multipleInputValidators: []
        )
        
        // Act: Run validation
        let result = policy.check()
        
        // Assert: Should fail with errors
        XCTAssertFalse(result, "Validation should fail when string exceeds max length")
        XCTAssertEqual(policy.errors.count, 1, "Should have 1 error for the long string")
    }
    
    func testTC04_FailedValidationWithStringHasMinLen() {
        // Arrange: Create policy with strings that don't meet min length
        var policy = MultipleInputPolicy<String>(
            inputs: ["ok", "hi", "a"],
            singleInputValidators: [StringHasMinLen(minLen: 3)],
            multipleInputValidators: []
        )
        
        // Act: Run validation
        let result = policy.check()
        
        // Assert: Should fail with errors
        XCTAssertFalse(result, "Validation should fail when strings don't meet min length")
        XCTAssertEqual(policy.errors.count, 3, "Should have 2 errors for 'hi' and 'a' and 'ok'")
    }
    
    func testTC05_FailedValidationWithStringContains() {
        // Arrange: Create policy with strings that don't contain required substring
        var policy = MultipleInputPolicy<String>(
            inputs: ["hello", "world", "test"],
            singleInputValidators: [StringContains(substr: "ll")],
            multipleInputValidators: []
        )
        
        // Act: Run validation
        let result = policy.check()
        
        // Assert: Should fail for strings not containing "ll"
        XCTAssertFalse(result, "Validation should fail when strings don't contain required substring")
        XCTAssertEqual(policy.errors.count, 2, "Should have 2 errors for 'world' and 'test'")
    }
    
    func testTC06_FailedValidationWithStringNotContainAnyInList() {
        // Arrange: Create policy with strings that contain forbidden substrings
        var policy = MultipleInputPolicy<String>(
            inputs: ["hello", "world", "test"],
            singleInputValidators: [StringNotContainAnyInList(notContained: ["ll", "st"])],
            multipleInputValidators: []
        )
        
        // Act: Run validation
        let result = policy.check()
        
        // Assert: Should fail for strings containing forbidden substrings
        XCTAssertFalse(result, "Validation should fail when strings contain forbidden substrings")
        XCTAssertEqual(policy.errors.count, 2, "Should have 2 errors for 'hello' and 'test'")
    }
    
    func testTC07_FailedValidationWithStringConformsToRegex() {
        // Arrange: Create policy with strings that don't match regex pattern
        var policy = MultipleInputPolicy<String>(
            inputs: ["hello123", "world", "test456"],
            singleInputValidators: [StringConfromsToRegex(regex: "^[a-z]+$")], // Only lowercase letters
            multipleInputValidators: []
        )
        
        // Act: Run validation
        let result = policy.check()
        
        // Assert: Should fail for strings not matching regex
        XCTAssertFalse(result, "Validation should fail when strings don't match regex pattern")
        XCTAssertEqual(policy.errors.count, 2, "Should have 2 errors for 'hello123' and 'test456'")
    }
    
    func testTC08_FailedValidationWithAllOfSameLen() {
        // Arrange: Create policy with strings of different lengths
        var policy = MultipleInputPolicy<String>(
            inputs: ["short", "medium", "very_long_string"],
            singleInputValidators: [],
            multipleInputValidators: [AllOfSameLen()]
        )
        
        // Act: Run validation
        let result = policy.check()
        
        // Assert: Should fail since strings have different lengths
        XCTAssertFalse(result, "Validation should fail when strings have different lengths")
        XCTAssertEqual(policy.errors.count, 1, "Should have 1 error from AllOfSameLen validator")
    }
    
    func testTC09_FailedValidationWithAllOfSameValue() {
        // Arrange: Create policy with strings of different values
        var policy = MultipleInputPolicy<String>(
            inputs: ["same", "same", "different"],
            singleInputValidators: [],
            multipleInputValidators: [AllOfSameValue()]
        )
        
        // Act: Run validation
        let result = policy.check()
        
        // Assert: Should fail since strings have different values
        XCTAssertFalse(result, "Validation should fail when strings have different values")
        XCTAssertEqual(policy.errors.count, 1, "Should have 1 error from AllOfSameValue validator")
    }
    
    // MARK: - Edge Cases
    
    func testTC10_EmptyInputsArray() {
        // Arrange: Create policy with empty inputs but validators present
        var policy = MultipleInputPolicy<String>(
            inputs: [],
            singleInputValidators: [StringHasMinLen(minLen: 3)],
            multipleInputValidators: [AllOfSameLen()]
        )
        
        // Act: Run validation
        let result = policy.check()
        
        // Assert: Should pass since no inputs to validate
        XCTAssertTrue(result, "Validation should pass with empty inputs array")
        XCTAssertTrue(policy.errors.isEmpty, "Should have no errors with empty inputs")
    }
    
    func testTC11_SingleInput() {
        // Arrange: Create policy with single input
        var policy = MultipleInputPolicy<String>(
            inputs: ["hello"],
            singleInputValidators: [StringHasMinLen(minLen: 3)],
            multipleInputValidators: [AllOfSameLen()]
        )
        
        // Act: Run validation
        let result = policy.check()
        
        // Assert: Should handle single input correctly
        XCTAssertTrue(result, "Validation should handle single input correctly")
        XCTAssertTrue(policy.errors.isEmpty, "Should have no errors with valid single input")
    }
    
    func testTC12_LargeInputCollection() {
        // Arrange: Create policy with many inputs
        let largeInputs = Array(0..<100).map { "input\($0)" }
        var policy = MultipleInputPolicy<String>(
            inputs: largeInputs,
            singleInputValidators: [StringHasMinLen(minLen: 3)],
            multipleInputValidators: []
        )
        
        // Act: Run validation
        let result = policy.check()
        
        // Assert: Should handle large input collection
        XCTAssertTrue(result, "Validation should handle large input collection")
        XCTAssertTrue(policy.errors.isEmpty, "Should have no errors with large valid input collection")
    }
    
    func testTC13_EmptyValidatorArrays() {
        // Arrange: Create policy with empty validator arrays
        var policy = MultipleInputPolicy<String>(
            inputs: ["test1", "test2"],
            singleInputValidators: [],
            multipleInputValidators: []
        )
        
        // Act: Run validation
        let result = policy.check()
        
        // Assert: Should pass with no validators
        XCTAssertTrue(result, "Validation should pass with empty validator arrays")
        XCTAssertTrue(policy.errors.isEmpty, "Should have no errors with no validators")
    }
    
    // MARK: - Error Handling Tests
    
    func testTC14_MultipleErrorsAccumulation() {
        // Arrange: Create policy with multiple failing validators
        var policy = MultipleInputPolicy<String>(
            inputs: ["a", "b"], // Too short for minLen
            singleInputValidators: [
                StringHasMinLen(minLen: 3),
                StringHasMaxLen(maxLen: 1) // Also too long for maxLen
            ],
            multipleInputValidators: [AllOfSameLen()]
        )
        
        // Act: Run validation
        let result = policy.check()
        
        // Assert: Should accumulate all errors
        XCTAssertFalse(result, "Validation should fail with multiple failing validators")
        XCTAssertEqual(policy.errors.count, 2, "Should have 2 errors total for minLen")
    }
    
    func testTC15_ErrorClearingBetweenChecks() {
        // Arrange: Create policy that initially fails
        var policy = MultipleInputPolicy<String>(
            inputs: ["a"], // Too short
            singleInputValidators: [StringHasMinLen(minLen: 3)],
            multipleInputValidators: []
        )
        
        // Act: Run first check (should fail)
        let firstResult = policy.check()
        let firstErrorCount = policy.errors.count
        
        // Modify inputs to valid ones
        policy.inputs = ["hello"]
        
        // Run second check (should pass)
        let secondResult = policy.check()
        
        // Assert: Errors should be cleared between checks
        XCTAssertFalse(firstResult, "First check should fail")
        XCTAssertGreaterThan(firstErrorCount, 0, "First check should have errors")
        XCTAssertTrue(secondResult, "Second check should pass")
        XCTAssertTrue(policy.errors.isEmpty, "Errors should be cleared for second check")
    }
    
    func testTC16_GetErrorReturnsFirstError() {
        // Arrange: Create policy with multiple failing validators
        var policy = MultipleInputPolicy<String>(
            inputs: ["a", "b"], // Too short
            singleInputValidators: [StringHasMinLen(minLen: 3)],
            multipleInputValidators: [AllOfSameLen()]
        )
        
        // Act: Run validation and get first error
        let result = policy.check()
        let firstError = policy.getError()
        
        // Assert: Should return first error
        XCTAssertFalse(result, "Validation should fail")
        XCTAssertNotNil(firstError, "getError() should return an error")
        XCTAssertTrue(firstError is StringHasMinLenError, "First error should be StringHasMinLenError")
    }
    
    // MARK: - Callback and Throwable Tests
    
    func testTC17_CheckAndExecWithSuccess() {
        // Arrange: Create policy that will pass
        var policy = MultipleInputPolicy<String>(
            inputs: ["hello", "world"],
            singleInputValidators: [StringHasMinLen(minLen: 3)],
            multipleInputValidators: []
        )
        
        var successCalled = false
        var failCalled = false
        
        // Act: Run checkAndExec
        policy.checkAndExec(
            onSuccess: { successCalled = true },
            onFail: { failCalled = true }
        )
        
        // Assert: Success callback should be called
        XCTAssertTrue(successCalled, "onSuccess callback should be called")
        XCTAssertFalse(failCalled, "onFail callback should not be called")
    }
    
    func testTC18_CheckAndExecWithFailure() {
        // Arrange: Create policy that will fail
        var policy = MultipleInputPolicy<String>(
            inputs: ["a"], // Too short
            singleInputValidators: [StringHasMinLen(minLen: 3)],
            multipleInputValidators: []
        )
        
        var successCalled = false
        var failCalled = false
        
        // Act: Run checkAndExec
        policy.checkAndExec(
            onSuccess: { successCalled = true },
            onFail: { failCalled = true }
        )
        
        // Assert: Fail callback should be called
        XCTAssertFalse(successCalled, "onSuccess callback should not be called")
        XCTAssertTrue(failCalled, "onFail callback should be called")
    }
    
    func testTC19_ThrowableCheckWithSuccess() {
        // Arrange: Create policy that will pass
        var policy = MultipleInputPolicy<String>(
            inputs: ["hello", "world"],
            singleInputValidators: [StringHasMinLen(minLen: 3)],
            multipleInputValidators: []
        )
        
        // Act & Assert: Should not throw
        XCTAssertNoThrow(try policy.ThrowableCheck(), "ThrowableCheck should not throw on success")
    }
    
    func testTC20_ThrowableCheckWithFailure() {
        // Arrange: Create policy that will fail
        var policy = MultipleInputPolicy<String>(
            inputs: ["a"], // Too short
            singleInputValidators: [StringHasMinLen(minLen: 3)],
            multipleInputValidators: []
        )
        
        // Act & Assert: Should throw first error
        XCTAssertThrowsError(try policy.ThrowableCheck(), "ThrowableCheck should throw on failure") { error in
            XCTAssertTrue(error is StringHasMinLenError, "Thrown error should be StringHasMinLenError")
        }
    }
    
    // MARK: - Complex Validation Scenarios
    
    func testTC21_ComplexStringValidationScenario() {
        // Arrange: Create policy with multiple string validators
        var policy = MultipleInputPolicy<String>(
            inputs: ["hello123", "world456", "test789"],
            singleInputValidators: [
                StringHasMinLen(minLen: 5),
                StringHasMaxLen(maxLen: 10),
                StringContains(substr: "o"),
                StringNotContainAnyInList(notContained: ["123"])
            ],
            multipleInputValidators: []
        )
        
        // Act: Run validation
        let result = policy.check()
        
        // Assert: Should fail for strings containing "123"
        XCTAssertFalse(result, "Validation should fail for strings containing forbidden substring")
        XCTAssertEqual(policy.errors.count, 2, "Should have 2 errors for 'hello123' and 'test789' (both contain '123')")
    }
    
    func testTC22_AllOfSameLenWithSameLength() {
        // Arrange: Create policy with strings of same length
        var policy = MultipleInputPolicy<String>(
            inputs: ["hello", "world", "tests"],
            singleInputValidators: [],
            multipleInputValidators: [AllOfSameLen()]
        )
        
        // Act: Run validation
        let result = policy.check()
        
        // Assert: Should pass since all strings have length 5
        XCTAssertTrue(result, "Validation should pass when all strings have same length")
        XCTAssertTrue(policy.errors.isEmpty, "Should have no errors when all strings have same length")
    }
    
    func testTC23_AllOfSameValueWithSameValues() {
        // Arrange: Create policy with strings of same value
        var policy = MultipleInputPolicy<String>(
            inputs: ["same", "same", "same"],
            singleInputValidators: [],
            multipleInputValidators: [AllOfSameValue()]
        )
        
        // Act: Run validation
        let result = policy.check()
        
        // Assert: Should pass since all strings have same value
        XCTAssertTrue(result, "Validation should pass when all strings have same value")
        XCTAssertTrue(policy.errors.isEmpty, "Should have no errors when all strings have same value")
    }
    
    func testTC24_RegexValidationWithValidPattern() {
        // Arrange: Create policy with strings matching regex pattern
        var policy = MultipleInputPolicy<String>(
            inputs: ["hello", "world", "test"],
            singleInputValidators: [StringConfromsToRegex(regex: "^[a-z]+$")],
            multipleInputValidators: []
        )
        
        // Act: Run validation
        let result = policy.check()
        
        // Assert: Should pass since all strings match regex
        XCTAssertTrue(result, "Validation should pass when all strings match regex pattern")
        XCTAssertTrue(policy.errors.isEmpty, "Should have no errors when all strings match regex")
    }
    
    func testTC25_CombinedSingleAndMultipleValidators() {
        // Arrange: Create policy with both single and multiple validators
        var policy = MultipleInputPolicy<String>(
            inputs: ["hello", "world"],
            singleInputValidators: [
                StringHasMinLen(minLen: 3),
                StringHasMaxLen(maxLen: 10)
            ],
            multipleInputValidators: [
                AllOfSameLen()
            ]
        )
        
        // Act: Run validation
        let result = policy.check()
        
        // Assert: Should pass all validations
        XCTAssertTrue(result, "Validation should pass with both single and multiple validators")
        XCTAssertTrue(policy.errors.isEmpty, "Should have no errors with valid inputs")
    }
    
    // MARK: - Performance Tests
    
    func testTC26_PerformanceWithLargeDatasets() {
        // Arrange: Create policy with large dataset
        let largeInputs = Array(0..<1000).map { "input\($0)" }
        var policy = MultipleInputPolicy<String>(
            inputs: largeInputs,
            singleInputValidators: [
                StringHasMinLen(minLen: 3),
                StringHasMaxLen(maxLen: 20)
            ],
            multipleInputValidators: []
        )
        
        // Act & Assert: Measure performance
        measure {
            let _ = policy.check()
        }
        
        XCTAssertTrue(policy.check(), "Should handle large datasets efficiently")
    }
}
