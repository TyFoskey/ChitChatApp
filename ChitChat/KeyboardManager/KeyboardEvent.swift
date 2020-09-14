//
//  KeyboardEvent.swift
//  ChitChat
//
//  Created by ty foskey on 9/13/20.
//  Copyright © 2020 ty foskey. All rights reserved.
//

import UIKit

enum KeyboardEvent {
    /// Event raised by UIKit's `.UIKeyboardWillShow`.
    case willShow
    
    /// Event raised by UIKit's `.UIKeyboardDidShow`.
    case didShow
    
    /// Event raised by UIKit's `.UIKeyboardWillShow`.
    case willHide
    
    /// Event raised by UIKit's `.UIKeyboardDidHide`.
    case didHide
    
    /// Event raised by UIKit's `.UIKeyboardWillChangeFrame`.
    case willChangeFrame
    
    /// Event raised by UIKit's `.UIKeyboardDidChangeFrame`.
    case didChangeFrame
    
    /// Non-keyboard based event raised by UIKit
    case unknown
}
