//
//  Authentication.swift
//  ChitChat
//
//  Created by ty foskey on 9/11/20.
//  Copyright © 2020 ty foskey. All rights reserved.
//

import Firebase
import FirebaseAuth
import FirebaseStorage

class Authentication {
    
    typealias SignInResult = (Result<()>) -> Void
    typealias SignUpResult = (Result<Any?>) -> Void
    typealias PhoneVerificationResult = (Result<String>) -> Void
    
    // MARK: - Sign Up
    
    /// Sign up the user
    /// - Parameters:
    ///   - name: The users name
    ///   - phoneNumber: The users phone number
    ///   - password: The password
    ///   - imageData: The profile picture image data
    ///   - completion: The completion which gives the result of a `SignupResult`.
    func signUp(name: String,
                phoneNumber: String,
                password: String,
                imageData: Data,
                completion: @escaping(SignUpResult)) {
        
        
        let email = "\(phoneNumber)@chitchat.com"
        
        
        Auth.auth().createUser(withEmail: email,
                               password: password) {[weak self] (user, error) in
                                guard let strongSelf = self else {
                                    completion(.error("Error, pleases try again."))
                                    return
                                }
                                // There is an error
                                if error != nil {
                                    guard let error = error as NSError? else {
                                        completion(.error("Error, please try again down."))
                                        return
                                    }
                                    
                                    if let errorCode = AuthErrorCode(rawValue: error.code) {
                                        switch errorCode {
                                        case .emailAlreadyInUse:
                                            completion(.error("The number is already in use for another account"))
                                            
                                        case .invalidEmail:
                                            completion(.error("The number is invalid"))
                                            
                                        default:
                                            completion(.error("\(errorCode) the error code /n \(error.localizedDescription), the localized description"))
                                        }
                                    }
                                    return
                                }
                                
                                // Sign up Success
                                let uid = user?.user.uid
                                
                                
                                // Store the image in the storage
                                strongSelf.uploadProfilePic(imageData: imageData,
                                                            uid: uid!) { (result) in
                                                                
                                                                switch result {
                                                                case .error(let errorMessage):
                                                                    completion(.error(errorMessage))
                                                                    
                                                                case .success(let profileUrl):
                                                                    break
                                                                    //   strongSelf.setUpFirebaseDBInfo(username: username, name: name, email: email, profileUrl: profileUrl as! String, uid: uid!, type: type, completion: completion)
                                                                    
                                                                case .completed(_) : break
                                                                    
                                                                }
                                }
        }
    }
    
    /// Uploads the profile picture image data to storage
    /// - Parameters:
    ///   - imageData: The users image data
    ///   - uid: The users uid
    ///   - completion: The completion that returns either a success with the profile url or error with an error message.
    private func uploadProfilePic(imageData: Data,
                                  uid: String,
                                  completion: @escaping(SignUpResult)) {
        
        let profileImageChild = "profile_image"
        let storageRef = Constants.storageConfig.storageRef.child(profileImageChild).child(uid)
        
        storageRef.putData(imageData, metadata: nil) { (metadata, error) in
            guard error == nil else {
                completion(.error("Error inputing profile pic"))
                return
            }
            
            storageRef.downloadURL { (url, error) in
                guard error == nil else {
                    completion(.error("Error downloading url"))
                    return
                }
                
                let profileImageUrl = url?.absoluteString
                completion(.success(profileImageUrl))
            }
        }
    }
    
    // MARK: - Sign In
    
    /// Signs in the user to the db
    /// - Parameters:
    ///   - text: the text that the user inputs either an email, phone number, or username
    ///   - password: the password the  user inputs
    ///   - completion: the completion which gives the result of  a success or errror with error message
    func signIn(text: String?,
                password: String?,
                completion: @escaping SignInResult) {
        
        guard let text = text, text.isEmpty == false else {
            completion(.error("Username / Email / Phone field cannot be empty"))
            return
        }
        guard let password = password, password.isEmpty == false else {
            completion(.error("Password field cannot be empty"))
            return
        }
        
        signInWithPhoneNumber(phoneNumber: text,
                              password: password,
                              completion: completion)
    }
    
    /// Authenticates the user in with a phone number
    /// - Parameters:
    ///   - phoneNumber: The phone number recieved from the user
    ///   - password: The password recieved form the user
    ///   - completion: The completion which gives the result of a `signinResult`.
    private func signInWithPhoneNumber(phoneNumber: String,
                                       password: String,
                                       completion: @escaping SignInResult) {
        
        // First search through the db for the specified number and return back an email
        
        Constants.refs.phoneNumberRef.queryOrderedByKey().queryEqual(toValue: phoneNumber).observeSingleEvent(of: .value) {[weak self] (snapshot) in
            guard let strongSelf = self else {
                completion(.error("Error, please try again"))
                return
            }
            
            // Checks to see if the phone number exists, and if there is an email
            guard snapshot.exists(), let email = snapshot.value as? String else {
                completion(.error("no phone number in records"))
                return
            }
            
            // Signs the user in with the eamil from the db and the password
            strongSelf.signInWithEmail(email: email,
                                       password: password,
                                       completion: completion)
        }
    }
    
    /// Authenticates the user with the specified email and password.
    /// - Parameters:
    ///   - email: The email address.
    ///   - password: The password.
    ///   - completion: The completion which gives the result of a `signinResult`.
    private func signInWithEmail(email: String,
                                 password: String,
                                 completion: @escaping SignInResult) {
        Auth.auth().signIn(withEmail: email,
                           password: password) { (data, error) in
                            if error != nil {
                                if let error = error as NSError? {
                                    if let errorCode = AuthErrorCode(rawValue: error.code) {
                                        switch errorCode {
                                        case .invalidEmail:
                                            completion(.error("Invalid Email"))
                                        default:
                                            completion(.error("Invalid Username/Email or Password"))
                                        }
                                    }
                                }
                                return
                            }
                            completion(.success(()))
        }
    }
    
    
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
