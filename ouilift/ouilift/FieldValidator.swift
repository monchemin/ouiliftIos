//
//  FieldValidator.swift
//  ouilift
//
//  Created by Mewena on 2019-09-28.
//  Copyright © 2019 AwessoMeTech. All rights reserved.
//

import Foundation

class FieldValidator {
    
    struct ValidationError: Error {
        var message: String
        
        init(_ message: String) {
            self.message = message
        }
    }
    
    enum ValidatorType {
        case email
        case number
    }
    
    func isValid(_ type: ValidatorType, _ value: String) throws -> String {
        switch type {
        case .email:
            return try isEmailValid(value)
        case .number:
            return try isEmailValid(value)
        }
    }
    
    func isEmailValid(_ value: String) throws -> String {
        do {
            if try NSRegularExpression(pattern: "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$", options: .caseInsensitive).firstMatch(in: value, options: [], range: NSRange(location: 0, length: value.count)) == nil {
                throw ValidationError("Email invalide")
            }
        } catch {
            throw ValidationError("Email invalide")
        }
        return value
    }
}
