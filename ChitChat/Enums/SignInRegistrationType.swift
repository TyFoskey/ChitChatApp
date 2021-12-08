//
//  SignInRegistrationType.swift
//  ChitChat
//
//  Created by ty foskey on 12/7/21.
//  Copyright © 2021 ty foskey. All rights reserved.
//

import UIKit

enum SignInRegistrationType {
    case social(String, String, String?)
    case phoneNumber(String, Data, VerificationObject)
    case createProfile(String, String, Data)
    case signIn(VerificationObject)
}
