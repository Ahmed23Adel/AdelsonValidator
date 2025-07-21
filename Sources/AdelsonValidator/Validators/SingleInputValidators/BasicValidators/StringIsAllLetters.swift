//
//  File.swift
//  AdelsonValidator
//
//  Created by ahmed on 21/07/2025.
//

import Foundation

public enum StringIsAllLettersError: AdelsonReadableError {
    case containsNonLetterCharacters

    public var message: String {
        switch self {
        case .containsNonLetterCharacters:
            return "The input must contain only letters."
        }
    }
}
public struct StringIsAllLetters: SingleInputValidator {
    public var input: String
    public var error: (any Error)?

    public init() {
        self.input = ""
    }

    public mutating func setInput(input: String) {
        self.input = input
    }

    public mutating func check() -> Bool {
        let isAllLetters = input.allSatisfy { $0.isLetter }
        if isAllLetters {
            return true
        } else {
            saveError()
            return false
        }
    }

    public mutating func saveError() {
        self.error = StringIsAllLettersError.containsNonLetterCharacters
    }
}
