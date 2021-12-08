//
//  FacebookAuthentication.swift
//  ChitChat
//
//  Created by ty foskey on 12/7/21.
//  Copyright © 2021 ty foskey. All rights reserved.
//

import Foundation
import FBSDKLoginKit
import FirebaseAuth
import CryptoKit

class FacebookAuthentication {
    
    let viewController: UIViewController
    let loginManager = LoginManager()
    
    weak var delegate: SocialAuthDelegate?
    
    init(viewController: UIViewController) {
        Settings.shared.appID = "583899199345718"
        self.viewController = viewController
    }
    
    func loginIn() {
        let nonce = randomNonceString()
        guard let configuration = LoginConfiguration(
            permissions:[.publicProfile, .email],
            tracking: .limited,
            nonce: sha256(nonce)
        ) else {
            return
        }
        loginManager.logIn(viewController: viewController, configuration: configuration) {[weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .cancelled:
                print("canceled?")
                
            case .failed(let error):
                print(error, "facebook login error")
                
            case .success(granted: _, declined: _, token: _):
                
                let idTokenString = AuthenticationToken.current?.tokenString
                let credential = OAuthProvider.credential(withProviderID: "facebook.com",
                                                          idToken: idTokenString!,
                                                          rawNonce: nonce)
                
                Auth.auth().signIn(with: credential) { (authResult, error) in
                    guard error == nil else {
                        // Error. If error.code == .MissingOrInvalidNonce, make sure
                        // you're sending the SHA256-hashed nonce as a hex string with
                        // your request to Apple.
                        print(error, "auth error")
                        strongSelf.delegate?.showError(error: error!)
                        return
                    }
                    
                    guard let name = Profile.current?.name, let profileUrl = Profile.current?.imageURL?.absoluteString, let id = Auth.auth().currentUser?.uid else {
                        return
                    }
                    
                    strongSelf.delegate?.signIn(id: id, name: name, profileUrl: profileUrl)
                 //   print("userid new")
                  // User is signed in to Firebase with Apple.
                  // ...
                }
                
            @unknown default:
                fatalError()
            }
        }
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError(
                        "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
                    )
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
                           
                           private func sha256(_ input: String) -> String {
            let inputData = Data(input.utf8)
            let hashedData = SHA256.hash(data: inputData)
            let hashString = hashedData.compactMap {
                String(format: "%02x", $0)
            }.joined()
            
            return hashString
        }
}
