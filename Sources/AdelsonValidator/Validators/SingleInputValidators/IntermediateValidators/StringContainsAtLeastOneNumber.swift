//
//  File.swift
//  AdelsonValidator
//
//  Created by ahmed on 05/07/2025.
//

import Foundation

enum StringContainsAtLeastOneNumError: Error{
    case givenInputDoesnotContainAtLeastOneNum
}

struct StringContainsAtLeastOneNumber: SingleInputValidator{
    var input: String
    var error: (any Error)?
    
    init(){
        self.input = ""
    }
    
    mutating func setInput(input: String) {
        self.input = input
    }
    
    mutating func check() -> Bool {
        let hasLetters = self.input.rangeOfCharacter(from: .decimalDigits) != nil
        if !hasLetters {
            saveError()
        }
        return hasLetters
        
    }
    
    mutating func saveError() {
        self.error = StringContainsAtLeastOneNumError.givenInputDoesnotContainAtLeastOneNum
    }
    
    
}
