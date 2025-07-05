import XCTest

@testable import AdelsonValidator
import XCTest

class StringContainsTests: XCTestCase {
    
    // MARK: - Basic Functionality Tests
    
    func testBasicSubstringValidationSuccess() {
        // TC001: Verify basic substring validation success
        // Arrange
        var validator = StringContains(input: "Hello World", substr: "World")
        
        // Act
        let result = validator.check()
        
        // Assert
        XCTAssertTrue(result, "Should return true when substring exists")
        XCTAssertNil(validator.error, "Error should be nil on successful validation")
    }
    
    func testBasicSubstringValidationFailure() {
        // TC002: Verify basic substring validation failure
        // Arrange
        var validator = StringContains(input: "Hello World", substr: "xyz")
        
        // Act
        let result = validator.check()
        
        // Assert
        XCTAssertFalse(result, "Should return false when substring doesn't exist")
        XCTAssertNotNil(validator.error, "Error should be set on validation failure")
        
        if case StringContainsError.errorNotContains(let substr) = validator.error as! StringContainsError {
            XCTAssertEqual(substr, "xyz", "Error should contain the substring that wasn't found")
        } else {
            XCTFail("Expected StringContainsError.errorNotContains")
        }
    }
    
    // MARK: - Edge Cases
    
    func testEmptySubstringAlwaysPasses() {
        // TC003: Verify empty substring always passes
        // Arrange
        var validator = StringContains(input: "Hello World", substr: "")
        
        // Act
        let result = validator.check()
        
        // Assert
        XCTAssertTrue(result, "Empty substring should always pass validation")
        XCTAssertNil(validator.error, "Error should be nil when empty substring passes")
    }
    
    func testEmptyInputWithNonEmptySubstringFails() {
        // TC004: Verify empty input with non-empty substring fails
        // Arrange
        var validator = StringContains(input: "", substr: "test")
        
        // Act
        let result = validator.check()
        
        // Assert
        XCTAssertFalse(result, "Should fail when searching for substring in empty input")
        XCTAssertNotNil(validator.error, "Error should be set when validation fails")
    }
    
    func testEmptyInputWithEmptySubstringPasses() {
        // TC005: Verify empty input with empty substring passes
        // Arrange
        var validator = StringContains(input: "", substr: "")
        
        // Act
        let result = validator.check()
        
        // Assert
        XCTAssertTrue(result, "Empty substring should pass even with empty input")
        XCTAssertNil(validator.error, "Error should be nil when validation passes")
    }
    
    func testCaseSensitiveValidation() {
        // TC006: Verify case-sensitive validation
        // Arrange
        var validator = StringContains(input: "Hello", substr: "hello")
        
        // Act
        let result = validator.check()
        
        // Assert
        XCTAssertFalse(result, "Validation should be case-sensitive")
        XCTAssertNotNil(validator.error, "Error should be set when case doesn't match")
    }
    
    // MARK: - Position Tests
    
    func testSubstringAtBeginning() {
        // TC007: Verify substring at beginning
        // Arrange
        var validator = StringContains(input: "Hello World", substr: "Hello")
        
        // Act
        let result = validator.check()
        
        // Assert
        XCTAssertTrue(result, "Should find substring at beginning of input")
        XCTAssertNil(validator.error, "Error should be nil when substring is found")
    }
    
    func testSubstringAtEnd() {
        // TC008: Verify substring at end
        // Arrange
        var validator = StringContains(input: "Hello World", substr: "World")
        
        // Act
        let result = validator.check()
        
        // Assert
        XCTAssertTrue(result, "Should find substring at end of input")
        XCTAssertNil(validator.error, "Error should be nil when substring is found")
    }
    
    func testSubstringInMiddle() {
        // TC009: Verify substring in middle
        // Arrange
        var validator = StringContains(input: "Hello World", substr: "lo Wo")
        
        // Act
        let result = validator.check()
        
        // Assert
        XCTAssertTrue(result, "Should find substring in middle of input")
        XCTAssertNil(validator.error, "Error should be nil when substring is found")
    }
    
