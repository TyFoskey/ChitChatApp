//
//  LoginButt.swift
//  ChitChat
//
//  Created by ty foskey on 9/11/20.
//  Copyright © 2020 ty foskey. All rights reserved.
//

import UIKit

class LoginButt: UIButton {
    
    let colorGradients = Constants.colors.colorGradients
    
    lazy var lineGradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colorGradients
        gradient.type = .axial
        gradient.startPoint = .init(x: 0, y: 1)
        gradient.endPoint = .init(x: 1, y: 0)
        return gradient
     }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        setTitle("Next", for: .normal)
        setTitleColor(.white, for: .normal)
        backgroundColor = .lightGray
        layer.cornerRadius = 10
        titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        isEnabled = false
    }
    
    func isValid() {
        addGradientBackground(colors: colorGradients, cornerRadius: 10, gradientType: .axial, startPoint: .init(x: 0, y: 1), endPoint: .init(x: 1, y: 0), locations: nil)
        layer.shadowOpacity = 0.2
        layer.shadowColor = Constants.colors.primaryColor.cgColor
        layer.shadowOffset = CGSize(width: 4, height: 4)
        layer.shadowRadius = 3
        isEnabled = true
    }
    
    func isNotValid() {
        isEnabled = false
        layer.shadowColor = UIColor.clear.cgColor
        if let count = layer.sublayers?.count, count > 0 {
            layer.sublayers?.removeFirst()
        }
        backgroundColor = .lightGray
    }
    
}
