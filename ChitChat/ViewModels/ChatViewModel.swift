//
//  ChatViewModel.swift
//  ChitChat
//
//  Created by ty foskey on 9/8/20.
//  Copyright © 2020 ty foskey. All rights reserved.
//

import Foundation


class ChatViewModel {
  
    let users: [Users]
    let messageView: MessageViewModel
    let id: String
    let isFromUser: Bool
    let timeText: String
    
    init(users: [Users], messageView: MessageViewModel) {
        self.users = users
        self.messageView = messageView
        self.id = messageView.chatId
        self.isFromUser = messageView.isFrom
        self.timeText = messageView.timeText
    }
    
    var usernameText: String {
        switch users.count {
        case 1:
            switch true {
            case isFromUser == true: return users.first!.name
            default: return messageView.user.name
            }
        default:
            return setMultiUsernameText()
        }
    }
    
    var photoUrl: String {
        switch true {
        case isFromUser == true: return users.first!.profilePhotoUrl
        default: return messageView.user.profilePhotoUrl
        }
    }
    
    var messageText: String {
        switch messageView.messageKind {
        case .text: return messageView.message.messageText!
        case .photo: return "Attatchment: 1"
        }
    }

    
    private func setMultiUsernameText() -> String {
        var isFirst = true
        var usernameText = ""
        for user in users {
            if isFirst == true {
                usernameText = user.name
                isFirst = false
            } else {
                usernameText = usernameText + ",\(user.name)"
            }
        }
        return usernameText
    }
    
    
    // MARK: - List Diffable
    
//    func diffIdentifier() -> NSObjectProtocol {
//        return "chatId\(id)" as NSObject
//    }
//
//    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
//        guard let chatView = object as? ChatViewModel else {return false}
//        guard self !== object else {return true}
//        return true
//        //return users == chatView.users && id == chatView.id && messageView == chatView.messageView && isFromUser == chatView.isFromUser && timeText == chatView.timeText
//    }
    
}
