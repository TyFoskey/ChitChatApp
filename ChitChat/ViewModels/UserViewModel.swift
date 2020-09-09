//
//  UserViewModel.swift
//  ChitChat
//
//  Created by ty foskey on 9/8/20.
//  Copyright © 2020 ty foskey. All rights reserved.
//

import Foundation

class UserViewModel {
    
    let user: Users
    let outOfSync: Bool
    
    init(user: Users, isFollowing: Follow, bioText: String? = nil, count: Count? = nil) {
        self.user = user
        self.isFollowing = isFollowing
        self.bioText = bioText
        self.count = count
        self.outOfSync = false
    }
}
