//
//  User.swift
//  ChitChat
//
//  Created by ty foskey on 9/8/20.
//  Copyright © 2020 ty foskey. All rights reserved.
//

import Foundation

class Users {
    
    let name: String
    let id: String
    let profilePhotoUrl: String
    
    init(name: String, id: String, profilePhotoUrl: String) {
        self.name = name
        self.id = id
        self.profilePhotoUrl = profilePhotoUrl
    }
    
    required init(snapDict: [String : Any], key: String) {
        self.id = key
        self.profilePhotoUrl = snapDict["profilePhotoUrl"] as! String
        self.name = snapDict["name"] as! String
    }
    
}
