//
//  File.swift
//  AdelsonValidator
//
//  Created by ahmed on 05/07/2025.
//

import Foundation

enum StringContainsAtLeastOneEngLetterError: Error{
    case givenInputDoesnotContainAtLeastOneEngLetter
}

struct StringContainsAtLeastOneEngLetter: SingleInputValidator{
    var input: String
    var error: (any Error)?
    
    init(){
        self.input = ""
    }
    
    mutating func setInput(input: String) {
        self.input = input
    }
    
    mutating func check() -> Bool {
        let hasLetters = self.input.rangeOfCharacter(from: .letters) != nil
        if !hasLetters {
            saveError()
        }
        return hasLetters
        
    }
    
    mutating func saveError() {
        self.error = StringContainsAtLeastOneEngLetterError.givenInputDoesnotContainAtLeastOneEngLetter
    }
    
    
}
