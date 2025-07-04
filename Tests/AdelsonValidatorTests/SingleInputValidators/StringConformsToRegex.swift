//
//  File.swift
//  AdelsonValidator
//
//  Created by ahmed on 03/07/2025.
//

import Foundation
import XCTest
@testable import AdelsonValidator

import XCTest

class StringConfromsToRegexTests: XCTestCase {
    
    // MARK: - Basic Functionality Tests
    
    func testBasicRegex_ValidEmail_ReturnsTrue() {
        var validator = StringConfromsToRegex(
            input: "test@example.com",
            regex: "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        )
        let result = validator.check()
        XCTAssertTrue(result)
        XCTAssertNil(validator.error)
    }
    
    func testBasicRegex_InvalidEmail_ReturnsFalse() {
        var validator = StringConfromsToRegex(
            input: "invalid-email",
            regex: "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        )
        let result = validator.check()
        XCTAssertFalse(result)
        XCTAssertNotNil(validator.error)
    }
    
    func testBasicRegex_ValidPhoneNumber_ReturnsTrue() {
        var validator = StringConfromsToRegex(
            input: "123-456-7890",
            regex: "^\\d{3}-\\d{3}-\\d{4}$"
        )
        let result = validator.check()
        XCTAssertTrue(result)
        XCTAssertNil(validator.error)
    }
    
    func testBasicRegex_InvalidPhoneNumber_ReturnsFalse() {
        var validator = StringConfromsToRegex(
            input: "123-45-6789",
            regex: "^\\d{3}-\\d{3}-\\d{4}$"
        )
        let result = validator.check()
        XCTAssertFalse(result)
        XCTAssertNotNil(validator.error)
    }
    
    // MARK: - Simple Pattern Tests
    
    func testSimplePattern_ExactMatch_ReturnsTrue() {
        var validator = StringConfromsToRegex(input: "hello", regex: "hello")
        let result = validator.check()
        XCTAssertTrue(result)
        XCTAssertNil(validator.error)
    }
    
    func testSimplePattern_NoMatch_ReturnsFalse() {
        var validator = StringConfromsToRegex(input: "hello", regex: "world")
        let result = validator.check()
        XCTAssertFalse(result)
        XCTAssertNotNil(validator.error)
    }
    
    func testSimplePattern_CaseSensitive_ReturnsFalse() {
        var validator = StringConfromsToRegex(input: "hello", regex: "Hello")
        let result = validator.check()
        XCTAssertFalse(result)
        XCTAssertNotNil(validator.error)
    }
    
    func testSimplePattern_CaseInsensitive_ReturnsTrue() {
        var validator = StringConfromsToRegex(input: "hello", regex: "(?i)Hello")
        let result = validator.check()
        XCTAssertTrue(result)
        XCTAssertNil(validator.error)
    }
    
    // MARK: - Digit Pattern Tests
    
    func testDigitPattern_ValidDigits_ReturnsTrue() {
        var validator = StringConfromsToRegex(input: "12345", regex: "^\\d+$")
        let result = validator.check()
        XCTAssertTrue(result)
        XCTAssertNil(validator.error)
    }
    
    func testDigitPattern_InvalidDigits_ReturnsFalse() {
        var validator = StringConfromsToRegex(input: "123a45", regex: "^\\d+$")
        let result = validator.check()
        XCTAssertFalse(result)
        XCTAssertNotNil(validator.error)
    }
    
    func testDigitPattern_ExactLength_ReturnsTrue() {
        var validator = StringConfromsToRegex(input: "12345", regex: "^\\d{5}$")
        let result = validator.check()
        XCTAssertTrue(result)
        XCTAssertNil(validator.error)
    }
    
    func testDigitPattern_WrongLength_ReturnsFalse() {
        var validator = StringConfromsToRegex(input: "1234", regex: "^\\d{5}$")
        let result = validator.check()
        XCTAssertFalse(result)
        XCTAssertNotNil(validator.error)
    }
    
    // MARK: - Character Class Tests
    
    func testCharacterClass_Alphanumeric_ReturnsTrue() {
        var validator = StringConfromsToRegex(input: "abc123", regex: "^[a-zA-Z0-9]+$")
        let result = validator.check()
        XCTAssertTrue(result)
        XCTAssertNil(validator.error)
    }
    
    func testCharacterClass_InvalidCharacters_ReturnsFalse() {
        var validator = StringConfromsToRegex(input: "abc123@", regex: "^[a-zA-Z0-9]+$")
        let result = validator.check()
        XCTAssertFalse(result)
        XCTAssertNotNil(validator.error)
    }
    
    func testCharacterClass_Range_ReturnsTrue() {
        var validator = StringConfromsToRegex(input: "m", regex: "^[a-z]$")
        let result = validator.check()
        XCTAssertTrue(result)
        XCTAssertNil(validator.error)
    }
    
    func testCharacterClass_OutOfRange_ReturnsFalse() {
        var validator = StringConfromsToRegex(input: "M", regex: "^[a-z]$")
        let result = validator.check()
        XCTAssertFalse(result)
        XCTAssertNotNil(validator.error)
    }
    
    // MARK: - Quantifier Tests
    
    func testQuantifier_ZeroOrMore_EmptyString_ReturnsTrue() {
        var validator = StringConfromsToRegex(input: "", regex: "^a*$")
        let result = validator.check()
        XCTAssertTrue(result)
        XCTAssertNil(validator.error)
    }
    
    func testQuantifier_ZeroOrMore_MultipleMatches_ReturnsTrue() {
        var validator = StringConfromsToRegex(input: "aaaa", regex: "^a*$")
        let result = validator.check()
        XCTAssertTrue(result)
        XCTAssertNil(validator.error)
    }
    
    func testQuantifier_OneOrMore_EmptyString_ReturnsFalse() {
        var validator = StringConfromsToRegex(input: "", regex: "^a+$")
        let result = validator.check()
        XCTAssertFalse(result)
        XCTAssertNotNil(validator.error)
    }
    
    func testQuantifier_OneOrMore_SingleMatch_ReturnsTrue() {
        var validator = StringConfromsToRegex(input: "a", regex: "^a+$")
        let result = validator.check()
        XCTAssertTrue(result)
        XCTAssertNil(validator.error)
    }
    
    func testQuantifier_ZeroOrOne_EmptyString_ReturnsTrue() {
        var validator = StringConfromsToRegex(input: "", regex: "^a?$")
        let result = validator.check()
        XCTAssertTrue(result)
        XCTAssertNil(validator.error)
    }
    
    func testQuantifier_ZeroOrOne_SingleMatch_ReturnsTrue() {
        var validator = StringConfromsToRegex(input: "a", regex: "^a?$")
        let result = validator.check()
        XCTAssertTrue(result)
        XCTAssertNil(validator.error)
    }
    
    func testQuantifier_ZeroOrOne_MultipleMatches_ReturnsFalse() {
        var validator = StringConfromsToRegex(input: "aa", regex: "^a?$")
        let result = validator.check()
        XCTAssertFalse(result)
        XCTAssertNotNil(validator.error)
    }
    
    // MARK: - Edge Cases
    
    func testEmptyInput_NonEmptyRegex_ReturnsFalse() {
        var validator = StringConfromsToRegex(input: "", regex: "a")
        let result = validator.check()
        XCTAssertFalse(result)
        XCTAssertNotNil(validator.error)
    }
    
    func testEmptyInput_OptionalRegex_ReturnsTrue() {
        var validator = StringConfromsToRegex(input: "", regex: "^a*$")
        let result = validator.check()
        XCTAssertTrue(result)
        XCTAssertNil(validator.error)
    }
    
    func testNonEmptyInput_EmptyRegex_ReturnsFalse() {
        var validator = StringConfromsToRegex(input: "hello", regex: "")
        let result = validator.check()
        XCTAssertFalse(result)
        XCTAssertNotNil(validator.error)
    }
    
    func testSingleCharacter_ExactMatch_ReturnsTrue() {
        var validator = StringConfromsToRegex(input: "a", regex: "a")
        let result = validator.check()
        XCTAssertTrue(result)
        XCTAssertNil(validator.error)
    }
    
    func testSingleCharacter_NoMatch_ReturnsFalse() {
        var validator = StringConfromsToRegex(input: "a", regex: "b")
        let result = validator.check()
        XCTAssertFalse(result)
        XCTAssertNotNil(validator.error)
    }
    
    // MARK: - Special Characters and Escaping Tests
    
    func testSpecialCharacters_Dot_ReturnsTrue() {
        var validator = StringConfromsToRegex(input: "a", regex: ".")
        let result = validator.check()
        XCTAssertTrue(result)
        XCTAssertNil(validator.error)
    }
    
    func testSpecialCharacters_EscapedDot_ReturnsTrue() {
        var validator = StringConfromsToRegex(input: ".", regex: "\\.")
        let result = validator.check()
        XCTAssertTrue(result)
        XCTAssertNil(validator.error)
    }
    
    func testSpecialCharacters_EscapedDot_ReturnsFalse() {
        var validator = StringConfromsToRegex(input: "a", regex: "\\.")
        let result = validator.check()
        XCTAssertFalse(result)
        XCTAssertNotNil(validator.error)
    }
    
    func testSpecialCharacters_Parentheses_ReturnsTrue() {
        var validator = StringConfromsToRegex(input: "(hello)", regex: "\\(hello\\)")
        let result = validator.check()
        XCTAssertTrue(result)
        XCTAssertNil(validator.error)
    }
    
    func testSpecialCharacters_Brackets_ReturnsTrue() {
        var validator = StringConfromsToRegex(input: "[hello]", regex: "\\[hello\\]")
        let result = validator.check()
        XCTAssertTrue(result)
        XCTAssertNil(validator.error)
    }
    
    // MARK: - Unicode and International Characters
    
    func testUnicodeCharacters_Emoji_ReturnsTrue() {
        var validator = StringConfromsToRegex(input: "🚀", regex: "🚀")
        let result = validator.check()
        XCTAssertTrue(result)
        XCTAssertNil(validator.error)
    }
    
    func testUnicodeCharacters_AccentedChars_ReturnsTrue() {
        var validator = StringConfromsToRegex(input: "café", regex: "café")
        let result = validator.check()
        XCTAssertTrue(result)
        XCTAssertNil(validator.error)
    }
    
    func testUnicodeCharacters_CyrillicChars_ReturnsTrue() {
        var validator = StringConfromsToRegex(input: "привет", regex: "привет")
        let result = validator.check()
        XCTAssertTrue(result)
        XCTAssertNil(validator.error)
    }
    
    // MARK: - Whitespace Tests
    
    func testWhitespace_Space_ReturnsTrue() {
        var validator = StringConfromsToRegex(input: " ", regex: "\\s")
        let result = validator.check()
        XCTAssertTrue(result)
        XCTAssertNil(validator.error)
    }
    
    func testWhitespace_Tab_ReturnsTrue() {
        var validator = StringConfromsToRegex(input: "\t", regex: "\\s")
        let result = validator.check()
        XCTAssertTrue(result)
        XCTAssertNil(validator.error)
    }
    
    func testWhitespace_Newline_ReturnsTrue() {
        var validator = StringConfromsToRegex(input: "\n", regex: "\\s")
        let result = validator.check()
        XCTAssertTrue(result)
        XCTAssertNil(validator.error)
    }
    
    func testWhitespace_MultipleSpaces_ReturnsTrue() {
        var validator = StringConfromsToRegex(input: "   ", regex: "^\\s+$")
        let result = validator.check()
        XCTAssertTrue(result)
        XCTAssertNil(validator.error)
    }
    
    // MARK: - Complex Pattern Tests
    
    func testComplexPattern_Password_Valid_ReturnsTrue() {
        var validator = StringConfromsToRegex(
            input: "Password123!",
            regex: "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[!@#$%^&*]).{8,}$"
        )
        let result = validator.check()
        XCTAssertTrue(result)
        XCTAssertNil(validator.error)
    }
    
    func testComplexPattern_Password_Invalid_ReturnsFalse() {
        var validator = StringConfromsToRegex(
            input: "password",
            regex: "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[!@#$%^&*]).{8,}$"
        )
        let result = validator.check()
        XCTAssertFalse(result)
        XCTAssertNotNil(validator.error)
    }
    
    func testComplexPattern_URL_Valid_ReturnsTrue() {
        var validator = StringConfromsToRegex(
            input: "https://www.example.com/path?query=value",
            regex: "^https?://[\\w\\.-]+\\.[a-zA-Z]{2,}(/[\\w\\.-]*)*/?(?:\\?[\\w&=%-]*)?$"
        )
        let result = validator.check()
        XCTAssertTrue(result)
        XCTAssertNil(validator.error)
    }
    
    func testComplexPattern_URL_Invalid_ReturnsFalse() {
        var validator = StringConfromsToRegex(
            input: "not-a-url",
            regex: "^https?://[\\w\\.-]+\\.[a-zA-Z]{2,}(/[\\w\\.-]*)*/?(?:\\?[\\w&=%-]*)?$"
        )
        let result = validator.check()
        XCTAssertFalse(result)
        XCTAssertNotNil(validator.error)
    }
    
    // MARK: - Error Handling Tests
    
    func testError_WhenCheckFails_SetsCorrectError() {
        var validator = StringConfromsToRegex(input: "hello", regex: "world")
        _ = validator.check()
        
        if let error = validator.error as? StringConfromsToRegexError {
            switch error {
            case .notConformingToGivenRegex(let regex):
                XCTAssertEqual(regex, "world")
            }
        } else {
            XCTFail("Expected StringConfromsToRegexError")
        }
    }
    
    func testGetError_ReturnsCorrectError() {
        var validator = StringConfromsToRegex(input: "hello", regex: "world")
        _ = validator.check()
        let error = validator.getError()
        XCTAssertNotNil(error)
        XCTAssertTrue(error is StringConfromsToRegexError)
    }
    
    func testGetError_WhenNoError_ReturnsNil() {
        var validator = StringConfromsToRegex(input: "hello", regex: "hello")
        _ = validator.check()
        let error = validator.getError()
        XCTAssertNil(error)
    }
    
    // MARK: - ThrowableCheck Tests
    
    func testThrowableCheck_WhenValid_DoesNotThrow() {
        var validator = StringConfromsToRegex(input: "hello", regex: "hello")
        XCTAssertNoThrow(try validator.ThrowableCheck())
    }
    
    func testThrowableCheck_WhenInvalid_ThrowsError() {
        var validator = StringConfromsToRegex(input: "hello", regex: "world")
        XCTAssertThrowsError(try validator.ThrowableCheck()) { error in
            XCTAssertTrue(error is StringConfromsToRegexError)
            if let regexError = error as? StringConfromsToRegexError {
                switch regexError {
                case .notConformingToGivenRegex(let regex):
                    XCTAssertEqual(regex, "world")
                }
            }
        }
    }
    
    func testThrowableCheck_WhenInvalid_SavesError() {
        var validator = StringConfromsToRegex(input: "hello", regex: "world")
        do {
            try validator.ThrowableCheck()
            XCTFail("Should have thrown an error")
        } catch {
            XCTAssertNotNil(validator.error)
        }
    }
    
    // MARK: - CheckAndExec Tests
    
    func testCheckAndExec_WhenValid_CallsOnSuccess() {
        var validator = StringConfromsToRegex(input: "hello", regex: "hello")
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
        var validator = StringConfromsToRegex(input: "hello", regex: "world")
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
        var validator = StringConfromsToRegex(input: "hello", regex: "world")
        validator.saveError()
        
        XCTAssertNotNil(validator.error)
        if let error = validator.error as? StringConfromsToRegexError {
            switch error {
            case .notConformingToGivenRegex(let regex):
                XCTAssertEqual(regex, "world")
            }
        } else {
            XCTFail("Expected StringConfromsToRegexError")
        }
    }
    
    // MARK: - Multiple Check Tests
    
    func testMultipleChecks_ErrorStateConsistency() {
        var validator = StringConfromsToRegex(input: "hello", regex: "world")
        
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
        var validator = StringConfromsToRegex(input: "hello", regex: "world")
        
        // First check fails
        _ = validator.check()
        XCTAssertNotNil(validator.error)
        
        // Change to valid regex
        validator = StringConfromsToRegex(input: "hello", regex: "hello")
        let result = validator.check()
        XCTAssertTrue(result)
        XCTAssertNil(validator.error)
    }
    
    // MARK: - Boundary Tests
    
    func testVeryLongString_ValidPattern_ReturnsTrue() {
        let longString = String(repeating: "a", count: 10000)
        var validator = StringConfromsToRegex(input: longString, regex: "^a+$")
        let result = validator.check()
        XCTAssertTrue(result)
        XCTAssertNil(validator.error)
    }
    
    func testVeryLongString_InvalidPattern_ReturnsFalse() {
        let longString = String(repeating: "a", count: 10000) + "b"
        var validator = StringConfromsToRegex(input: longString, regex: "^a+$")
        let result = validator.check()
        XCTAssertFalse(result)
        XCTAssertNotNil(validator.error)
    }
    
    func testComplexRegexPattern_ValidInput_ReturnsTrue() {
        var validator = StringConfromsToRegex(
            input: "test@example.com",
            regex: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        )
        let result = validator.check()
        XCTAssertTrue(result)
        XCTAssertNil(validator.error)
    }
    
    // MARK: - Performance Tests
    
    func testPerformance_ComplexRegex() {
        let input = "This is a test string with various characters 123!@#"
        let regex = "^[A-Za-z0-9\\s!@#$%^&*()_+\\-=\\[\\]{};':\"\\\\|,.<>\\/?]+$"
        
        measure {
            var validator = StringConfromsToRegex(input: input, regex: regex)
            _ = validator.check()
        }
    }
    
    // MARK: - Protocol Conformance Tests
    
    func testProtocolConformance_InputProperty() {
        let validator = StringConfromsToRegex(input: "hello", regex: "world")
        XCTAssertEqual(validator.input, "hello")
    }
    
    func testProtocolConformance_ErrorProperty() {
        var validator = StringConfromsToRegex(input: "hello", regex: "world")
        _ = validator.check()
        XCTAssertNotNil(validator.error)
    }
    
    func testProtocolConformance_RegexProperty() {
        let validator = StringConfromsToRegex(input: "hello", regex: "world")
        XCTAssertEqual(validator.regex, "world")
    }
}
