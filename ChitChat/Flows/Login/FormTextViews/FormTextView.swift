//
//  FormTextView.swift
//  ChitChat
//
//  Created by ty foskey on 9/10/20.
//  Copyright © 2020 ty foskey. All rights reserved.
//

import UIKit
import SnapKit

class FormTextFieldView: UIView {
    
    // MARK: - Properties
    let textField = UITextField()
    let bottomView = UIView()
    let imageView = UIImageView()
    let topLabel = UILabel()
    let blockView = UIView()
    let errorImageView = UIImageView()
    let errorLabel = UILabel()
    let textViewImageView = UIImageView()
    weak var delegate: FormTextViewDelegate?
    
    // MARK: - Variables
    let colorGradients = [UIColor(red: 125/255, green: 137/255, blue: 225/255, alpha: 1).cgColor, UIColor(red: 137/255, green: 213/255, blue: 222/255, alpha: 1).cgColor]
    let errorImage = UIImage(named: "errorImageRed")
    let successImage = UIImage(named: "sendCheck")
    
    lazy var lineGradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = colorGradients
        gradient.type = .axial
        gradient.startPoint = .init(x: 0, y: 1)
        gradient.endPoint = .init(x: 1, y: 0)
        return gradient
    }()
    
    // MARK: - View Lifecycle
    init(labelText: String,placeholder: String, image: UIImage?, topLabelFont: UIFont? = nil, frame: CGRect, isPassword: Bool? = nil) {
        super.init(frame: frame)
        textField.placeholder = placeholder
        textField.isSecureTextEntry = isPassword ?? false
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        blockView.backgroundColor = .white
        bottomView.backgroundColor = .clear
        bottomView.layer.cornerRadius = 8
        bottomView.layer.borderWidth = 2
        bottomView.layer.borderColor = UIColor.groupTableViewBackground.cgColor//Colors.lightGray.cgColor
        
        
        setLabels(labelText: labelText, font: topLabelFont)
        setImageViews(with: image)
        topLabel.isHidden = true
        blockView.isHidden = true
        hideError()
        bottomView.isUserInteractionEnabled = false
        addSubview(bottomView)
        addSubview(blockView)
        addSubview(topLabel)
        addSubview(imageView)
        addSubview(textField)
        addSubview(textViewImageView)
        addSubview(errorLabel)
        setConstraints()
    }
    
    
    // MARK: - SetUp
    private func setLabels(labelText: String, font: UIFont?) {
        topLabel.text = labelText
        topLabel.font = font ?? UIFont.systemFont(ofSize: 10, weight: .semibold)
        textField.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        topLabel.textColor = Colors.primaryColor
        
        errorLabel.textColor = .red
        errorLabel.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        errorLabel.text = "There was an error"
    }
    
    private func setImageViews(with image: UIImage?) {
        imageView.contentMode = .scaleAspectFill
        imageView.image = image
        textViewImageView.contentMode = .scaleAspectFill
        textViewImageView.isHidden = true
    }
    
    private func setConstraints() {
        topLabel.snp.makeConstraints { (make) in
            make.top.equalTo(bottomView.snp.top).offset(-4)
            make.left.equalTo(bottomView).offset(20)
        }
        
        blockView.snp.makeConstraints { (make) in
            make.top.left.equalTo(topLabel).offset(-4)
            make.bottom.right.equalTo(topLabel).offset(4)
        }
        
        imageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(bottomView).offset(0)
            make.left.equalTo(bottomView).offset(12)
            make.height.width.equalTo(15)
        }
        
        textViewImageView.snp.makeConstraints { (make) in
            make.right.equalTo(bottomView.snp.right).offset(-8)
            make.height.width.equalTo(20)
            make.centerY.equalTo(imageView)
        }
        
        textField.snp.makeConstraints { (make) in
            make.centerY.equalTo(imageView)
            make.left.equalTo(imageView.snp.right).offset(10)
            make.right.equalTo(textViewImageView.snp.left).offset(-6)
        }
        
        bottomView.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(8)
            make.left.equalTo(self).offset(0)
            make.right.equalTo(self).offset(0)
            make.bottom.equalTo(textField).offset(12)
        }
        
        
        errorLabel.snp.makeConstraints { (make) in
            make.top.equalTo(bottomView.snp.bottom).offset(3)
            make.left.right.equalTo(bottomView).offset(0)
        }
        
    }
    

    // MARK: - Show/Hide Errors
    func showError(withErrorMessage text: String) {
        errorImageView.isHidden = false
        errorLabel.isHidden = false
        textViewImageView.isHidden = false
        textViewImageView.image = errorImage
        errorLabel.text = text
    }
    
    func hideError(showSuccess: Bool? = nil) {
        if showSuccess == true {
            textViewImageView.isHidden = false
            textViewImageView.image = successImage
        } else {
            textViewImageView.isHidden = true
        }
        errorImageView.isHidden = true
        errorLabel.isHidden = true
    }
    
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


// MARK: - TextField Delegate
extension FormTextFieldView: UITextFieldDelegate {
    
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
                        strongSelf.bottomView.layer.addGradienBorder(colors: Colors.colorGradients, width: 2, cornerRadius: 8)
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
