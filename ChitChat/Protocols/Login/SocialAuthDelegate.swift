//
//  SocialAuthDelegate.swift
//  ChitChat
//
//  Created by ty foskey on 12/7/21.
//  Copyright © 2021 ty foskey. All rights reserved.
//

import Foundation

protocol SocialAuthDelegate: AnyObject {
    func signIn(id: String, name: String, profileUrl: String?)
    func showError(error: Error)
}
