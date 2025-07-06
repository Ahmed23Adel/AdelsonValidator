//
//  File.swift
//  AdelsonValidator
//
//  Created by ahmed on 04/07/2025.
//

import Foundation

@available(macOS 13.0.0, *)
struct SingleInputPolicy<InputType: Comparable>: SingleInputPolicyType{
    var inputs: [InputType]
    var singleInputValidators: [any SingleInputValidator<InputType>]
    var errors: [any Error] = []
    
    init(inputs: [InputType], singleInputValidators: [any SingleInputValidator<InputType>]) {
        self.inputs = inputs
        self.singleInputValidators = singleInputValidators
    }
    
    mutating func check() -> Bool {
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
    
    
    mutating func saveError() {
        
    }
    
    
}
