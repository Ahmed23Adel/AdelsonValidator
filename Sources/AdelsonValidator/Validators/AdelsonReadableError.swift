//
//  File.swift
//  AdelsonValidator
//
//  Created by ahmed on 21/07/2025.
//

import Foundation

public protocol AdelsonReadableError: Error {
    var message: String { get }
}
