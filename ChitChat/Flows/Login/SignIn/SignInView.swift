//
//  SignInView.swift
//  ChitChat
//
//  Created by ty foskey on 9/14/20.
//  Copyright © 2020 ty foskey. All rights reserved.
//

import UIKit

class SignInView: UIView {
    
    // MARK: - Properties
    let titleLabel = UILabel()
    let titleLabelMaskView = UIView()
    let subtitleLabel = UILabel()
    let loginButt = LoginButt()
    let numberForm = FormTextFieldView(labelText: "PHONE NUMBER", placeholder: "Phone Number", image: UIImage(named: "signupProfile"), frame: .zero)
    let passwordForm = FormTextFieldView(labelText: "PASSWORD", placeholder: "Password", image: UIImage(named: "passwordLock"), frame: .zero, isPassword: true)
    let forgotPasswordButt = UIButton()
    let notUserLabel = UILabel()
    let signUpLabel = UILabel()
    let signUpButtMaskView = UIView()
    let showPasswordButt = UIButton()
    let colorGradients = Constants.colors.colorGradients
    weak var delegate: LoginViewDelegate?
    
    
    // MARK: - View Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabelMaskView.addGradientBackground(colors: colorGradients)
        signUpButtMaskView.addGradientBackground(colors: colorGradients)
        titleLabelMaskView.mask = titleLabel
        signUpButtMaskView.mask = signUpLabel
    }
    
    // MARK: - Actions
    @objc private func loginButtTapped() {
        delegate?.loginButtTapped()
    }
    
    @objc private func showPasswordTapped() {
        delegate?.showPasswordButtTapped()
    }
    
    @objc private func signUpButtTapped() {
        print("sign up butt tapped")
        delegate?.switchViewsButtTapped()
    }
    
    // MARK: - Set Up
    private func setUp() {
        self.backgroundColor = .white
        titleLabelMaskView.backgroundColor = .red
        titleLabel.text = "Welcome Back,"
        titleLabel.backgroundColor = .clear
        titleLabel.layer.shadowOpacity = 0.2
        titleLabel.layer.shadowColor = Constants.colors.primaryColor.cgColor
        titleLabel.layer.shadowOffset = CGSize(width: 4, height: 3)
        titleLabel.layer.shadowRadius = 3
        titleLabel.font = UIFont.systemFont(ofSize: 37, weight: .semibold)
        titleLabel.textColor = .black//Colors.primaryColor
        subtitleLabel.text = "Sign in to continue!"
        subtitleLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        subtitleLabel.textColor = Constants.colors.lightGray
        forgotPasswordButt.setTitle("Forgot Password?", for: .normal)
        forgotPasswordButt.setTitleColor(UIColor.black, for: .normal)
        forgotPasswordButt.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        notUserLabel.text = "Don't have an account yet?"
        notUserLabel.textColor = .black
        notUserLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        signUpButtMaskView.backgroundColor = .red
        signUpButtMaskView.isUserInteractionEnabled = false
        signUpLabel.text = "Sign Up"
        signUpLabel.backgroundColor = .clear
        signUpLabel.textColor = .black
        signUpLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        loginButt.addTarget(self, action: #selector(loginButtTapped), for: .touchUpInside)
        numberForm.delegate = self
        passwordForm.delegate = self
        showPasswordButt.setTitle("Show Password", for: .normal)
        showPasswordButt.backgroundColor = .clear
        showPasswordButt.addTarget(self, action: #selector(showPasswordTapped), for: .touchUpInside)
        showPasswordButt.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        showPasswordButt.setTitleColor(UIColor.black, for: .normal)
        let gesture = UITapGestureRecognizer.init(target: self, action: #selector(signUpButtTapped))
        signUpButtMaskView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(signUpButtTapped)))
        signUpButtMaskView.isUserInteractionEnabled = true
        notUserLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(signUpButtTapped)))
        notUserLabel.isUserInteractionEnabled = true
        addSubviews()
        setConstraints()
    }
    
    private func addSubviews() {
        addSubview(titleLabelMaskView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(numberForm)
        addSubview(passwordForm)
        addSubview(forgotPasswordButt)
        addSubview(showPasswordButt)
        addSubview(loginButt)
        addSubview(notUserLabel)
        addSubview(signUpButtMaskView)
        addSubview(signUpLabel)
    }
    
    private func setConstraints() {
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(0)
            make.leading.equalTo(self).offset(30)
        }
        
        titleLabelMaskView.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(0)
            make.leading.equalTo(self).offset(0)
            make.trailing.equalTo(self)
            make.bottom.equalTo(subtitleLabel.snp.top)
        }
        
        subtitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalTo(titleLabel)
        }
        
        numberForm.snp.makeConstraints { (make) in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(60)
            make.leading.equalTo(titleLabel)
            make.trailing.equalTo(self).offset(-30)
            make.height.equalTo(65)
        }
        
        passwordForm.snp.makeConstraints { (make) in
            make.top.equalTo(numberForm.snp.bottom).offset(10)
            make.leading.height.trailing.equalTo(numberForm)
        }
        
        forgotPasswordButt.snp.makeConstraints { (make) in
            make.top.equalTo(passwordForm.snp.bottom).offset(6)
            make.trailing.equalTo(passwordForm)
        }
        
        showPasswordButt.snp.makeConstraints { (make) in
            make.top.equalTo(passwordForm.snp.bottom).offset(6)
            make.leading.equalTo(passwordForm)
        }
        
        loginButt.snp.makeConstraints { (make) in
            make.bottom.equalTo(self).offset(-50)
            make.leading.trailing.equalTo(numberForm)
            make.height.equalTo(50)
        }
        
        notUserLabel.snp.makeConstraints { (make) in
            make.top.equalTo(loginButt.snp.bottom).offset(12)
            make.centerX.equalTo(self).offset(-12)
        }
        
        signUpLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.leading.equalTo(notUserLabel.snp.trailing).offset(3)
        }
        
        signUpButtMaskView.snp.makeConstraints { (make) in
            make.centerY.equalTo(notUserLabel)
            make.leading.trailing.equalTo(self)
            make.height.equalTo(notUserLabel)
        }
    }
    
}

extension SignInView: FormTextViewDelegate {
    func textFieldDidChange() {
        delegate?.textFieldDidChange()
    }
}
