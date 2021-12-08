//
//  LoginDelegate.swift
//  ChitChat
//
//  Created by ty foskey on 12/6/21.
//  Copyright © 2021 ty foskey. All rights reserved.
//

import Foundation

enum LoginType {
    case phoneNumber
    case facebook
    case google
    case twitter
    case apple
}

protocol LoginDelegate: AnyObject {
    func loginWith(type: LoginType)
}
