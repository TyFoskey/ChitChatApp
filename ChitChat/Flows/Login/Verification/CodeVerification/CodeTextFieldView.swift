//
//  CodeTextFieldView.swift
//  ChitChat
//
//  Created by ty foskey on 9/14/20.
//  Copyright © 2020 ty foskey. All rights reserved.
//

import UIKit
import SnapKit

protocol CodeTextFieldDelegate: class {
    func moveToNext(_ textFieldView: CodeTextFieldView)
    func moveToPrevious(_ textFieldView: CodeTextFieldView, oldCode: String)
    func didChangeCharacters()
}

class CodeTextFieldView: UIView {
    
    // MARK: - Properties
    let numberTextField = UITextField()
    let underlineView = UIView()
    let shadowView = UIView()
    
    var underlineColor: UIColor = UIColor.darkGray {
      didSet {
        underlineView.backgroundColor = underlineColor
      }
    }

    var underlineSelectedColor: UIColor = UIColor.black

    var textColor: UIColor = UIColor.darkText {
      didSet {
        numberTextField.textColor = textColor
      }
    }

    var textSize: CGFloat = 24.0 {
      didSet {
        numberTextField.font = UIFont.systemFont(ofSize: textSize)
      }
    }

    var textFont: String = "" {
      didSet {
        if let font = UIFont(name: textFont, size: textSize) {
          numberTextField.font = font
        } else {
          numberTextField.font = UIFont.systemFont(ofSize: textSize)
        }
      }
    }

    var textFieldBackgroundColor: UIColor = UIColor.clear {
      didSet {
        numberTextField.backgroundColor = textFieldBackgroundColor
      }
    }

    var textFieldTintColor: UIColor = UIColor.blue {
      didSet {
        numberTextField.tintColor = textFieldTintColor
      }
    }

    var darkKeyboard: Bool = false {
      didSet {
        keyboardAppearance = darkKeyboard ? .dark : .light
        numberTextField.keyboardAppearance = keyboardAppearance
      }
    }
    
    var gradient = CAGradientLayer()
    
    // MARK: - Variables
    private var keyboardAppearance = UIKeyboardAppearance.default
    weak var delegate: CodeTextFieldDelegate?
    
    var code: String? {
        return numberTextField.text
    }
    
    // MARK: - Constants
    static let maxCharactersLen = 1
    
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(numberTextField)
        addSubview(shadowView)
        addSubview(underlineView)
        
        setUp()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        underlineView.addGradientBackground(colors: Colors.colorGradients, cornerRadius: 3, gradientType: .axial)
       
    }
    
    // MARK: - Methods
    func activate() {
        numberTextField.textAlignment = .center
        numberTextField.becomeFirstResponder()
        if numberTextField.text?.count == 0 {
            numberTextField.text = " "
        }

    }
    
    func deactivate() {
  
    }
    
    func reset() {
        numberTextField.text = " "
        updateUnderlineView()
        animateLineView()
    }
    
    func animateLineView() {
        let animation = CABasicAnimation(keyPath: "colors")
        animation.fromValue = [Colors.primaryColor.cgColor, Colors.secondaryColor.cgColor]
        animation.toValue = [UIColor.lightGray.cgColor, UIColor.lightGray.cgColor]
        animation.duration = 1.0
        animation.autoreverses = true
        animation.repeatCount = Float.greatestFiniteMagnitude
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        // add the animation to the gradient
        gradient.add(animation, forKey: nil)
    }
    
    // MARK: - Private Methods
    private func setUp() {
        numberTextField.delegate = self
        numberTextField.autocorrectionType = .no
        numberTextField.keyboardType = .numberPad
        numberTextField.tintColor = .clear
        numberTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        numberTextField.font = UIFont.systemFont(ofSize: textSize)
        numberTextField.textAlignment = .center
        numberTextField.snp.makeConstraints { (make) in
            make.top.equalTo(self)
            make.width.equalTo(underlineView)
           // make.left.right.equalTo(underlineView)
            make.centerX.equalTo(underlineView)
            make.bottom.equalTo(self).offset(-1)
        }
        
        underlineView.backgroundColor = .clear
        underlineView.layer.cornerRadius = 3
        underlineView.clipsToBounds = true
        underlineView.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(0)
            make.right.equalTo(self).offset(0)
            make.height.equalTo(8)
            make.bottom.equalTo(self)
        }
        
        
        shadowView.layer.shadowColor = Colors.secondaryColor.cgColor
        shadowView.layer.shadowOffset = CGSize(width: 1, height: 2)
        shadowView.layer.shadowRadius = 4
        shadowView.layer.shadowOpacity = 0.2
        shadowView.layer.cornerRadius = 4
        shadowView.backgroundColor = Colors.primaryColor
        shadowView.snp.makeConstraints { (make) in
            make.edges.equalTo(underlineView)
        }
        
    }
    
    private func updateUnderlineView() {
        underlineView.backgroundColor = numberTextField.text?.trim() != "" ? underlineSelectedColor : underlineColor
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        if numberTextField.text?.count == 0 {
            numberTextField.text = " "
        }
    }
    
    func addGradientLayer() {
        // create the gradient layer
        gradient.frame = self.underlineView.bounds
        gradient.startPoint = CGPoint(x:0.0, y:0.5)
        gradient.endPoint = CGPoint(x:1.0, y:0.5)
        gradient.colors = [Colors.primaryColor.cgColor, Colors.secondaryColor.cgColor]
        gradient.locations =  [-0.5, 1.5]
        
        let width: CGFloat = underlineView.bounds.width
        let cornerRadius: CGFloat = 3

        let shapeLayer = CAShapeLayer()
        shapeLayer.lineWidth = width
        shapeLayer.path = UIBezierPath(roundedRect: underlineView.bounds.insetBy(dx: width,
                                                                        dy: width), cornerRadius: cornerRadius).cgPath
        shapeLayer.fillColor = nil
        shapeLayer.strokeColor = UIColor.black.cgColor
     //   gradient.mask = shapeLayer
        
        // add the gradient to the view
        underlineView.layer.insertSublayer(gradient, at: 0)

    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - UITextFieldDelegate
extension CodeTextFieldView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentString = numberTextField.text!
        let newString = currentString.replacingCharacters(in: textField.text!.range(from: range)!, with: string)
        
        print(newString.count, "new string count")
        if newString.count > type(of: self).maxCharactersLen {
            delegate?.moveToNext(self)
            textField.text = string
        } else if newString.count == 0 {
            delegate?.moveToPrevious(self, oldCode: textField.text!)
            numberTextField.text = " "
        }
        
        delegate?.didChangeCharacters()
      //  updateUnderlineView()
        
        return newString.count <= type(of: self).maxCharactersLen
    }
}
