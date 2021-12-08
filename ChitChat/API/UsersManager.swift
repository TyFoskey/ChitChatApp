//
//  UsersManager.swift
//  ChitChat
//
//  Created by ty foskey on 12/7/21.
//  Copyright © 2021 ty foskey. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseAuth

protocol UsersManagerDelegate: AnyObject {
    func showError(error: String)
    func setUsers(users: [Users])
    func currentUser(user: Users)
}

class UsersManager {
    
    let dataFetcher = DataFetcher(modelRef: Constants.refs.userRef, queryRef: Constants.refs.userRef, id: Auth.auth().currentUser!.uid)
    
    weak var delegate: UsersManagerDelegate?
    
    func fetchAllUsers() {
        dataFetcher.fetchData(t: Users.self, startingAt: nil, orderedBy: "id", andWithReturnCount: 100) {[weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .error(let error):
                print(error, "getting users error")
                strongSelf.delegate?.showError(error: error)
            case .completed(_):
                break
                
            case .success(let snapshot):
                var users = [Users]()
                print(snapshot, "the snapshot")
                for snap in snapshot.enumerated() {
                    print(snap.element.value, "the value")
                    if let dict = snap.element.value as? [String:Any] {
                        let user = Users(snapDict: dict, key: snap.element.key)
                        let uid = Auth.auth().currentUser!.uid
                        if user.id != uid {
                            users.append(user)
                        }
                    }
                }
                print(users.count, "users count")
                print(users.first?.name, "first name")
                strongSelf.delegate?.setUsers(users: users)
            }
        }
    }
    
    func fetchCurrentUser() {
        let uid = Auth.auth().currentUser!.uid
        print(uid, "the uid")
        dataFetcher.fetchFromDatabase(t: Users.self, ref: Constants.refs.userRef.child(uid)) {[weak self] user in
            guard let strongSelf = self else { return }
            strongSelf.delegate?.currentUser(user: user!)
        }
    }
}
