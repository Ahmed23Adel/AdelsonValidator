//
//  File.swift
//  AdelsonValidator
//
//  Created by ahmed on 04/07/2025.
//

import Foundation

@available(macOS 13.0.0, *)
public struct MultipleInputPolicy<InputType: Comparable>: MultipleInputPolicyType{
    public var inputs: [InputType]
    public var singleInputValidators: [any SingleInputValidator<InputType>]
    public var multipleInputValidators: [any MultipleInputValidator<InputType>]
    public var errors: [any Error] = []
    
    public init(inputs: [InputType],
         singleInputValidators: [any SingleInputValidator<InputType>],
         multipleInputValidators: [any MultipleInputValidator<InputType>]) {
        self.inputs = inputs
        self.singleInputValidators = singleInputValidators
        self.multipleInputValidators = multipleInputValidators
    }
    
    public mutating func check() -> Bool {
        errors.removeAll()
        checkSingleInputValidators()
        checkMultipleInputValidators()
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
