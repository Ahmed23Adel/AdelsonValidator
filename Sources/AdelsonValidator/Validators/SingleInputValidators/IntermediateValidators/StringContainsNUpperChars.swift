//
//  File.swift
//  AdelsonValidator
//
//  Created by ahmed on 06/07/2025.
//

import Foundation

enum StringContainsNUpperCharsError: Error{
    case notContainsNUpperChars
}

struct StringContainsNUpperChars: SingleInputValidator{
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
        let lowerCaseCharsCount = input.filter{ $0.isUppercase }.count
        if lowerCaseCharsCount >= n{
            return true
        } else{
            saveError()
            return false
        }
    }
    
    mutating func saveError() {
        self.error = StringContainsNUpperCharsError.notContainsNUpperChars
    }
    
    
}
