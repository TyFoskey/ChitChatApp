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
    
    // MARK: - Views
    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Create Account,"
        titleLabel.backgroundColor = .clear
        titleLabel.layer.shadowOpacity = 0.2
        titleLabel.layer.shadowColor = Constants.colors.primaryColor.cgColor
        titleLabel.layer.shadowOffset = CGSize(width: 4, height: 3)
        titleLabel.layer.shadowRadius = 3
        titleLabel.font = UIFont.systemFont(ofSize: 37, weight: .semibold)
        titleLabel.textColor = .label//Colors.primaryColor
        return titleLabel
    }()
    
    let titleLabelMaskView: UIView = {
        let titleLabelMaskView = UIView()
        titleLabelMaskView.backgroundColor = .red
        return titleLabelMaskView
    }()
    
    let subtitleLabel: UILabel = {
        let subtitleLabel = UILabel()
        subtitleLabel.text = "What's your name" //"Sign up to get started!"
        subtitleLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        subtitleLabel.textColor =  .secondaryLabel//Constants.colors.lightGray
        return subtitleLabel
    }()
    
    let alreadyUserLabel: UILabel = {
        let alreadyUserLabel = UILabel()
        alreadyUserLabel.text = "Already have an account?"
        alreadyUserLabel.textColor = .label
        alreadyUserLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        alreadyUserLabel.isUserInteractionEnabled = true
        return alreadyUserLabel
    }()
    
    let signInLabel: UILabel = {
        let signInLabel = UILabel()
        signInLabel.text = "Sign In"
        signInLabel.backgroundColor = .clear
        signInLabel.textColor = .label
        signInLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        return signInLabel
    }()
    
    let signInButtMaskView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.isUserInteractionEnabled = true
        return view
    }()
    
    let loginButt = LoginButt()
    let nameForm = FormTextFieldView(labelText: "FULL NAME", placeholder: "Full Name", image: UIImage(named: "signupProfile"), frame: .zero)
    
    
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
        self.backgroundColor = .systemBackground
        loginButt.addTarget(self, action: #selector(loginButtTapped), for: .touchUpInside)
        signInButtMaskView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(signUpButtTapped)))
        alreadyUserLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(signUpButtTapped)))
        nameForm.delegate = self
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
            numberFormCenterConstr = make.centerY.equalTo(self).constraint
            numberFormBottomConstr = make.bottom.equalTo(loginButt.snp.top).offset(-30).constraint
            make.leading.equalTo(titleLabel)
            make.trailing.equalTo(self).offset(-30)
            make.height.equalTo(65)
        }
        
        numberFormBottomConstr.deactivate()
        numberFormCenterConstr.activate()
        
        loginButt.snp.makeConstraints { (make) in
            loginButtBottomConstr = make.bottom.equalTo(self).offset(-50).constraint
            make.leading.trailing.equalTo(nameForm)
            make.height.equalTo(50)
        }
        
        loginButtBottomConstr.activate()
        
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
