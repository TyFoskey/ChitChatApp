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
    let photoButt = UIButton()
    let sendButt = UIButton()
    let topView = UIView()
    
    let maxHeight: CGFloat = 125
    let minHeight: CGFloat = 50
    let paddingTop: CGFloat = 7
    let paddingBottom: CGFloat = 7
    var accessoryHeightConst: Constraint!
    var accessoryBottomConst: Constraint!
    
    var visualEffectAccessoryView: UIVisualEffectView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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
        textView.font = UIFont.systemFont(ofSize: 15)
        placeHolderTextLabel.font = UIFont.systemFont(ofSize: 15)
        placeHolderTextLabel.textColor = UIColor.gray
        placeHolderTextLabel.text = "Add a message..."
        
        visualEffectAccessoryView.contentView.addSubview(textView)
        visualEffectAccessoryView.contentView.addSubview(placeHolderTextLabel)
        
        textView.snp.makeConstraints { (make) in
            make.left.equalTo(photoButt.snp.right).offset(15)
            make.top.equalTo(visualEffectAccessoryView).offset(7)
            make.bottom.equalTo(visualEffectAccessoryView).offset(-7)
            make.right.equalTo(sendButt.snp.left).offset(-8)
        }
        
        placeHolderTextLabel.snp.makeConstraints { (make) in
            make.left.equalTo(photoButt.snp.right).offset(21)
            make.centerY.equalTo(visualEffectAccessoryView).offset(1)
        }
        
    }
    
    
    private func setButts() {
        visualEffectAccessoryView.contentView.addSubview(photoButt)
        visualEffectAccessoryView.contentView.addSubview(sendButt)
        
        photoButt.snp.makeConstraints { (make) in
            make.left.equalTo(visualEffectAccessoryView).offset(12)
            make.bottom.equalTo(visualEffectAccessoryView).offset(-12)
            make.height.equalTo(25)
            make.width.equalTo(25)
        }
        
        sendButt.snp.makeConstraints { (make) in
            make.right.equalTo(visualEffectAccessoryView).offset(-8)
            make.bottom.equalTo(visualEffectAccessoryView).offset(-8)
            make.height.equalTo(35)
            make.width.equalTo(35)
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
            make.width.equalTo(360)
            strongSelf.accessoryBottomConst = make.bottom.equalTo(strongSelf).offset(-7).constraint
            strongSelf.accessoryHeightConst = make.height.equalTo(50).constraint
        }
        visualEffectAccessoryView.layer.cornerRadius = 25
        visualEffectAccessoryView.layer.masksToBounds = true
        visualEffectAccessoryView.contentView.backgroundColor = UIColor.groupTableViewBackground.withAlphaComponent(0.6)
        visualEffectAccessoryView.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        visualEffectAccessoryView.layer.borderWidth = 1
    }
    
    
    private func configureItems() {
        photoButt.setImage(UIImage(named: "cam Butt"), for: .normal)
        sendButt.setImage(UIImage(named: "sendButt"), for: .normal)
        sendButt.isHidden = true
        //textView.delegate = self
    }
    
    private func setTopView() {
        self.addSubview(topView)
        topView.backgroundColor = UIColor(red: 243, green: 243, blue: 243)
        topView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self)
            make.height.equalTo(1)
        }
    }
    
    required init?(coder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
      }
    
}
