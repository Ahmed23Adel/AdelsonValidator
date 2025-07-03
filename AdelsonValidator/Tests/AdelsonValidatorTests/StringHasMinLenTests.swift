@testable import AdelsonValidator
import XCTest

class StringHasMinLenTests: XCTestCase {
    
    // MARK: - Test Cases for Basic Validation Logic
    
    func testTC01_ValidStringPassesMinLengthCheck() {
        // Arrange: Create validator with valid input
        var validator = StringHasMinLen(input: "hello", minLen: 3)
        
        // Act: Perform validation check
        let result = validator.check()
        
        // Assert: Validation should pass and no error should be set
        XCTAssertTrue(result, "String 'hello' with minLen 3 should pass validation")
        XCTAssertNil(validator.getError(), "No error should be set for valid input")
    }
    
    func testTC02_StringExactlyAtMinLengthPasses() {
        // Arrange: Create validator with input exactly at minimum length
        var validator = StringHasMinLen(input: "abc", minLen: 3)
        
        // Act: Perform validation check
        let result = validator.check()
        
        // Assert: Validation should pass for exact boundary case
        XCTAssertTrue(result, "String 'abc' with minLen 3 should pass validation")
        XCTAssertNil(validator.getError(), "No error should be set for boundary valid input")
    }
    
    func testTC03_StringShorterThanMinimumFails() {
        // Arrange: Create validator with input shorter than minimum
        var validator = StringHasMinLen(input: "hi", minLen: 5)
        
        // Act: Perform validation check
        let result = validator.check()
        
        // Assert: Validation should fail and error should be set
        XCTAssertFalse(result, "String 'hi' with minLen 5 should fail validation")
        XCTAssertNotNil(validator.getError(), "Error should be set for invalid input")
        
        // Verify correct error type
        if let error = validator.getError() as? StringHasMinLenError {
            XCTAssertEqual(error, StringHasMinLenError.providedInputIsSmallerThanMinLen, "Correct error type should be set")
        } else {
            XCTFail("Expected StringHasMinLenError but got different error type")
        }
    }
    
    func testTC04_EmptyStringFailsNonZeroMinimum() {
        // Arrange: Create validator with empty string and non-zero minimum
        var validator = StringHasMinLen(input: "", minLen: 1)
        
        // Act: Perform validation check
        let result = validator.check()
        
        // Assert: Empty string should fail validation for non-zero minimum
        XCTAssertFalse(result, "Empty string with minLen 1 should fail validation")
        XCTAssertNotNil(validator.getError(), "Error should be set for empty string with non-zero minimum")
    }
    
    func testTC05_EmptyStringPassesZeroMinimum() {
        // Arrange: Create validator with empty string and zero minimum
        var validator = StringHasMinLen(input: "", minLen: 0)
        
        // Act: Perform validation check
        let result = validator.check()
        
        // Assert: Empty string should pass validation for zero minimum
        XCTAssertTrue(result, "Empty string with minLen 0 should pass validation")
        XCTAssertNil(validator.getError(), "No error should be set for empty string with zero minimum")
    }
    
    func testTC06_SingleCharacterStringBehavior() {
        // Arrange: Create validator with single character and minimum of 1
        var validator = StringHasMinLen(input: "a", minLen: 1)
        
        // Act: Perform validation check
        let result = validator.check()
        
        // Assert: Single character should pass with minimum of 1
        XCTAssertTrue(result, "Single character 'a' with minLen 1 should pass validation")
        XCTAssertNil(validator.getError(), "No error should be set for single character with minLen 1")
    }
    
    // MARK: - Test Cases for checkAndExec Method
    
    func testTC07_CheckAndExecCallsOnSuccessForValidInput() {
        // Arrange: Create validator with valid input and callback flags
        var validator = StringHasMinLen(input: "valid", minLen: 3)
        var onSuccessCalled = false
        var onFailCalled = false
        
        // Act: Execute checkAndExec with callbacks
        validator.checkAndExec(
            onSuccess: { onSuccessCalled = true },
            onFail: { onFailCalled = true }
        )
        
        // Assert: Only onSuccess should be called
        XCTAssertTrue(onSuccessCalled, "onSuccess callback should be called for valid input")
        XCTAssertFalse(onFailCalled, "onFail callback should not be called for valid input")
        XCTAssertNil(validator.getError(), "No error should be set after successful validation")
    }
    
    func testTC08_CheckAndExecCallsOnFailForInvalidInput() {
        // Arrange: Create validator with invalid input and callback flags
        var validator = StringHasMinLen(input: "no", minLen: 5)
        var onSuccessCalled = false
        var onFailCalled = false
        
        // Act: Execute checkAndExec with callbacks
        validator.checkAndExec(
            onSuccess: { onSuccessCalled = true },
            onFail: { onFailCalled = true }
        )
        
        // Assert: Only onFail should be called and error should be saved
        XCTAssertFalse(onSuccessCalled, "onSuccess callback should not be called for invalid input")
        XCTAssertTrue(onFailCalled, "onFail callback should be called for invalid input")
        XCTAssertNotNil(validator.getError(), "Error should be saved after failed validation")
    }
    
    // MARK: - Test Cases for ThrowableCheck Method
    
    func testTC09_ThrowableCheckSucceedsForValidInput() {
        // Arrange: Create validator with valid input
        var validator = StringHasMinLen(input: "valid", minLen: 3)
        
        // Act & Assert: ThrowableCheck should not throw for valid input
        XCTAssertNoThrow(try validator.ThrowableCheck(), "ThrowableCheck should not throw for valid input")
        XCTAssertNil(validator.getError(), "No error should be set after successful ThrowableCheck")
    }
    
