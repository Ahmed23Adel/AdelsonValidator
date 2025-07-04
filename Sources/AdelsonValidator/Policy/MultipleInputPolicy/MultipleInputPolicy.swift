//
//  File.swift
//  AdelsonValidator
//
//  Created by ahmed on 04/07/2025.
//

import Foundation

@available(macOS 13.0.0, *)
struct MultipleInputPolicy<InputType: Comparable>: MultipleInputPolicyType{
    var inputs: [InputType]
    var singleInputValidators: [any SingleInputValidator<InputType>]
    var multipleInputValidators: [any MultipleInputValidator<InputType>]
    var errors: [any Error]
    
    mutating func check() -> Bool {
        errors.removeAll()
        if errors.isEmpty{
            return true
        } else{
            return false
        }
    }
    
    private mutating func checkSingleInputValidators() {
        for var validator in singleInputValidators {
            for input in inputs {
                validator.setInput(input: input)
                let result = validator.check()
                if !result{
                    errors.append(validator.getError()!)
                }
            }
        }
    }
    
    private mutating func checkMultipleInputValidators() {
        for var validator in multipleInputValidators {
                validator.setInputs(inputs: inputs)
                let result = validator.check()
                if !result{
                    errors.append(validator.getError()!)
                }
        }
    }
    
    
    
    
}
