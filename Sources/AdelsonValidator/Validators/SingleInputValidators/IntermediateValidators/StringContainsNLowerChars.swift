//
//  File.swift
//  AdelsonValidator
//
//  Created by ahmed on 06/07/2025.
//

import Foundation

public enum StringContainsNLowerCharsError: AdelsonReadableError {
    case notContainsNLowerChars

    public var message: String {
        switch self {
        case .notContainsNLowerChars:
            return "The input must contain at least the required number of lowercase letters."
        }
    }
}
public  struct StringContainsNLowerChars: SingleInputValidator{
    public var input: String
    public var n: Int
    public var error: (any Error)?
    
    public init(n: Int){
        self.n = n
        self.input = ""
    }
    
    public mutating func setInput(input: String) {
        self.input = input
    }
    public mutating func check() -> Bool {
        let lowerCaseCharsCount = input.filter{ $0.isLowercase }.count
        if lowerCaseCharsCount >= n{
            return true
        } else{
            saveError()
            return false
        }
    }
    
    public mutating func saveError() {
        self.error = StringContainsNLowerCharsError.notContainsNLowerChars
    }
    
    
}
