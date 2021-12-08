//
//  CodeVerificationViewController.swift
//  ChitChat
//
//  Created by ty foskey on 9/14/20.
//  Copyright © 2020 ty foskey. All rights reserved.
//

import UIKit
import SnapKit

class CodeVerificationViewController: UIViewController {
    
    // MARK: - Properties
    let verifyView: CodeVerificationView
    let phoneNumber: String
    let authentication: Authentication
    var vericationCode: String! = "123456"
    var verificationId: String!
    let keyboardManager = KeyboardManager()
    var onVerifiedAction: ((VerificationObject) -> Void)?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        setUpKeyboard()
        view.backgroundColor = .systemBackground
        view.addSubview(verifyView)
        addCustomBackButton()
        verifyView.delegate = self
        verifyView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin)
            make.left.right.equalTo(view)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottomMargin)
        }
        sendAuthenticationCode()
    }
    
    init(phoneNumber: String,
         authentication: Authentication) {
        self.verifyView = CodeVerificationView(phoneNumber: phoneNumber,
                                               frame: .zero)
        self.phoneNumber = phoneNumber
        self.authentication = authentication
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK: - Private functions
    private func sendAuthenticationCode() {
        authentication.sendPhoneCode(phoneNumber: phoneNumber) { [weak self] (result) in
            guard let strongSelf = self else { return }
            switch result {
            case .error(let errorMessage):
                print(errorMessage, "the send phone code authentication error")
            case .success(let verificationId):
                strongSelf.verificationId = verificationId
                print("got verificationId")
                
            default:
                break
            }
        }
    }
    
    
    private func setUpKeyboard() {
        keyboardManager.on(event: .willShow) {[weak self] (notification) in
            self?.animateButton(to: -notification.endFrame.height)
        }
        
        keyboardManager.on(event: .willHide) {[weak self] (notification) in
            self?.animateButton(to: -8)
        }
    }
    
    func animateButton(to height: CGFloat) {
        UIView.animate(withDuration: 0.55,
                       delay: 0,
                       usingSpringWithDamping: 0.9,
                       initialSpringVelocity: 0.2,
                       options: .curveEaseOut,
                       animations: { [weak self] in
                        
                        self?.verifyView.sendAgainButt.snp.updateConstraints { (make) in
                            make.bottom.equalTo(height)
                        }
                        self?.verifyView.layoutIfNeeded()
                        
            }, completion: nil)
    }
    
    
    
}

extension CodeVerificationViewController: CodeVerificationViewDelegate {
    func didChangeCharacters() {
        print("changing characters")
        if verifyView.codeView.isAnimating == false {
            verifyView.errorLabel.isHidden = true
        }
        verifyView.updateBottomButt(isEnabled: verifyView.codeView.hasValidCode())
    }
    
    func verifyNumber(code: String) {
        let verificationObject = VerificationObject(number: phoneNumber, code: code, id: verificationId)
        onVerifiedAction?(verificationObject)
//        if code == vericationCode {
//            onVerifiedAction?()
//        } else {
//            verifyView.setWrongValue()
//        }
    }
    
    func resendCode() {
        print("resend tapped")
    }
    
}

