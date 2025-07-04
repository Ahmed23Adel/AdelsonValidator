//
//  File.swift
//  AdelsonValidator
//
//  Created by ahmed on 03/07/2025.
//

import Foundation

enum StringConfromsToRegexError: Error{
    case notConformingToGivenRegex(regex: String)
}

struct StringConfromsToRegex: SingleInputValidator{
    private(set)var input: String
    private(set) var regex: String
    private(set) var error: (any Error)?
    
    init(input: String, regex: String){
        self.input = input
        self.regex = regex
    }
    
    init(regex: String){
        self.regex = regex
        self.input = ""
    }
    
    mutating func setInput(input: String) {
        self.input = input
        self.error = nil
    }
    
    mutating func check() -> Bool {
        let predicate  = NSPredicate(format: "SELF MATCHES %@", regex)
        if predicate.evaluate(with: input){
            return true
        }
        else{
            saveError()
            return false
        }
        
    }
    
    
    mutating func saveError() {
        error = StringConfromsToRegexError.notConformingToGivenRegex(regex: regex)
    }
    
    
    
}
