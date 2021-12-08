//
//  UserCell.swift
//  ChitChat
//
//  Created by ty foskey on 9/26/20.
//  Copyright © 2020 ty foskey. All rights reserved.
//

import UIKit
import SDWebImage

class UserCell: UICollectionViewCell {
    
    // MARK: - Properties
    let profilePic = UIImageView()
    let nameLabel = UILabel()
   // let numberLabel = UILabel()
    let selectedView = UIView()
    let bottomView = UIView()
    let profilePicHeight: CGFloat = 45
    let selectedViewHeight: CGFloat = 25
    
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
    
    // MARK: - Update Cell
    private func updateCell() {
        nameLabel.text = user.name
        guard let url = URL(string: user.profilePhotoUrl) else { return }
        profilePic.sd_setImage(with: url, completed: nil)
       // numberLabel.text = user.phoneNumber
    }
    
    func setSelectedView(isSelected: Bool) {
        selectedView.backgroundColor = (isSelected == true) ? Constants.colors.secondaryColor : .systemBackground
    }
    
    
    // MARK: - SetUp
    private func setUp() {
        addSubview(profilePic)
        addSubview(nameLabel)
       // addSubview(numberLabel)
        addSubview(selectedView)
        addSubview(bottomView)
        
        profilePic.clipsToBounds = true
        profilePic.layer.cornerRadius = profilePicHeight / 2
        profilePic.backgroundColor = .secondaryLabel
        profilePic.snp.makeConstraints { (make) in
            make.width.height.equalTo(profilePicHeight)
            make.centerY.equalTo(self)
            make.left.equalTo(self).offset(16)
        }
        
        nameLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        nameLabel.numberOfLines = 1
        nameLabel.allowsDefaultTighteningForTruncation = true
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(profilePic.snp.right).offset(8)
            make.centerY.equalTo(profilePic).offset(0)
        }
        
//        numberLabel.font = UIFont.systemFont(ofSize: 12)
//        numberLabel.textColor = .secondaryLabel
//        numberLabel.numberOfLines = 1
//        numberLabel.snp.makeConstraints { (make) in
//            make.left.equalTo(nameLabel)
//            make.top.equalTo(nameLabel.snp.bottom).offset(3)
//        }
        
        selectedView.layer.cornerRadius = selectedViewHeight / 2
        selectedView.layer.borderWidth = 2
        selectedView.layer.borderColor = Constants.colors.secondaryColor.cgColor
        selectedView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.height.width.equalTo(selectedViewHeight)
            make.right.equalTo(self).offset(-16)
        }
        
        bottomView.backgroundColor = UIColor.secondarySystemBackground
        bottomView.snp.makeConstraints { (make) in
            make.bottom.equalTo(self)
            make.left.right.equalTo(self)
            make.height.equalTo(2)
        }
    }
}
