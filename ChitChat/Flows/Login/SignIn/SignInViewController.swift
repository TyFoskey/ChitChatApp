//
//  SignInViewController.swift
//  ChitChat
//
//  Created by ty foskey on 9/14/20.
//  Copyright © 2020 ty foskey. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {
    
    // MARK: - Properties
    let signInView = SignInView()
    let keyboardManager = KeyboardManager()
    var onBottomButtTap: ((Any?) -> Void)?
    var onSignUpButtTap: (() -> Void)?
    var isShowingPassword = false
    
    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        view.backgroundColor = .white
        view.addSubview(signInView)
        signInView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin)
            make.left.right.equalTo(view)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottomMargin)
        }
        signInView.delegate = self
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
              self?.signInView.loginButt.snp.updateConstraints { (make) in
                  make.bottom.equalTo(height)
              }
              self?.signInView.layoutIfNeeded()
          }, completion: nil)
        
      }
    
}

// MARK: - TextField Delegate
extension SignInViewController: LoginViewDelegate {
    func switchViewsButtTapped() {
        onSignUpButtTap?()
    }
    
    func showPasswordButtTapped() {
        isShowingPassword = !isShowingPassword
        signInView.passwordForm.textField.isSecureTextEntry = !isShowingPassword
        signInView.showPasswordButt.setTitle(isShowingPassword ? "Hide Password": "Show Password", for: .normal)
    }
    
    
    func textFieldDidChange() {
        if signInView.numberForm.textField.text?.isEmpty == false,
            signInView.passwordForm.textField.text?.isEmpty == false {
            if signInView.loginButt.isEnabled == false {
                print("making it valid")
                signInView.loginButt.isValid()
            }
        } else {
            if signInView.loginButt.isEnabled == true {
                print("making it invalid")
                signInView.loginButt.isNotValid()
            }
        }
    }
    
    func loginButtTapped() {
        guard let numberText = signInView.numberForm.textField.text else {
            signInView.numberForm.showError(withErrorMessage: "Please enter your number")
            return
        }
        
        guard let passwordText = signInView.passwordForm.textField.text else {
            signInView.passwordForm.showError(withErrorMessage: "Please enter your password")
            return
        }
        
        print("login butt tapped")
    }
    

}

