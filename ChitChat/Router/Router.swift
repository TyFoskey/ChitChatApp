//
//  Router.swift
//  ChitChat
//
//  Created by ty foskey on 9/10/20.
//  Copyright © 2020 ty foskey. All rights reserved.
//

import UIKit

final class Router: NSObject, RouterType {
    
    weak var navigationController: UINavigationController?
    private var completions: [UIViewController : () -> Void]
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        completions = [:]
        
        super.init()
        self.navigationController?.delegate = self
    }
    
    
    func present(_ module: Presentable?) {
        present(module, animated: true)
    }
    
    func present(_ module: Presentable?, animated: Bool) {
        guard let controller = module?.toPresent() else {return}
        navigationController?.present(controller, animated: animated, completion: nil)
    }
    
    func push(_ module: Presentable?) {
        push(module, animated: true)
    }
    
    func push(_ module: Presentable?, hideBottomBar: Bool) {
        push(module, animated: true, hideBottomBar: hideBottomBar, completion: nil)
    }
    
    func push(_ module: Presentable?, animated: Bool) {
        push(module, animated: animated, completion: nil)
    }
    
    func push(_ module: Presentable?, animated: Bool, completion: (() -> Void)?) {
        push(module, animated: animated, hideBottomBar: false, completion: completion)
    }
    
    func push(_ module: Presentable?, animated: Bool, hideBottomBar: Bool, completion: (() -> Void)?) {
        guard let controller = module?.toPresent(), (controller is UINavigationController == false) else { assertionFailure("Deprectated push UINavigaitonController."); return }
        
        if let completion = completion {
            completions[controller] = completion
        }
        
        controller.hidesBottomBarWhenPushed = hideBottomBar
        navigationController?.pushViewController(controller, animated: animated)
    }
    
    func popModule() {
        popModule(animated: true)
    }
    
    func popModule(animated: Bool) {
        if let controller = navigationController?.popViewController(animated: animated) {
            runCompletion(for: controller)
        }
    }
    
    func dismissModule() {
        dismissModule(animated: true, completion: nil)
    }
    
    func dismissModule(animated: Bool, completion: (() -> Void)?) {
        navigationController?.dismiss(animated: animated, completion: completion)
    }
    
    func setRootModule(_ module: Presentable?) {
        setRootModule(module, hideBar: false)
    }
    
    func setRootModule(_ module: Presentable?, hideBar: Bool) {
        guard let controller = module?.toPresent() else { return }
        navigationController?.setViewControllers([controller], animated: false)
        navigationController?.isNavigationBarHidden = hideBar
    }
    
    func setRootModule(_ module: Presentable?, hideBorderLine: Bool) {
        guard let controller = module?.toPresent() else { return }
        navigationController?.setViewControllers([controller], animated: false)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func popToRootModule(animated: Bool) {
        if let controllers = navigationController?.popToRootViewController(animated: animated) {
            controllers.forEach { controller in
                runCompletion(for: controller)
            }
        }
    }
    
    func toPresent() -> UIViewController? {
        return navigationController
    }
    
    private func runCompletion(for controller: UIViewController) {
        guard let completion = completions[controller] else {return}
        completion()
        completions.removeValue(forKey: controller)
    }
    
    
    
    
}

extension Router: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let poppingViewController = navigationController.transitionCoordinator?.viewController(forKey: .from), !navigationController.viewControllers.contains(poppingViewController) else {return}
        
        runCompletion(for: poppingViewController)
    }
}
