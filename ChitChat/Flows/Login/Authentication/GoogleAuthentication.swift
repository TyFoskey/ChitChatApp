//
//  GoogleAuthentication.swift
//  ChitChat
//
//  Created by ty foskey on 12/7/21.
//  Copyright © 2021 ty foskey. All rights reserved.
//

import FirebaseAuth
import GoogleSignIn
import FirebaseCore
import UIKit

class GoogleAuthentication {
    
    let viewController: UIViewController
    
    weak var delegate: SocialAuthDelegate?
    
    init(vc: UIViewController) {
        self.viewController = vc
    }
    
    func login() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)

        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(with: config, presenting: viewController) { [weak self] user, error in
            guard let strongSelf = self else { return }
          if let error = error {
              print(error as Error, "google auth error")
              strongSelf.delegate?.showError(error: error)
            return
          }

          guard
            let authentication = user?.authentication,
            let idToken = authentication.idToken
          else {
            return
          }

          let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                         accessToken: authentication.accessToken)

            Auth.auth().signIn(with: credential) { authResult, error in
                if error != nil {
                    print(error! as Error, "firebase auth error")
                    strongSelf.delegate?.showError(error: error!)
                    return
                }
                
                guard let name = user?.profile?.name, let id = authResult?.user.uid else { return }
                let profileUrl = user?.profile?.imageURL(withDimension: UInt())?.absoluteString
                
                strongSelf.delegate?.signIn(id: id, name: name, profileUrl: profileUrl)
            }
        }
    }
    
}
