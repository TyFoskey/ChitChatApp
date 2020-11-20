//
//  RegisterCompletedView.swift
//  ChitChat
//
//  Created by ty foskey on 9/16/20.
//  Copyright © 2020 ty foskey. All rights reserved.
//

import UIKit
import SnapKit

class RegisterCompletedView: UIView {
    
    // MARK: - Properties
    let statusLabel = UILabel()
    let imageView = UIImageView()
    let bottomView = UIView()
    let bottomLabel = UILabel()
    let bottomButt = UIButton()
    let backgroundLayer = CAShapeLayer()
    let circleSpinner = CircularSpinner(width: 250, frame: .zero)
    let loadingLabel = UILabel()
    weak var delegate: RegisterCompletedViewDelegate?

    
    // MARK: - View Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setUp()
        setUpBottomView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let circularPath = UIBezierPath(arcCenter: .zero,
                                        radius: 300 / 2,
                                        startAngle: 0,
                                        endAngle: 2 * CGFloat.pi,
                                        clockwise: true)
        
        backgroundLayer.path = circularPath.cgPath
        backgroundLayer.frame = CGRect(origin: CGPoint(x: self.center.x,
                                                       y: self.center.y - 30),
                                       size: CGSize(width: 290,
                                                    height: 290))
        
    }
    
    
    // MARK: - Set Up
    private func setUp() {
        setupShapes()
        self.addSubview(imageView)
        self.addSubview(bottomView)
        self.addSubview(statusLabel)
        self.addSubview(circleSpinner)
        self.addSubview(loadingLabel)
        
        statusLabel.text = "Congratulations!!!"
        statusLabel.textColor = Constants.colors.secondaryColor
        statusLabel.font = UIFont.systemFont(ofSize: 40, weight: .semibold)
        statusLabel.layer.shadowOpacity = 0.2
        statusLabel.layer.shadowColor = UIColor.gray.cgColor
        statusLabel.layer.shadowOffset = CGSize(width: 4, height: 3)
        statusLabel.layer.shadowRadius = 3
        
        statusLabel.isHidden = true
        statusLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(130)
            make.centerX.equalTo(self)
        }
        
        imageView.isHidden = true
        imageView.image = UIImage(named: "sendCheckBig")
        imageView.layer.cornerRadius = 250 / 2
        imageView.contentMode = .scaleAspectFill

        imageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.centerY.equalTo(self).offset(-30)
            make.height.width.equalTo(250)
        }
        
        bottomView.backgroundColor = .white
        bottomView.layer.masksToBounds = true
        bottomView.snp.makeConstraints { (make) in
            make.right.left.bottom.equalTo(self)
            make.height.equalTo(200)
        }
        
        circleSpinner.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.centerY.equalTo(self).offset(-30)
            make.height.width.equalTo(250)
        }
        
        loadingLabel.text = "Signing up..."
        loadingLabel.textAlignment = .center
        loadingLabel.textColor = .gray
        loadingLabel.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        loadingLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(circleSpinner.snp.top).offset(-16)
            make.centerX.equalTo(self)
        }
    }
    
    private func setUpBottomView() {
        bottomView.addSubview(bottomLabel)
        bottomView.addSubview(bottomButt)
        
        bottomLabel.text = "You successfuly signed up \n Now you can start chatting with your friends"
        bottomLabel.numberOfLines = 0
        bottomLabel.textColor = UIColor.gray
        bottomLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        bottomLabel.textAlignment = .center
        bottomLabel.isHidden = true
        bottomLabel.snp.makeConstraints { (make) in
            make.top.equalTo(bottomButt.snp.top).offset(-80)
            make.centerX.equalTo(self)
            make.width.equalTo(300)
        }
        
        bottomButt.setTitle("Let's get started", for: .normal)
        bottomButt.backgroundColor = Constants.colors.secondaryColor
        bottomButt.layer.cornerRadius = 10
        bottomButt.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        bottomButt.isHidden = true
        bottomButt.layer.shadowOpacity = 0.2
        bottomButt.layer.shadowColor = UIColor.gray.cgColor
        bottomButt.layer.shadowOffset = CGSize(width: 4, height: 3)
        bottomButt.layer.shadowRadius = 3
        bottomButt.addTarget(self, action: #selector(bottomButtTapped), for: .touchUpInside)
        bottomButt.snp.makeConstraints { (make) in
            make.bottom.equalTo(self).offset(-8)
            make.left.equalTo(self).offset(30)
            make.right.equalTo(self).offset(-30)
            make.height.equalTo(60)
        }
        
    }
        
    // MARK: - Pulsating Implementation
    private func setupShapes() {
        backgroundLayer.lineWidth = 10
        backgroundLayer.fillColor = UIColor.clear.cgColor
        backgroundLayer.lineCap = .round
        self.layer.addSublayer(backgroundLayer)
    }
    
    // MARK: - Actions
    @objc private func bottomButtTapped() {
        delegate?.bottomButtTapped()
    }
    
}


