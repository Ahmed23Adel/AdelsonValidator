//
//  File.swift
//  AdelsonValidator
//
//  Created by ahmed on 06/07/2025.
//

import Foundation

enum StringContainsNSpecialCharsError: Error{
    case notContainsNSpecialChars
}

struct StringContainsNSpecialChars: SingleInputValidator{
    var input: String
    var n: Int
    var error: (any Error)?
    
    init(n: Int){
        self.n = n
        self.input = ""
    }
    
    mutating func setInput(input: String) {
        self.input = input
    }
    
    mutating func check() -> Bool {
        let numbersCount = input.filter{ !$0.isNumber && !$0.isLetter }.count
        if numbersCount >= n {
            return true
        } else{
            saveError()
            return false
        }
    }
    
    mutating func saveError() {
        self.error = StringContainsNSpecialCharsError.notContainsNSpecialChars
    }
    
    
}
