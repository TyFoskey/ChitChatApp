//
//  Authentication.swift
//  ChitChat
//
//  Created by ty foskey on 9/11/20.
//  Copyright © 2020 ty foskey. All rights reserved.
//

import Firebase

class Authentication {
    
     typealias PhoneVerificationResult = (Result<String>) -> Void
    
    
    /// Checks if the text input is a phone number and returns a bool
    /// - Parameters:
    ///   - text: the text that is being check
    ///   - textCount: the letter count of the text
    private func isValidPhoneNumber(text: String,
                                    textCount: Int) -> Bool {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let matches = detector.matches(in: text,
                                           options: [],
                                           range: NSRange(location: 0, length: textCount))
            if let res = matches.first {
                return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == textCount
            } else {
                return false
            }
        } catch {
            return false
        }
    }
    
    // MARK: - Phone Verification
    
    /// Sends a verification code to the specific number and returns the code in the completion or returns an error with a message
    /// - Parameters:
    ///   - phoneNumber: The phone number to send to
    ///   - completion: The completion which gives the result of a `phoneverificationResult`.
    func verifyPhone(phoneNumber: String,
                     completion: @escaping(PhoneVerificationResult)) {
        
//        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationCode, error) in
//            
//            guard let code = verificationCode, error == nil else {
//                completion(.error(error?.localizedDescription ?? ""))
//                return
//            }
//            
//            completion(.success(code))
//        }
    }
}
