//
//  MessagesProtocol.swift
//  ChitChat
//
//  Created by ty foskey on 9/16/20.
//  Copyright © 2020 ty foskey. All rights reserved.
//

import Foundation

protocol MessagesManagerDelegate: AnyObject {
    func setMessages(messages: [MessageViewModel])
    func showError(error: String)
    func newMessage(message: MessageViewModel)
    func deletedMessage(message: MessageViewModel)
}
