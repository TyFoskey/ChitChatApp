//
//  AuthCoordinator.swift
//  ChitChat
//
//  Created by ty foskey on 9/11/20.
//  Copyright © 2020 ty foskey. All rights reserved.
//

import UIKit
import PhoneNumberKit

final class AuthCoordinator: BaseCoordinator, CoordinatorFinishOutput {
    
    // MARK: - Properties
    let router: Router
    let auth: Authentication
    
    // MARK: - Coordinator Finish Output
    var finishFlow: ((Any?) -> Void)?
    
    
    // MARK: - Coordinator Lifecycle
    init(router: Router, auth: Authentication) {
        self.router = router
        self.auth = auth
    }
    
    override func start() {
        showSignIn(isStarting: true)
    }
    
    deinit {
        print("being deallocated")
    }
    
    
    // MARK: - Show VCs
    private func showSignIn(isStarting: Bool) {
        let signInVC = SignInViewController()
        signInVC.onBottomButtTap = { (isValid) in
            
        }
        
        signInVC.onSignUpButtTap = {[weak self] in
            guard let strongSelf = self else { return }
            strongSelf.showOtherVC(isStarting: isStarting, isSignIn: true)
        }
        
        if isStarting == true {
            router.setRootModule(signInVC, hideBorderLine: true)
        } else {
            router.push(signInVC, animated: true)
        }
    }
    
    private func showSignUp(isStarting: Bool) {
        let signUpVC = SignUpViewController()
        
        signUpVC.onSignInButtTap = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.showOtherVC(isStarting: isStarting, isSignIn: false)
        }
        
        if isStarting == true {
            router.setRootModule(signUpVC, hideBorderLine: true)
        } else {
            router.push(signUpVC, animated: true)
        }
        
        signUpVC.onBottomButtTap = {[weak self] (name, password) in
            guard let strongSelf = self else { return }
            strongSelf.showVerification()
        }
        
    }
    
    private func showOtherVC(isStarting: Bool, isSignIn: Bool) {
        if isStarting == true, isSignIn == true {
            showSignUp(isStarting: false)
        } else if isStarting == true, isSignIn == false {
            showSignIn(isStarting: false)
        } else {
            router.popModule()
        }
    }
    
    // Verifies the user and returns either an email or phone number
    private func showVerification() {
        let phoneKit = PhoneNumberKit()
        let verificationCoordinator = VerificationCoordinator(router: router, phoneKit: phoneKit)
        
        verificationCoordinator.finishFlow = { [weak self] (number) in
            guard let strongSelf = self else { return }
            strongSelf.removeChildCoordinator(verificationCoordinator)
            strongSelf.showProfilePicVC()
            print("your verified")
        }
        self.addChildCoordinator(verificationCoordinator)
        verificationCoordinator.start()
    }
    
    private func showProfilePicVC() {
        let profilePicVC = RegisterProfilePicViewController()
        
        profilePicVC.onBottomButtTap = {[weak self] (image) in
            guard let strongSelf = self else { return }
            strongSelf.showCompletedVC()
        }
        
        router.push(profilePicVC, hideBottomBar: true)
    }
    
    private func showCompletedVC() {
        let congratsVC = RegisterCompletedViewController()
        router.push(congratsVC, hideBottomBar: true)
    }
    
}