    func testExactMatch() {
        // TC010: Verify exact match
        // Arrange
        var validator = StringContains(input: "Hello", substr: "Hello")
        
        // Act
        let result = validator.check()
        
        // Assert
        XCTAssertTrue(result, "Should pass when substring exactly matches input")
        XCTAssertNil(validator.error, "Error should be nil on exact match")
    }
    
    func testPartialMatchFailure() {
        // TC011: Verify partial match failure
        // Arrange
        var validator = StringContains(input: "Hello", substr: "Hello World")
        
        // Act
        let result = validator.check()
        
        // Assert
        XCTAssertFalse(result, "Should fail when substring is longer than input")
        XCTAssertNotNil(validator.error, "Error should be set when validation fails")
    }
    
    // MARK: - State Management Tests
    
    func testSetInputClearsPreviousError() {
        // TC012: Verify setInput clears previous error
        // Arrange
        var validator = StringContains(input: "Hello", substr: "xyz")
        _ = validator.check() // This will set an error
        XCTAssertNotNil(validator.error, "Error should be set initially")
        
        // Act
        validator.setInput(input: "Hello World")
        
        // Assert
        XCTAssertNil(validator.error, "Error should be cleared after setInput")
        XCTAssertEqual(validator.input, "Hello World", "Input should be updated")
    }
    
    // MARK: - Callback Tests
    
    func testCheckAndExecCallsOnSuccessOnValidInput() {
        // TC013: Verify checkAndExec calls onSuccess on valid input
        // Arrange
        var validator = StringContains(input: "Hello", substr: "ell")
        var onSuccessCalled = false
        var onFailCalled = false
        
        // Act
        validator.checkAndExec(
            onSuccess: { onSuccessCalled = true },
            onFail: { onFailCalled = true }
        )
        
        // Assert
        XCTAssertTrue(onSuccessCalled, "onSuccess should be called for valid input")
        XCTAssertFalse(onFailCalled, "onFail should not be called for valid input")
    }
    
    func testCheckAndExecCallsOnFailOnInvalidInput() {
        // TC014: Verify checkAndExec calls onFail on invalid input
        // Arrange
        var validator = StringContains(input: "Hello", substr: "xyz")
        var onSuccessCalled = false
        var onFailCalled = false
        
        // Act
        validator.checkAndExec(
            onSuccess: { onSuccessCalled = true },
            onFail: { onFailCalled = true }
        )
        
        // Assert
        XCTAssertFalse(onSuccessCalled, "onSuccess should not be called for invalid input")
        XCTAssertTrue(onFailCalled, "onFail should be called for invalid input")
        XCTAssertNotNil(validator.error, "Error should be saved when onFail is called")
    }
    
    // MARK: - Exception Tests
    
    func testThrowableCheckThrowsOnFailure() {
        // TC015: Verify ThrowableCheck throws on failure
        // Arrange
        var validator = StringContains(input: "Hello", substr: "xyz")
        
        // Act & Assert
        XCTAssertThrowsError(try validator.ThrowableCheck()) { error in
            XCTAssertTrue(error is StringContainsError, "Should throw StringContainsError")
            if case StringContainsError.errorNotContains(let substr) = error as! StringContainsError {
                XCTAssertEqual(substr, "xyz", "Error should contain the substring that wasn't found")
            }
        }
        XCTAssertNotNil(validator.error, "Error should be saved when exception is thrown")
    }
    
    func testThrowableCheckSucceedsWithoutThrowing() {
        // TC016: Verify ThrowableCheck succeeds without throwing
        // Arrange
        var validator = StringContains(input: "Hello", substr: "ell")
        
        // Act & Assert
        XCTAssertNoThrow(try validator.ThrowableCheck(), "Should not throw for valid input")
    }
    
    // MARK: - Error Handling Tests
    
    func testGetErrorReturnsCurrentError() {
        // TC017: Verify getError returns current error
        // Arrange
        var validator = StringContains(input: "Hello", substr: "xyz")
        _ = validator.check() // This will set an error
        
        // Act
        let error = validator.getError()
        
        // Assert
        XCTAssertNotNil(error, "getError should return the current error")
        XCTAssertTrue(error is StringContainsError, "Error should be of type StringContainsError")
    }
    
