//
//  File.swift
//  AdelsonValidator
//
//  Created by ahmed on 03/07/2025.
//

import Foundation

public enum StringHasMinLenError: AdelsonReadableError {
    case providedInputIsSmallerThanMinLen

    public var message: String {
        switch self {
        case .providedInputIsSmallerThanMinLen:
            return "The input is shorter than the required minimum length."
        }
    }
}

public struct StringHasMinLen: SingleInputValidator{
    public var input: String
    public var minLen: Int
    public var error: (any Error)?
    
    public init(input: String, minLen: Int){
        self.input = input
        self.minLen = minLen
    }
    
    public init(minLen: Int){
        self.minLen = minLen
        self.input = ""
    }
    
    
    public mutating func setInput(input: String) {
        self.input = input
        self.error = nil
    }
    
    public mutating func check() -> Bool {
        if input.count >= minLen{
            return true
        } else{
            saveError()
            return false
        }
    }
    
    
    public mutating func saveError() {
        error = StringHasMinLenError.providedInputIsSmallerThanMinLen
    }
    
    
}
