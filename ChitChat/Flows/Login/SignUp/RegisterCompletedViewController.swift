//
//  RegisterCompletedViewController.swift
//  ChitChat
//
//  Created by ty foskey on 9/16/20.
//  Copyright © 2020 ty foskey. All rights reserved.
//

import UIKit
import SnapKit

class RegisterCompletedViewController: UIViewController {
    
    // MARK: - Properties
    var registerCompletedView = RegisterCompletedView()
    var onBottomButtTap: (() -> Void)?
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(registerCompletedView)
        registerCompletedView.snp.makeConstraints { (make) in
            make.top.equalTo(view)
            make.left.right.equalTo(view)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottomMargin)
        }
        registerCompletedView.bottomButt.addTarget(self, action: #selector(bottomButtTapped), for: .touchUpInside)
        unhideButtonButt()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.barStyle = .black
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Private functions
    @objc private func bottomButtTapped() {
        onBottomButtTap?()
    }
    
    
    private func unhideButtonButt() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            guard let strongSelf = self else { return }
            
            UIView.transition(with: strongSelf.registerCompletedView.bottomButt,
                              duration: 0.8,
                              options: .transitionCrossDissolve,
                              animations: {
                                
                                strongSelf.registerCompletedView.bottomButt.isHidden = false
                                
            }, completion: nil)
        }
    }
    
}
