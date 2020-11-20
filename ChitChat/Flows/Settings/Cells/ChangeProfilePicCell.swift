//
//  ChangeProfilePicCell.swift
//  ChitChat
//
//  Created by ty foskey on 9/26/20.
//  Copyright © 2020 ty foskey. All rights reserved.
//

import UIKit
import SnapKit

class ChangeProfilePicCell: UICollectionViewCell {
    
    let profilePicImageView = UIImageView()
    let changeButton = UIButton()
    weak var delegate: SettingsDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    private func setUp() {
        addSubview(profilePicImageView)
        addSubview(changeButton)
        
        profilePicImageView.layer.cornerRadius = 130 / 2
        profilePicImageView.backgroundColor = .lightGray
        profilePicImageView.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(16)
            make.height.width.equalTo(130)
            make.centerX.equalTo(self)
        }
        
        changeButton.setTitle("Change Profile Picture", for: .normal)
        changeButton.setTitleColor(UIColor.blue, for: .normal)
        changeButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        changeButton.addTarget(self, action: #selector(changeButtTapped), for: .touchUpInside)
        changeButton.snp.makeConstraints { (make) in
            make.top.equalTo(profilePicImageView.snp.bottom).offset(16)
            make.centerX.equalTo(profilePicImageView)
        }
    }
    
    @objc private func changeButtTapped() {
        delegate?.changeProfilePic()
    }
    
   
}
