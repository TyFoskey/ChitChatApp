//
//  MessageCellTextView.swift
//  ChitChat
//
//  Created by ty foskey on 12/5/21.
//  Copyright © 2021 ty foskey. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage

class MessageFromCellTextView: UIView {
    
    let frontView = UIView()
    let messageView = MessageView()
    let revealView = RevealView()
    let sendingBubble = UIView()
    let sendingBubbleHeight: CGFloat = 15
    
    
    let timeStamp: UILabel = {
        let label = UILabel()
        label.font = UIFont.italicSystemFont(ofSize: 10)
        label.numberOfLines = 1
        label.textColor = .gray
        return label
    }()
    
    
    var messageViewModel: MessageViewModel! {
        didSet {
            updateUI()
        }
    }
    
    override func layoutSubviews() {
        transform = CGAffineTransform(scaleX: 1, y: -1)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        messageView.bubbleView.backgroundColor = Constants.colors.secondaryColor
        frontView.backgroundColor = .clear
        revealView.backgroundColor = .systemBackground
       // sendingBubble.backgroundColor = Constants.colors.secondaryColor
        sendingBubble.layer.cornerRadius = sendingBubbleHeight / 2
        sendingBubble.isHidden = true
        addSubview(timeStamp)
        addSubview(messageView)
        addSubview(revealView)
        addSubview(frontView)
        addSubview(sendingBubble)

        setConstraints()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateUI() {
        messageView.messageLabel.text = messageViewModel.message.messageText
        messageView.messageLabel.textColor = .white
        revealView.message = messageViewModel
        sendingBubble.isHidden = !(messageViewModel.isFrom == true && messageViewModel.isSending == true)
    }
    
    private func setConstraints() {
        
        frontView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self)
            make.top.equalTo(self).offset(-1)
            make.bottom.equalTo(self).offset(0)
        }
        
        messageView.snp.makeConstraints { (make) in
            make.width.lessThanOrEqualTo(270)
            make.width.greaterThanOrEqualTo(40)
            make.trailing.equalTo(self).offset(-24)
            make.top.equalTo(self).offset(12)
        }
        
        timeStamp.snp.makeConstraints { (make) in
            make.bottom.equalTo(self).offset(1)
            make.trailing.equalTo(self).offset(-25)
        }
        
        revealView.snp.makeConstraints { (make) in
            make.bottom.top.equalTo(self)
            make.left.equalTo(self.snp.right)
            make.width.equalTo(70)
        }
        
        sendingBubble.snp.makeConstraints { (make) in
            make.centerY.equalTo(revealView.timeLabel)
            make.left.equalTo(self).offset(-(sendingBubbleHeight / 2))
            make.height.width.equalTo(sendingBubbleHeight)
        }

    }
}


class MessageToCellTextView: UIView {
    
    let frontView = UIView()
    let messageView = MessageView()
    let revealView = RevealView()

    let profileImageHeight: CGFloat = 32

    
    let timeStamp: UILabel = {
        let label = UILabel()
        label.font = UIFont.italicSystemFont(ofSize: 10)
        label.numberOfLines = 1
        label.textColor = .gray
        return label
    }()
    
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
       // imageView.layer.borderWidth = 1
        imageView.backgroundColor = .secondaryLabel
   //     imageView.layer.borderColor = UIColor.systemGroupedBackground.cgColor
        imageView.layer.cornerRadius = profileImageHeight / 2
        imageView.clipsToBounds = true
        return imageView
    }()

    
    var messageViewModel: MessageViewModel! {
        didSet {
            updateUI()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setBubbleViewBackgroundColor()
        messageView.layer.cornerRadius = 18
        frontView.backgroundColor = .systemBackground
       // messageView.bubbleView.backgroundColor = .red
        addSubview(frontView)
        addSubview(profileImageView)
        addSubview(timeStamp)
        addSubview(messageView)
        addSubview(revealView)
        
        setConstraints()

    }
    
    override func layoutSubviews() {
        transform = CGAffineTransform(scaleX: 1, y: -1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateUI() {
       // messageView.bubbleView.backgroundColor = .secondarySystemGroupedBackground
        messageView.messageLabel.text = messageViewModel.message.messageText
       // messageView.messageLabel.textColor = .black
        let urlString = messageViewModel.user.profilePhotoUrl
        profileImageView.sd_setImage(with: URL(string: urlString), completed: nil)
        revealView.message = messageViewModel
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setBubbleViewBackgroundColor()
    }
    
    private func setBubbleViewBackgroundColor() {
        let currentTrait = self.traitCollection
        switch currentTrait.userInterfaceStyle {
        case .dark:
            messageView.bubbleView.backgroundColor = .secondarySystemGroupedBackground
        case .light:
            messageView.bubbleView.backgroundColor = .systemGroupedBackground
        case .unspecified:
            messageView.bubbleView.backgroundColor = .systemGroupedBackground
            
        @unknown default:
            fatalError()
        }
    }
    
    private func setConstraints() {
        
        frontView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self)
            make.top.equalTo(self).offset(-1)
            make.bottom.equalTo(self).offset(0)
        }
        
        messageView.snp.makeConstraints { (make) in
            make.width.lessThanOrEqualTo(270)
            make.width.greaterThanOrEqualTo(40)
            make.leading.equalTo(self).offset(60)
            make.top.equalTo(self).offset(12)
        }
        
        timeStamp.snp.makeConstraints { (make) in
            make.bottom.equalTo(self).offset(1)
            make.leading.equalTo(self).offset(48)
        }
        
        // Profile Image Constraints
        profileImageView.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(16)
            make.bottom.equalTo(self).offset(-12)
            make.width.height.equalTo(profileImageHeight)
        }
        
        revealView.snp.makeConstraints { (make) in
            make.bottom.top.equalTo(self)
            make.left.equalTo(self.snp.right)
            make.width.equalTo(70)
        }

    }
}
