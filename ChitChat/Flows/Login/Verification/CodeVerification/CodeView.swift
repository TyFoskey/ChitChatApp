//
//  CodeView.swift
//  ChitChat
//
//  Created by ty foskey on 9/14/20.
//  Copyright © 2020 ty foskey. All rights reserved.
//

import UIKit
import SnapKit

protocol CodeViewDelegate: class {
    func didChangeCharacters()
    func verifyNumber(code: String)
}

class CodeView: UIView {
    
    // MARK: - Constants
    private let minDigits: UInt8 = 2
    private let maxDigits: UInt8 = 8
    private let textFieldViewLeadingSpace: CGFloat = 5
    private let textFieldViewVerticalSpace: CGFloat = 6
    var isAnimating = false
    
    
    // MARK: - Properties
    var underlineColor: UIColor = UIColor.darkGray {
        didSet {
            for textFieldView in textFieldViews {
                textFieldView.underlineColor = underlineColor
            }
        }
    }
    
    var underlineSelectedColor: UIColor = UIColor.black {
        didSet {
            for textFieldView in textFieldViews {
                textFieldView.underlineSelectedColor = underlineSelectedColor
            }
        }
    }
    
    var textColor: UIColor = UIColor.darkText {
        didSet {
            for textFieldView in textFieldViews {
                textFieldView.numberTextField.textColor = textColor
            }
        }
    }
    
    var digits: UInt8 = 6 {
        didSet {
            setupTextFieldViews()
        }
    }
    
    var textSize: CGFloat = 24.0 {
        didSet {
            for textFieldView in textFieldViews {
                textFieldView.numberTextField.font = UIFont.systemFont(ofSize: textSize)
            }
        }
    }
    
    var textFont: String = "" {
        didSet {
            if let font = UIFont(name: textFont.trim(), size: textSize) {
                textFieldFont = font
            } else {
                textFieldFont = UIFont.systemFont(ofSize: textSize)
            }
            
            for textFieldView in textFieldViews {
                textFieldView.numberTextField.font = textFieldFont
            }
        }
    }
    
    var textFieldBackgroundColor: UIColor = UIColor.clear {
        didSet {
            for textFieldView in textFieldViews {
                textFieldView.numberTextField.backgroundColor = textFieldBackgroundColor
            }
        }
    }
    
    var textFieldTintColor: UIColor = UIColor.blue {
        didSet {
            for textFieldView in textFieldViews {
                textFieldView.numberTextField.tintColor = textFieldTintColor
            }
        }
    }
    
    var darkKeyboard: Bool = false {
        didSet {
            keyboardAppearance = darkKeyboard ? .dark : .light
            for textFieldView in textFieldViews {
                textFieldView.numberTextField.keyboardAppearance = keyboardAppearance
            }
        }
    }
    
    var keyboardType: UIKeyboardType = UIKeyboardType.numberPad {
        didSet {
            for textFieldView in textFieldViews {
                textFieldView.numberTextField.keyboardType = keyboardType
            }
        }
    }
    
    
    // MARK: - Variables
    var isTappable: Bool = false {
        didSet {
          //  self.isUserInteractionEnabled = isTappable
        }
    }
    
    private var textFieldViews = [CodeTextFieldView]()
    private var keyboardAppearance = UIKeyboardAppearance.default
    private var textFieldFont = UIFont.systemFont(ofSize: 24.0)
    private var requiredDigits: Int = 6
    
    weak var delegate: CodeViewDelegate?
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    // MARK: - Methods
    func focus() {
        textFieldViews[0].numberTextField.becomeFirstResponder()
    }
    
    func getVerificationCode() -> String {
        var verificationCode = ""
        for textFieldView in textFieldViews {
            verificationCode += textFieldView.numberTextField.text!
        }
        
        return verificationCode
    }
    
    func hasValidCode() -> Bool {
        for textFieldView in textFieldViews {
            if textFieldView.numberTextField.text!.trim() == "" {
                return false
            }
        }
        
        return true
    }
    
    func clear() {
        for textFieldView in textFieldViews {
            textFieldView.numberTextField.text = ""
        }
        
        textFieldViews[0].activate()
        delegate?.didChangeCharacters()
    }
    
