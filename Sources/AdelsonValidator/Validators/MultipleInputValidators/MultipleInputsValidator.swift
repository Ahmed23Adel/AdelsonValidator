//
//  File.swift
//  AdelsonValidator
//
//  Created by ahmed on 03/07/2025.
//

import Foundation

public  protocol MultipleInputValidator<InputType>{
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

