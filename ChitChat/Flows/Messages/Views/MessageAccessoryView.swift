//
//  MessageAccessoryView.swift
//  ChitChat
//
//  Created by ty foskey on 9/16/20.
//  Copyright © 2020 ty foskey. All rights reserved.
//

import UIKit
import SnapKit

class MessageAccessoryView: UIView {
    let placeHolderTextLabel = UILabel()
    let textView = CustomTextView()
    let sendButt = UIButton()
    let topView = UIView()
    
    let maxHeight: CGFloat = 125
    let minHeight: CGFloat = 50
    let paddingTop: CGFloat = 7
    let paddingBottom: CGFloat = 7
    var accessoryHeightConst: Constraint!
    var accessoryBottomConst: Constraint!
    
    
    var visualEffectAccessoryView: UIVisualEffectView!
    weak var delegate: MessageAccessoryDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemBackground
        configureItems()
        configureVisualEffect()
        setButts()
        setTextLabels()
        setTopView()
    }
    
    
    
    override var intrinsicContentSize: CGSize {
        self.textView.isScrollEnabled = false
        let size = textView.sizeThatFits(CGSize(width: textView.frame.width, height: CGFloat(MAXFLOAT)))
        
        let totalHeight = size.height + paddingTop + paddingBottom
        
        if totalHeight <= maxHeight {
            let updatedHeight = totalHeight > 50 ? totalHeight : 50
            accessoryHeightConst.update(offset: updatedHeight)
            return CGSize(width: self.bounds.width, height: max(totalHeight, minHeight))
        } else {
            accessoryHeightConst.update(offset: maxHeight)
            self.textView.isScrollEnabled = true
            return CGSize(width: self.bounds.width, height: maxHeight)
        }
    }
    
    private func setTextLabels() {
        textView.backgroundColor = .clear
//        textView.layer.cornerRadius = 20
//        textView.layer.borderWidth = 2
//        textView.layer.borderColor = Constants.colors.primaryColor.cgColor
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.tintColor = .label
        placeHolderTextLabel.font = UIFont.systemFont(ofSize: 16)
        placeHolderTextLabel.textColor = UIColor.placeholderText
        placeHolderTextLabel.text = "Type a message..."
        
        visualEffectAccessoryView.contentView.addSubview(textView)
        visualEffectAccessoryView.contentView.addSubview(placeHolderTextLabel)
        
        textView.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(20)
            make.top.equalTo(visualEffectAccessoryView).offset(7)
            make.bottom.equalTo(visualEffectAccessoryView).offset(-7)
            make.right.equalTo(sendButt.snp.left).offset(-8)
        }
        
        placeHolderTextLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(27)
            make.centerY.equalTo(visualEffectAccessoryView).offset(0)
        }
        
    }
    
    
    private func setButts() {
        visualEffectAccessoryView.contentView.addSubview(sendButt)
        sendButt.addTarget(self, action: #selector(sendTapped), for: .touchUpInside)
        
        sendButt.snp.makeConstraints { (make) in
            make.right.equalTo(visualEffectAccessoryView).offset(-12)
            make.bottom.equalTo(visualEffectAccessoryView).offset(-8)
            make.height.equalTo(35)
         //   make.width.equalTo(35)
        }
        
    }
    
    private func configureVisualEffect() {
        let blurEffect = UIBlurEffect(style: .regular)
        visualEffectAccessoryView = UIVisualEffectView(effect: blurEffect)
        visualEffectAccessoryView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(visualEffectAccessoryView)
        visualEffectAccessoryView.snp.makeConstraints {[weak self] (make) in
            guard let strongSelf = self else {return}
            make.centerX.equalTo(strongSelf)
            make.leading.equalTo(strongSelf).offset(12)
            make.trailing.equalTo(strongSelf).offset(-12)
            strongSelf.accessoryBottomConst = make.bottom.equalTo(strongSelf).offset(-7).constraint
            strongSelf.accessoryHeightConst = make.height.equalTo(50).constraint
        }
        visualEffectAccessoryView.layer.cornerRadius = 8
        visualEffectAccessoryView.layer.masksToBounds = true
        visualEffectAccessoryView.contentView.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.3)
      //  setBorderColor()
        //visualEffectAccessoryView.layer.borderColor = UIColor.systemGroupedBackground.cgColor
      //  visualEffectAccessoryView.layer.borderWidth = 1.5
    }
    
    
    private func configureItems() {
        sendButt.setTitle("Send", for: .normal)
        sendButt.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        sendButt.setTitleColor(.secondaryLabel, for: .normal)
        sendButt.isEnabled = false
        //sendButt.isHidden = true
        textView.delegate = self
    }
    
    private func setTopView() {
        self.addSubview(topView)
        topView.backgroundColor = .secondarySystemBackground//UIColor(red: 243, green: 243, blue: 243)
        topView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self)
            make.height.equalTo(1)
        }
    }
    
    // MARK: - Actions
    @objc private func sendTapped() {
        delegate?.sendTapped()
        textView.text = ""
        textViewDidEndEditing(textView)
    }
    