    func testSaveErrorSetsErrorCorrectly() {
        // TC018: Verify saveError sets error correctly
        // Arrange
        var validator = StringContains(input: "Hello", substr: "xyz")
        
        // Act
        validator.saveError()
        
        // Assert
        XCTAssertNotNil(validator.error, "saveError should set the error")
        if case StringContainsError.errorNotContains(let substr) = validator.error as! StringContainsError {
            XCTAssertEqual(substr, "xyz", "Error should contain the correct substring")
        } else {
            XCTFail("Expected StringContainsError.errorNotContains")
        }
    }
    
    // MARK: - Initialization Tests
    
    func testInitializationWithBothParameters() {
        // TC019: Verify initialization with both parameters
        // Arrange & Act
        let validator = StringContains(input: "test", substr: "es")
        
        // Assert
        XCTAssertEqual(validator.input, "test", "Input should be set correctly")
        XCTAssertEqual(validator.substr, "es", "Substr should be set correctly")
        XCTAssertNil(validator.error, "Error should be nil initially")
    }
    
    func testInitializationWithSubstrOnly() {
        // TC020: Verify initialization with substr only
        // Arrange & Act
        let validator = StringContains(substr: "test")
        
        // Assert
        XCTAssertEqual(validator.input, "", "Input should be empty string")
        XCTAssertEqual(validator.substr, "test", "Substr should be set correctly")
        XCTAssertNil(validator.error, "Error should be nil initially")
    }
    
    // MARK: - Special Character Tests
    
    func testSpecialCharactersInSubstring() {
        // TC021: Verify special characters in substring
        // Arrange
        var validator = StringContains(input: "test@example.com", substr: "@")
        
        // Act
        let result = validator.check()
        
        // Assert
        XCTAssertTrue(result, "Should find special characters in substring")
        XCTAssertNil(validator.error, "Error should be nil when special character is found")
    }
    
    func testUnicodeCharacters() {
        // TC022: Verify unicode characters
        // Arrange
        var validator = StringContains(input: "Hello 世界", substr: "世界")
        
        // Act
        let result = validator.check()
        
        // Assert
        XCTAssertTrue(result, "Should handle unicode characters correctly")
        XCTAssertNil(validator.error, "Error should be nil when unicode substring is found")
    }
    
    func testWhitespaceHandling() {
        // TC023: Verify whitespace handling
        // Arrange
        var validator = StringContains(input: "Hello World", substr: " ")
        
        // Act
        let result = validator.check()
        
        // Assert
        XCTAssertTrue(result, "Should find whitespace characters")
        XCTAssertNil(validator.error, "Error should be nil when whitespace is found")
    }
    
    func testMultipleOccurrences() {
        // TC024: Verify multiple occurrences
        // Arrange
        var validator = StringContains(input: "Hello Hello", substr: "Hello")
        
        // Act
        let result = validator.check()
        
        // Assert
        XCTAssertTrue(result, "Should find substring even with multiple occurrences")
        XCTAssertNil(validator.error, "Error should be nil when substring is found")
    }
    
    // MARK: - Protocol Method Tests
    
    func testProtocolMethodsWorkTogether() {
        // Integration test to verify all protocol methods work together
        // Arrange
        var validator = StringContains(substr: "test")
        
        // Act & Assert - Test initialization state
        XCTAssertEqual(validator.input, "", "Initial input should be empty")
        XCTAssertNil(validator.getError(), "Initial error should be nil")
        
        // Act & Assert - Test setInput
        validator.setInput(input: "testing")
        XCTAssertEqual(validator.input, "testing", "Input should be updated")
        
        // Act & Assert - Test successful validation
        XCTAssertTrue(validator.check(), "Should pass validation")
        XCTAssertNil(validator.getError(), "Error should remain nil after successful check")
        
        // Act & Assert - Test failed validation
        validator.setInput(input: "hello")
        XCTAssertFalse(validator.check(), "Should fail validation")
        XCTAssertNotNil(validator.getError(), "Error should be set after failed check")
    }
}

// MARK: - Helper Extensions for Testing

extension StringContainsError: Equatable {
    public static func == (lhs: StringContainsError, rhs: StringContainsError) -> Bool {
        switch (lhs, rhs) {
        case (.errorNotContains(let substr1), .errorNotContains(let substr2)):
            return substr1 == substr2
        }
    }
}
