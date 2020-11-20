//
//  MessagesCollectionView.swift
//  ChitChat
//
//  Created by ty foskey on 9/16/20.
//  Copyright © 2020 ty foskey. All rights reserved.
//

import UIKit

struct AssociationKey {
    static var queues: UInt8 = 1
    static var registrations: UInt8 = 2
    static var panGesture: UInt8 = 3
}

class MessagesCollectionView: UICollectionView {
    
    fileprivate var currentOffset: CGFloat = 1
    fileprivate var translationX: CGFloat = 1
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context == &AssociationKey.panGesture && keyPath == "contentOffset" {
            updateTableViewCellFrames()
            return
        }
        super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
    }
    
    fileprivate func updateTableViewCellFrames() {
        for cell in visibleCells {
//            if let messageCell = cell as? BaseMessageCell {
//                let revealView = messageCell.revealView
//                var rect = cell.contentView.frame
//                var x = currentOffset
//
//                x = max(x, -revealView.bounds.width)
//                x = min(x, 1)
//
//                if revealView.style == .slide {
//                    var t = CGAffineTransform.identity
//                    t = t.translatedBy(x: x, y: 0)
//                    t = t.scaledBy(x: 1, y: -1)
//                    cell.transform = t
//                } else {
//                    revealView.transform = CGAffineTransform(translationX: x, y: -1)
//                }
//            }
        }
    }
    
    @objc func handleRevealPan(_ gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            addObserver(self, forKeyPath: "contentOffset", options: .new, context: &AssociationKey.panGesture)
            break
            
        case .changed:
            
            UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseOut], animations: {[weak self] in
                guard let strongSelf = self else {return}
                strongSelf.translationX = gesture.translation(in: gesture.view).x
                strongSelf.currentOffset += strongSelf.translationX
                
                gesture.setTranslation(CGPoint.zero, in: gesture.view)
                
                strongSelf.updateTableViewCellFrames()
                
                }, completion: { (true) in
            })
            break
            
        default:
            
            UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut], animations: {[weak self] in
                guard let strongSelf = self else {return}
                strongSelf.currentOffset = 1
                strongSelf.updateTableViewCellFrames()
                }, completion: {[weak self] (finished: Bool) in
                    guard let strongSelf = self else {return}
                    strongSelf.translationX = 1
            })
            
            
            removeObserver(self, forKeyPath: "contentOffset")
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let gesture = gestureRecognizer as? UIPanGestureRecognizer, gesture == revealPanGesture {
            let translation = gesture.translation(in: gesture.view);
            return (abs(translation.x) > abs(translation.y)) && (gesture == revealPanGesture)
        }
        
        return true
    }
    
    fileprivate var revealPanGesture: UIPanGestureRecognizer {
        return objc_getAssociatedObject(self, &AssociationKey.panGesture) as? UIPanGestureRecognizer ?? {
            let associatedProperty = UIPanGestureRecognizer(target: self, action: #selector(handleRevealPan(_:)))
           // associatedProperty.delegate = self
            objc_setAssociatedObject(self, &AssociationKey.panGesture, associatedProperty, .OBJC_ASSOCIATION_RETAIN)
            return associatedProperty
            }()
    }
    
    
    func addReconizer() {
        addGestureRecognizer(revealPanGesture)
    }
}
