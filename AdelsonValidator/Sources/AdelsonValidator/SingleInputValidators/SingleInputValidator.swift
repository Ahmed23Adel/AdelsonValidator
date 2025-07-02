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
    
    func check() -> Bool
    func checkAndExec(onSuccess: ()->Void, onFail: ()->Void)
    func ThrowableCheck() throws
    func getError() -> (any Error)? 
}
