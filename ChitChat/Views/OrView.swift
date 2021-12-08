//
//  OrView.swift
//  ChitChat
//
//  Created by ty foskey on 12/6/21.
//  Copyright © 2021 ty foskey. All rights reserved.
//

import UIKit
import SnapKit

class OrView: UIView {
    
    let lineView: UIView = {
        let v = UIView()
        v.backgroundColor = .separator
        return v
    }()
    
    let orLabel: UILabel = {
        let label = UILabel()
        label.text = "OR"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .secondaryLabel
        return label
    }()
    
    let blockView: UIView = {
        let v = UIView()
        v.backgroundColor = .systemBackground
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(lineView)
        addSubview(blockView)
        addSubview(orLabel)
        setConstriants()
    }
    
    private func setConstriants() {
        lineView.snp.makeConstraints { make in
            make.leading.equalTo(self).offset(20)
            make.trailing.equalTo(self).offset(-20)
            make.height.equalTo(1)
            make.centerY.equalTo(self)
        }
        
        blockView.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(self)
            make.width.equalTo(50)
            make.height.equalTo(25)
        }
        
        orLabel.snp.makeConstraints { make in
            make.centerY.centerX.equalTo(self)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
