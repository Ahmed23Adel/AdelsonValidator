//
//  File.swift
//  AdelsonValidator
//
//  Created by ahmed on 03/07/2025.
//

import Foundation

public enum StringHasMaxLenError: Error{
    case providedInputIsGreaterThanMinLen
}

struct StringHasMaxLen: SingleInputValidator{
    private(set)var input: String
    private(set) var maxLen: Int
    private(set) var error: (any Error)?
    
    init(input: String, maxLen: Int){
        self.input = input
        self.maxLen = maxLen
    }

    init(maxLen: Int){
        self.maxLen = maxLen
        self.input = ""
    }
    
    mutating func setInput(input: String) {
        self.input = input
        self.error = nil
    }
    
    mutating func check() -> Bool {
        if input.count <= maxLen{
            return true
        } else{
            saveError()
            return false
        }
    }
    
    mutating func saveError() {
        error = StringHasMaxLenError.providedInputIsGreaterThanMinLen
    }
    
    
}
