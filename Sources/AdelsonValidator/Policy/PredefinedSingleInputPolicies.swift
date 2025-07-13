//
//  File.swift
//  AdelsonValidator
//
//  Created by ahmed on 05/07/2025.
//

import Foundation

@available(macOS 13.0.0, *)
public  struct PredefinedSingleInputPolicies{
    private init(){}
    
    public static func simplePasswordPolicy(input: String) -> any SingleInputPolicyType{
        SingleInputPolicy(singleInputValidators: [
            StringHasMinLen(minLen: 6),
            StringHasMaxLen(maxLen: 50),
            StringContainsAtLeastOneEngLetter(),
            StringContainsAtLeastOneNumber()
        ])
    }
    
    public static func mediumPasswordPolicy(input: String) -> any SingleInputPolicyType{
        SingleInputPolicy(singleInputValidators: [
            StringHasMinLen(minLen: 8),
            StringContainsAtLeastOneNumber(),
            StringContainsNSpecialChars(n: 1),
            StringNotContainAnyInList(notContained: [" "])
            
        ])
    }
    
    public static func hardPasswordPolicy(input: String) -> any SingleInputPolicyType{
        SingleInputPolicy(singleInputValidators: [
            StringHasMinLen(minLen: 12),
            StringContainsNNumbers(n: 3),
            StringContainsNLowerChars(n: 2),
            StringContainsNUpperChars(n: 2),
            StringContainsNSpecialChars(n: 1),
            StringNotContainAnyInList(notContained: [" "])
            
        ])
    }
}


