//
//  EmptyChatsView.swift
//  ChitChat
//
//  Created by ty foskey on 9/17/20.
//  Copyright © 2020 ty foskey. All rights reserved.
//

import UIKit
import SnapKit

class EmptyChatsView: UIView {
    
    let emptyLabel = UILabel()
    let startChatButt = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        emptyLabel.text = "No Chats yet"
        addSubview(emptyLabel)
        emptyLabel.snp.makeConstraints { (make) in
            make.centerX.centerY.equalTo(self)
        }
        
        startChatButt.setTitle("Start a Chat", for: .normal)
        startChatButt.setTitleColor(Constants.colors.secondaryColor, for: .normal)
        addSubview(startChatButt)
        startChatButt.snp.makeConstraints { (make) in
            make.top.equalTo(emptyLabel.snp.bottom).offset(16)
            make.centerX.equalTo(self)
        }

    }
    
    
}
