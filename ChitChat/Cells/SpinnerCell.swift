//
//  SpinnerCell.swift
//  ChitChat
//
//  Created by ty foskey on 12/5/21.
//  Copyright © 2021 ty foskey. All rights reserved.
//

import UIKit
import SnapKit

final class SpinnerCell: UICollectionViewCell {
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .medium)
        self.contentView.addSubview(view)
        return view
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let bounds = contentView.bounds
        activityIndicator.center = CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
