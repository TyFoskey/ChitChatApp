//
//  AppCoordinator.swift
//  ChitChat
//
//  Created by ty foskey on 9/10/20.
//  Copyright © 2020 ty foskey. All rights reserved.
//

import UIKit
import FirebaseAuth

class AppCoordinator: BaseCoordinator {
    
    let router: Router
    var authRouter: Router?
    var mainRouter: Router?
    
    init(router: Router) {
        self.router = router
    }
    
    override func start() {
        if Auth.auth().currentUser != nil {
            runMainFlow()
        } else {
            runAuthFlow()
        }
    }
    
    private func runMainFlow() {
        //mainRouter = Router(navigationController: UINavigationController())
        let mainCoordinator = MainCoordinator(router: router)
        
        mainCoordinator.finishFlow = {[weak self, weak mainCoordinator] _ in
            guard let strongSelf = self else { return }
          // strongSelf.mainRouter = nil
            strongSelf.router.popToRootModule(animated: false)
            strongSelf.removeChildCoordinator(mainCoordinator)
            strongSelf.runAuthFlow()
        }
        addChildCoordinator(mainCoordinator)
        mainCoordinator.start()
    }
    
    private func runAuthFlow() {
        let authCoordinator = AuthCoordinator(router: router, auth: Authentication())
        authCoordinator.finishFlow = {[weak self, weak authCoordinator] _ in
            guard let strongSelf = self else { return }
            strongSelf.router.popToRootModule(animated: false)
            strongSelf.removeChildCoordinator(authCoordinator)
            strongSelf.runMainFlow()
        }
        addChildCoordinator(authCoordinator)
        authCoordinator.start()
        
    }
    
    deinit {
        print("app coordinator deallocated")
    }
    
}
