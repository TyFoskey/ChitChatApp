//
//  BaseCoordinator.swift
//  ChitChat
//
//  Created by ty foskey on 9/10/20.
//  Copyright © 2020 ty foskey. All rights reserved.
//

import Foundation

class BaseCoordinator: NSObject, Coordinator {
    
    var childCoordinators: [Coordinator] = []
    
    func start() {
        fatalError("Children coordinators should implement `start`.")
    }
    
    func addChildCoordinator(_ coordinator: Coordinator) {
        guard !childCoordinators.contains(where: { $0 === coordinator }) else { return }
        childCoordinators.append(coordinator)
    }
    
    func removeChildCoordinator(_  coordinator: Coordinator?) {
        guard childCoordinators.isEmpty == false, let coordinator = coordinator else { return }
        
        if let coordinator = coordinator as? BaseCoordinator, !coordinator.childCoordinators.isEmpty {
            coordinator.childCoordinators.filter({ $0 !== coordinator })
                .forEach({ coordinator.removeChildCoordinator($0) })
        }
        
        for (index, element) in childCoordinators.enumerated() where element === coordinator {
            childCoordinators.remove(at: index)
            break
        }
    }
    
}
