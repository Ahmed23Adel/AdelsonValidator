import XCTest

@testable import AdelsonValidator

class StringContainsTests: XCTestCase {
    
    // MARK: - Basic Functionality Tests
    
    func testBasicContains_WhenSubstringExists_ReturnsTrue() {
        var validator = StringContains(input: "Hello World", substr: "World")
        let result = validator.check()
        XCTAssertTrue(result)
        XCTAssertNil(validator.error)
    }
    
    func testBasicContains_WhenSubstringDoesNotExist_ReturnsFalse() {
        var validator = StringContains(input: "Hello World", substr: "Swift")
        let result = validator.check()
        XCTAssertFalse(result)
        XCTAssertNotNil(validator.error)
    }
    
    func testBasicContains_WhenSubstringIsAtBeginning_ReturnsTrue() {
        var validator = StringContains(input: "Hello World", substr: "Hello")
        let result = validator.check()
        XCTAssertTrue(result)
        XCTAssertNil(validator.error)
    }
    
    func testBasicContains_WhenSubstringIsAtEnd_ReturnsTrue() {
        var validator = StringContains(input: "Hello World", substr: "World")
        let result = validator.check()
        XCTAssertTrue(result)
        XCTAssertNil(validator.error)
    }
    
    func testBasicContains_WhenSubstringIsEntireString_ReturnsTrue() {
        var validator = StringContains(input: "Hello", substr: "Hello")
        let result = validator.check()
        XCTAssertTrue(result)
        XCTAssertNil(validator.error)
    }
    
    // MARK: - Edge Cases
    
    func testEmptySubstring_ReturnsTrue() {
        var validator = StringContains(input: "Hello World", substr: "")
        let result = validator.check()
        XCTAssertTrue(result)
        XCTAssertNil(validator.error)
    }
    
    func testEmptyInput_WithNonEmptySubstring_ReturnsFalse() {
        var validator = StringContains(input: "", substr: "test")
        let result = validator.check()
        XCTAssertFalse(result)
        XCTAssertNotNil(validator.error)
    }
    
    func testEmptyInput_WithEmptySubstring_ReturnsTrue() {
        var validator = StringContains(input: "", substr: "")
        let result = validator.check()
        XCTAssertTrue(result)
        XCTAssertNil(validator.error)
    }
    
    func testSingleCharacter_Contains_ReturnsTrue() {
        var validator = StringContains(input: "a", substr: "a")
        let result = validator.check()
        XCTAssertTrue(result)
        XCTAssertNil(validator.error)
    }
    
    func testSingleCharacter_DoesNotContain_ReturnsFalse() {
        var validator = StringContains(input: "a", substr: "b")
        let result = validator.check()
        XCTAssertFalse(result)
        XCTAssertNotNil(validator.error)
    }
    
    // MARK: - Case Sensitivity Tests
    
    func testCaseSensitivity_DifferentCase_ReturnsFalse() {
        var validator = StringContains(input: "Hello World", substr: "hello")
        let result = validator.check()
        XCTAssertFalse(result)
        XCTAssertNotNil(validator.error)
    }
    
    func testCaseSensitivity_ExactCase_ReturnsTrue() {
        var validator = StringContains(input: "Hello World", substr: "Hello")
        let result = validator.check()
        XCTAssertTrue(result)
        XCTAssertNil(validator.error)
    }
    
    // MARK: - Special Characters Tests
    
    func testSpecialCharacters_Contains_ReturnsTrue() {
        var validator = StringContains(input: "Hello@World#123", substr: "@World#")
        let result = validator.check()
        XCTAssertTrue(result)
        XCTAssertNil(validator.error)
    }
    
    func testUnicodeCharacters_Contains_ReturnsTrue() {
        var validator = StringContains(input: "Hello 🌍 World", substr: "🌍")
        let result = validator.check()
        XCTAssertTrue(result)
        XCTAssertNil(validator.error)
    }
    
    func testWhitespaceCharacters_Contains_ReturnsTrue() {
        var validator = StringContains(input: "Hello\tWorld\n", substr: "\t")
        let result = validator.check()
        XCTAssertTrue(result)
        XCTAssertNil(validator.error)
    }
    
    // MARK: - Error Handling Tests
    
    func testError_WhenCheckFails_SetsCorrectError() {
        var validator = StringContains(input: "Hello World", substr: "Swift")
        _ = validator.check()
        
        if let error = validator.error as? StringContainsError {
            switch error {
            case .errorNotContains(let substr):
                XCTAssertEqual(substr, "Swift")
            }
        } else {
            XCTFail("Expected StringContainsError")
        }
    }
    
    func testGetError_ReturnsCorrectError() {
        var validator = StringContains(input: "Hello World", substr: "Swift")
        _ = validator.check()
        let error = validator.getError()
        XCTAssertNotNil(error)
        XCTAssertTrue(error is StringContainsError)
    }
    
