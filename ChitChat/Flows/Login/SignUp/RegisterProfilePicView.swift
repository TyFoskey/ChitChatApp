//
//  RegisterProfilePicView.swift
//  ChitChat
//
//  Created by ty foskey on 9/15/20.
//  Copyright © 2020 ty foskey. All rights reserved.
//

import UIKit
import SnapKit

class RegisterProfilePicView: UIView {
    
    // MARK: - Properties
    let topLabel = UILabel()
    let titleLabelMaskView = UIView()
    let profilePicImageView = UIImageView()
    let changePicButt = UIButton()
    let bottomButt = LoginButt()
    let titleText = "Add a profile picture"
    let profilePicHeight: CGFloat = 200
    let buttonHeight: CGFloat = 50
    let buttonCornerRadius: CGFloat = 8
    weak var delegate: RegisterProfilePicDelegate?
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabelMaskView)
        addSubview(topLabel)
        addSubview(profilePicImageView)
        addSubview(changePicButt)
        addSubview(bottomButt)
        setUp()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabelMaskView.addGradientBackground(colors: Constants.colors.colorGradients)
        titleLabelMaskView.mask = topLabel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    @objc private func changePic() {
        delegate?.changePic()
    }
    
    @objc private func bottomButtTapped() {
        delegate?.bottomButtTapped()
    }
    
    // MARK: - Set Up
    
    private func setUp() {
        backgroundColor = .white
        topLabel.textAlignment = .center
        topLabel.text = titleText
        topLabel.font = UIFont.systemFont(ofSize: 34, weight: .semibold) //26
        topLabel.numberOfLines = 0
        topLabel.layer.shadowColor = UIColor.lightGray.cgColor
        topLabel.layer.shadowOffset = CGSize(width: 2, height: 2)
        topLabel.layer.shadowRadius = 2
        topLabel.layer.shadowOpacity = 0.25
       
        profilePicImageView.contentMode = .scaleAspectFill
        profilePicImageView.image = UIImage(named: "emptyProfilePic")
        //profilePicImageView.backgroundColor = .lightGray
        profilePicImageView.layer.cornerRadius = profilePicHeight / 2
        profilePicImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changePic)))
     
        changePicButt.setTitle("Add Profile Photo", for: .normal)
        changePicButt.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        changePicButt.setTitleColor(Constants.colors.buttonBlue, for: .normal)
        changePicButt.addTarget(self, action: #selector(changePic), for: .touchUpInside)
       
        bottomButt.setTitle("Sign Up", for: .normal)
        bottomButt.isEnabled = false
        bottomButt.backgroundColor = .gray
        bottomButt.addTarget(self, action: #selector(bottomButtTapped), for: .touchUpInside)
        
        setConstraints()
    }
    
    private func setConstraints() {
        topLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(40)
            make.left.equalTo(self).offset(34)
            make.right.equalTo(self).offset(-34)
        }
        
        titleLabelMaskView.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(0)
            make.leading.equalTo(self).offset(0)
            make.trailing.equalTo(self)
            make.bottom.equalTo(profilePicImageView.snp.top)
        }
        
        profilePicImageView.snp.makeConstraints { (make) in
            make.top.equalTo(topLabel.snp.bottom).offset(40)
            make.height.width.equalTo(profilePicHeight)
            make.centerX.equalTo(self)
        }
        
        changePicButt.snp.makeConstraints { (make) in
            make.top.equalTo(profilePicImageView.snp.bottom).offset(20)
            make.centerX.equalTo(profilePicImageView)
        }
        
        bottomButt.snp.makeConstraints { (make) in
            make.bottom.equalTo(self).offset(-20)
            make.left.equalTo(self).offset(30)
            make.right.equalTo(self).offset(-30)
            make.height.equalTo(buttonHeight)
        }
    }
    
}
