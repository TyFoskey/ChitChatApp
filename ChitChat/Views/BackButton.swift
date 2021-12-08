//
//  BackButton.swift
//  ChitChat
//
//  Created by ty foskey on 11/23/21.
//  Copyright © 2021 ty foskey. All rights reserved.
//

import UIKit

class BackButton: UIButton {
    
    private let imageName = "chevron.left"
    
    init(frame: CGRect, pointSize: CGFloat? = nil) {
        super.init(frame: frame)
        let imageSymbolConfiguration = UIImage.SymbolConfiguration(pointSize: pointSize ?? 20, weight: .semibold)
        let image = UIImage(systemName: imageName, withConfiguration: imageSymbolConfiguration)
        self.setImage(image, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
