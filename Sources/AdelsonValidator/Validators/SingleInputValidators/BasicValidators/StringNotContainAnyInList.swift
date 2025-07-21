//
//  File.swift
//  AdelsonValidator
//
//  Created by ahmed on 03/07/2025.
//

import Foundation

public enum StringNotContainAnyInListError: Error {
    case StringContainsOneItemOrMoreFromList
}

public struct StringNotContainAnyInList: SingleInputValidator {
    public var input: String
    public  var notContained: [String]
    public var error: (any Error)?
    
    public init(input: String, notContained: [String]) {
        self.input = input
        self.notContained = notContained
    }
    
    public init(notContained: [String]) {
        self.notContained = notContained
        self.input = ""
    }
    
    
    public mutating func setInput(input: String) {
        self.input = input
        self.error = nil
    }
    
    public mutating func check() -> Bool {
        for item in notContained{
            if input.contains(item){
                saveError()
                return false
            }
        }
        return true
    }
    
    public mutating func saveError() {
        error = StringNotContainAnyInListError.StringContainsOneItemOrMoreFromList
    }
    
    
}
