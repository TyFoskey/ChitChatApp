//
//  ChatsManager.swift
//  ChitChat
//
//  Created by ty foskey on 12/8/21.
//  Copyright © 2021 ty foskey. All rights reserved.
//

import FirebaseDatabase
import FirebaseAuth

protocol ChatsManagerDelegate: AnyObject {
    func showError(error: Error)
    func setChats(chats: [ChatViewModel])
    func newChat(chat: ChatViewModel)
    func noChats()
}

class ChatsManager {
    
    private let uid: String
    private let dataFetcher: DataFetcher
    private var chatsDict: [String:String] = [:]

    
    weak var delegate: ChatsManagerDelegate?
    
    init() {
        self.uid = Auth.auth().currentUser!.uid
        self.dataFetcher = DataFetcher(modelRef: Constants.refs.userMessagesRef, queryRef: Constants.refs.userMessagesRef.child(uid), id: uid)
    }
    
    
    deinit {
        removeAllChatsObservers()
    }
    
    func fetchChats() {
        fetchUsersChatIds {[weak self] ids in
            guard let strongSelf = self else { return }
            strongSelf.fetchUserChatFirstMessageId(ids: ids) { chats in
                strongSelf.delegate?.setChats(chats: chats)
                for chat in chats {
                    strongSelf.observeChangesinConversation(chatId: chat.id)
                }
            }
        }
    }
    
    // fetch user chat partners
    private func fetchUsersChatIds(completion: @escaping([String]) -> Void) {
        Constants.refs.userChatsRef.child(uid).observeSingleEvent(of: .value) {[weak self] snapshot in
            guard let objects = snapshot.children.allObjects as? [DataSnapshot], objects.isEmpty != true else {
                guard let strongSelf = self else { return }
                strongSelf.delegate?.noChats()
                return
            }
            let ids = objects.compactMap({
                return $0.key
            })
            
            completion(ids)
        }
    }
    
    // fetch the first message id in those chat partners
    private func fetchUserChatFirstMessageId(ids: [String], completion: @escaping([ChatViewModel]) -> Void) {
        let group = DispatchGroup()
        var chats = [ChatViewModel]()
        for id in ids {
            group.enter()
            Constants.refs.userMessagesRef.child(uid).child(id).queryOrdered(byChild: "date").queryLimited(toFirst: 1).observeSingleEvent(of: .value) {[weak self] snapshot in
                
                guard let dict = snapshot.value as? [String:Any],
                      let key = dict.keys.first,
                      let strongSelf = self else {
                          group.leave()
                          return
                      }
                
                let messageId = key
                //  let isRead = dict["isRead"] as? Bool
                
                strongSelf.fetchMessage(messageId: messageId) { messageViewModel in
                    guard let messageViewModel = messageViewModel else { return }
                    strongSelf.createChatViewModel(messageViewModel: messageViewModel) { chatViewModel in
                        chats.append(chatViewModel)
                        strongSelf.chatsDict.updateValue(chatViewModel.id, forKey: chatViewModel.messageView.message.id)
                        group.leave()
                    }
                }
                
            }
        }
        
        group.notify(queue: .main) {
            print("final chats")
            completion(chats)
        }
    }
    
    
    // fetch the message from the message id
    private func fetchMessage(messageId: String, completion: @escaping(MessageViewModel?) -> Void) {
        Constants.refs.messagesRef.child(messageId).observeSingleEvent(of: .value) {[weak self] snapshot in
            
            
            guard let dict = snapshot.value as? [String:Any],
                  let strongSelf = self else {
                      completion(nil)
                      return
                  }
            
            let message = Message(snapDict: dict, key: snapshot.key)
            strongSelf.fetchUser(userId: message.fromId) { messageUser in
                guard let messageUser = messageUser else {
                    completion(nil)
                    return
                }
                
                let messageViewModel = MessageViewModel(message: message, user: messageUser, isSending: false)
                completion(messageViewModel)
            }
        }
    }
    
    private func fetchUser(userId: String, completion: @escaping(Users?) -> Void) {
        Constants.refs.userRef.child(userId).observeSingleEvent(of: .value) { snapshot in
            guard let dict = snapshot.value as? [String:Any] else {
                completion(nil)
                return
            }
            
            let user = Users(snapDict: dict, key: snapshot.key)
            completion(user)
        }
    }
    
    private func createChatViewModel(messageViewModel: MessageViewModel, completion: @escaping(ChatViewModel) -> Void) {
        switch messageViewModel.message.type {
        case "group":
            fetchUsersInChat(toId: messageViewModel.message.toId) { users in
                let chatViewModel = ChatViewModel(users: users, messageView: messageViewModel)
                completion(chatViewModel)
            }
            
        default:
            if messageViewModel.isFrom == false {
                let chatViewModel = ChatViewModel(users: [messageViewModel.user], messageView: messageViewModel)
                completion(chatViewModel)
            } else {
                fetchUser(userId: messageViewModel.message.toId) { user in
                    let chatViewModel = ChatViewModel(users: [user!], messageView: messageViewModel)
                    completion(chatViewModel)
                }
            }
        }
    }
    
    
    private func fetchUsersInChat(toId: String, completion: @escaping([Users]) -> Void) {
        let ids = toId.components(separatedBy: "-")
        var users = [Users]()
        let group = DispatchGroup()
        
        for id in ids {
            if id != uid {
                group.enter()
                fetchUser(userId: id) { user in
                    users.append(user!)
                    group.leave()
                }
            }
        }
        
        group.notify(queue: .main) {
            completion(users)
        }
        
    }
    
    
    func observeChangesinConversation(chatId: String) {
        Constants.refs.userMessagesRef.child(uid).child(chatId).queryOrdered(byChild: "date").queryLimited(toFirst: 1).observe(.childAdded) {[weak self] (snapshot) in
            guard let strongSelf = self else { return }
            if let messageId = strongSelf.chatsDict[chatId], messageId == snapshot.key {
                // message already in chat
                print("message in chat already")
                return
            }
            strongSelf.fetchMessage(messageId: snapshot.key) { messageViewModel in
                guard let messageViewModel = messageViewModel else { return }
                strongSelf.createChatViewModel(messageViewModel: messageViewModel) { chatViewModel in
                    strongSelf.delegate?.newChat(chat: chatViewModel)
                }
            }
        }
    }
    
    func observeNewConversation() {
        Constants.refs.userMessagesRef.child(uid).observe(.childAdded) {[weak self] (snapshot) in
            guard let strongSelf = self else {return}
            strongSelf.fetchMessage(messageId: snapshot.key) { messageViewModel in
                guard let messageViewModel = messageViewModel else { return }
                strongSelf.createChatViewModel(messageViewModel: messageViewModel) { chatViewModel in
                    strongSelf.delegate?.newChat(chat: chatViewModel)
                    strongSelf.observeChangesinConversation(chatId: chatViewModel.id)
                }
            }
        }
    }
    
    
    func removeAllChatsObservers() {
        Constants.refs.ref.removeAllObservers()
    }
    
    
}
