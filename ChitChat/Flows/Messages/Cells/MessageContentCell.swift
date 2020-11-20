//
//  MessageContentCell.swift
//  ChitChat
//
//  Created by ty foskey on 9/21/20.
//  Copyright © 2020 ty foskey. All rights reserved.
//

import UIKit
import SnapKit

class MessageContentCell: UICollectionViewCell {
    
    let profileImageHeight: CGFloat = 32
    
    let messageView: MessageView = {
        let message = MessageView()
        message.layer.cornerRadius = 18
      //  message.layer.masksToBounds = true
        return message
    }()
    
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        imageView.layer.cornerRadius = profileImageHeight / 2

     //   imageView.maskToBounds = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let timeStamp: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.italicSystemFont(ofSize: 10)
        label.numberOfLines = 1
        label.textColor = .gray
        return label
    }()
    
    
    var timeStampLeading: Constraint?
    var timeStampTrailing: Constraint?
    var messageViewLeadingConstr: Constraint!
    var messageViewTrailingConstr: Constraint!
    var messageViewTopConstr: Constraint!
    var messageViewTopConstrToOther: Constraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(messageView)
        addSubview(profileImageView)
        addSubview(timeStamp)
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressed))
        self.addGestureRecognizer(longPressGesture)
        setConstraints()

    }

    @objc func longPressed() {
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setConstraints() {
        
        // MessageView constraints
        messageView.snp.makeConstraints { (make) in
            make.width.lessThanOrEqualTo(270)
            make.width.greaterThanOrEqualTo(40)
            messageViewLeadingConstr = make.leading.equalTo(self).offset(60).constraint
            messageViewTrailingConstr = make.trailing.equalTo(self).offset(-24).constraint
            messageViewTopConstr = make.top.equalTo(self).constraint
        
        }
        
        // TimeStamp unactivated constraints
        timeStamp.snp.makeConstraints { (make) in
            make.bottom.equalTo(self).offset(1)
            timeStampLeading = make.leading.equalTo(self).offset(48).constraint
            timeStampTrailing = make.trailing.equalTo(self).offset(-25).constraint
        }
  
        // Profile Image Constraints
        profileImageView.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(8)
            make.bottom.equalTo(self).offset(-10)
            make.width.height.equalTo(profileImageHeight)
        }
          
    }
}
