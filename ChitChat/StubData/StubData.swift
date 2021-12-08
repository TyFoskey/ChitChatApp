//
//  StubData.swift
//  ChitChat
//
//  Created by ty foskey on 9/20/20.
//  Copyright © 2020 ty foskey. All rights reserved.
//

import Foundation

class StubData {
    // Users
    static func createUser() -> [Users] {
        let user = Users(name: "Tyler", id: "1", profilePhotoUrl: "id", phoneNumber: "873-902-0982")
        let secondUser = Users(name: "Aaron Rodgers", id: "ar", profilePhotoUrl: "photo", phoneNumber: "778-213-4444")
        let thirdUser = Users(name: "Steph Curry", id: "SC30", profilePhotoUrl: "photo", phoneNumber: "555-999-0000")
        let forthUser = Users(name: "Dak Prescott", id: "DK4", profilePhotoUrl: "photo", phoneNumber: "768-543-9083")
        let fithUser = Users(name: "Lebron James", id: "LBJ23", profilePhotoUrl: "photo", phoneNumber: "908-763-8888")
        let sixthUser = Users(name: "Kevin Durant", id: "KD", profilePhotoUrl: "photo", phoneNumber: "333-222-1111")
        let seventhUser = Users(name: "Mila Kunis", id: "Mila", profilePhotoUrl: "photo", phoneNumber: "444-555-7777")
        let eighthUser = Users(name: "Zenday", id: "Z", profilePhotoUrl: "photo", phoneNumber: "862-520-9851")
        let ninthUser = Users(name: "Beyonce", id: "Beyonce", profilePhotoUrl: "photo", phoneNumber: "789-973-2233")

        return [user, secondUser, thirdUser, forthUser, fithUser, sixthUser, seventhUser, eighthUser, ninthUser]
    }
      
      
    //Messages
    static func createMessage() -> [MessageViewModel] {
        
        let message = Message(messageText: "hey there you look very good over there in you nice outfit that is ", creationDate: 123, toId: "ty11", fromId: "dJKAXrdebmaCLnrR2AFcfeg7cqv1", type: "text", id: "1", imageUrl: nil, imageWidth: nil, imageHeight: nil, isShare: false, username: nil, title: nil, postId: nil, localImage: nil)
        let messageView = MessageViewModel(message: message, user: StubData.createUser().first!)
        let secondMessage = Message(messageText: "This is the message text", creationDate: 1234, toId: "tmoney", fromId: "hABt3JVE7cPHQ5an0apr3tFTutr1", type: "group", id: "2", isShare: true)
        let secondMessageView = MessageViewModel(message: secondMessage, user: StubData.createUser()[1])
        let thirdMessage = Message(messageText: "Looking pretty good this app is going to be the number one in the app store", creationDate: 123, toId: "ty11", fromId: "SC", type: "text", id: "3", imageUrl: nil, imageWidth: nil, imageHeight: nil, isShare: false, username: nil, title: nil, postId: nil, localImage: nil)
        let thirdMessageView = MessageViewModel(message: thirdMessage, user: StubData.createUser()[2])
        let forthMessage = Message(messageText: "Just testing to see if it will hide the user profile", creationDate: 123, toId: "ty11", fromId: "hABt3JVE7cPHQ5an0apr3tFTutr1", type: "text", id: "4", imageUrl: nil, imageWidth: nil, imageHeight: nil, isShare: false, username: nil, title: nil, postId: nil, localImage: nil)
        let fourthMessageView = MessageViewModel(message: forthMessage, user: StubData.createUser()[2])
        let fithMessage = Message(messageText: "Trying another long message to see how the view will react with another long message that it will be forced to see how it will change and what the changes will be lol", creationDate: 123, toId: "ty11", fromId: "dJKAXrdebmaCLnrR2AFcfeg7cqv1", type: "text", id: "5", imageUrl: nil, imageWidth: nil, imageHeight: nil, isShare: false, username: nil, title: nil, postId: nil, localImage: nil)
        let fithMessageView = MessageViewModel(message: fithMessage, user: StubData.createUser()[0])
        let sixthMessage = Message(messageText: "This will be the sixth message to see what the changes will hold and the sixth one", creationDate: 123, toId: "ty11", fromId: "ty", type: "text", id: "6", imageUrl: nil, imageWidth: nil, imageHeight: nil, isShare: false, username: nil, title: nil, postId: nil, localImage: nil)
        let sixthMessageView = MessageViewModel(message: sixthMessage, user: StubData.createUser()[0])
        let seventhMessage = Message(messageText: "And another one lol", creationDate: 123, toId: "ty11", fromId: "hABt3JVE7cPHQ5an0apr3tFTutr1", type: "text", id: "7", imageUrl: nil, imageWidth: nil, imageHeight: nil, isShare: false, username: nil, title: nil, postId: nil, localImage: nil)
        let seventhMessageView = MessageViewModel(message: seventhMessage, user: StubData.createUser()[0])
        let eightMessage = Message(messageText: "And another one thats gonna be super long to test out the scroll ability of the chat view controller to see how well the view controller will handle being able to scroll up and down with more than one chat message that the user will be able to look at", creationDate: 123, toId: "ty11", fromId: "ty", type: "text", id: "8", imageUrl: nil, imageWidth: nil, imageHeight: nil, isShare: false, username: nil, title: nil, postId: nil, localImage: nil)
        let eightMessageView = MessageViewModel(message: eightMessage, user: StubData.createUser()[1])
        let nithMessage = Message(messageText: "The nith message that the user will look at lol", creationDate: 123, toId: "ty11", fromId: "dJKAXrdebmaCLnrR2AFcfeg7cqv1", type: "text", id: "9", imageUrl: nil, imageWidth: nil, imageHeight: nil, isShare: false, username: nil, title: nil, postId: nil, localImage: nil)
        let nithMessageView = MessageViewModel(message: nithMessage, user: StubData.createUser()[1])

        return [messageView,secondMessageView, thirdMessageView, fourthMessageView, fithMessageView, sixthMessageView, seventhMessageView, eightMessageView, nithMessageView]
    }
      
      // Chats
      static func createChatView() -> [ChatViewModel] {
          let chatView = ChatViewModel(users: [StubData.createUser().first!], messageView: StubData.createMessage().first!)
          let secondChatView = ChatViewModel(users: [StubData.createUser()[1]], messageView: StubData.createMessage()[1])
        let thridChatView = ChatViewModel(users: [StubData.createUser()[2], StubData.createUser()[1]], messageView: StubData.createMessage()[2])
          return [chatView, secondChatView, thridChatView]
      }
      
}
