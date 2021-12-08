//
//  LoginView.swift
//  ChitChat
//
//  Created by ty foskey on 12/6/21.
//  Copyright © 2021 ty foskey. All rights reserved.
//

import UIKit
import SnapKit
import AuthenticationServices

class LoginView: UIView {
    
    // MARK: - Views
    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Welcome to\nChitChat"
        titleLabel.backgroundColor = .clear
        titleLabel.numberOfLines = 0
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
        subtitleLabel.text = "Login in to continue"
        subtitleLabel.numberOfLines = 0
        subtitleLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        subtitleLabel.textColor = .secondaryLabel//Constants.colors.lightGray
        return subtitleLabel
    }()
    
    let loginButt: LoginButt = {
        let butt = LoginButt()
        butt.setTitle("Continue with Phone Number", for: .normal)
        butt.addTarget(self, action: #selector(handleLogInWithPhoneNumber), for: .touchUpInside)
        return butt
    }()
    
    lazy var facebookButt: UIButton = {
        let butt = UIButton()
        butt.setImage(Constants.images.facebookIcon, for: .normal)
        butt.layer.cornerRadius = buttHeight / 2
        butt.addTarget(self, action: #selector(handleLoginInWithFacebook), for: .touchUpInside)
        return butt
    }()
    
    lazy var twitterButt: UIButton = {
        let butt = UIButton()
        butt.setImage(Constants.images.twitterIcon, for: .normal)
        butt.layer.cornerRadius = buttHeight / 2
        butt.addTarget(self, action: #selector(handleLoginInWithTwitter), for: .touchUpInside)

        return butt
    }()
    
    lazy var googleButt: UIButton = {
        let butt = UIButton()
        butt.setImage(Constants.images.googleIcon, for: .normal)
        butt.layer.cornerRadius = buttHeight / 2
        butt.addTarget(self, action: #selector(handleLoginInWithGoogle), for: .touchUpInside)

        return butt
    }()
    
    var appleLogInButton : ASAuthorizationAppleIDButton = {
        let button = ASAuthorizationAppleIDButton(type: .continue, style: .whiteOutline)
        button.addTarget(self, action: #selector(handleLogInWithAppleID), for: .touchUpInside)
        return button
    }()
    
    let orView = OrView()
    
    let buttHeight: CGFloat = 100
    weak var delegate: LoginDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loginButt.isEnabled = true
        addAllSubviews()
        setConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        loginButt.isValid()
        titleLabelMaskView.addGradientBackground(colors: Constants.colors.colorGradients)
        titleLabelMaskView.mask = titleLabel
    }
    
    private func addAllSubviews() {
        addSubview(titleLabelMaskView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(loginButt)
        addSubview(orView)
        addSubview(facebookButt)
        addSubview(twitterButt)
        addSubview(googleButt)
        addSubview(appleLogInButton)
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
            make.trailing.equalTo(self).offset(-30)
        }
        
        loginButt.snp.makeConstraints { make in
            make.bottom.equalTo(appleLogInButton.snp.top).offset(-20)
            make.leading.equalTo(titleLabel)
            make.trailing.equalTo(self).offset(-30)
            make.height.equalTo(50)
        }
        
        orView.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.width.centerX.equalTo(loginButt)
            make.height.equalTo(40)
        }
        
        facebookButt.snp.makeConstraints { make in
            make.top.equalTo(orView.snp.bottom).offset(30)
            make.trailing.equalTo(twitterButt.snp.leading).offset(-20)
            make.height.width.equalTo(buttHeight)
        }
        
        twitterButt.snp.makeConstraints { make in
            make.top.equalTo(facebookButt)
            make.centerX.equalTo(self).offset(0)
            make.height.width.equalTo(facebookButt)
        }
        
        googleButt.snp.makeConstraints { make in
            make.top.equalTo(facebookButt)
            make.leading.equalTo(twitterButt.snp.trailing).offset(20)
            make.height.width.equalTo(facebookButt)
        }
        
        appleLogInButton.snp.makeConstraints { make in
            make.bottom.equalTo(orView.snp.top).offset(-30)
            make.leading.equalTo(titleLabel)
            make.trailing.equalTo(self).offset(-30)
            make.height.equalTo(50)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    @objc private func handleLogInWithAppleID() {
        print("tapped apple")
        delegate?.loginWith(type: .apple)
    }
    
    @objc private func handleLogInWithPhoneNumber() {
        print("tapped phone")
        delegate?.loginWith(type: .phoneNumber)

    }
    
    @objc private func handleLoginInWithFacebook() {
        print("tapped facebook")
        delegate?.loginWith(type: .facebook)
    }
    
    @objc private func handleLoginInWithTwitter() {
        print("tapped twitter")
        delegate?.loginWith(type: .twitter)
    }
    
    @objc private func handleLoginInWithGoogle() {
        print("tapped google")
        delegate?.loginWith(type: .google)
    }
}
