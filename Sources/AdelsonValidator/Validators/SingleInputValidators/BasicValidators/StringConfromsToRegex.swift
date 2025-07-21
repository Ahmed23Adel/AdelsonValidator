//
//  File.swift
//  AdelsonValidator
//
//  Created by ahmed on 03/07/2025.
//

import Foundation

public enum StringConformsToRegexError: AdelsonReadableError {
    case notConformingToGivenRegex(regex: String)

    public var message: String {
        switch self {
        case .notConformingToGivenRegex(let regex):
            return "The input does not match the required pattern: \(regex)"
        }
    }
}

public struct StringConfromsToRegex: SingleInputValidator{
    public var input: String
    public var regex: String
    public var error: (any Error)?
    
    public init(input: String, regex: String){
        self.input = input
        self.regex = regex
    }
    
    public init(regex: String){
        self.regex = regex
        self.input = ""
    }
    
    public mutating func setInput(input: String) {
        self.input = input
        self.error = nil
    }
    
    public mutating func check() -> Bool {
        let predicate  = NSPredicate(format: "SELF MATCHES %@", regex)
        if predicate.evaluate(with: input){
            return true
        }
        else{
            saveError()
            return false
        }
        
    }
    
    
    public mutating func saveError() {
        error = StringConformsToRegexError.notConformingToGivenRegex(regex: regex)
    }
    
    
    
}
