//
//  File.swift
//  AdelsonValidator
//
//  Created by ahmed on 04/07/2025.
//

import Foundation

@available(macOS 13.0.0, *)
public struct SingleInputPolicy<InputType: Comparable>: SingleInputPolicyType{
    public var inputs: [InputType]
    public var singleInputValidators: [any SingleInputValidator<InputType>]
    public var errors: [any Error] = []
    
    public init(inputs: [InputType], singleInputValidators: [any SingleInputValidator<InputType>]) {
        self.inputs = inputs
        self.singleInputValidators = singleInputValidators
    }
    
    public mutating func check() -> Bool {
        for var validator in singleInputValidators {
            for input in inputs {
                validator.setInput(input: input)
                let result = validator.check()
                if !result{
                    errors.append(validator.getError()!)
                }
            }
        }
        if errors.isEmpty{
            return true
        } else{
            return false
        }
        
    }
    
    
    public mutating func saveError() {
        
    }
    
    
}