//    @objc private func photoTapped() {
//        delegate?.photoTapped()
//    }
    
    required init?(coder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
      }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
       // setBorderColor()
    }
    
    private func setBorderColor() {
        let currentTrait = self.traitCollection
        var color: UIColor?
        switch currentTrait.userInterfaceStyle {
        case .dark:
            color = .secondarySystemGroupedBackground
        case .light, .unspecified:
            color = .systemGroupedBackground
       
        @unknown default:
            fatalError()
        }
        visualEffectAccessoryView.layer.borderColor = color?.cgColor
    }
}

// MARK: - TextView Delegate
extension MessageAccessoryView: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        showHidePlaceHolder(in: textView)
        //setBorderColor()
        //visualEffectAccessoryView.layer.borderColor = UIColor.systemGroupedBackground.cgColor
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let height = self.intrinsicContentSize.height + 20
        self.invalidateIntrinsicContentSize()
        updateConstraints()
        delegate?.textDidChangeHeight(height: height)
        delegate?.textDidChange(textView: textView)
        showHidePlaceHolder(in: textView)
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        visualEffectAccessoryView.layer.borderColor = Constants.colors.secondaryColor.cgColor
    }
    
    private func showHidePlaceHolder(in textView: UITextView) {
         if !textView.hasText || textView.text.isEmpty {
            placeHolderTextLabel.isHidden = false
            sendButt.isEnabled = false
            sendButt.setTitleColor(.secondaryLabel, for: .normal)

             //sendButt.isHidden = true
         } else {
            placeHolderTextLabel.isHidden = true
            sendButt.isEnabled = true
             sendButt.setTitleColor(Constants.colors.buttonBlue, for: .normal)


            // sendButt.isHidden = false
         }
     }
}


extension UITextView {
    
    func curserPosition() -> NSInteger {
        print("curser position")
        let selectedRange : UITextRange = self.selectedTextRange!
        let textPosition : UITextPosition = selectedRange.start
        return self.offset(from: self.beginningOfDocument, to: textPosition)
    }
    
    func getCurrentWord() -> String {
        print("get current word")
        let cursorOffset : NSInteger = self.curserPosition()
        let text : NSString = self.text as NSString
        let substring : NSString = text.substring(to: cursorOffset) as NSString
        var lastWord = substring.components(separatedBy: " ").last
        lastWord = lastWord?.components(separatedBy: "\n").last
        return lastWord!
    }
    
    func setCurserAtPosition(position : NSInteger) {
        print("set curser position")
        let str : NSString = text as NSString
        if position < str.length {
            let textPosition : UITextPosition = self.position(from: self.beginningOfDocument, offset: position)!
            self.selectedTextRange = self.textRange(from: textPosition, to: textPosition)
        }else{
            let textPosition : UITextPosition = self.position(from: self.beginningOfDocument, offset: str.length)!
            self.selectedTextRange = self.textRange(from: textPosition, to: textPosition)
        }
        
    }
    
    func changeCurrentWordWith(newWordString : NSString) {
        print("change current word with")
        let curserIndex = self.curserPosition()
        let textNSString : NSString = self.text as NSString
        //        let preString : NSString = textNSString.substring(to: curserIndex) as NSString
        var startIndex : NSInteger = 0
        for (index, element) in self.text.enumerated() {
            if (element == " " || element == "\n") && curserIndex > index{
                startIndex = index + 1
            }
        }
        
        let nsrange = NSMakeRange(startIndex, curserIndex - startIndex)
        
        if nsrange.location + nsrange.length <= textNSString.length {
            let newString = textNSString.replacingCharacters(in: nsrange, with: newWordString as String)
            
            self.text = newString
            
            self.setCurserAtPosition(position: startIndex + newWordString.length)
        }
        
        
    }


}
