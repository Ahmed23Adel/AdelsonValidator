//
//  StringContains.swift
//  AdelsonValidator
//
//  Created by ahmed on 02/07/2025.
//

import Foundation

enum StringContainsError: Error{
    case errorNotContains(substr: String)
}
class StringContains: SingleInputValidator{
    typealias InputType = String
    private(set)var input: String
    private(set) var substr: String
    private(set) var error: (any Error)?

    init(input: String, substr: String){
        self.input = input
        self.substr = substr
    }
    
    func check() -> Bool {
        if substr.isEmpty{ return true }
        if input.contains(substr) {
            return true
        }
        error = StringContainsError.errorNotContains(substr: substr)
        return false
    }
    
    func checkAndExec(onSuccess: () -> Void, onFail: () -> Void) {
        if check() {
            onSuccess()
        }
        else{
            onFail()
        }
    }
    
    func ThrowableCheck() throws {
        if !check() {
            error = StringContainsError.errorNotContains(substr: substr)
            throw StringContainsError.errorNotContains(substr: substr)
            
        }
        
    }
    
    func getError() -> (any Error)? {
        return error
    }
    
    
}
