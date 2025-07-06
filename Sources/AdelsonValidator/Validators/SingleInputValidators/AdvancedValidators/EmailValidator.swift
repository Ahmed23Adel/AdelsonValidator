//
//  File.swift
//  AdelsonValidator
//
//  Created by ahmed on 05/07/2025.
//

import Foundation
enum EmailValidatorError: Error{
    case givenEmailNotValid
}

struct EmailValidator: SingleInputValidator{
    var input: String
    var error: (any Error)?
    
    mutating func setInput(input: String) {
        self.input = input
    }
    
    mutating func check() -> Bool {
        var validatorRegex = StringConfromsToRegex(regex: "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$")
        if validatorRegex.check(){
            return true
        }
        saveError()
        return false
    }
    
    mutating func saveError() {
        self.error = EmailValidatorError.givenEmailNotValid
    }
    
    
}
