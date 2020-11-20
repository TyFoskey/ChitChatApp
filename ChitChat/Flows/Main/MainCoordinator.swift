//
//  MainCoordinator.swift
//  ChitChat
//
//  Created by ty foskey on 9/17/20.
//  Copyright © 2020 ty foskey. All rights reserved.
//

import UIKit

final class MainCoordinator: BaseCoordinator {
    let router: Router
    
    override func start() {
        showChatsVC()
    }
    
    init(router: Router) {
        self.router = router
    }
    
    deinit {
        
    }
    
    private func showAuthCoordinator() {
        let authCoordinator = AuthCoordinator(router: router, auth: Authentication())
        authCoordinator.finishFlow = { [weak self] (_) in
            guard let strongSelf = self else { return }
            strongSelf.removeChildCoordinator(authCoordinator)
            strongSelf.showChatsVC()
        }
        
        self.addChildCoordinator(authCoordinator)
        authCoordinator.start()
    }
    
    private func showChatsVC() {
        let chatsVC = ChatsViewController()
        chatsVC.onGoToMessages = {[weak self] in
            print("on go")
            guard let strongSelf = self else { return }
            strongSelf.showMessagesVC()
        }
        
        chatsVC.onCreateNewMessage = {[weak self] in
            guard let strongSelf = self else { return }
            strongSelf.showNewMessageVC()
        }
        
        chatsVC.onAddNewUser = {[weak self] in
            guard let strongSelf = self else { return }
            strongSelf.showAddNewUserVC()
        }
        
        chatsVC.onGoToSettings = {[weak self] in
            guard let strongSelf = self else { return }
            strongSelf.showSettingsVC()
        }
        router.setRootModule(chatsVC)
    }
    
    private func showMessagesVC() {
        print("should be going to messages")
        let messagesVC = MessagesViewController()
        router.push(messagesVC)
    }
    
    private func showNewMessageVC() {
        let newMessagesVC = NewMessageViewController()
        router.push(newMessagesVC)
    }
    
    private func showAddNewUserVC() {
        let addNewUserVC = AddNewUserViewController()
        router.push(addNewUserVC)
    }
    
    private func showSettingsVC() {
        let settingsVC = SettingsViewController()
      
        settingsVC.onSignOut = {
            print("sign outt")
        }
        router.push(settingsVC)
    }
}

