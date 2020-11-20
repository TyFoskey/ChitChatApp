//
//  SignUpView.swift
//  ChitChat
//
//  Created by ty foskey on 9/11/20.
//  Copyright © 2020 ty foskey. All rights reserved.
//

import UIKit
import SnapKit

class SignUpView: UIView {
    
    // MARK: - Properties
    let titleLabel = UILabel()
    let titleLabelMaskView = UIView()
    let subtitleLabel = UILabel()
    let loginButt = LoginButt()
    let nameForm = FormTextFieldView(labelText: "FULL NAME", placeholder: "Full Name", image: UIImage(named: "signupProfile"), frame: .zero)
    let alreadyUserLabel = UILabel()
    let signInLabel = UILabel()
    let signInButtMaskView = UIView()
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
        signInButtMaskView.addGradientBackground(colors: colorGradients)
        titleLabelMaskView.mask = titleLabel
        signInButtMaskView.mask = signInLabel

    }
    
    // MARK: - Actions
    @objc private func loginButtTapped() {
        delegate?.loginButtTapped()
    }
    
    
    @objc private func signUpButtTapped() {
        delegate?.switchViewsButtTapped()
    }
    
    // MARK: - Set up
    private func setUp() {
        self.backgroundColor = .white
        titleLabelMaskView.backgroundColor = .red
        titleLabel.text = "Create Account,"
        titleLabel.backgroundColor = .clear
        titleLabel.layer.shadowOpacity = 0.2
        titleLabel.layer.shadowColor = Constants.colors.primaryColor.cgColor
        titleLabel.layer.shadowOffset = CGSize(width: 4, height: 3)
        titleLabel.layer.shadowRadius = 3
        titleLabel.font = UIFont.systemFont(ofSize: 37, weight: .semibold)
        titleLabel.textColor = .black//Colors.primaryColor
        subtitleLabel.text = "What's your name" //"Sign up to get started!"
        subtitleLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        subtitleLabel.textColor = Constants.colors.lightGray
        alreadyUserLabel.text = "Already have an account?"
        alreadyUserLabel.textColor = .black
        alreadyUserLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        signInButtMaskView.backgroundColor = .red
        signInLabel.text = "Sign In"
        signInLabel.backgroundColor = .clear
        signInLabel.textColor = .black
        signInLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        loginButt.addTarget(self, action: #selector(loginButtTapped), for: .touchUpInside)
        nameForm.delegate = self
        signInButtMaskView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(signUpButtTapped)))
        signInButtMaskView.isUserInteractionEnabled = true
        alreadyUserLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(signUpButtTapped)))
        alreadyUserLabel.isUserInteractionEnabled = true
        addSubviews()
        setConstraints()
    }
    
    private func addSubviews() {
        addSubview(titleLabelMaskView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(nameForm)
        addSubview(loginButt)
        addSubview(alreadyUserLabel)
        addSubview(signInButtMaskView)
        addSubview(signInLabel)
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
        
        nameForm.snp.makeConstraints { (make) in
            make.centerY.equalTo(self).offset(0)
            make.leading.equalTo(titleLabel)
            make.trailing.equalTo(self).offset(-30)
            make.height.equalTo(65)
        }
        
 
        loginButt.snp.makeConstraints { (make) in
            make.bottom.equalTo(self).offset(-50)
            make.leading.trailing.equalTo(nameForm)
            make.height.equalTo(50)
        }
        
        alreadyUserLabel.snp.makeConstraints { (make) in
            make.top.equalTo(loginButt.snp.bottom).offset(12)
            make.centerX.equalTo(self).offset(-12)
        }
        
        signInLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.leading.equalTo(alreadyUserLabel.snp.trailing).offset(3)
        }
        
        signInButtMaskView.snp.makeConstraints { (make) in
            make.centerY.equalTo(alreadyUserLabel)
            make.leading.trailing.equalTo(self)
            make.height.equalTo(alreadyUserLabel)
        }
    }
    
    
}

extension SignUpView: FormTextViewDelegate {
    func textFieldDidChange() {
        delegate?.textFieldDidChange()
    }
}
