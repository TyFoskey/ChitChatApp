//
//  TextFieldCell.swift
//  ChitChat
//
//  Created by ty foskey on 9/26/20.
//  Copyright © 2020 ty foskey. All rights reserved.
//

import UIKit

class TextFieldCell: UICollectionViewCell {
    
    let textField = UITextField()
    let topView = UIView()
    let bottomView = UIView()
    let wordCountLabel = UILabel()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    private func setUp() {
        addSubview(topView)
        addSubview(bottomView)
        addSubview(textField)
        addSubview(wordCountLabel)
        
        topView.backgroundColor = UIColor.groupTableViewBackground
        topView.snp.makeConstraints { (make) in
            make.top.right.left.equalTo(self)
            make.height.equalTo(1)
        }
        
        bottomView.backgroundColor = topView.backgroundColor
        bottomView.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(topView)
            make.bottom.equalTo(self)
        }
        
        textField.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        textField.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(32)
            make.right.equalTo(self).offset(-38)
            make.top.equalTo(self).offset(8)
            make.bottom.equalTo(self).offset(-2)
            
        }
        
        wordCountLabel.font = UIFont.systemFont(ofSize: 9, weight: .medium)
        wordCountLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(textField)
            make.right.equalTo(self).offset(-12)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
