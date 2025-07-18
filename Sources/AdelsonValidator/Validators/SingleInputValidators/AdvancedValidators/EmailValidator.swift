//
//  File.swift
//  AdelsonValidator
//
//  Created by ahmed on 05/07/2025.
//

import Foundation
public enum EmailValidatorError: Error{
    case givenEmailNotValid
}

public struct EmailValidator: SingleInputValidator{
    public var input: String
    public var error: (any Error)?
    
    public init(input: String) {
        self.input = input
        self.error = nil
    }

    
    public mutating func setInput(input: String) {
        self.input = input
    }
    
    public mutating func check() -> Bool {
        var validatorRegex = StringConfromsToRegex(input: self.input, regex: "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$")
        if validatorRegex.check(){
            return true
        }
        saveError()
        return false
    }
    
    public mutating func saveError() {
        self.error = EmailValidatorError.givenEmailNotValid
    }
    
    
}
