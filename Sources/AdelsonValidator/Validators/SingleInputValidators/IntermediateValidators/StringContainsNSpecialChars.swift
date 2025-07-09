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

public struct StringContainsNSpecialChars: SingleInputValidator{
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
        let numbersCount = input.filter{ !$0.isNumber && !$0.isLetter }.count
        if numbersCount >= n {
            return true
        } else{
            saveError()
            return false
        }
    }
    
    public mutating func saveError() {
        self.error = StringContainsNSpecialCharsError.notContainsNSpecialChars
    }
    
    
}
