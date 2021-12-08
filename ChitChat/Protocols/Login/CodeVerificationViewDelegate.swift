//
//  CodeVerificationViewDelegate.swift
//  ChitChat
//
//  Created by ty foskey on 11/23/21.
//  Copyright © 2021 ty foskey. All rights reserved.
//

import UIKit

protocol CodeVerificationViewDelegate: AnyObject {
    func resendCode()
    func didChangeCharacters()
    func verifyNumber(code: String)
}