    func testGetError_WhenNoError_ReturnsNil() {
        var validator = StringContains(input: "Hello World", substr: "World")
        _ = validator.check()
        let error = validator.getError()
        XCTAssertNil(error)
    }
    
    // MARK: - ThrowableCheck Tests
    
    func testThrowableCheck_WhenValid_DoesNotThrow() {
        var validator = StringContains(input: "Hello World", substr: "World")
        XCTAssertNoThrow(try validator.ThrowableCheck())
    }
    
    func testThrowableCheck_WhenInvalid_ThrowsError() {
        var validator = StringContains(input: "Hello World", substr: "Swift")
        XCTAssertThrowsError(try validator.ThrowableCheck()) { error in
            XCTAssertTrue(error is StringContainsError)
            if let containsError = error as? StringContainsError {
                switch containsError {
                case .errorNotContains(let substr):
                    XCTAssertEqual(substr, "Swift")
                }
            }
        }
    }
    
    func testThrowableCheck_WhenInvalid_SavesError() {
        var validator = StringContains(input: "Hello World", substr: "Swift")
        do {
            try validator.ThrowableCheck()
            XCTFail("Should have thrown an error")
        } catch {
            XCTAssertNotNil(validator.error)
        }
    }
    
    // MARK: - CheckAndExec Tests
    
    func testCheckAndExec_WhenValid_CallsOnSuccess() {
        var validator = StringContains(input: "Hello World", substr: "World")
        var successCalled = false
        var failCalled = false
        
        validator.checkAndExec(
            onSuccess: { successCalled = true },
            onFail: { failCalled = true }
        )
        
        XCTAssertTrue(successCalled)
        XCTAssertFalse(failCalled)
        XCTAssertNil(validator.error)
    }
    
    func testCheckAndExec_WhenInvalid_CallsOnFail() {
        var validator = StringContains(input: "Hello World", substr: "Swift")
        var successCalled = false
        var failCalled = false
        
        validator.checkAndExec(
            onSuccess: { successCalled = true },
            onFail: { failCalled = true }
        )
        
        XCTAssertFalse(successCalled)
        XCTAssertTrue(failCalled)
        XCTAssertNotNil(validator.error)
    }
    
    // MARK: - SaveError Tests
    
    func testSaveError_SetsCorrectError() {
        var validator = StringContains(input: "Hello World", substr: "Swift")
        validator.saveError()
        
        XCTAssertNotNil(validator.error)
        if let error = validator.error as? StringContainsError {
            switch error {
            case .errorNotContains(let substr):
                XCTAssertEqual(substr, "Swift")
            }
        } else {
            XCTFail("Expected StringContainsError")
        }
    }
    
    // MARK: - Multiple Check Tests
    
    func testMultipleChecks_ErrorStateConsistency() {
        var validator = StringContains(input: "Hello World", substr: "Swift")
        
        // First check should fail and set error
        let firstResult = validator.check()
        XCTAssertFalse(firstResult)
        XCTAssertNotNil(validator.error)
        
        // Second check should still fail and maintain error
        let secondResult = validator.check()
        XCTAssertFalse(secondResult)
        XCTAssertNotNil(validator.error)
    }
    
    func testMultipleChecks_SuccessAfterFailure() {
        var validator = StringContains(input: "Hello World", substr: "Swift")
        
        // First check fails
        _ = validator.check()
        XCTAssertNotNil(validator.error)
        
        // Change to valid substring
        validator = StringContains(input: "Hello World", substr: "World")
        let result = validator.check()
        XCTAssertTrue(result)
        XCTAssertNil(validator.error)
    }
    
    // MARK: - Boundary Tests
    
    func testVeryLongStrings() {
        let longString = String(repeating: "a", count: 10000)
        let substring = String(repeating: "a", count: 100)
        
        var validator = StringContains(input: longString, substr: substring)
        let result = validator.check()
        XCTAssertTrue(result)
        XCTAssertNil(validator.error)
    }
    
    func testSubstringLongerThanInput_ReturnsFalse() {
        var validator = StringContains(input: "Hi", substr: "Hello World")
        let result = validator.check()
        XCTAssertFalse(result)
        XCTAssertNotNil(validator.error)
    }
    
    // MARK: - Performance Tests
    
    func testPerformance_LargeString() {
        let largeString = String(repeating: "Hello World ", count: 1000)
        let substring = "World"
        
        measure {
            var validator = StringContains(input: largeString, substr: substring)
            _ = validator.check()
        }
    }
    
    // MARK: - Protocol Conformance Tests
    
    func testProtocolConformance_InputProperty() {
        let validator = StringContains(input: "Hello World", substr: "World")
        XCTAssertEqual(validator.input, "Hello World")
    }
    
    func testProtocolConformance_ErrorProperty() {
        var validator = StringContains(input: "Hello World", substr: "Swift")
        _ = validator.check()
        XCTAssertNotNil(validator.error)
    }
}
