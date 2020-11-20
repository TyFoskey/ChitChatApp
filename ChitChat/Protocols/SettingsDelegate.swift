//
//  SettingsDelegate.swift
//  ChitChat
//
//  Created by ty foskey on 9/26/20.
//  Copyright © 2020 ty foskey. All rights reserved.
//

import UIKit

protocol SettingsDelegate: class {
    func changeProfilePic()
    func textFieldDidChange(textFieldType: SettingsTextFeildType, text: String?)
    func signOut()
}

