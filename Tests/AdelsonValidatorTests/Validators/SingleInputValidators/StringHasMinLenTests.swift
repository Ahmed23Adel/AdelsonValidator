@testable import AdelsonValidator
import XCTest


class StringHasMinLenTests: XCTestCase {
    
    // MARK: - TC001: Test initialization with input and minLen
    func testInitializationWithInputAndMinLen() {
        // Arrange & Act
        let validator = StringHasMinLen(input: "hello", minLen: 3)
        
        // Assert
        XCTAssertEqual(validator.input, "hello")
        XCTAssertEqual(validator.minLen, 3)
        XCTAssertNil(validator.error)
    }
    
    // MARK: - TC002: Test initialization with only minLen
    func testInitializationWithOnlyMinLen() {
        // Arrange & Act
        let validator = StringHasMinLen(minLen: 5)
        
        // Assert
        XCTAssertEqual(validator.input, "")
        XCTAssertEqual(validator.minLen, 5)
        XCTAssertNil(validator.error)
    }
    
    // MARK: - TC003: Test setInput functionality
    func testSetInputFunctionality() {
        // Arrange
        var validator = StringHasMinLen(minLen: 3)
        // Set an initial error state
        _ = validator.check() // This will fail and set error
        XCTAssertNotNil(validator.error)
        
        // Act
        validator.setInput(input: "test")
        
        // Assert
        XCTAssertEqual(validator.input, "test")
        XCTAssertNil(validator.error) // Error should be reset
    }
    
    // MARK: - TC004: Test check() with valid input
    func testCheckWithValidInput() {
        // Arrange
        var validator = StringHasMinLen(input: "hello", minLen: 3)
        
        // Act
        let result = validator.check()
        
        // Assert
        XCTAssertTrue(result)
        XCTAssertNil(validator.error)
    }
    
    // MARK: - TC005: Test check() with invalid input
    func testCheckWithInvalidInput() {
        // Arrange
        var validator = StringHasMinLen(input: "hi", minLen: 5)
        
        // Act
        let result = validator.check()
        
        // Assert
        XCTAssertFalse(result)
        XCTAssertNotNil(validator.error)
        XCTAssertTrue(validator.error is StringHasMinLenError)
    }
    
    // MARK: - TC006: Test check() with exact minimum length
    func testCheckWithExactMinimumLength() {
        // Arrange
        var validator = StringHasMinLen(input: "hello", minLen: 5)
        
        // Act
        let result = validator.check()
        
        // Assert
        XCTAssertTrue(result)
        XCTAssertNil(validator.error)
    }
    
    // MARK: - TC007: Test check() with empty string
    func testCheckWithEmptyString() {
        // Arrange
        var validator = StringHasMinLen(input: "", minLen: 1)
        
        // Act
        let result = validator.check()
        
        // Assert
        XCTAssertFalse(result)
        XCTAssertNotNil(validator.error)
    }
    
    // MARK: - TC008: Test check() with zero minimum length
    func testCheckWithZeroMinimumLength() {
        // Arrange
        var validator = StringHasMinLen(input: "", minLen: 0)
        
        // Act
        let result = validator.check()
        
        // Assert
        XCTAssertTrue(result)
        XCTAssertNil(validator.error)
    }
    
    // MARK: - TC009: Test checkAndExec with success case
    func testCheckAndExecWithSuccessCase() {
        // Arrange
        var validator = StringHasMinLen(input: "hello", minLen: 3)
        var successCalled = false
        var failCalled = false
        
        // Act
        validator.checkAndExec(
            onSuccess: { successCalled = true },
            onFail: { failCalled = true }
        )
        
        // Assert
        XCTAssertTrue(successCalled)
        XCTAssertFalse(failCalled)
        XCTAssertNil(validator.error)
    }
    
    // MARK: - TC010: Test checkAndExec with failure case
    func testCheckAndExecWithFailureCase() {
        // Arrange
        var validator = StringHasMinLen(input: "hi", minLen: 5)
        var successCalled = false
        var failCalled = false
        
        // Act
        validator.checkAndExec(
            onSuccess: { successCalled = true },
            onFail: { failCalled = true }
        )
        
        // Assert
        XCTAssertFalse(successCalled)
        XCTAssertTrue(failCalled)
        XCTAssertNotNil(validator.error)
    }
    
    // MARK: - TC011: Test ThrowableCheck with valid input
    func testThrowableCheckWithValidInput() {
        // Arrange
        var validator = StringHasMinLen(input: "hello", minLen: 3)
        
        // Act & Assert
        XCTAssertNoThrow(try validator.ThrowableCheck())
        XCTAssertNil(validator.error)
    }
    
