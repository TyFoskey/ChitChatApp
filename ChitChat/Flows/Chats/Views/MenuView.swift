//
//  MenuView.swift
//  ChitChat
//
//  Created by ty foskey on 9/21/20.
//  Copyright © 2020 ty foskey. All rights reserved.
//

import UIKit

class MenuView: UIView {
    
    // MARK: - Properties
    let newConvoButt = UIButton()
    let settingsButt = UIButton()
    let addNewUserButt = UIButton()
    
    let imageName = "plus.circle.fill"
    weak var delegate: MenuViewDelegate?
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Set up
    private func setUp() {
        //backgroundColor = .cyan
        addSubview(newConvoButt)
       // addSubview(settingsButt)
       // addSubview(addNewUserButt)
        setConstraints()
    }
    
    private func setConstraints() {
       // newConvoButt.backgroundColor = .red
        let imageSymbolConfiguration = UIImage.SymbolConfiguration(pointSize: 100, weight: .semibold)
        let image = UIImage(systemName: imageName, withConfiguration: imageSymbolConfiguration)
//        newConvoButt.backgroundColor = .red
        newConvoButt.setImage(image, for: .normal)
        newConvoButt.layer.cornerRadius = 50
        newConvoButt.addTarget(self, action: #selector(newConvoButtTapped), for: .touchUpInside)
        newConvoButt.snp.makeConstraints { (make) in
           // make.centerX.centerY.equalTo(self)
            make.trailing.equalTo(self).offset(-20)
            make.height.width.equalTo(100)
        }
        
//        settingsButt.backgroundColor = .orange
//        settingsButt.layer.cornerRadius = 45 / 2
//        settingsButt.addTarget(self, action: #selector(settingsButtTapped), for: .touchUpInside)
//        settingsButt.snp.makeConstraints { (make) in
//            make.centerY.equalTo(newConvoButt).offset(6)
//            make.height.width.equalTo(45)
//            make.left.equalTo(newConvoButt.snp.right).offset(30)
//        }
//
//        addNewUserButt.backgroundColor = .green
//        addNewUserButt.layer.cornerRadius = 45 / 2
//        addNewUserButt.addTarget(self, action: #selector(addUserButtTapped), for: .touchUpInside)
//        addNewUserButt.snp.makeConstraints { (make) in
//            make.centerY.height.width.equalTo(settingsButt)
//            make.right.equalTo(newConvoButt.snp.left).offset(-30)
//        }
    }
    
    // MARK: - Actions
    @objc private func newConvoButtTapped() {
        delegate?.goToNewMesssages()
    }
    
    @objc private func addUserButtTapped() {
        delegate?.addNewUser()
    }
    
    @objc private func settingsButtTapped() {
        delegate?.goToSettings()
    }
}
