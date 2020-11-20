//
//  VerificationObject.swift
//  ChitChat
//
//  Created by ty foskey on 9/17/20.
//  Copyright © 2020 ty foskey. All rights reserved.
//

import Foundation

class VerificationObject {
    
    let number: String
    let code: String
    let id: String
    
    init(number: String,
         code: String,
         id: String) {
        
        self.number = number
        self.code = code
        self.id = id
    }
}
