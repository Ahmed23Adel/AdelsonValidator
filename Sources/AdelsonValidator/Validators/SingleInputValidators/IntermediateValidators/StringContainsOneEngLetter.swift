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

public  struct StringContainsAtLeastOneEngLetter: SingleInputValidator{
    public var input: String
    public var error: (any Error)?
    
    public init(){
        self.input = ""
    }
    
    public mutating func setInput(input: String) {
        self.input = input
    }
    
    public mutating func check() -> Bool {
        let hasLetters = self.input.rangeOfCharacter(from: .letters) != nil
        if !hasLetters {
            saveError()
        }
        return hasLetters
        
    }
    
    public mutating func saveError() {
        self.error = StringContainsAtLeastOneEngLetterError.givenInputDoesnotContainAtLeastOneEngLetter
    }
    
    
}
