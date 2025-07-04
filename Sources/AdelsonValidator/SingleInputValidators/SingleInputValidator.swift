//
//  SingleInputValidator.swift
//  AdelsonValidator
//
//  Created by ahmed on 02/07/2025.
//

import Foundation

protocol SingleInputValidator{
    associatedtype InputType: Comparable
    var input: InputType { get }
    var error: (any Error)? { get }
    
    mutating func check() -> Bool
    mutating func checkAndExec(onSuccess: ()->Void, onFail: ()->Void)
    mutating func ThrowableCheck() throws
    mutating func getError() -> (any Error)?
    mutating func saveError()
}

extension SingleInputValidator{
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
            throw error!
        }
    }
    
    mutating func getError() -> (any Error)? {
        return error
    }
}
