//
//  PhoneNumberView.swift
//  ChitChat
//
//  Created by ty foskey on 9/14/20.
//  Copyright © 2020 ty foskey. All rights reserved.
//

import UIKit
import PhoneNumberKit
import SnapKit

class PhoneNumberView: UIView {
    
    // MARK: - Properties
    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Sign Up,"
        titleLabel.backgroundColor = .clear
        titleLabel.layer.shadowOpacity = 0.2
        titleLabel.layer.shadowColor = Constants.colors.primaryColor.cgColor
        titleLabel.layer.shadowOffset = CGSize(width: 4, height: 3)
        titleLabel.layer.shadowRadius = 3
        titleLabel.font = UIFont.systemFont(ofSize: 37, weight: .semibold)
        titleLabel.textColor = .label//Colors.primaryColor
        return titleLabel
    }()
    
    let subtitleLabel: UILabel = {
        let subtitleLabel = UILabel()
        subtitleLabel.text = "Please enter your phone number"
        subtitleLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        subtitleLabel.textColor = .secondaryLabel
        return subtitleLabel
    }()
    
    let titleLabelMaskView = UIView()
    let nextButt = LoginButt()
    let numberForm = NumberFormTextField()
    let colorGradients = Constants.colors.colorGradients
    weak var delegate: PhoneNumberViewDelegate?
    
    
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
        titleLabelMaskView.mask = titleLabel
    }
    
    // MARK: - Actions
    @objc private func loginButtTapped() {
        delegate?.loginButtTapped()
    }
    
    
    // MARK: - Set Up
    private func setUp() {
        self.backgroundColor = .systemBackground
        titleLabelMaskView.backgroundColor = .red
        nextButt.addTarget(self, action: #selector(loginButtTapped), for: .touchUpInside)
        numberForm.delegate = self
        addSubviews()
        setConstraints()
    }
    
    private func addSubviews() {
        addSubview(titleLabelMaskView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(numberForm)
        addSubview(nextButt)
    }
    
    private func setConstraints() {
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(50)
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
        
        nextButt.snp.makeConstraints { (make) in
            make.bottom.equalTo(self).offset(-20)
            make.leading.trailing.equalTo(numberForm)
            make.height.equalTo(50)
        }
        
    }
    
    
    func emojiFlag(code: String) -> String {
        var string = ""
        var country = code.uppercased()
        for uS in country.unicodeScalars {
            string.append(String(describing: UnicodeScalar(127397 + uS.value)!))
        }
        return string
    }
    
}

extension PhoneNumberView: NumerFormTextViewDelegate {
    
    func textFieldDidChange() {
        delegate?.textFieldDidChange()
    }
    
    func phoneCodeButtTapped() {
        print("view tapped")
        delegate?.codeButtTapped()
    }
    
}


