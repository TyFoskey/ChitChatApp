//
//  Validation.swift
//  ChitChat
//
//  Created by ty foskey on 9/13/20.
//  Copyright © 2020 ty foskey. All rights reserved.
//

import Foundation

class Validation {
    
    // MARK: - Email
    
    /// Validates Email adresses and returns a bool
    /// - Parameter email: the email adress for validation
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    // MARK: - Username
    
    /// Validates usernames in db
    /// - Parameters:
    ///   - username: the username the user provides
    ///   - completion: returns a bool which indicates if the username is valid, and string which indicates the error if neccessary
    func isValidName(_ username: String,
                         completion: @escaping(Bool, String) -> Void) {
  
        guard containsLetters(text: username) == true else {
            completion(false, "Name must contain letters")
            return
        }
        
        completion(true, "")

    }
    
    /// Returns a boolean indicating if the text contains any letter or not
    /// - Parameter text: The text string to test
    private func containsLetters(text: String) -> Bool {
        let letters = NSCharacterSet.letters
        
        let range = text.rangeOfCharacter(from: letters)
        
        return range != nil
    }
    
    
    /// Returns a boolean indicating fi the text contains any special characters
    /// - Parameter text: The text string to test
    private func containsSpecialChars(text: String) -> Bool {
        let specialCharacterRegEx  = ".*[^A-Za-z0-9._].*"
        //".*[!&^%$#@'()/*+-.?<>,:;]+.*"
        let texttest2 = NSPredicate(format:"SELF MATCHES %@", specialCharacterRegEx)
        
        guard texttest2.evaluate(with: text) == true else {
            return false
        }
        
        return true
    }
    

    // MARK: - Password
    
    /// Validates a password and returns a bool indicating if password is valid and a string that indicates a error message if neccessary
    /// - Parameter password: the password for validaion
    func isValidPassword(password: String) -> (Bool, String) {
        let capitalLetterRegEx  = ".*[A-Z]+.*"
        let texttest = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx)
        guard texttest.evaluate(with: password) else {
            return (false, "Password must contain atleast 1 uppercase letter")
        }
        
        let numberRegEx  = ".*[0-9]+.*"
        let texttest1 = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        guard texttest1.evaluate(with: password) else {
            return (false, "Password must contain atleast 1 number")
        }
        
        let specialCharacterRegEx  = ".*[!&^%$#@()/_*+-]+.*"
        let texttest2 = NSPredicate(format:"SELF MATCHES %@", specialCharacterRegEx)
        guard texttest2.evaluate(with: password) else {
            return (false, "Password must contain atleast 1 speacial character (!&^$#)")
        }
        
        return (true,"")
    }
    
}
