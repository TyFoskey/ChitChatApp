//
//  AppCoordinator.swift
//  ChitChat
//
//  Created by ty foskey on 9/10/20.
//  Copyright © 2020 ty foskey. All rights reserved.
//

import UIKit

final class AppCoordinator: BaseCoordinator {
    
    let router: Router
    
    init(router: Router) {
        self.router = router
    }
    
    override func start() {
        runAuthFlow()
    }
    
    private func runAuthFlow() {
        let authCoordinator = AuthCoordinator(router: router, auth: Authentication())
        addChildCoordinator(authCoordinator)
        authCoordinator.start()
        
    }
    
    deinit {
        print("app coordinator deallocated")
    }
    
}
