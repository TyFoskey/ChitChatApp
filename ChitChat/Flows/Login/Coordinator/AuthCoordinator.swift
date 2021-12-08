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
    var name: String!
    var imageData: Data!
    var verificationObject: VerificationObject!
    
    // MARK: - Coordinator Finish Output
    var finishFlow: ((Any?) -> Void)?
    
    // MARK: - Coordinator Lifecycle
    init(router: Router, auth: Authentication) {
        self.router = router
        self.auth = auth
    }
    
    override func start() {
        showLoginVC()
        //showSignIn(isStarting: true)
    }
    
    deinit {
        print("being deallocated")
    }
    
    
    // MARK: - Show VCs
    private func showLoginVC() {
        let loginVC = LoginViewController()
        loginVC.onGoToPhoneLogin = {[weak self] in
            guard let strongSelf = self else { return }
            strongSelf.showSignIn()
        }
        
        loginVC.onGoToCheckSignIn = {[weak self] type in
            guard let strongSelf = self else { return }
            strongSelf.showCompletedVC(type: type)
        }
        router.setRootModule(loginVC, hideBorderLine: true)
    }
    private func showSignIn() {
        let signInVC = SignInViewController(auth: auth)
        signInVC.onBottomButtTap = { [weak self] (phoneNumber) in
            guard let strongSelf = self else { return }
            strongSelf.showVerification(type: .alreadyUser(phoneNumber))
        }
        
        signInVC.onSignUpButtTap = {[weak self] in
            guard let strongSelf = self else { return }
            strongSelf.showSignUp()
        }
        
        router.push(signInVC, animated: true)
        
    }
    
    private func showSignUp() {
        let signUpVC = SignUpViewController()
        
        signUpVC.onSignInButtTap = { [weak self] in
            guard let strongSelf = self else { return }
            //strongSelf.showOtherVC(isStarting: isStarting, isSignIn: false)
            strongSelf.router.popModule()
        }
            
        signUpVC.onBottomButtTap = {[weak self] (name) in
            guard let strongSelf = self else { return }
            strongSelf.name = name
            strongSelf.showProfilePicVC(name: nil, id: nil)
        }
        
        router.push(signUpVC, animated: true)
        
    }
    
//    private func showOtherVC(isStarting: Bool, isSignIn: Bool) {
//        if isStarting == true, isSignIn == true {
//            showSignUp(isStarting: false)
//        } else if isStarting == true, isSignIn == false {
//            showSignIn(isStarting: false)
//        } else {
//            router.popModule()
//        }
//    }
    
    // Verifies the user and returns either an email or phone number
    private func showVerification(type: VerificationType) {
        let phoneKit = PhoneNumberKit()
        let verificationCoordinator = VerificationCoordinator(router: router, phoneKit: phoneKit, auth: auth, type: type)
        
        verificationCoordinator.finishFlow = { [weak self] _ in
            guard let strongSelf = self else { return }

            strongSelf.removeChildCoordinator(verificationCoordinator)
            strongSelf.finishFlow?(nil)
            print("you're verified")
        }
        self.addChildCoordinator(verificationCoordinator)
        verificationCoordinator.start()
    }
    
    private func showProfilePicVC(name: String?, id: String?) {
        let profilePicVC = RegisterProfilePicViewController(name: name, id: id)
        
        profilePicVC.onBottomButtTap = {[weak self] (image) in
            guard let strongSelf = self,
                  let imageData = image.jpegData(compressionQuality: 0.5) else { return }
            strongSelf.imageData = imageData
            strongSelf.showVerification(type: .notUser(strongSelf.name, imageData))
        }
        
        profilePicVC.onGoToCreateProfile = {[weak self] type in
            guard let strongSelf = self else { return }
            strongSelf.showCompletedVC(type: type)
            
        }
        
        router.push(profilePicVC, hideBottomBar: true)
    }
    
    private func showCompletedVC(type: SignInRegistrationType) {
        let congratsVC = RegisterCompletedViewController(auth: auth, type: type)
        congratsVC.onBottomButtTap = {[weak self] in
            guard let strongSelf = self else { return }
            strongSelf.finishFlow?(nil)
        }
        
        congratsVC.onGoToRegisterProfile = {[weak self] in
            guard let strongSelf = self else { return }
            switch type {
            case .social(let id, let name, _):
                strongSelf.showProfilePicVC(name: name, id: id)
                
            default:
                fatalError("Should not get here")
            }
        }
        router.push(congratsVC, hideBottomBar: true)
    }
    
    private func goToMainVC() {
        let mainCoordinator = MainCoordinator(router: router)
        
        self.addChildCoordinator(mainCoordinator)
        mainCoordinator.start()
    }
}
