//
//  File.swift
//  AdelsonValidator
//
//  Created by ahmed on 03/07/2025.
//

import Foundation

public enum StringHasMinLenError: Error{
    case providedInputIsSmallerThanMinLen
}

struct StringHasMinLen: SingleInputValidator{
    private(set)var input: String
    private(set) var minLen: Int
    private(set) var error: (any Error)?
    
    init(input: String, minLen: Int){
        self.input = input
        self.minLen = minLen
    }
    
    init(minLen: Int){
        self.minLen = minLen
        self.input = ""
    }
    
    
    mutating func setInput(input: String) {
        self.input = input
        self.error = nil
    }
    
    mutating func check() -> Bool {
        if input.count >= minLen{
            return true
        } else{
            saveError()
            return false
        }
    }
    
    
    mutating func saveError() {
        error = StringHasMinLenError.providedInputIsSmallerThanMinLen
    }
    
    
}
