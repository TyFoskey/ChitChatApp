//
//  Refs.swift
//  ChitChat
//
//  Created by ty foskey on 9/13/20.
//  Copyright © 2020 ty foskey. All rights reserved.
//

import FirebaseDatabase

class References {
    let ref = Database.database().reference()
    let userRef = Database.database().reference().child("Users")
    var postRef = Database.database().reference().child("post")
    let notificationRef = Database.database().reference().child("notifications")
    let messagesRef = Database.database().reference().child("messages")
    let userMessagesRef = Database.database().reference().child("userMessages")
    let emailsRef = Database.database().reference().child("Emails")
    let phoneNumberRef = Database.database().reference().child("Numbers")
    let pushNotificationsRef = Database.database().reference().child("pushNotifications")
    let userChatsRef = Database.database().reference().child("userChats")
    
}
