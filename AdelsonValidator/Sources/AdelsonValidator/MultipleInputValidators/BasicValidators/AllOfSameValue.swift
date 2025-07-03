//
//  File.swift
//  AdelsonValidator
//
//  Created by ahmed on 03/07/2025.
//

import Foundation

enum AllOfSameValueError: Error{
    case inputsHaveDifferentValues
}

struct AllOfSameValue: MultipleInputValidator{
    typealias InputType = String
    var inputs: [String]
    var error: (any Error)?
    
    init(inputs: [String]) {
        self.inputs = inputs
    }
    mutating func check() -> Bool {
        if inputs.count == 0 {
            return true
        }
        let fixedValue = inputs[0]
        for input in inputs {
            if input != fixedValue{
                saveError()
                return false
            }
        }
        return true
    }
    
    mutating func saveError() {
        error = AllOfSameValueError.inputsHaveDifferentValues
    }
    
    
}
