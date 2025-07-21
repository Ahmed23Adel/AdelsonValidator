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

public struct StringHasMaxLen: SingleInputValidator{
    public var input: String
    public  var maxLen: Int
    public  var error: (any Error)?
    
    public init(input: String, maxLen: Int){
        self.input = input
        self.maxLen = maxLen
    }

    public init(maxLen: Int){
        self.maxLen = maxLen
        self.input = ""
    }
    
    public mutating func setInput(input: String) {
        self.input = input
        self.error = nil
    }
    
    public mutating func check() -> Bool {
        if input.count <= maxLen{
            return true
        } else{
            saveError()
            return false
        }
    }
    
    public mutating func saveError() {
        error = StringHasMaxLenError.providedInputIsGreaterThanMinLen
    }
    
    
}
