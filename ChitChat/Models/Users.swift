//
//  User.swift
//  ChitChat
//
//  Created by ty foskey on 9/8/20.
//  Copyright © 2020 ty foskey. All rights reserved.
//

import IGListKit
import PhoneNumberKit

class Users: SnapshotProtocol {
    
    let name: String
    let id: String
    let profilePhotoUrl: String
    let phoneNumber: String
    
    init(name: String, id: String, profilePhotoUrl: String, phoneNumber: String) {
        self.name = name
        self.id = id
        self.profilePhotoUrl = profilePhotoUrl
        self.phoneNumber = phoneNumber
    }
    
    required init(snapDict: [String : Any], key: String) {
        self.id = key
        self.profilePhotoUrl = snapDict["profilePhotoUrl"] as! String
        self.name = snapDict["name"] as! String
        self.phoneNumber = snapDict["phoneNumber"] as! String
    }
    
    
}

// MARK: - Equatable
extension Users: Equatable {
    static func == (lhs: Users, rhs: Users) -> Bool {
        return lhs.name == rhs.name &&
            lhs.id == rhs.id &&
            lhs.profilePhotoUrl == rhs.profilePhotoUrl &&
            lhs.phoneNumber == rhs.phoneNumber
    }
    
}

// MARK: - List Diffable
extension Users: ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return id as NSObject
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let newUser = object as? Users else { return false }
        return self == newUser
    }
}
