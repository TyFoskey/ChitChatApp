//
//  Refs.swift
//  ChitChat
//
//  Created by ty foskey on 9/13/20.
//  Copyright © 2020 ty foskey. All rights reserved.
//

import Firebase

class References {
    static let ref = Database.database().reference()
    static let userRef = Database.database().reference().child("User")
    static var postRef = Database.database().reference().child("post")
    static let notificationRef = Database.database().reference().child("notifications")
    static let messagesRef = Database.database().reference().child("messages")
    static let userMessagesRef = Database.database().reference().child("userMessages")
    static let emailsRef = Database.database().reference().child("Emails")
    static let phoneNumberRef = Database.database().reference().child("phoneNumbers")
    static let pushNotificationsRef = Database.database().reference().child("pushNotifications")
    
}
