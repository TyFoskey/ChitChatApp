//
//  SingleUserCell.swift
//  ChitChat
//
//  Created by ty foskey on 9/25/20.
//  Copyright © 2020 ty foskey. All rights reserved.
//

import UIKit
import SnapKit

class SingleUserCell: UICollectionViewCell {
    
    // MARK: - Properties
    let profilePic = UIImageView()
    let nameLabel = UILabel()
    let deleteButt = UIButton()
    let profilePicHeight: CGFloat = 60
    let deleteButtHeight: CGFloat = 20
    weak var delegate: SelectedUserDelegate?
    
    var user: Users! {
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
        nameLabel.text = user.name
        
    }
    
    // MARK: - Actions
    @objc private func deleteButtTapped() {
        delegate?.didDeselectUser(user: user)
    }
    
    // MARK: - SetUp
    private func setUp() {
        addSubview(profilePic)
        addSubview(nameLabel)
        addSubview(deleteButt)
        
        profilePic.layer.cornerRadius = profilePicHeight / 2
        profilePic.backgroundColor = .orange
        profilePic.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.centerY.equalTo(self).offset(-8)
            make.height.width.equalTo(profilePicHeight)
        }
        
        nameLabel.textAlignment = .center
        nameLabel.textColor = .lightGray
        nameLabel.font = UIFont.systemFont(ofSize: 14)
        nameLabel.numberOfLines = 2
        nameLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(profilePic)
            make.top.equalTo(profilePic.snp.bottom).offset(4)
            make.left.equalTo(self).offset(5)
            make.right.equalTo(self).offset(-5)
        }
        
        deleteButt.backgroundColor = .red
        deleteButt.layer.cornerRadius = 5
        deleteButt.addTarget(self, action: #selector(deleteButtTapped), for: .touchUpInside)
        deleteButt.snp.makeConstraints { (make) in
            make.height.width.equalTo(deleteButtHeight)
            make.bottom.equalTo(profilePic)
            make.left.equalTo(profilePic.snp.right).offset(-3)
        }
    }
}
