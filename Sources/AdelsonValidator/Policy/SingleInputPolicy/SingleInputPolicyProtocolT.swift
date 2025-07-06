//
//  File.swift
//  AdelsonValidator
//
//  Created by ahmed on 04/07/2025.
//

import Foundation


protocol SingleInputPolicyType<InputType> {
    associatedtype InputType: Comparable
    var inputs: [InputType] { get }
    @available(macOS 13.0.0, *)
    var singleInputValidators: [any SingleInputValidator<InputType>] { get }
    var errors: [(any Error)] { get }
    
    mutating func check() -> Bool
    mutating func checkAndExec(onSuccess: ()->Void, onFail: ()->Void)
    mutating func ThrowableCheck() throws
    mutating func getError() -> (any Error)?
    mutating func saveError()
}


extension SingleInputPolicyType{
    mutating func checkAndExec(onSuccess: () -> Void, onFail: () -> Void) {
        if check(){
            onSuccess()
        } else {
            saveError()
            onFail()
        }
    }
    
    mutating func ThrowableCheck() throws {
        if !check(){
            saveError()
            throw getError()!
        }
    }
    
    // it returns the first error only
    mutating func getError() -> (any Error)? {
        return errors[0]
    }
}


