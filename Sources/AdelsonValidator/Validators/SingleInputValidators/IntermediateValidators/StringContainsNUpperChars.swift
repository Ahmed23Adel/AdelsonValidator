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

public  struct StringContainsNUpperChars: SingleInputValidator{
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
        let lowerCaseCharsCount = input.filter{ $0.isUppercase }.count
        if lowerCaseCharsCount >= n{
            return true
        } else{
            saveError()
            return false
        }
    }
    
    public mutating func saveError() {
        self.error = StringContainsNUpperCharsError.notContainsNUpperChars
    }
    
    
}
