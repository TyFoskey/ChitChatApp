//
//  MessageViewModel.swift
//  ChitChat
//
//  Created by ty foskey on 9/8/20.
//  Copyright © 2020 ty foskey. All rights reserved.
//

import UIKit


class MessageViewModel {
    
    let message: Message
    let chatId: String
    let user: Users
    let isFrom: Bool
    let isSending: Bool
    
    init(message: Message, user: Users, isSending: Bool? = nil) {
        self.message = message
        self.user = user
        self.isFrom = false//message.fromId == Auth.auth().currentUser?.uid
        self.isSending = isSending ?? false
        if isFrom == true {
            self.chatId = message.toId
        } else {
            if message.type == "group" {
                self.chatId = message.toId
            } else {
                self.chatId = message.fromId
            }
        }
    }
    
    init(messageView: MessageViewModel, user: Users) {
        self.message = messageView.message
        self.user = user
        self.chatId = messageView.chatId
        self.isFrom = messageView.isFrom
        self.isSending = messageView.isSending
    }
    
       let dateFormatter = DateFormatter()

        var messageKind: MessageKind {
            switch message.photoUrl != nil || message.localImage != nil {
                case true: return .photo
                case false: return .text
            }
        }
        
        var timeText: String {
            let date = Date(timeIntervalSince1970: (message.creationDate))
         //   dateFormatter.dateFormat = "MMM/dd, h:mm a"
            dateFormatter.dateFormat = "h:mm a"
            return dateFormatter.string(from: date)
        }
        
//        var dateText: String {
//            let date = Date(timeIntervalSince1970: message.creationDate)
//            return Date().timestampOfLastMessage(date)
//        }
        
        var comparableDate: Int {
            let calendar = Calendar.current
            let date = Date(timeIntervalSince1970: message.creationDate)
            let startDay = calendar.startOfDay(for: date)
            let dayInterval = startDay.timeIntervalSince1970
            return Int(dayInterval)
        }
        
        var cellWidth: CGFloat {
            return getWidthSize()
        }
        
        var cellHeight: CGFloat {
            
            switch messageKind {
                
            case .text:
               return getTextSize()
                
            case .photo:

                guard let imageWidth = message.imageWidth?.floatValue, let imageHeight = message.imageHeight?.floatValue else {return 200}
                print(CGFloat(imageHeight / imageWidth * 270), "cell size")
                return CGFloat(imageHeight / imageWidth * 270)
                
            default:
                if let text = message.messageText, text.isEmpty == false {
                   let textSize = getTextSize()
                    return 320 + textSize
                } else {
                    return 340

                }
            }
        
        }
        
        func getWidthSize() -> CGFloat {
            let approximateWidthofBioText = 270 - 32
               
               let size = CGSize(width: approximateWidthofBioText, height: 1000)
               let attributes = [NSAttributedString.Key.font
                   : UIFont.systemFont(ofSize: 17)]
               
            let estimatedFrame = NSString(string: message.messageText!).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
               
               let width = estimatedFrame.width + 40 //42
               
               return CGFloat(width)
        }
        
        func getTextSize() -> CGFloat {
            let approximateWidthofBioText = 270 - 32
            
            let size = CGSize(width: approximateWidthofBioText, height: 1000)
            let attributes = [NSAttributedString.Key.font
                : UIFont.systemFont(ofSize: 17)]
            
            let estimatedFrame = NSString(string: message.messageText!).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
            
            let height = estimatedFrame.height + 32 //42
            
            return CGFloat(height)
        }
        
    
}