    func testTC10_ThrowableCheckThrowsForInvalidInput() {
        // Arrange: Create validator with invalid input
        var validator = StringHasMinLen(input: "no", minLen: 5)
        
        // Act & Assert: ThrowableCheck should throw for invalid input
        XCTAssertThrowsError(try validator.ThrowableCheck(), "ThrowableCheck should throw for invalid input") { error in
            XCTAssertTrue(error is StringHasMinLenError, "Thrown error should be StringHasMinLenError")
            if let stringError = error as? StringHasMinLenError {
                XCTAssertEqual(stringError, StringHasMinLenError.providedInputIsSmallerThanMinLen, "Correct error case should be thrown")
            }
        }
        
        XCTAssertNotNil(validator.getError(), "Error should be saved after failed ThrowableCheck")
    }
    
    // MARK: - Test Cases for Error State Management
    
    func testTC11_GetErrorReturnsNilInitially() {
        // Arrange: Create fresh validator instance
        var validator = StringHasMinLen(input: "test", minLen: 3)
        
        // Act: Get error without performing any checks
        let error = validator.getError()
        
        // Assert: Error should be nil initially
        XCTAssertNil(error, "getError() should return nil for fresh validator instance")
    }
    
    func testTC12_GetErrorReturnsErrorAfterFailedCheck() {
        // Arrange: Create validator with invalid input
        var validator = StringHasMinLen(input: "x", minLen: 5)
        
        // Act: Perform failed check then get error
        let checkResult = validator.check()
        let error = validator.getError()
        
        // Assert: Error should be available after failed check
        XCTAssertFalse(checkResult, "Check should fail for invalid input")
        XCTAssertNotNil(error, "getError() should return error after failed check")
        XCTAssertTrue(error is StringHasMinLenError, "Error should be of correct type")
    }
    
    // MARK: - Test Cases for State and Multiple Operations
    
    func testTC13_MultipleConsecutiveChecksWorkCorrectly() {
        // Arrange: Create validator with valid input
        var validator = StringHasMinLen(input: "testing", minLen: 4)
        
        // Act: Perform multiple consecutive checks
        let result1 = validator.check()
        let result2 = validator.check()
        let result3 = validator.check()
        
        // Assert: All checks should return consistent results
        XCTAssertTrue(result1, "First check should pass")
        XCTAssertTrue(result2, "Second check should pass")
        XCTAssertTrue(result3, "Third check should pass")
        XCTAssertNil(validator.getError(), "No error should be set after multiple successful checks")
    }
    
    func testTC14_ErrorStatePersistsUntilReset() {
        // Arrange: Create validator with invalid input
        var validator = StringHasMinLen(input: "hi", minLen: 10)
        
        // Act: Perform failed check and query error multiple times
        let checkResult = validator.check()
        let error1 = validator.getError()
        let error2 = validator.getError()
        
        // Assert: Error should persist across multiple queries
        XCTAssertFalse(checkResult, "Check should fail")
        XCTAssertNotNil(error1, "First error query should return error")
        XCTAssertNotNil(error2, "Second error query should return error")
        
        // Verify both errors are the same
        if let e1 = error1 as? StringHasMinLenError, let e2 = error2 as? StringHasMinLenError {
            XCTAssertEqual(e1, e2, "Error should be consistent across multiple queries")
        }
    }
    
    func testTC15_VeryLongStringPassesValidation() {
        // Arrange: Create validator with very long string
        let longString = String(repeating: "a", count: 1000)
        var validator = StringHasMinLen(input: longString, minLen: 10)
        
        // Act: Perform validation check
        let result = validator.check()
        
        // Assert: Very long string should pass validation
        XCTAssertTrue(result, "Very long string should pass validation")
        XCTAssertNil(validator.getError(), "No error should be set for very long valid string")
    }
    
    // MARK: - Additional Edge Cases
    
    func testNegativeMinimumLength() {
        // Arrange: Create validator with negative minimum length
        var validator = StringHasMinLen(input: "test", minLen: -1)
        
        // Act: Perform validation check
        let result = validator.check()
        
        // Assert: Any string should pass with negative minimum
        XCTAssertTrue(result, "Any string should pass validation with negative minimum length")
        XCTAssertNil(validator.getError(), "No error should be set for negative minimum length")
    }
    
    func testUnicodeCharacterCounting() {
        // Arrange: Create validator with unicode characters
        var validator = StringHasMinLen(input: "🚀🌟💫", minLen: 3)
        
        // Act: Perform validation check
        let result = validator.check()
        
        // Assert: Unicode characters should be counted correctly
        XCTAssertTrue(result, "Unicode string with 3 characters should pass minLen 3 validation")
        XCTAssertNil(validator.getError(), "No error should be set for valid unicode string")
    }
    
    func testErrorTypeConsistency() {
        // Arrange: Create multiple validators with different invalid inputs
        var validator1 = StringHasMinLen(input: "", minLen: 1)
        var validator2 = StringHasMinLen(input: "a", minLen: 5)
        
        // Act: Perform failed checks
        _ = validator1.check()
        _ = validator2.check()
        
        // Assert: Both should produce the same error type
        let error1 = validator1.getError()
        let error2 = validator2.getError()
        
        XCTAssertTrue(error1 is StringHasMinLenError, "First validator should produce StringHasMinLenError")
        XCTAssertTrue(error2 is StringHasMinLenError, "Second validator should produce StringHasMinLenError")
        
        if let e1 = error1 as? StringHasMinLenError, let e2 = error2 as? StringHasMinLenError {
            XCTAssertEqual(e1, e2, "Both errors should be the same case")
        }
    }
}
