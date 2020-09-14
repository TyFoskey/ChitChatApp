//
//  CircularSpinner.swift
//  ChitChat
//
//  Created by ty foskey on 9/14/20.
//  Copyright © 2020 ty foskey. All rights reserved.
//

import UIKit
import SnapKit

class CircularSpinner: UIView {
    
    // MARK: - Properties
    var width: CGFloat
    let circleView = UIView()
    weak var customSuperview: UIView? = nil
    
    private var backgroundCircleLayer = CAShapeLayer()
    private var progressCircleLayer = CAShapeLayer()
    
    var duration: Double = 1.5
    
    fileprivate var startAngle: CGFloat {
         return CGFloat(Double.pi / 2)
     }
     fileprivate var endAngle: CGFloat {
         return 5 * CGFloat(Double.pi / 2)
     }
     fileprivate var arcCenter: CGPoint {
         return convert(circleView.center, to: circleView)
     }
     fileprivate var arcRadius: CGFloat {
         return (min(bounds.width, bounds.height) * 0.8) / 2
     }

    
    fileprivate var oldStrokeEnd: Float?
    fileprivate var backingValue: Float = 0
    var value: Float {
        get {
            return backingValue
        }
        set {
            backingValue = min(1, max(0, newValue))
        }
    }
    
    var trackLineWidth: CGFloat = 6
    private lazy var lineWidth = trackLineWidth

    var trackBgColor = UIColor(red: 238.0/255, green: 238.0/255, blue: 238.0/255, alpha: 1)
    private lazy var bgColor = trackBgColor

    var trackPgColor = UIColor(red: 47.0/255, green: 177.0/255, blue: 254.0/255, alpha: 1)
    private lazy var pgColor = trackPgColor

    
    
    // MARK: - Init
    init(width: CGFloat, frame: CGRect) {
        self.width = width
        super.init(frame: frame)
        setUp()
        configure()
    }

    
    private func setUp() {
        addSubview(circleView)
        circleView.snp.makeConstraints { (make) in
            make.centerX.centerY.equalTo(self)
            make.width.height.equalTo(width)
        }
    }
    
    
    // MARK: - Methods
    fileprivate func containerView() -> UIView? {
        return customSuperview ?? UIApplication.shared.keyWindow
    }
    
    @objc func updateFrame() {
        if let containerView = containerView() {
            self.frame = containerView.bounds
        }
    }
    
    // MARK: - drawing methods
    override func draw(_ rect: CGRect) {
         backgroundCircleLayer.path = getCirclePath()
         progressCircleLayer.path = getCirclePath()
         updateFrame()
     }
     
     fileprivate func getCirclePath() -> CGPath {
         return UIBezierPath(arcCenter: arcCenter, radius: arcRadius, startAngle: startAngle, endAngle: endAngle, clockwise: true).cgPath
     }
    
    
    // MARK: - configure
    fileprivate func configure() {
        backgroundColor = UIColor.clear

        configureCircleView()
        configureBackgroundLayer()
        configureProgressLayer()
        startAnimation()
    }
    
    fileprivate func configureCircleView() {
        width = arcRadius * 2
    }
    
    fileprivate func configureBackgroundLayer() {
        circleView.layer.addSublayer(backgroundCircleLayer)
        appearanceBackgroundLayer()
    }
    
    fileprivate func configureProgressLayer() {
        circleView.layer.addSublayer(progressCircleLayer)
        appearanceProgressLayer()
    }
    
    
    // MARK: - appearance
    fileprivate func appearanceBackgroundLayer() {
        backgroundCircleLayer.lineWidth = lineWidth
        backgroundCircleLayer.fillColor = UIColor.clear.cgColor
        backgroundCircleLayer.strokeColor = bgColor.cgColor
        backgroundCircleLayer.lineCap = CAShapeLayerLineCap.round
    }
    
    fileprivate func appearanceProgressLayer() {
        progressCircleLayer.lineWidth = lineWidth
        progressCircleLayer.fillColor = UIColor.clear.cgColor
        progressCircleLayer.strokeColor = pgColor.cgColor
        progressCircleLayer.lineCap = CAShapeLayerLineCap.round
    }
    
    
    // MARK: - Animation
    fileprivate func generateAnimation() -> CAAnimationGroup {
        let headAnimation = CABasicAnimation(keyPath: "strokeStart")
        headAnimation.beginTime = duration / 3
        headAnimation.fromValue = 0
        headAnimation.toValue = 1
        headAnimation.duration = duration / 1.5
        headAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        
        let tailAnimation = CABasicAnimation(keyPath: "strokeEnd")
        tailAnimation.fromValue = 0
        tailAnimation.toValue = 1
        tailAnimation.duration = duration / 1.5
        tailAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        
        let groupAnimation = CAAnimationGroup()
        groupAnimation.duration = duration
        groupAnimation.repeatCount = Float.infinity
        groupAnimation.animations = [headAnimation, tailAnimation]
        return groupAnimation
    }
    
    fileprivate func generateRotationAnimation() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.fromValue = 0
        animation.toValue = 2 * Double.pi
        animation.duration = duration
        animation.repeatCount = Float.infinity
        return animation
    }
    
    fileprivate func startAnimation() {
        progressCircleLayer.add(generateAnimation(), forKey: "strokeLineAnimation")
        circleView.layer.add(generateRotationAnimation(), forKey: "rotationAnimation")
    }
    
    fileprivate func stopAnimation() {
        progressCircleLayer.removeAllAnimations()
        circleView.layer.removeAllAnimations()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: - API
extension CircularSpinner {
    
    
    func show() {
        UIView.animate(withDuration: 0.33, delay: 0, options: .curveEaseOut, animations: {
         //   spinner.alpha = 1
        }, completion: nil)
    }
    
    
}
