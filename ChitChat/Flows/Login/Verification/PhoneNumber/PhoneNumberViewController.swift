//
//  PhoneNumberViewController.swift
//  ChitChat
//
//  Created by ty foskey on 9/14/20.
//  Copyright © 2020 ty foskey. All rights reserved.
//

import UIKit

class PhoneNumberViewController: UIViewController {
    
    // MARK: - Properties
    let phoneNumberView = PhoneNumberView()
    let keyboardManager = KeyboardManager()
    var onButtomButtTap: ((String) -> Void)?
    var onCountryButtTap: (() -> Void)?
    
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        setUpView()
        setUpKeyboard()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        phoneNumberView.numberForm.phoneTextField.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
    // MARK: - Set Up
    
    private func setUpView() {
        view.backgroundColor = .systemBackground
        view.addSubview(phoneNumberView)
        addCustomBackButton()
        phoneNumberView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin)
            make.left.right.equalTo(view)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottomMargin)
        }
        phoneNumberView.delegate = self
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
        UIView.animate(withDuration: 0.55, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.2, options: .curveEaseOut, animations: {[weak self] in
            self?.phoneNumberView.nextButt.snp.updateConstraints { (make) in
                make.bottom.equalTo(height)
            }
            self?.phoneNumberView.layoutIfNeeded()
            }, completion: nil)
    }
    
    func updateRegionButton(region: String) {
        phoneNumberView.numberForm.setRegion(region: region)
    }
    
    // MARK: - Actions
    
    @objc func countryButtTapped() {
        onCountryButtTap?()
    }
    
    @objc func bottomButtTapped() {
        guard let text = phoneNumberView.numberForm.phoneTextField.text, let preText = phoneNumberView.numberForm.phoneCodeButt.titleLabel?.text else { return }
        onButtomButtTap?("\(preText) \(text)")
    }
        
    // MARK: - Init
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PhoneNumberViewController: PhoneNumberViewDelegate {
    func loginButtTapped() {
        guard let numberText = phoneNumberView.numberForm.phoneTextField.text else {
            return
        }
        
        do {
            let parsedNumber = try phoneNumberView.numberForm.phoneTextField.phoneNumberKit.parse(numberText)
            let number = phoneNumberView.numberForm.phoneTextField.phoneNumberKit.format(parsedNumber, toType: .e164)
            onButtomButtTap?(number)
        } catch {
            print("parsing error")
        }
    }
    
    func codeButtTapped() {
        onCountryButtTap?()
    }
    
    func textFieldDidChange() {
        if phoneNumberView.numberForm.phoneTextField.text?.isEmpty == false {
               if phoneNumberView.nextButt.isEnabled == false {
                   phoneNumberView.nextButt.isValid()
               }
           } else {
               if phoneNumberView.nextButt.isEnabled == true {
                   phoneNumberView.nextButt.isNotValid()
               }
           }
       }
}
