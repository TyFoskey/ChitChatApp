//
//  Authentication.swift
//  ChitChat
//
//  Created by ty foskey on 9/11/20.
//  Copyright © 2020 ty foskey. All rights reserved.
//

import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

class Authentication {
    
    typealias SignInResult = (Result<(String)>) -> Void
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
                verificationObject: VerificationObject,
                imageData: Data,
                completion: @escaping(SignUpResult)) {
        
        signIn(verificationObject: verificationObject) {[weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let uid):
                strongSelf.createUserWithProfilePic(uid: uid, imageData: imageData, name: name, phoneNumber: verificationObject.number, completion: completion)

            case .error(let error):
                completion(.error(error))
                
            case .completed(_):
                fatalError()
            }
        }
        
    }
    
    func signIn(verificationObject: VerificationObject, completion: @escaping(SignInResult)) {
        let credentials = PhoneAuthProvider.provider().credential(withVerificationID: verificationObject.id, verificationCode: verificationObject.code)
        
        
        Auth.auth().signIn(with: credentials) { (authData, error) in
            // There is an error
            if error != nil {
                guard let error = error as NSError? else {
                    completion(.error("Error, please try again down."))
                    return
                }
                
                if let errorCode = AuthErrorCode(rawValue: error.code) {
                    switch errorCode {
                    case .accountExistsWithDifferentCredential, .credentialAlreadyInUse:
                        completion(.error("The number is already in use for another account"))
                        
                    case .invalidCredential, .invalidPhoneNumber:
                        completion(.error("The number is invalid"))
                        
                    case .internalError:
                        completion(.error("Error, please try again down."))
                        
                    default:
                        completion(.error("\(errorCode) the error code /n \(error.localizedDescription), the localized description"))
                    }
                }
                return
            }
            
            // Sign up Success
            let uid = authData?.user.uid
            completion(.success(uid!))
        }

    }
    
    func createUserWithProfilePic(uid: String, imageData: Data, name: String, phoneNumber: String?, completion: @escaping(SignUpResult)) {
        uploadProfilePic(imageData: imageData,
                         uid: uid) {[weak self] (result) in
            guard let strongSelf = self else { return }
            switch result {
            case .error(let errorMessage):
                completion(.error(errorMessage))
                
            case .success(let profileUrl):
                strongSelf.setUpFirebaseDBInfo(name: name, phoneNumber: phoneNumber, profileUrl: profileUrl as! String, uid: uid, completion: completion)
                
            case .completed(_) : break
                
            }
        }
    }
    
    func checkIfUserInDB(id: String, completion: @escaping(Bool) -> Void) {
        let ref = Constants.refs.userRef.child(id)
        ref.observeSingleEvent(of: .value) { snapshot in
            completion(snapshot.exists())
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
    
    /// Creates a user in the db with information given
    /// - Parameters:
    ///   - username: The users username
    ///   - name: The users name
    ///   - email: The users email
    ///   - profileUrl: The users profile image url
    ///   - uid: The users uid
    ///   - type: The sign up type either phone or email
    ///   - completion: The completion that returns a success with void or an error with an error message
    func setUpFirebaseDBInfo(name: String,
                                     phoneNumber: String?,
                                     profileUrl: String,
                                     uid: String,
                                     completion: @escaping(SignUpResult)) {
        
        let usersString = "Users"
      //  let active_usernamesString = "active_usernames"
       // let pushNotificationsString = "pushNotifications"
        
        // refernce
        let ref = Constants.refs.ref
        
        // dictionaries
        let userDict = [
            "name": name,
            "profileUrl": profileUrl]
        
        
//        let badgeDict = ["notificationCount": 0,
//                         "total": 0]

        
        
        var childUpdates: [String:Any] = [
            "/\(usersString)/\(uid)" : userDict
          //  "/\(pushNotificationsString)/\(uid)/badges" : badgeDict,
          //  "/\(pushNotificationsString)/\(uid)/notifications" : postNotifDict,
          //  "/\(pushNotificationsString)/\(uid)/notificationsEnabled" : true,
            ]
        
        if phoneNumber != nil {
            childUpdates.updateValue(uid, forKey: "Numbers/\(phoneNumber!)")
        }
        
        // set values
        ref.updateChildValues(childUpdates)
    
        completion(.success(nil))
        
        
        
    }
    
    // MARK: - Sign In
    
    /// Signs in the user to the db
    /// - Parameters:
    ///   - text: the text that the user inputs either an email, phone number, or username
    ///   - password: the password the  user inputs
    ///   - completion: the completion which gives the result of  a success or errror with error message
    func signIn(text: String?,
                completion: @escaping PhoneVerificationResult) {
        
        guard let text = text, text.isEmpty == false else {
            completion(.error("Username / Email / Phone field cannot be empty"))
            return
        }
      
        signInWithPhoneNumber(phoneNumber: text,
                              completion: completion)
    }
    
    /// Authenticates the user in with a phone number
    /// - Parameters:
    ///   - phoneNumber: The phone number recieved from the user
    ///   - password: The password recieved form the user
    ///   - completion: The completion which gives the result of a `signinResult`.
    private func signInWithPhoneNumber(phoneNumber: String,
                                       completion: @escaping PhoneVerificationResult) {
        
        // First search through the db for the specified number and return back an email
        
        Constants.refs.phoneNumberRef.queryOrderedByKey().queryEqual(toValue: phoneNumber).observeSingleEvent(of: .value) {[weak self] (snapshot) in
            guard let strongSelf = self else {
                completion(.error("Error, please try again"))
                return
            }

            // Checks to see if the phone number exists, and if there is an email
            guard snapshot.exists() else {
                completion(.error("No phone number in records"))
                return
            }

            completion(.success(phoneNumber))
            //strongSelf.sendPhoneCode(phoneNumber: phoneNumber, completion: completion)
        }
    }
    
//    /// Authenticates the user with the specified email and password.
//    /// - Parameters:
//    ///   - email: The email address.
//    ///   - password: The password.
//    ///   - completion: The completion which gives the result of a `signinResult`.
//    private func signInWithEmail(email: String,
//                                 password: String,
//                                 completion: @escaping SignInResult) {
//        Auth.auth().signIn(withEmail: email,
//                           password: password) { (data, error) in
//                            if error != nil {
//                                if let error = error as NSError? {
//                                    if let errorCode = AuthErrorCode(rawValue: error.code) {
//                                        switch errorCode {
//                                        case .invalidEmail:
//                                            completion(.error("Invalid Phone Number"))
//                                        default:
//                                            completion(.error("Invalid Phone Number or Password"))
//                                        }
//                                    }
//                                }
//                                return
//                            }
//                            completion(.success(()))
//        }
//    }
    
    
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
    func sendPhoneCode(phoneNumber: String,
                       completion: @escaping(PhoneVerificationResult)) {
      
//        #if DEBUG
//            Auth.auth().settings?.isAppVerificationDisabledForTesting = true
//        #endif
        
        PhoneAuthProvider.provider(auth: Auth.auth())
        
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationId, error) in
            
            guard let id = verificationId, error == nil else {
                print(error, "the error")
                completion(.error(error?.localizedDescription ?? ""))
                return
            }
            
            print("success verification id")
            completion(.success(id))
        }
    }
    
    
    // MARK: - Sign Out
    func signOut(completion: @escaping(Result<()>) -> Void) {
        let auth = Auth.auth()
        try! auth.signOut()
        print(Auth.auth().currentUser?.uid, "should be none since we signed out")
        completion(.success(()))
        
    }
}
