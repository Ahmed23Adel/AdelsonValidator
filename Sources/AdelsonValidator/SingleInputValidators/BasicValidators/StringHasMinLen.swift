//
//  File.swift
//  AdelsonValidator
//
//  Created by ahmed on 03/07/2025.
//

import Foundation

enum StringHasMinLenError: Error{
    case providedInputIsSmallerThanMinLen
}

struct StringHasMinLen: SingleInputValidator{
    typealias InputType = String
    private(set)var input: String
    private(set) var minLen: Int
    private(set) var error: (any Error)?
    
    init(input: String, minLen: Int){
        self.input = input
        self.minLen = minLen
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
