//
//  RevealView.swift
//  ChitChat
//
//  Created by ty foskey on 12/5/21.
//  Copyright © 2021 ty foskey. All rights reserved.
//

import UIKit
import SnapKit

enum RevealStyle {
    case slide
    case over
}

class RevealView: UIView {
    
    var style: RevealStyle = .slide
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.italicSystemFont(ofSize: 11)
        label.textColor = .secondaryLabel
        return label
    }()
    
    var message: MessageViewModel! {
        didSet {
            setView()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(timeLabel)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setView() {
        switch message.isFrom {
        case true: style = .slide
        case false: style = .over
        }
        if message.messageKind == .photo { style = .slide}
        let text = message.isSending ? "Sending..." : message.timeText
        timeLabel.text = text
    }
    
    private func setConstraints() {
        timeLabel.snp.makeConstraints { (make) in
            make.centerX.width.equalTo(self)
            make.bottom.equalTo(self).offset(-20)
        }
    }
}
