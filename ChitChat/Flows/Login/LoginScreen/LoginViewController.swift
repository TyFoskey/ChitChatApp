//
//  LoginViewController.swift
//  ChitChat
//
//  Created by ty foskey on 12/6/21.
//  Copyright © 2021 ty foskey. All rights reserved.
//

import UIKit
import SnapKit

class LoginViewController: UIViewController {
    
    let loginView = LoginView()
    var appleAuthentication: AppleAuthentication?
    var facebookAuthentication: FacebookAuthentication?
    var twitterAuthentication: TwitterAuthentication?
    var googleAuthentication: GoogleAuthentication?
    
    var onGoToPhoneLogin: (() -> Void)?
    var onGoToCheckSignIn: ((SignInRegistrationType) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginView.delegate = self
        view.backgroundColor = .systemBackground
        view.addSubview(loginView)
        loginView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

extension LoginViewController: LoginDelegate {
    func loginWith(type: LoginType) {
        switch type {
        case .phoneNumber:
            onGoToPhoneLogin?()
        case .facebook:
            facebookAuthentication = FacebookAuthentication(viewController: self)
            facebookAuthentication?.delegate = self
            facebookAuthentication?.loginIn()
        case .google:
            googleAuthentication = GoogleAuthentication(vc: self)
            googleAuthentication?.delegate = self
            googleAuthentication?.login()
        case .twitter:
            twitterAuthentication = TwitterAuthentication(vc: self)
            twitterAuthentication?.delegate = self
            twitterAuthentication?.login()
        case .apple:
            appleAuthentication = AppleAuthentication(loginVC: self)
            appleAuthentication?.startSignInWithAppleFlow()
        }
    }
}

extension LoginViewController: SocialAuthDelegate {
    func signIn(id: String, name: String, profileUrl: String?) {
        onGoToCheckSignIn?(.social(id, name, profileUrl))
    }
    
    func showError(error: Error) {
        print("social auth error")
    }
    
    
}

