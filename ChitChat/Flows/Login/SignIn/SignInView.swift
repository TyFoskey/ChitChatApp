//
//  SignInView.swift
//  ChitChat
//
//  Created by ty foskey on 9/14/20.
//  Copyright © 2020 ty foskey. All rights reserved.
//

import UIKit
import SnapKit

class SignInView: UIView {
    
    // MARK: - Views
    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Welcome Back,"
        titleLabel.backgroundColor = .clear
        titleLabel.layer.shadowOpacity = 0.2
        titleLabel.layer.shadowColor = Constants.colors.primaryColor.cgColor
        titleLabel.layer.shadowOffset = CGSize(width: 4, height: 3)
        titleLabel.layer.shadowRadius = 3
        titleLabel.font = UIFont.systemFont(ofSize: 37, weight: .semibold)
        titleLabel.textColor = .label
        return titleLabel
    }()
    
    let titleLabelMaskView: UIView = {
        let titleLabelMaskView = UIView()
        titleLabelMaskView.backgroundColor = .red
        return titleLabelMaskView
    }()
    
    let subtitleLabel: UILabel = {
        let subtitleLabel = UILabel()
        subtitleLabel.text = "Sign in with your phone number to continue!"
        subtitleLabel.numberOfLines = 0
        subtitleLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        subtitleLabel.textColor = .secondaryLabel//Constants.colors.lightGray
        return subtitleLabel
    }()
    
    let notUserLabel: UILabel = {
        let notUserLabel = UILabel()
        notUserLabel.text = "Don't have an account yet?"
        notUserLabel.textColor = .label
        notUserLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        notUserLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(signUpButtTapped)))
        notUserLabel.isUserInteractionEnabled = true
        return notUserLabel
    }()
  
    let errorLabel: UILabel = {
        let errorLabel = UILabel()
        errorLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        errorLabel.textColor = .red
        return errorLabel
    }()
    
    let signUpLabel: UILabel = {
        let signUpLabel = UILabel()
        signUpLabel.text = "Sign Up"
        signUpLabel.backgroundColor = .clear
        signUpLabel.textColor = .label
        signUpLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        return signUpLabel
    }()
    
    let signUpButtMaskView: UIView = {
        let signUpButtMaskView = UIView()
        signUpButtMaskView.backgroundColor = .red
        return signUpButtMaskView
    }()
    
    let loginButt = LoginButt()
    let numberForm = FormTextFieldView(labelText: "PHONE NUMBER", placeholder: "Phone Number", image: UIImage(named: "signupProfile"), frame: .zero)
    
    // MARK: - Properties
    let colorGradients = Constants.colors.colorGradients
    weak var delegate: SignInDelegate?
    var numberFormCenterConstr: Constraint!
    var numberFormBottomConstr: Constraint!
    var loginButtBottomConstr: Constraint!
    
    
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

    
    @objc private func signUpButtTapped() {
        print("sign up butt tapped")
        delegate?.switchViewsButtTapped()
    }
    
    // MARK: - Set Up
    private func setUp() {
        self.backgroundColor = .systemBackground
        signUpButtMaskView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(signUpButtTapped)))
        signUpButtMaskView.isUserInteractionEnabled = true
        loginButt.addTarget(self, action: #selector(loginButtTapped), for: .touchUpInside)
        numberForm.delegate = self
    
        addSubviews()
        setConstraints()
    }
    
    private func addSubviews() {
        addSubview(titleLabelMaskView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(errorLabel)
        addSubview(numberForm)
        addSubview(loginButt)
        addSubview(notUserLabel)
        addSubview(signUpButtMaskView)
        addSubview(signUpLabel)
    }
    
    
    private func setConstraints() {
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(40)
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
            make.trailing.equalTo(self).offset(-30)
        }
        
        numberForm.snp.makeConstraints { (make) in
            numberFormBottomConstr = make.bottom.equalTo(loginButt.snp.top).offset(-30).constraint
            numberFormCenterConstr = make.centerY.equalTo(self).constraint
            make.leading.equalTo(titleLabel)
            make.trailing.equalTo(self).offset(-30)
            make.height.equalTo(65)
        }
        
        numberFormCenterConstr.activate()
        numberFormBottomConstr.deactivate()
        
        errorLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(numberForm.snp.top).offset(-12)
            make.left.right.equalTo(numberForm)
        }
        
        
        loginButt.snp.makeConstraints { (make) in
            loginButtBottomConstr = make.bottom.equalTo(self).offset(-50).constraint
            make.leading.trailing.equalTo(numberForm)
            make.height.equalTo(50)
        }
        
        loginButtBottomConstr.activate()
        
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
