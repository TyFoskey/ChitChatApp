//
//  StorageConfig.swift
//  ChitChat
//
//  Created by ty foskey on 9/15/20.
//  Copyright © 2020 ty foskey. All rights reserved.
//

import FirebaseStorage

struct StorageConfig {
    
    lazy var storageRef = Storage.storage().reference(forURL: storageRootRef)
    
    private var storageRootRef: String {
       return "gs://chitchat-8e72d.appspot.com"
    }
    
}
