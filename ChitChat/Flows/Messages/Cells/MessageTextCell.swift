//
//  MessageTextCell.swift
//  ChitChat
//
//  Created by ty foskey on 9/21/20.
//  Copyright © 2020 ty foskey. All rights reserved.
//

import UIKit
import SnapKit

class FromMessageTextCell: MessageContentCell {

    let messageCellTextView = MessageFromCellTextView()

//    var messageViewModel: MessageViewModel! {
//        didSet {
//            updateUI()
//            layoutSubviews()
//            layoutIfNeeded()
//        }
//    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(messageCellTextView)

        setConstraints()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateUI() {
        messageCellTextView.messageViewModel = messageViewModel
        layoutSubviews()
        layoutIfNeeded()
    }
    
    private func setConstraints() {
        
        messageCellTextView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }

    }
    
}


class ToMessageTextCell: MessageContentCell {
    
    let messageToCellTextView = MessageToCellTextView()
    
//    var messageViewModel: MessageViewModel! {
//        didSet {
//            updateUI()
//            layoutSubviews()
//            layoutIfNeeded()
//        }
//    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(messageToCellTextView)
        
        setConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateUI() {
        messageToCellTextView.messageViewModel = messageViewModel
        layoutSubviews()
        layoutIfNeeded()
    }
    
    private func setConstraints() {
        messageToCellTextView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }

}
