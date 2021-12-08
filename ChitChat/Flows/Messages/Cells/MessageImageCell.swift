////
////  MessageImageCell.swift
////  ChitChat
////
////  Created by ty foskey on 9/21/20.
////  Copyright © 2020 ty foskey. All rights reserved.
////
//
//import UIKit
//import SnapKit
//
//class MessageImageCell: MessageContentCell {
//    
//    var imageLeadingConstr: Constraint!
//    var imageTrailingConstr: Constraint!
//
//    let messageImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.layer.cornerRadius = 16
//        imageView.layer.masksToBounds = true
//        imageView.contentMode = .scaleAspectFill
//        return imageView
//    }()
//    
//    var messageViewModel: MessageViewModel! {
//        didSet {
//            updateUI()
//        }
//    }
//    
//    func updateUI() {
//     //   let url = URL(string: messageViewModel.photoUrl!)
//       // messageImageView.sd_setImage(with: url, completed: nil)
//        // timeStamp.text = messageViewModel.timeText
//        setNewConstraints()
//        setConstrainsts()
//
//    }
//    
//    func setConstrainsts() {
//        
//        if messageViewModel.message.messageText?.isEmpty == false {
//            messageView.isHidden = false
//            messageView.messageLabel.text = messageViewModel.message.messageText
//            messageView.snp.updateConstraints { (make) in
//                messageViewTopConstr =  make.top.equalTo(messageImageView.snp.bottom).offset(3).constraint
//            }
//            messageViewTopConstr.isActive = true
//        } else {
//            messageView.isHidden = true
//        }
//        
//        switch messageViewModel.isFrom {
//            
//        case true:
//            messageViewLeadingConstr?.isActive = false
//            timeStampLeading?.isActive = false
//            messageViewTrailingConstr?.isActive = true
//            timeStampTrailing?.isActive = true
//            //  bubbleView.backgroundColor = .blue
//            //   messageLabel.textColor = .white
//            profileImageView.isHidden = true
//            
//        case false:
//            messageViewTrailingConstr?.isActive = false
//            timeStampTrailing?.isActive = false
//            messageViewLeadingConstr?.isActive = true
//            timeStampLeading?.isActive = true
//            //   bubbleView.backgroundColor = UIColor.init(red: 64/255, green: 224/255, blue: 208/255, alpha: 1)
//            //     messageLabel.textColor = .white
//            profileImageView.isHidden = false
//        }
//        
//    }
//    
//    func setNewConstraints() {
//        self.addSubview(messageImageView)
//        
//        messageImageView.snp.makeConstraints { (make) in
//            make.top.equalTo(self).offset(16)
//            make.width.lessThanOrEqualTo(270)
//            make.height.lessThanOrEqualTo(200)
//            imageTrailingConstr = make.trailing.equalTo(self).offset(-24).constraint
//            imageLeadingConstr = make.leading.equalTo(self).offset(60).constraint
//        }
//     
//        guard let imageWidth = messageViewModel.message.imageWidth?.floatValue, let imageHeight = messageViewModel.message.imageHeight?.floatValue else {return}
//        var height: CGFloat {
//            guard let imageWidth = messageViewModel.message.imageWidth?.floatValue, let imageHeight = messageViewModel.message.imageHeight?.floatValue else {return 200}
//           return CGFloat(imageHeight / imageWidth * 270) + 20
//        }
//        
//        messageView.bubbleView.backgroundColor = .clear
//        
//        switch messageViewModel.isFrom {
//        case true:
//            imageLeadingConstr.isActive = false
//            imageTrailingConstr.isActive = true
//        case false:
//            imageTrailingConstr.isActive = false
//            imageLeadingConstr.isActive = true
//
//        }
//        
//    }
//    
//    override func didMoveToSuperview() {
//        profileImageView.layer.cornerRadius = profileImageView.frame.size.height/2
//        
//        if messageViewModel.isFrom == true {
//            let gradientLayer = CAGradientLayer()
//            gradientLayer.colors = [UIColor(hexString: "#1E90FF").cgColor, UIColor(hexString: "#00BFFF").cgColor]
//            gradientLayer.frame = CGRect(x: 0, y: 0, width: messageView.frame.width, height: messageView.frame.height)
//            messageView.layer.borderWidth = 1
//            messageView.layer.borderColor = UIColor(hexString: "#1E90FF").cgColor
//            if #available(iOS 12.0, *) {
//                gradientLayer.type = .conic
//                print("using 12.0 baby")
//            } else {
//                gradientLayer.type = .axial
//            }
//            
//            //  bubbleView.layer.insertSublayer(gradientLayer, at: 0)
//        } else {
//            //            let gradientLayer = CAGradientLayer()
//            ////            gradientLayer.colors = [UIColor.init(red: 64/255, green: 224/255, blue: 208/255, alpha: 1).cgColor, UIColor(hexString: "#ADFF2F").cgColor]
//            //            gradientLayer.colors = [UIColor.groupTableViewBackground.cgColor, UIColor.lightGray.cgColor]
//            //            gradientLayer.frame = CGRect(x: 0, y: 0, width: bubbleView.frame.width, height: bubbleView.frame.height)
//            //            gradientLayer.type = .radial
//            messageView.layer.borderWidth = 1
//            messageView.layer.borderColor = UIColor.groupTableViewBackground.cgColor
//            
//            
//            //  bubbleView.layer.insertSublayer(gradientLayer, at: 0)
//        }
//    }
//}
