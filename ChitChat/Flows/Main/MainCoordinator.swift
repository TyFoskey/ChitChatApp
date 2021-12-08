//
//  MainCoordinator.swift
//  ChitChat
//
//  Created by ty foskey on 9/17/20.
//  Copyright © 2020 ty foskey. All rights reserved.
//

import UIKit

final class MainCoordinator: BaseCoordinator, CoordinatorFinishOutput {
    
    let router: Router
    var finishFlow: ((Any?) -> Void)?
    
    override func start() {
        showChatsVC()
    }
    
    init(router: Router) {
        self.router = router
    }
    
    deinit {
        print("deiniting main coordinator")
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
        chatsVC.onGoToMessages = {[weak self] chatViewModel in
            print("on go")
            guard let strongSelf = self else { return }
            strongSelf.showMessagesVC(chatId: chatViewModel.id, users: chatViewModel.users, chatTitle: chatViewModel.usernameText)
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
    
    private func showMessagesVC(chatId: String, users: [Users], chatTitle: String) {
        print("should be going to messages")
        let messagesVC = MessagesViewController(chatId: chatId, users: users, title: chatTitle)
        router.push(messagesVC)
    }
    
    private func showNewMessageVC() {
        let newMessagesVC = NewMessageViewController()
        newMessagesVC.onGoToMessages = {[weak self] chatId, users, chatTitle in
            guard let strongSelf = self else { return }
            strongSelf.showMessagesVC(chatId: chatId, users: users, chatTitle: chatTitle)
            strongSelf.router.navigationController?.viewControllers.remove(at: 1)
        }
        router.push(newMessagesVC)
    }
    
    private func showAddNewUserVC() {
        let addNewUserVC = AddNewUserViewController()
        router.push(addNewUserVC)
    }
    
    private func showSettingsVC() {
        let settingsVC = SettingsViewController()
      
        settingsVC.onSignOut = {[weak self] in
            guard let strongSelf = self else { return }
            print("sign outt")
            strongSelf.finishFlow?(nil)
        }
        router.push(settingsVC)
    }
}

