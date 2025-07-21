//
//  StringContains.swift
//  AdelsonValidator
//
//  Created by ahmed on 02/07/2025.
//

import Foundation

public enum StringContainsError: AdelsonReadableError {
    case errorNotContains(substr: String)

    public var message: String {
        switch self {
        case .errorNotContains(let substr):
            return "The input must contain \"\(substr)\"."
        }
    }
}
public struct StringContains: SingleInputValidator{
    public var input: String
    public  var substr: String
    public  var error: (any Error)?

    public init(input: String, substr: String){
        self.input = input
        self.substr = substr
    }
    
    public init(substr: String){
        self.substr = substr
        self.input = ""
    }
    
    public mutating func setInput(input: String) {
        self.input = input
        self.error = nil
    }
    
    
    public mutating func check() -> Bool {
        if substr.isEmpty{ return true }
        if input.contains(substr) {
            return true
        }
        error = StringContainsError.errorNotContains(substr: substr)
        return false
    }
    
    public mutating func saveError() {
        error = StringContainsError.errorNotContains(substr: substr)
    }
    
   
    
    
}
