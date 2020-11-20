//
//  MultiUsersCell.swift
//  ChitChat
//
//  Created by ty foskey on 9/25/20.
//  Copyright © 2020 ty foskey. All rights reserved.
//

import UIKit
import SnapKit

class MultiUsersCell: UICollectionViewCell {
    
    // MARK: - Properties
    let profilePic1 = UIImageView()
    let profilePic2 = UIImageView()
    let nameLabel = UILabel()
    let deleteButt = UIButton()
    let profilePicHeight: CGFloat = 40
    let profilePic2Height: CGFloat = 30
    
    var selectedUsers: SelectedUsers! {
        didSet {
            updateCell()
        }
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Update
    private func updateCell() {
        nameLabel.text = selectedUsers.nameTitleText
        profilePic1.backgroundColor = .orange
        profilePic2.backgroundColor = .purple
    }
    
    // MARK: - SetUp
    private func setUp() {
        addSubview(profilePic1)
        addSubview(profilePic2)
        addSubview(nameLabel)
        addSubview(deleteButt)
        
        profilePic1.layer.cornerRadius = profilePicHeight / 2
        profilePic1.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(5)
            make.width.height.equalTo(profilePicHeight)
            make.top.equalTo(self).offset(20)
        }
        
        profilePic2.layer.cornerRadius = profilePic1.layer.cornerRadius
        profilePic2.snp.makeConstraints { (make) in
            make.height.width.equalTo(profilePic2Height)
            make.top.equalTo(profilePic1).offset(-29)
            make.left.equalTo(profilePic1).offset(-18)
        }
        
        nameLabel.textColor = .lightGray
        nameLabel.font = UIFont.systemFont(ofSize: 14)
        nameLabel.textAlignment = .center
        nameLabel.numberOfLines = 2
        nameLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.left.equalTo(self).offset(5)
            make.right.equalTo(self).offset(-5)
            make.top.equalTo(profilePic2.snp.bottom).offset(1.5)
        }
        
        deleteButt.backgroundColor = .red
        deleteButt.snp.makeConstraints { (make) in
            make.width.height.equalTo(20)
            make.bottom.equalTo(profilePic2)
            make.left.equalTo(profilePic2.snp.right).offset(3)
        }
    }
}
