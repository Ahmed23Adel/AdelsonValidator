//
//  File.swift
//  AdelsonValidator
//
//  Created by ahmed on 03/07/2025.
//

import Foundation

protocol MultipleInputValidator<InputType>{
    associatedtype InputType: Comparable
    var inputs: [InputType] { get }
    var error: (any Error)? { get }
    
    mutating func setInputs(inputs: [InputType])
    mutating func check() -> Bool
    mutating func checkAndExec(onSuccess: ()->Void, onFail: ()->Void)
    mutating func ThrowableCheck() throws
    mutating func getError() -> (any Error)?
    mutating func saveError()
}

extension MultipleInputValidator{
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
    
    mutating func getError() -> (any Error)? {
        return error
    }
}

