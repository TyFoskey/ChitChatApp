//
//  MessagesManager.swift
//  ChitChat
//
//  Created by ty foskey on 9/16/20.
//  Copyright © 2020 ty foskey. All rights reserved.
//

import Firebase

class MessagesManager {
    
    private let id: String
    private let uid: String
    private let dataFetcher: DataFetcher
    private var lastMessageId: String = ""
    typealias messagesCompletion = (_ result: Result<[MessageViewModel]>) -> Void
    
    init(id: String) {
        self.id = id
        self.uid = Auth.auth().currentUser!.uid
        self.dataFetcher = DataFetcher(modelRef: Constants.refs.messagesRef, queryRef: Constants.refs.userMessagesRef.child(uid).child(id), id: id)
    }
    
    /**
     Fetches  messages from the database.
    - Parameters:
        - startKey: the double value of where the fetch should begin.
        - completion: the handler for result callback.
     */
    func fetchMessages(startKey: Double?, completion: @escaping messagesCompletion) {
        dataFetcher.fetchData(t: Message.self, startingAt: startKey, orderedBy: "date", andWithReturnCount: 10) {[weak self] (result) in self?.dataHandler(startKey: startKey, result: result, completion: completion)
        }
    }
    
    /**
    Observes the new messages that come in from the database.
     - Parameters:
        - chatId: the id of the chat log the observer observes new messages from.
     */
    func observeNewMessages(chatId: String, completion: @escaping(MessageViewModel) -> Void) {
        Constants.refs.userMessagesRef.child(uid).child(chatId).queryOrdered(byChild: "date").queryLimited(toFirst: 1).observe(.childAdded) {[weak self] (snapshot) in
            print(snapshot.key, "snap key", self?.lastMessageId, "last message id")
            guard snapshot.key != self?.lastMessageId else { print("not equal"); return}
            self?.lastMessageId = snapshot.key
            print("about to observe message")
            
            self?.dataFetcher.fetchFromDatabase(t: Message.self, ref: Constants.refs.messagesRef.child(snapshot.key), completion: { (message) in
                self?.createMessageViewModel(message: message, completion: { (messageView) in
                    guard let newMessageView = messageView else {return}
                    completion(newMessageView)
                })
            })
        }
    }
    

    private func dataHandler(startKey: Double?, result: Result<[DataSnapshot]>, completion: @escaping messagesCompletion) {
        let group = DispatchGroup()
        var messages = [MessageViewModel]()
        switch result {
        case .completed(_): completion(.completed(nil))
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
            
            group.notify(queue: .main) {
                if messages.count != 0 {
                    completion(.success(messages))
                }
                guard let lastObject = snapshots.last?.value as? [String:Any], let date = lastObject["date"] as? Double, date != startKey else { completion(.completed(nil)); return}
                
                completion(.completed(date))
            }
        case .error(let errorString): completion(.error(errorString))
            
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
