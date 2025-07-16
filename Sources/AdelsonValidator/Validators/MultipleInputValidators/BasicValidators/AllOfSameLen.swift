//
//  File.swift
//  AdelsonValidator
//
//  Created by ahmed on 03/07/2025.
//

import Foundation

public enum AllOfSameLenError: Error{
    case inputsHaveDifferentLengths
}

struct AllOfSameLen: MultipleInputValidator{
    var inputs: [String]
    var error: (any Error)?
    
    init(inputs: [String]) {
        self.inputs = inputs
    }
    init (){
        self.inputs = []
    }
    
    mutating func setInputs(inputs: [String]){
        self.inputs = inputs
        self.error = nil
    }
    mutating func check() -> Bool {
        if inputs.count == 0 {
            return true
        }
        let fixedSize = inputs[0].count
        for input in inputs {
            if input.count != fixedSize{
                saveError()
                return false
            }
        }
        return true
    }
    
    mutating func saveError() {
        error = AllOfSameLenError.inputsHaveDifferentLengths
    }
    
    
}
