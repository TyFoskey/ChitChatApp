//
//  MultiChatCell.swift
//  ChitChat
//
//  Created by ty foskey on 9/20/20.
//  Copyright © 2020 ty foskey. All rights reserved.
//

import UIKit
import SnapKit

class MultiChatCell: UICollectionViewCell {
    
    // MARK: - Properties
    let borderView = UIView()
    let firstProfilePic = UIImageView()
    let secondProfilePic = UIImageView()
    let usernameLabel = UILabel()
    let messageLabel = UILabel()
    let timeLabel = UILabel()
    let bubbleView = UIView()
    let profileHeight: CGFloat = 35
    
    weak var chatViewModel: ChatViewModel! {
        didSet {
            updateUI()
        }
    }
    
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Update UI
    private func updateUI() {
        
        usernameLabel.text = chatViewModel.usernameText
        messageLabel.text = chatViewModel.messageText
        timeLabel.text = chatViewModel.timeText
        bubbleView.isHidden = chatViewModel.messageView.message.isRead ?? false
      //  let photoId = chatViewModel.photoUrl
     //   let secondUrl = chatViewModel.users[1].profilePhotoUrl
        
    }
    
    
    private func setViews() {
        self.addSubview(borderView)
        self.addSubview(firstProfilePic)
        self.addSubview(secondProfilePic)
        self.addSubview(usernameLabel)
        self.addSubview(messageLabel)
        self.addSubview(timeLabel)
        self.addSubview(bubbleView)
        setBorderView()
        setProfilePics()
        setLabels()
        setBubbleView()
    }
    
    private func setBorderView() {
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
    
    private func setProfilePics() {
        firstProfilePic.layer.cornerRadius = profileHeight / 2
        firstProfilePic.backgroundColor = Constants.colors.primaryColor
        firstProfilePic.snp.makeConstraints { (make) in
            make.left.equalTo(borderView).offset(16)
            make.height.width.equalTo(profileHeight)
            make.top.equalTo(borderView).offset(16)
        }
        
        secondProfilePic.layer.cornerRadius = firstProfilePic.layer.cornerRadius
        secondProfilePic.backgroundColor = Constants.colors.secondaryColor
        secondProfilePic.snp.makeConstraints { (make) in
            make.height.width.equalTo(firstProfilePic)
            make.bottom.equalTo(borderView).offset(-14)
            make.left.equalTo(firstProfilePic.snp.right).offset(-24)
        }
    }
    
    private func setLabels() {
        // Username
        usernameLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        usernameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(firstProfilePic.snp.right).offset(20)
            make.top.equalTo(firstProfilePic).offset(0)
            make.right.equalTo(timeLabel.snp.left).offset(-6)
        }
        
        // Message
        messageLabel.font = UIFont.systemFont(ofSize: 13.5, weight: .medium)
        messageLabel.textColor = .darkGray
        messageLabel.numberOfLines = 2
        messageLabel.snp.makeConstraints { (make) in
            make.right.equalTo(timeLabel.snp.left).offset(-16)
            make.top.equalTo(usernameLabel.snp.bottom).offset(1)
            make.left.equalTo(usernameLabel).offset(1)
        }
        
        // Time Label
        timeLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        timeLabel.textColor = .darkGray
        timeLabel.snp.makeConstraints { (make) in
            make.right.equalTo(borderView).offset(-12)
            make.top.equalTo(usernameLabel).offset(-1)
        }
    }
    
    
    private func setBubbleView() {
        bubbleView.layer.cornerRadius = 15 / 2
        bubbleView.backgroundColor = Constants.colors.secondaryColor
        
        bubbleView.snp.makeConstraints { (make) in
            make.height.width.equalTo(15)
            make.top.equalTo(timeLabel.snp.bottom).offset(12)
            make.centerX.equalTo(timeLabel)
        }
    }
    
    
}
