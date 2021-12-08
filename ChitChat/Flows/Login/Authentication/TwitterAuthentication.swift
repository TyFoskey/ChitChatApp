//
//  TwitterAuthentication.swift
//  ChitChat
//
//  Created by ty foskey on 12/7/21.
//  Copyright © 2021 ty foskey. All rights reserved.
//

import FirebaseAuth
import UIKit
import SwifteriOS
import AuthenticationServices
import FirebaseCore
import FirebaseUI


class TwitterAuthentication: NSObject {
    
    let viewController: UIViewController
    var swifter = Swifter(consumerKey: Constants.swifterConfig.CONSUMERKEY, consumerSecret: Constants.swifterConfig.CONSUMERSECRET)

    weak var delegate: SocialAuthDelegate?
    
    init(vc: UIViewController) {
        self.viewController = vc
    }
    
    func login() {

        let url = URL(string: Constants.swifterConfig.CALLBACKURL)
        swifter.authorize(withProvider: self, callbackURL: url!) {[weak self] token, _ in
            guard let strongSelf = self else { return }
            let provider = TwitterAuthProvider.credential(withToken: token!.verifier!, secret: token!.secret)
            Auth.auth().signIn(with: provider) { authResult, error in
              if error != nil {
                // Handle error.
                  print(error! as Error, "firebase error")
                  strongSelf.delegate?.showError(error: error!)
                  return
              }
                
                print("successfully signed up twitter user")
                guard let name = Auth.auth().currentUser?.displayName, let id = Auth.auth().currentUser?.uid else { return }
                
                strongSelf.delegate?.signIn(id: id, name: name, profileUrl: nil)

            }
        }

    
    }

}

extension TwitterAuthentication: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return viewController.view.window!
    }
}

