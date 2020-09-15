//
//  RegisterProfilePicViewController.swift
//  ChitChat
//
//  Created by ty foskey on 9/15/20.
//  Copyright © 2020 ty foskey. All rights reserved.
//

import UIKit
import SnapKit

class RegisterProfilePicViewController: UIViewController {
    
    let registerProfileView = RegisterProfilePicView()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
    }
    
    
    // MARK: - Set View
    
    private func setView() {
        view.backgroundColor = .white
        view.addSubview(registerProfileView)
        registerProfileView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin)
            make.left.right.equalTo(view)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottomMargin)
        }
        registerProfileView.delegate = self
    }
    
    // MARK: - Init
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Register ProfilePic Delegate
extension RegisterProfilePicViewController: RegisterProfilePicDelegate {
    func changePic() {
        print("change pic")
    }
    
    func bottomButtTapped() {
        print("bottom but tapped")
    }
    
}
