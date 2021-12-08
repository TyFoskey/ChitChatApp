//
//  SendAPI.swift
//  ChitChat
//
//  Created by ty foskey on 11/29/21.
//  Copyright © 2021 ty foskey. All rights reserved.
//

import FirebaseDatabase
import FirebaseAuth

class SendAPI: NSObject {
    
    func uploadTextToServers(text: String, toId: String, users: [Users]) {
        let messageText = text
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        
        let creationDate = Int(Date().timeIntervalSince1970)
        let messageType = users.count > 1 ? "group" : "individually"
        
        let messageValue = ["creationDate" : creationDate,
                            "fromId" : currentUid,
                            "toId" : toId,
                            "messageText" : messageText,
                            "type": messageType] as [String: Any]
        
        let messageRef = Constants.refs.messagesRef.childByAutoId()
        
        messageRef.updateChildValues(messageValue)
        let messageDict = ["date" : -creationDate, "read" : false] as [String : Any]
        let userMessageDict = ["date" : -creationDate, "read" : true] as [String : Any]
        
        Constants.refs.userMessagesRef.child(currentUid).child((toId)).child(messageRef.key!).setValue(userMessageDict)
        Constants.refs.userChatsRef.child(currentUid).updateChildValues([toId: true])
        
        if users.count > 1 {
            for user in users {
                Constants.refs.userMessagesRef.child((user.id)).child(toId).child(messageRef.key!).setValue(messageDict)
                Constants.refs.userChatsRef.child(user.id).updateChildValues([toId: true])
            }
        } else {
            guard let newUserId = users.first?.id else {return}
            Constants.refs.userMessagesRef.child((newUserId)).child(currentUid).child(messageRef.key!).setValue(messageDict)
            Constants.refs.userChatsRef.child(newUserId).updateChildValues([currentUid: true])
        }
    }
    
}
