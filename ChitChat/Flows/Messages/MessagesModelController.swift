//
//  MessagesModelController.swift
//  ChitChat
//
//  Created by ty foskey on 9/16/20.
//  Copyright © 2020 ty foskey. All rights reserved.
//

import Foundation

class MessagesModelController {
    
    let id: String
    let messagesManager: MessagesManager
    var lastKey: Double?
    weak var delegate: MessagesProtocol?
    var messages = [MessageViewModel]()
    
    init(id: String, messagesManager: MessagesManager?) {
        self.id = id
        self.messagesManager = messagesManager ?? MessagesManager(id: id)
    }
    
    
    func fetchMessages() {
        messagesManager.fetchMessages(startKey: nil) { (result) in
            
        }
    }
    
    func observeNewMessages() {
        messagesManager.observeNewMessages(chatId: id) {[weak self] (messageView) in
            guard let strongSelf = self else {return}
            strongSelf.messages.append(messageView)
            strongSelf.delegate?.setMessages(messages: strongSelf.messages)
        }
    }
    
}
