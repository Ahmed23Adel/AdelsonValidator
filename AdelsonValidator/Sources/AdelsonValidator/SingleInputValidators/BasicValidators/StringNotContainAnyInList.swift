//
//  File.swift
//  AdelsonValidator
//
//  Created by ahmed on 03/07/2025.
//

import Foundation

enum StringNotContainAnyInListError: Error {
    case StringContainsOneItemFromList
}
struct StringNotContainAnyInList: SingleInputValidator {
    typealias InputType = String
    private(set) var input: String
    private(set) var notContained: [String]
    private(set)var error: (any Error)?
    
    init(input: String, notContained: [String]) {
        self.input = input
        self.notContained = notContained
    }
    
    
    mutating func check() -> Bool {
        for item in notContained{
            if input.contains(item){
                saveError()
                return false
            }
        }
        return true
    }
    
    mutating func saveError() {
        error = StringNotContainAnyInListError.StringContainsOneItemFromList
    }
    
    
}
