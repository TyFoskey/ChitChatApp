//
//  SelectedUsers.swift
//  ChitChat
//
//  Created by ty foskey on 9/25/20.
//  Copyright © 2020 ty foskey. All rights reserved.
//

import IGListKit

class SelectedUsers: ListDiffable {
    
    let users: [Users]
    let chatId: String
    
    init(users: [Users], chatId: String?) {
        self.users = users
        if chatId != nil {
            self.chatId = chatId!
        } else if users.count > 0 {
            var toId = ""
            for user in users.sorted(by: { $0.id > $1.id}) {
                toId = (toId == "") ? user.id : toId + "-\(user.id)"
            }
            self.chatId = toId
        } else {
            self.chatId = users.first!.id
        }
        
    }
    
    private func createChatId() -> String {
        if users.count > 0 {
            var toId = ""
            for user in users.sorted(by: { $0.id > $1.id}) {
                toId = (toId == "") ? user.id : toId + "-\(user.id)"
            }
            return toId
        } else {
            return users.first!.id
        }
    }
    
    var nameTitleText: String {
        var title = ""
        for user in users {
            title = (user.id == users.first!.id) ? user.name : title + " \(user.name)"
        }
        return title
    }
    
    // MARK: - List Diffable
    func diffIdentifier() -> NSObjectProtocol {
        return chatId as NSObject
    }
    
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let newSelectedUser = object as? SelectedUsers else { return false }
        return self == newSelectedUser
    }
}

// MARK: - Equatable
extension SelectedUsers: Equatable {
    static func == (lhs: SelectedUsers, rhs: SelectedUsers) -> Bool {
        return lhs.users == rhs.users &&
            lhs.chatId == rhs.chatId
    }
    
    
}
