//
//  SettingsView.swift
//  ChitChat
//
//  Created by ty foskey on 9/26/20.
//  Copyright © 2020 ty foskey. All rights reserved.
//

import UIKit

class SettingsView: UIView {
    // MARK: - Properties
    lazy var collectionView: UICollectionView = {
          let layout = UICollectionViewFlowLayout()
          let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
          collection.backgroundColor = .white
          return collection
      }()
      
      let signOutButt = UIButton()
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        signOutButt.addGradientBackground(colors: Constants.colors.colorGradients)
    }
    
    // MARK: - Set Up
    private func setUp() {
        addSubview(collectionView)
        addSubview(signOutButt)
        
        collectionView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self)
            make.bottom.equalTo(signOutButt.snp.top)
        }
        
        signOutButt.setTitle("Sign Out", for: .normal)
        signOutButt.setTitleColor(.white, for: .normal)
        signOutButt.snp.makeConstraints { (make) in
            make.bottom.left.right.equalTo(self)
            make.height.equalTo(50)
        }
    }
}