    // MARK: - TC012: Test ThrowableCheck with invalid input
    func testThrowableCheckWithInvalidInput() {
        // Arrange
        var validator = StringHasMinLen(input: "hi", minLen: 5)
        
        // Act & Assert
        XCTAssertThrowsError(try validator.ThrowableCheck()) { error in
            XCTAssertTrue(error is StringHasMinLenError)
        }
        XCTAssertNotNil(validator.error)
    }
    
    // MARK: - TC013: Test getError() after successful validation
    func testGetErrorAfterSuccessfulValidation() {
        // Arrange
        var validator = StringHasMinLen(input: "hello", minLen: 3)
        _ = validator.check()
        
        // Act
        let error = validator.getError()
        
        // Assert
        XCTAssertNil(error)
    }
    
    // MARK: - TC014: Test getError() after failed validation
    func testGetErrorAfterFailedValidation() {
        // Arrange
        var validator = StringHasMinLen(input: "hi", minLen: 5)
        _ = validator.check()
        
        // Act
        let error = validator.getError()
        
        // Assert
        XCTAssertNotNil(error)
        XCTAssertTrue(error is StringHasMinLenError)
    }
    
    // MARK: - TC015: Test multiple setInput calls
    func testMultipleSetInputCalls() {
        // Arrange
        var validator = StringHasMinLen(input: "short", minLen: 10)
        _ = validator.check() // This will fail and set error
        XCTAssertNotNil(validator.error)
        
        // Act
        validator.setInput(input: "first")
        XCTAssertNil(validator.error) // Error should be cleared
        
        validator.setInput(input: "second")
        
        // Assert
        XCTAssertEqual(validator.input, "second")
        XCTAssertNil(validator.error)
    }
    
    // MARK: - TC016: Test error persistence and clearing
    func testErrorPersistenceAndClearing() {
        // Arrange
        var validator = StringHasMinLen(input: "hi", minLen: 5)
        
        // Act - First check (should fail)
        let firstResult = validator.check()
        XCTAssertFalse(firstResult)
        XCTAssertNotNil(validator.error)
        
        // Act - Set valid input
        validator.setInput(input: "hello world")
        XCTAssertNil(validator.error) // Error should be cleared
        
        // Act - Second check (should succeed)
        let secondResult = validator.check()
        
        // Assert
        XCTAssertTrue(secondResult)
        XCTAssertNil(validator.error)
    }
    
    // MARK: - TC017: Test negative minLen
    func testNegativeMinLen() {
        // Arrange
        var validator = StringHasMinLen(input: "test", minLen: -1)
        
        // Act
        let result = validator.check()
        
        // Assert
        // With negative minLen, any string should pass
        XCTAssertTrue(result)
        XCTAssertNil(validator.error)
    }
    
    // MARK: - TC018: Test very large minLen
    func testVeryLargeMinLen() {
        // Arrange
        var validator = StringHasMinLen(input: "test", minLen: Int.max)
        
        // Act
        let result = validator.check()
        
        // Assert
        XCTAssertFalse(result)
        XCTAssertNotNil(validator.error)
    }
    
    // MARK: - TC019: Test Unicode characters
    func testUnicodeCharacters() {
        // Arrange
        var validator = StringHasMinLen(input: "🚀🌟", minLen: 1)
        
        // Act
        let result = validator.check()
        
        // Assert
        XCTAssertTrue(result)
        XCTAssertNil(validator.error)
        
        // Test exact count
        validator.setInput(input: "🚀🌟")
        validator = StringHasMinLen(input: "🚀🌟", minLen: 2)
        let exactResult = validator.check()
        XCTAssertTrue(exactResult)
    }
    
    // MARK: - TC020: Test state consistency after multiple operations
    func testStateConsistencyAfterMultipleOperations() {
        // Arrange
        var validator = StringHasMinLen(minLen: 3)
        
        // Act - Multiple operations
        validator.setInput(input: "hi")
        let firstCheck = validator.check()
        
        validator.setInput(input: "hello")
        let secondCheck = validator.check()
        
        validator.setInput(input: "x")
        let thirdCheck = validator.check()
        
        // Assert
        XCTAssertFalse(firstCheck)
        XCTAssertTrue(secondCheck)
        XCTAssertFalse(thirdCheck)
        XCTAssertNotNil(validator.error) // Should have error from last failed check
    }
}
