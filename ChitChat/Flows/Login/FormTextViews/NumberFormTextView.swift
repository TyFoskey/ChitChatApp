//
//  NumberFormTextView.swift
//  ChitChat
//
//  Created by ty foskey on 9/14/20.
//  Copyright © 2020 ty foskey. All rights reserved.
//

import UIKit
import SnapKit
import PhoneNumberKit

class NumberFormTextField: UIView {
    
    // MARK: - Properties
    let phoneTextField = PhoneNumberTextField()
    let phoneCodeButt = UIButton()
    let bottomView = UIView()
    let topLabel = UILabel()
    let blockView = UIView()
    var regionCode = PhoneNumberKit.defaultRegionCode()
    let colorGradients = Constants.colors.colorGradients
    weak var delegate: NumerFormTextViewDelegate?
    let errorImage = UIImage(named: "errorImageRed")

    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bottomView)
        addSubview(phoneCodeButt)
        addSubview(phoneTextField)
        addSubview(topLabel)
        addSubview(blockView)
        setUp()
    }
    
    
    // MARK: - Layout Subview
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    
    // MARK: - SetUp
    private func setUp() {
        setRegion(region: regionCode)
        phoneCodeButt.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        phoneCodeButt.setImage(UIImage(named: "downArrow"), for: .normal)
        phoneCodeButt.semanticContentAttribute = .forceRightToLeft
        phoneCodeButt.imageEdgeInsets = UIEdgeInsets(top: 6, left: 12, bottom: 5, right: 5)
        phoneCodeButt.setTitleColor(.black, for: .normal)
        topLabel.isHidden = true
        blockView.isHidden = true
        bottomView.backgroundColor = .clear
        bottomView.layer.cornerRadius = 8
        bottomView.layer.borderWidth = 2
        bottomView.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        phoneTextField.delegate = self
        phoneTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        phoneTextField.placeholder = "Phone number"
        phoneTextField.keyboardType = .phonePad
        phoneCodeButt.addTarget(self, action: #selector(phoneCodeButtTapped), for: .touchUpInside)
        
        setContraints()
    }
    
    private func setContraints() {
        topLabel.snp.makeConstraints { (make) in
            make.top.equalTo(bottomView.snp.top).offset(-4)
            make.left.equalTo(bottomView).offset(20)
        }
        
        blockView.snp.makeConstraints { (make) in
            make.top.left.equalTo(topLabel).offset(-4)
            make.bottom.right.equalTo(topLabel).offset(4)
        }
        
        phoneCodeButt.snp.makeConstraints { (make) in
            make.centerY.equalTo(bottomView).offset(0)
            make.left.equalTo(bottomView).offset(12)
            make.width.equalTo(70)
        }
        
        phoneTextField.snp.makeConstraints { (make) in
            make.centerY.equalTo(phoneCodeButt)
            make.left.equalTo(phoneCodeButt.snp.right).offset(13)
            make.right.equalTo(self)
        }
        
        bottomView.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(8)
            make.left.equalTo(self).offset(0)
            make.right.equalTo(self).offset(0)
            make.bottom.equalTo(phoneTextField).offset(12)
        }
                
    }
    
    func setRegion(region: String) {
        var title = emojiFlag(code: region)
        let callingCode = PhoneNumberKit().countryCode(for: region)
        title = "\(title) +\(callingCode!)"
        phoneCodeButt.setTitle(title, for: .normal)
    }
    
    func emojiFlag(code: String) -> String {
        var string = ""
        let country = code.uppercased()
        for uS in country.unicodeScalars {
            string.append(String(describing: UnicodeScalar(127397 + uS.value)!))
        }
        return string
    }
    
    // MARK: - Actions
    @objc private func phoneCodeButtTapped() {
        print("tapped")
        delegate?.phoneCodeButtTapped()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NumberFormTextField: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        checkGradient()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        bottomView.layer.sublayers?.removeAll()
        bottomView.layer.borderColor = UIColor.groupTableViewBackground.cgColor
    }
    
    
    func checkGradient() {
        guard let sublayers = bottomView.layer.sublayers else {
            setGradients()
            return
        }
        if sublayers.count > 1 {
            setGradients()
        }
    }
    
    private func setGradients() {
        UIView.animate(withDuration: 0.55,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0.6,
                       options: .curveEaseOut,
                       animations: { [weak self] in
                        guard let strongSelf = self else { return }
                        strongSelf.bottomView.layer.addGradienBorder(colors: Constants.colors.colorGradients, width: 2, cornerRadius: 8)
                        strongSelf.bottomView.layer.borderColor = UIColor.clear.cgColor
                        strongSelf.layoutIfNeeded()
            }, completion: nil)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        topLabel.isHidden = textField.text?.isEmpty ?? true
        blockView.isHidden = textField.text?.isEmpty ?? true
        delegate?.textFieldDidChange()
    }
}
