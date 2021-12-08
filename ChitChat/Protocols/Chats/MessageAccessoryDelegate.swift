//
//  MessageAccessoryDelegate.swift
//  ChitChat
//
//  Created by ty foskey on 12/5/21.
//  Copyright © 2021 ty foskey. All rights reserved.
//

import UIKit

protocol MessageAccessoryDelegate: AnyObject {
    func sendTapped()
    func textDidChangeHeight(height: CGFloat)
    func textDidChange(textView: UITextView)
}
