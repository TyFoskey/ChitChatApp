//
//  RegisterCompletedViewController.swift
//  ChitChat
//
//  Created by ty foskey on 9/16/20.
//  Copyright © 2020 ty foskey. All rights reserved.
//

import UIKit
import SnapKit

class RegisterCompletedViewController: UIViewController {
    
    // MARK: - Properties
    var registerCompletedView = RegisterCompletedView()
    var onBottomButtTap: (() -> Void)?
    var onGoToRegisterProfile: (() -> Void)?
    let signInRegistrationType: SignInRegistrationType
//    let name: String
//    let imageData: Data
    let auth: Authentication
   // let verificationObject: VerificationObject
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        view.backgroundColor = .white
        view.addSubview(registerCompletedView)
        registerCompletedView.snp.makeConstraints { (make) in
            make.top.equalTo(view)
            make.left.right.equalTo(view)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottomMargin)
        }
        registerCompletedView.delegate = self
        signUp()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       // navigationController?.navigationBar.barStyle = .black
    }
    
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        .lightContent
//    }
    
    init(auth: Authentication, type: SignInRegistrationType) {
        self.auth = auth
        self.signInRegistrationType = type
//        self.name = name
//        self.imageData = imageData
//        self.verificationObject = verificationObject
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    // MARK: - Private functions
    private func signUp() {
        switch signInRegistrationType {
        case .social(let id, let name, let profileUrl):
            auth.checkIfUserInDB(id: id) {[weak self] isUserInDB in
                guard let strongSelf = self else { return }
                if isUserInDB {
                    strongSelf.onBottomButtTap?()
                } else {
                    if profileUrl != nil {
                        // sign up with name and profile
                        strongSelf.auth.setUpFirebaseDBInfo(name: name, phoneNumber: nil, profileUrl: profileUrl!, uid: id) { result in
                            strongSelf.signUpHandle(result: result)
                        }
                    } else {
                        // go to create profile image screen
                        strongSelf.onGoToRegisterProfile?()
                    }
                }
            }
        case .phoneNumber(let name, let imageData, let verificationObject):
            auth.signUp(name: name,
                        verificationObject: verificationObject,
                        imageData: imageData) {[weak self] (result) in
                guard let strongSelf = self else { return }
                strongSelf.signUpHandle(result: result)
            }
            
        case .createProfile(let id, let name, let imageData):
            auth.createUserWithProfilePic(uid: id, imageData: imageData, name: name, phoneNumber: nil) {[weak self] result in
                guard let strongSelf = self else { return }
                strongSelf.signUpHandle(result: result)
            }
            
        case .signIn(let verificationObject):
            auth.signIn(verificationObject: verificationObject) {[weak self] result in
                guard let strongSelf = self else { return }
                strongSelf.signInHandle(result: result)
            }
        }
        
    }
    
    private func signUpHandle(result: Result<Any?>) {
        switch result {
        case.success(_):
            unhideButtonButt()
        case .error(let errorMessage):
            print(errorMessage, "error Message")
        default: break
        }
    }
    
    private func signInHandle(result: Result<String>) {
        switch result {
        case.success(_):
            unhideButtonButt()
        case .error(let errorMessage):
            print(errorMessage, "error Message")
        default: break
        }
    }

    private func unhideButtonButt() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.registerCompletedView.circleSpinner.isHidden = true
            strongSelf.registerCompletedView.loadingLabel.isHidden = true
            strongSelf.registerCompletedView.imageView.isHidden = false
            strongSelf.registerCompletedView.statusLabel.isHidden = false
            strongSelf.registerCompletedView.bottomLabel.isHidden = false
            strongSelf.registerCompletedView.bottomButt.isEnabled = true
            UIView.transition(with: strongSelf.registerCompletedView.bottomButt,
                              duration: 3.8,
                              options: .transitionCrossDissolve,
                              animations: {
                                
                                 strongSelf.registerCompletedView.bottomButt.isHidden = false
                                
                                
            }, completion: nil)
        }
    }
    
    
    
}

// MARK: - CompletedView Delegate
extension RegisterCompletedViewController: RegisterCompletedViewDelegate {
    func bottomButtTapped() {
        onBottomButtTap?()
    }
}
