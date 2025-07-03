//
//  File.swift
//  AdelsonValidator
//
//  Created by ahmed on 03/07/2025.
//

import Foundation

enum StringHasMaxLenError: Error{
    case providedInputIsGreaterThanMinLen
}

struct StringHasMaxLen: SingleInputValidator{
    typealias InputType = String
    private(set)var input: String
    private(set) var maxLen: Int
    private(set) var error: (any Error)?
    
    init(input: String, maxLen: Int){
        self.input = input
        self.maxLen = maxLen
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
