//
//  MessageTextCell.swift
//  ChitChat
//
//  Created by ty foskey on 9/21/20.
//  Copyright © 2020 ty foskey. All rights reserved.
//

import UIKit
import SnapKit

class MessageTextCell: MessageContentCell {
    
  //  weak var delegate: MessageCellDelegate?
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        messageView.gradientLayer.frame = messageView.bubbleView.frame
    }

    override func longPressed() {
        print("long pressed")
       // delegate?.longTapped(message: messageViewModel)
    }

 
    var messageViewModel: MessageViewModel! {
        didSet {
          updateUI()
        }
    }
    
    
    func updateUI() {
        messageView.messageLabel.text = messageViewModel.message.messageText!
        profileImageView.backgroundColor = .red
       // UIImage.cirlceImage(with: messageViewModel.userView.profileUrl, to: profileImageView)
       // timeStamp.text = messageViewModel.timeText
        
        UIView.performWithoutAnimation {
            setConstrainsts()
        }

    }
    
    func setConstrainsts() {
        
        messageViewTopConstr.update(offset: 16)
        messageViewTopConstr.isActive = true

        switch messageViewModel.isFrom {
            
        case true:
            messageViewLeadingConstr?.isActive = false
            timeStampLeading?.isActive = false
            messageViewTrailingConstr?.isActive = true
            timeStampTrailing?.isActive = true
          //  messageView.messageLabel.textColor = .white
            profileImageView.isHidden = true
         
            
        case false:
            messageViewTrailingConstr?.isActive = false
            timeStampTrailing?.isActive = false
            messageViewLeadingConstr?.isActive = true
            timeStampLeading?.isActive = true
            //messageView.messageLabel.textColor = .white
            profileImageView.isHidden = false
         
        }
        setMessageColor()
        layoutIfNeeded()

    }
    
    override func prepareForReuse() {
        messageViewTrailingConstr?.isActive = false
        messageViewLeadingConstr?.isActive = false
        timeStampTrailing?.isActive = false
        timeStampLeading?.isActive = false
      
    }
    
    override func layoutSubviews() {
        messageView.layer.shadowPath = UIBezierPath(roundedRect: messageView.bubbleView.bounds, cornerRadius: 18).cgPath
    }
    
    func setMessageColor() {
        messageView.bubbleView.backgroundColor = UIColor(red: 243, green: 243, blue: 243)
        messageView.gradientLayer.colors = messageViewModel.isFrom == true ? [Constants.colors.primaryColor.withAlphaComponent(0.6).cgColor, Constants.colors.secondaryColor.withAlphaComponent(0.5).cgColor] : [UIColor.clear.cgColor]
        messageView.layer.shadowColor =  messageViewModel.isFrom == true ? Constants.colors.primaryColor.withAlphaComponent(0.55).cgColor : UIColor.black.withAlphaComponent(0.25).cgColor
        messageView.layer.shadowOffset = CGSize(width: 2.5, height: 1.5)
        messageView.layer.shadowOpacity = 0.15
        messageView.layer.shadowRadius = 3
        messageView.messageLabel.textColor = messageViewModel.isFrom == true ? .white : UIColor.darkText

    }
    
}
