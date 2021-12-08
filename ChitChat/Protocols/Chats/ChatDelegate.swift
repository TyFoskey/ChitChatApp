//
//  ChatDelegate.swift
//  ChitChat
//
//  Created by ty foskey on 9/21/20.
//  Copyright © 2020 ty foskey. All rights reserved.
//

import UIKit

protocol ChatDelegate: AnyObject {
    func goToMessages(chatViewModel: ChatViewModel, isRead: Bool)
}