    private func setUp() {
        setupTextFieldViews()
        setupVerificationCodeView()
    }
    
    var colors: [UIColor] = [.blue, .red, .orange, .green, .gray, .purple]
    
    private func setupTextFieldViews() {
        textFieldViews.forEach { $0.removeFromSuperview() }
        textFieldViews.removeAll()
        
        let textFieldViewWidth = (375 - (textFieldViewLeadingSpace * (CGFloat(requiredDigits) + 1))) / CGFloat(requiredDigits)
        let textFieldViewHeight: CGFloat = 90 - (textFieldViewVerticalSpace * 2)
        var currentX: CGFloat = textFieldViewLeadingSpace
        for i in 0..<requiredDigits {
            let textFieldView = CodeTextFieldView()
            addSubview(textFieldView)
            textFieldView.snp.makeConstraints { (make) in
                make.height.equalTo(textFieldViewHeight)
                make.width.equalTo(textFieldViewWidth)
                make.centerY.equalTo(self)
                
                if i == 0 {
                    make.left.equalTo(self).offset(5)
                } else {
                    make.left.equalTo(textFieldViews[textFieldViews.count - 1].snp.right).offset(5)
                }
            }
            
            
            textFieldView.delegate = self
            textFieldViews.append(textFieldView)
            currentX += (textFieldViewWidth + textFieldViewLeadingSpace)
        }
        
        textFieldViews[0].numberTextField.text = " "
      //  textFieldViews[1].numberTextField.text = "2"
    }
    
    private func setupVerificationCodeView() {
        for textFieldView in textFieldViews {
            textFieldView.delegate = self
        }
        
        textFieldViews.first?.activate()
    }
    
    func animateFailure(_ completion : (() -> Void)? = nil) {
        

        isAnimating = true

        
        for textview in textFieldViews {
            textview.underlineView.backgroundColor = .red
            textview.underlineView.layer.sublayers?.removeAll()
        }
        
        clear()
        
        
        CATransaction.begin()
        CATransaction.setCompletionBlock({
            completion?()
            self.reloadAppearance()
        })
        
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction.init(name: .linear)
        animation.duration = 0.6
        animation.values = [-14.0, 14.0, -14.0, 14.0, -8.0, 8.0, -4.0, 4.0, 0.0 ]
        layer.add(animation, forKey: "shake")
        
        CATransaction.commit()
    }
    
    private func reloadAppearance() {
        for textview in textFieldViews {
            textview.addGradientLayer()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {[weak self] in
            self?.textFieldViews.first?.activate()
            self?.isAnimating = false
        }
        
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension CodeView: CodeTextFieldDelegate {
    
    func moveToNext(_ textFieldView: CodeTextFieldView) {
        guard var validIndex = textFieldViews.firstIndex(where: { $0 == textFieldView }) else {return}
        
        validIndex = validIndex == textFieldViews.count - 1 ? validIndex : validIndex + 1
            //textFieldViews.firstIndex(of: textFieldView) == textFieldViews.count - 1 ? textFieldViews.firstIndex(of: textFieldView)! : textFieldViews.firstIndex(of: textFieldView)! + 1
        guard textFieldView != textFieldViews.last else { textFieldView.activate(); return }
        textFieldView.deactivate()
        textFieldViews[validIndex].activate()
    }
    
    func moveToPrevious(_ textFieldView: CodeTextFieldView, oldCode: String) {
        if textFieldViews.last == textFieldView && oldCode != " " {
           // guard let index = textFieldViews.firstIndex(where: { $0 == textFieldView }) else { return }
           // textFieldViews[index - 1].animateLineView()
            return
        }
        textFieldView.gradient.removeAllAnimations()
        
        if textFieldView.code == " " {
            let validIndex = textFieldViews.firstIndex(of: textFieldView)! == 0 ? 0 : textFieldViews.firstIndex(of: textFieldView)! - 1
            textFieldViews[validIndex].activate()
            textFieldViews[validIndex].reset()
        }
    }
    
    func didChangeCharacters() {
        delegate?.didChangeCharacters()
    }
}
