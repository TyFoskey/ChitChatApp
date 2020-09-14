//
//  SignUpViewController.swift
//  ChitChat
//
//  Created by ty foskey on 9/11/20.
//  Copyright © 2020 ty foskey. All rights reserved.
//

import UIKit
import SnapKit

class SignUpViewController: UIViewController {
    
    // MARK: - Properties
    let signUpView = SignUpView()
    let keyboardManager = KeyboardManager()
    var onBottomButtTap: ((Any?) -> Void)?
    var onSignInButtTap: (() -> Void)?
    var isShowingPassword = false
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        view.backgroundColor = .white
        view.addSubview(signUpView)
        signUpView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin)
            make.left.right.equalTo(view)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottomMargin)
        }
        signUpView.delegate = self
        setKeyboard()
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
        
    
    // MARK: - Keyboard Manager
    private func setKeyboard() {
        keyboardManager.on(event: .willShow) {[weak self] (notification) in
            self?.animateButton(to: -notification.endFrame.height)
        }
        
        keyboardManager.on(event: .willHide) {[weak self] (notification) in
            self?.animateButton(to: -50)
        }
        
    }
    
    private func animateButton(to height: CGFloat) {
          UIView.animate(withDuration: 0.55, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.2, options: .curveEaseOut, animations: {[weak self] in
              self?.signUpView.loginButt.snp.updateConstraints { (make) in
                  make.bottom.equalTo(height)
              }
              self?.signUpView.layoutIfNeeded()
          }, completion: nil)
        
      }
    
}

// MARK: - TextField Delegate
extension SignUpViewController: LoginViewDelegate {
    func switchViewsButtTapped() {
        onSignInButtTap?()
    }
    
    func showPasswordButtTapped() {
        isShowingPassword = !isShowingPassword
        signUpView.passwordForm.textField.isSecureTextEntry = !isShowingPassword
        signUpView.confirmPasswordForm.textField.isSecureTextEntry = !isShowingPassword
        signUpView.showPasswordButt.setTitle(isShowingPassword ? "Hide Password": "Show Password", for: .normal)
    }
    
    
    func textFieldDidChange() {
        if signUpView.nameForm.textField.text?.isEmpty == false,
            signUpView.passwordForm.textField.text?.isEmpty == false,
            signUpView.confirmPasswordForm.textField.text?.isEmpty == false {
            if signUpView.loginButt.isEnabled == false {
                print("making it valid")
                signUpView.loginButt.isValid()
            }
        } else {
            if signUpView.loginButt.isEnabled == true {
                print("making it invalid")
                signUpView.loginButt.isNotValid()
            }
        }
    }
    
    func loginButtTapped() {
        guard let nameText = signUpView.nameForm.textField.text else {
            signUpView.nameForm.showError(withErrorMessage: "Please enter your full name")
            return
        }
        
        guard let passwordText = signUpView.passwordForm.textField.text else {
            signUpView.passwordForm.showError(withErrorMessage: "Please enter your password")
            return
        }
        
        guard let conformPasswordText = signUpView.confirmPasswordForm.textField.text else {
            signUpView.confirmPasswordForm.showError(withErrorMessage: "Please confirm your password")
            return
        }
        
        validate(type: .name, text: nameText) {[weak self] in
            guard let strongSelf = self else { return }
            strongSelf.validate(type: .password, text: passwordText) {
                strongSelf.validate(type: .confirmPassword, text: conformPasswordText) {
                    print("next please")
                    strongSelf.onBottomButtTap?(nil)
                }
            }
        }
    }
    
    private func validate(type: ValidationType, text: String,
                          completion: @escaping() -> Void) {
        switch type {
        case .name:
            Constants.validate.isValidName(text.lowercased()) {[weak self] (isValid, errorMessage) in
                switch isValid {
                case true:
                    self?.signUpView.nameForm.hideError(showSuccess: true)
                    completion()
                    
                case false:
                    self?.signUpView.nameForm.showError(withErrorMessage: errorMessage)
                }
            }
            
        case .password:
            let (isValidPassword, errorText) = Constants.validate.isValidPassword(password: text)
            switch isValidPassword {
            case true:
                signUpView.passwordForm.hideError(showSuccess: true)
                completion()
            default:
                signUpView.passwordForm.showError(withErrorMessage: errorText)
            }
            
        case .confirmPassword:
            if signUpView.passwordForm.textField.text == signUpView.confirmPasswordForm.textField.text {
                completion()
            } else {
                signUpView.confirmPasswordForm.showError(withErrorMessage: "Confirm Password must match password")
            }
        }
    }

}
