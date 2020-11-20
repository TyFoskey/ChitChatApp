//
//  CodeVerificationView.swift
//  ChitChat
//
//  Created by ty foskey on 9/14/20.
//  Copyright © 2020 ty foskey. All rights reserved.
//

import UIKit
import SnapKit

class CodeVerificationView: UIView {
    
    // MARK: - Properties
    let topLabel = UILabel()
    let descriptionLabel = UILabel()
    let phoneNumberButt = UIButton()
    let codeView = CodeView()
    let timerLabel = UILabel()
    let sendAgainButt = UIButton()
    let bottomButt = UIButton()
    let circleSpinner = CircularSpinner(width: 20, frame: .zero)
    let errorLabel = UILabel()
    let phoneNumber: String
    
    

    // MARK: - Init
    init(phoneNumber: String, frame: CGRect) {
        self.phoneNumber = phoneNumber
        super.init(frame: frame)
        addSubview(topLabel)
        addSubview(descriptionLabel)
        addSubview(phoneNumberButt)
        addSubview(codeView)
        addSubview(errorLabel)
        addSubview(sendAgainButt)
        addSubview(bottomButt)
        addSubview(circleSpinner)
        setUp()
    }
    
    // MARK: - Private functions
    private func setUp() {
        topLabel.text = "Verify your Number"
        topLabel.font = UIFont.systemFont(ofSize: 30, weight: .semibold)
        topLabel.textAlignment = .center
        topLabel.numberOfLines = 0
        topLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(40)
            make.left.equalTo(self).offset(24)
            make.right.equalTo(self).offset(-24)
        }
        
        descriptionLabel.text = "Enter the four digit code that we sent to"
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = UIFont.systemFont(ofSize: 19, weight: .regular)
        descriptionLabel.textColor = .lightGray
        descriptionLabel.textAlignment = .center
        descriptionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(topLabel.snp.bottom).offset(12)
            make.left.equalTo(self).offset(16)
            make.right.equalTo(self).offset(-16)
        }
        
        phoneNumberButt.setTitle(phoneNumber, for: .normal)
        phoneNumberButt.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        phoneNumberButt.setTitleColor(Constants.colors.primaryColor, for: .normal)
        phoneNumberButt.snp.makeConstraints { (make) in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(4)
            make.centerX.equalTo(descriptionLabel)
            make.height.equalTo(20)
        }
        
        codeView.snp.makeConstraints { (make) in
            make.top.equalTo(phoneNumberButt.snp.bottom).offset(16)
            make.left.equalTo(self).offset(20)
            make.right.equalTo(self).offset(-20)
            make.height.equalTo(90)
        }
        
        errorLabel.isHidden = true
        errorLabel.text = "Code did not match. Please try again."
        errorLabel.textColor = .red
        errorLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        errorLabel.snp.makeConstraints { (make) in
            make.top.equalTo(codeView.snp.bottom).offset(12)
            make.left.equalTo(codeView).offset(10)
        }
        
        sendAgainButt.setTitle("Resend a new code", for: .normal)
        sendAgainButt.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        sendAgainButt.setTitleColor(Constants.colors.secondaryColor, for: .normal)
        sendAgainButt.snp.makeConstraints { (make) in
            make.bottom.equalTo(self).offset(-20)
            make.centerX.equalTo(self)
            make.height.equalTo(25)
        }
        
        bottomButt.setTitle("Verify Number", for: .normal)
        bottomButt.titleLabel?.font = UIFont.systemFont(ofSize: 23, weight: .medium)
        bottomButt.layer.cornerRadius = 10
        bottomButt.backgroundColor = .gray
        bottomButt.addTarget(self, action: #selector(bottomButtTapped), for: .touchUpInside)
        bottomButt.snp.makeConstraints { (make) in
            make.bottom.equalTo(sendAgainButt.snp.top).offset(-12)
            make.height.equalTo(55)
            make.left.equalTo(self).offset(20)
            make.right.equalTo(self).offset(-20)
        }
        
        circleSpinner.isHidden = true
        circleSpinner.snp.makeConstraints { (make) in
            make.bottom.equalTo(bottomButt.snp.bottom).offset(0)
            make.height.width.equalTo(90)
            make.centerX.equalTo(self)
        }
    }
    

    func updateBottomButt(isEnabled: Bool) {
        bottomButt.isEnabled = isEnabled
        bottomButt.backgroundColor = isEnabled == true ? Constants.colors.secondaryColor : .gray
    }
    
    @objc private func bottomButtTapped() {
        bottomButt.isHidden = true
        sendAgainButt.isHidden = true
        circleSpinner.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {[weak self] in
            guard let strongSelf = self else { return }
            strongSelf.codeView.delegate?.verifyNumber(code: strongSelf.codeView.getVerificationCode())
        }
    }
    
    
    func setWrongValue() {
        errorLabel.isHidden = false
        codeView.animateFailure(nil)
        circleSpinner.isHidden = true
        bottomButt.isHidden = false
        sendAgainButt.isHidden = false
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
