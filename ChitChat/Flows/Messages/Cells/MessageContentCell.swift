//
//  MessageContentCell.swift
//  ChitChat
//
//  Created by ty foskey on 9/21/20.
//  Copyright © 2020 ty foskey. All rights reserved.
//

import UIKit
import SnapKit

class MessageContentCell: UICollectionViewCell {
    
    //weak var delegate: MessageCellDelegate?
    
    var messageViewModel: MessageViewModel! {
        didSet {
            updateUI()
        }
    }
    
    func updateUI() {
            
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressed))
        self.addGestureRecognizer(longPressGesture)

    }

    @objc func longPressed() {
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
