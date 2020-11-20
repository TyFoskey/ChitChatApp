//
//  ChatCell.swift
//  ChitChat
//
//  Created by ty foskey on 9/16/20.
//  Copyright © 2020 ty foskey. All rights reserved.
//

import UIKit

class ChatCell: UICollectionViewCell {
    
    let profilePic = UIImageView()
    let borderView = UIView()
    let usernameLabel = UILabel()
    let messageLabel = UILabel()
    let bubbleView = UIView()
    let timeLabel = UILabel()
    
    var chatView: ChatViewModel! {
        didSet {
            updateView()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setBorderView()
        setProfilePhoto()
        setUsernameLabel()
        setTimeLabel()
        setMessageLabel()
        setBubbleView()
    }
    
    private func updateView() {
        usernameLabel.text = chatView.usernameText
        messageLabel.text = chatView.messageText
        timeLabel.text = chatView.timeText
        bubbleView.isHidden = chatView.messageView.message.isRead ?? false
    }
    
    private func setBorderView() {
        self.addSubview(borderView)
        borderView.layer.cornerRadius = 18
        borderView.layer.borderWidth = 1.2
        borderView.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        borderView.backgroundColor = .white
        borderView.layer.shadowOpacity = 0.2
        borderView.layer.shadowColor = UIColor.gray.cgColor
        borderView.layer.shadowOffset = CGSize(width: 6, height: 7)
        borderView.layer.shadowRadius = 6
        borderView.snp.makeConstraints { (make) in
            make.bottom.equalTo(self).offset(-8)
            make.right.equalTo(self).offset(-16)
            make.top.equalTo(self).offset(8)
            make.left.equalTo(self).offset(16)
        }
    }
    
    private func setProfilePhoto() {
        self.addSubview(profilePic)
        profilePic.backgroundColor = .orange
        profilePic.layer.cornerRadius = 55 / 2
        
        profilePic.snp.makeConstraints { (make) in
            make.height.width.equalTo(55)
            make.top.left.equalTo(borderView).offset(12)
        }
    }
    
    private func setUsernameLabel() {
        self.addSubview(usernameLabel)
        usernameLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        
        usernameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(profilePic.snp.right).offset(12)
            make.top.equalTo(profilePic).offset(6)
            
        }
    }
    
    private func setMessageLabel() {
        self.addSubview(messageLabel)
        messageLabel.font = UIFont.systemFont(ofSize: 13.5, weight: .medium)
        messageLabel.textColor = .darkGray
        messageLabel.numberOfLines = 2
        
        messageLabel.snp.makeConstraints { (make) in
            make.right.equalTo(timeLabel.snp.left).offset(-16)
            make.top.equalTo(usernameLabel.snp.bottom).offset(1)
            make.left.equalTo(usernameLabel).offset(1)
        }
    }
    
    private func setBubbleView() {
        self.addSubview(bubbleView)
        bubbleView.layer.cornerRadius = 15 / 2
        bubbleView.backgroundColor = Constants.colors.secondaryColor
        
        bubbleView.snp.makeConstraints { (make) in
            make.height.width.equalTo(15)
            make.top.equalTo(timeLabel.snp.bottom).offset(12)
            make.centerX.equalTo(timeLabel)
        }
    }
    
    private func setTimeLabel() {
        self.addSubview(timeLabel)
        timeLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        timeLabel.textColor = .darkGray
        
        timeLabel.snp.makeConstraints { (make) in
            make.right.equalTo(borderView).offset(-12)
            make.top.equalTo(usernameLabel).offset(-1)
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
