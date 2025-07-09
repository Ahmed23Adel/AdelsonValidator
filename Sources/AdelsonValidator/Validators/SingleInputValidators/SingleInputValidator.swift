//
//  SingleInputValidator.swift
//  AdelsonValidator
//
//  Created by ahmed on 02/07/2025.
//

import Foundation

// you must call setInput before checking, otherwise it will work on the default value
public protocol SingleInputValidator<InputType> {
    associatedtype InputType: Comparable
    var input: InputType { get }
    var error: (any Error)? { get }
    
    mutating func setInput(input: InputType)
    mutating func check() -> Bool
    mutating func checkAndExec(onSuccess: ()->Void, onFail: ()->Void)
    mutating func ThrowableCheck() throws
    mutating func getError() -> (any Error)?
    mutating func saveError()
}

extension SingleInputValidator{
    
    
    
    public mutating func checkAndExec(onSuccess: () -> Void, onFail: () -> Void) {
        if check(){
            onSuccess()
        } else {
            saveError()
            onFail()
        }
    }
    
    public mutating func ThrowableCheck() throws {
        if !check(){
            saveError()
            throw getError()!
        }
    }
    
    public mutating func getError() -> (any Error)? {
        return error
    }
}
