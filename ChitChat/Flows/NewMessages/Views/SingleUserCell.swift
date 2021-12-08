//
//  SingleUserCell.swift
//  ChitChat
//
//  Created by ty foskey on 9/25/20.
//  Copyright © 2020 ty foskey. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage

class SingleUserCell: UICollectionViewCell {
    
    // MARK: - Properties
    let profilePic = UIImageView()
    let nameLabel = UILabel()
    let deleteButt = UIButton()
    let profilePicHeight: CGFloat = 60
    let deleteButtHeight: CGFloat = 20
    weak var delegate: SelectedUserDelegate?
    let imageName = "minus.circle"
    
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
        guard let url = URL(string: user.profilePhotoUrl) else { return }
        profilePic.sd_setImage(with: url, completed: nil)
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
        
        profilePic.clipsToBounds = true
        profilePic.layer.cornerRadius = profilePicHeight / 2
        profilePic.backgroundColor = .secondaryLabel
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
        
        let imageSymbolConfiguration = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold)
        let image = UIImage(systemName: imageName, withConfiguration: imageSymbolConfiguration)
        deleteButt.setImage(image, for: .normal)
        deleteButt.tintColor = .red
        deleteButt.layer.cornerRadius = 5
        deleteButt.addTarget(self, action: #selector(deleteButtTapped), for: .touchUpInside)
        deleteButt.snp.makeConstraints { (make) in
            make.height.width.equalTo(deleteButtHeight)
            make.bottom.equalTo(profilePic)
            make.left.equalTo(profilePic.snp.right).offset(-10)
        }
    }
}
