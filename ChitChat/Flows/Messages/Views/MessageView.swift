//
//  MessageView.swift
//  ChitChat
//
//  Created by ty foskey on 9/21/20.
//  Copyright © 2020 ty foskey. All rights reserved.
//

import UIKit
import SnapKit

class MessageView: UIView {
    
    let bubbleView: UIView = {
        let bubble = UIView()
        bubble.backgroundColor = .systemBackground
        bubble.layer.cornerRadius = 18
        bubble.layer.masksToBounds = true
        bubble.translatesAutoresizingMaskIntoConstraints = false
        return bubble
    }()
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = UIColor.label
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var gradientLayer = createGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setContraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setContraints() {
        addSubview(bubbleView)
        addSubview(messageLabel)
        
        bubbleView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    
        messageLabel.snp.makeConstraints { (make) in
            make.top.equalTo(bubbleView).offset(10)
            make.left.equalTo(bubbleView).offset(16)
            make.right.equalTo(bubbleView).offset(-16)
            make.bottom.equalTo(bubbleView).offset(-10)
        }
        
    }
    
    
    override func layoutSubviews() {
//        gradientLayer.frame = bubbleView.frame
//        bubbleView.layer.insertSublayer(gradientLayer, at: 0)
        self.layer.shadowPath = UIBezierPath(roundedRect: bubbleView.bounds, cornerRadius: 18).cgPath
    }
    
    
    private func createGradientLayer() -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [Constants.colors.primaryColor.withAlphaComponent(0.6).cgColor, Constants.colors.secondaryColor.withAlphaComponent(0.5).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.locations = [-0.2, 1.2]
        gradientLayer.cornerRadius = 18
        return gradientLayer
    }
}
