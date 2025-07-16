//
//  StringContains.swift
//  AdelsonValidator
//
//  Created by ahmed on 02/07/2025.
//

import Foundation

public enum StringContainsError: Error{
    case errorNotContains(substr: String)
}

struct StringContains: SingleInputValidator{
    private(set)var input: String
    private(set) var substr: String
    private(set) var error: (any Error)?

    init(input: String, substr: String){
        self.input = input
        self.substr = substr
    }
    
    init(substr: String){
        self.substr = substr
        self.input = ""
    }
    
    mutating func setInput(input: String) {
        self.input = input
        self.error = nil
    }
    
    
    mutating func check() -> Bool {
        if substr.isEmpty{ return true }
        if input.contains(substr) {
            return true
        }
        error = StringContainsError.errorNotContains(substr: substr)
        return false
    }
    
    mutating func saveError() {
        error = StringContainsError.errorNotContains(substr: substr)
    }
    
   
    
    
}
