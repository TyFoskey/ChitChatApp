//
//  MessagesVCKeyboardExts.swift
//  ChitChat
//
//  Created by ty foskey on 9/22/20.
//  Copyright © 2020 ty foskey. All rights reserved.
//

import UIKit

// MARK: - Keyboard extension
extension MessagesViewController {
    
    // MARK: - Keyboard Manager
    func setKeyboard() {
        keyboardManager.on(event: .willShow) {[weak self] (notification) in
            guard let strongSelf = self,
                strongSelf.messageInputView.textView.isFirstResponder == true,
                strongSelf.isFirstLayout == false else {
                    return
            }
        
            strongSelf.messageInputView.snp.updateConstraints { (make) in
                make.bottom.equalTo(strongSelf.view.safeAreaLayoutGuide.snp.bottomMargin).offset(-notification.endFrame.height + 30)
            }
            
            UIView.animate(withDuration: notification.timeInterval) {
                strongSelf.view.layoutIfNeeded()
            }
        }
        
        keyboardManager.on(event: .willHide) {[weak self] (notification) in
            guard let strongSelf = self,
            strongSelf.keyboardManager.isKeyboardHidden == false else {
                return
            }
            
            strongSelf.messageInputView.snp.updateConstraints { (make) in
                make.bottom.equalTo(strongSelf.view.safeAreaLayoutGuide.snp.bottomMargin).offset(0)
            }
            
            UIView.animate(withDuration: notification.timeInterval) {
                strongSelf.view.layoutIfNeeded()
            }
         
        }
    
    }
    
}

