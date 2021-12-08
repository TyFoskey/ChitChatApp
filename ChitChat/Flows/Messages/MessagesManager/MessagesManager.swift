//
//  MessagesManager.swift
//  ChitChat
//
//  Created by ty foskey on 9/16/20.
//  Copyright © 2020 ty foskey. All rights reserved.
//

import FirebaseDatabase
import FirebaseAuth

class MessagesManager {
    
    private let chatId: String
    private let uid: String
    private let users: [Users]
    private let dataFetcher: DataFetcher
    private let sendAPI = SendAPI()
    private var lastMessageId: String = ""
    private var startKey: Double?
    typealias messagesCompletion = (_ result: Result<[MessageViewModel]>) -> Void
    
    weak var delgate: MessagesManagerDelegate?
    
    init(chatId: String, users: [Users]) {
        self.chatId = chatId
        self.users = users
        self.uid = Auth.auth().currentUser!.uid
        self.dataFetcher = DataFetcher(modelRef: Constants.refs.messagesRef, queryRef: Constants.refs.userMessagesRef.child(uid).child(chatId), id: chatId)
    }
    
    
    deinit {
        Constants.refs.userMessagesRef.child(uid).child(chatId).queryOrdered(byChild: "date").removeAllObservers()
    }
    /**
     Fetches  messages from the database.
    - Parameters:
        - startKey: the double value of where the fetch should begin.
        - completion: the handler for result callback.
     */
    func fetchMessages() {
        dataFetcher.fetchData(t: Message.self, startingAt: startKey, orderedBy: "date", andWithReturnCount: 100) {[weak self] (result) in
            guard let strongSelf = self else { return }
            strongSelf.dataHandler(startKey: strongSelf.startKey, result: result)
        }
    }
    
    
    /// Sends Message to database
    /// - Parameters:
    ///   - text: the text
    ///   - toId: the chatId or toId
    ///   - users: the users in the chat
    func sendMessage(text: String) {
        sendAPI.uploadTextToServers(text: text, toId: chatId, users: users)
    }
    
    
    /**
    Observes the new messages that come in from the database.
     - Parameters:
        - chatId: the id of the chat log the observer observes new messages from.
     */
    func observeNewMessages() {
        Constants.refs.userMessagesRef.child(uid).child(chatId).queryOrdered(byChild: "date").queryLimited(toFirst: 1).observe(.childAdded) {[weak self] (snapshot) in
            print(snapshot.key, "snap key", self?.lastMessageId, "last message id")
            guard let strongSelf = self, snapshot.key != self?.lastMessageId else {
                print("not equal")
                return
            }
            strongSelf.lastMessageId = snapshot.key
            print("about to observe message")
            
            strongSelf.dataFetcher.fetchFromDatabase(t: Message.self, ref: Constants.refs.messagesRef.child(snapshot.key), completion: { (message) in
                strongSelf.createMessageViewModel(message: message, completion: { (messageView) in
                    guard let newMessageView = messageView else {return}
                    strongSelf.delgate?.newMessage(message: newMessageView)
                })
            })
        }
    }
    

    private func dataHandler(startKey: Double?, result: Result<[DataSnapshot]>) {
        let group = DispatchGroup()
        var messages = [MessageViewModel]()
        switch result {
        case .completed(_):
            delgate?.setMessages(messages: [])
            //delgate?.updateLastDate(lastDate: nil)
           // completion(.completed(nil))
        case .success(let snapshots):
            let _ = snapshots.compactMap({[weak self] in
                guard let strongSelf = self else {return}
                group.enter()
                strongSelf.dataFetcher.fetchFromDatabase(t: Message.self, ref: Constants.refs.messagesRef.child($0.key)) { (message) in
                    strongSelf.createMessageViewModel(message: message) { (messageView) in
                        if messageView != nil, message?.creationDate != startKey {
                            messages.append(messageView!)
                        }
                        group.leave()
                    }
                }
            })
            
            group.notify(queue: .main) {[weak self] in
                guard let strongSelf = self else { return }
                if messages.count != 0 {
                    strongSelf.delgate?.setMessages(messages: messages)
                }
                
                guard let lastObject = snapshots.last?.value as? [String:Any], let date = lastObject["date"] as? Double, date != startKey else {
                    strongSelf.startKey = nil
                    return
                }
                
                strongSelf.startKey = date
            }
            
        case .error(let errorString):
            delgate?.showError(error: errorString)
        }
    }
    
    
    private func createMessageViewModel(message: Message?, completion: @escaping(MessageViewModel?) -> Void) {
        guard let message = message else { completion(nil); return }
        
        dataFetcher.fetchFromDatabase(t: Users.self, ref: Constants.refs.userRef.child(message.fromId)) { (user) in
            guard let user = user else { completion(nil); return }
            let messageView = MessageViewModel(message: message, user: user)
            completion(messageView)

        }
     }
    
    
}
