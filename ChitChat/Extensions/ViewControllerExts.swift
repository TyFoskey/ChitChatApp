//
//  ViewController.swift
//  ChitChat
//
//  Created by ty foskey on 9/22/20.
//  Copyright © 2020 ty foskey. All rights reserved.
//

import UIKit

extension UIViewController {
        
    func setUpToHideKeyboardOnTapOnView() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
              target: self,
              action: #selector(UIViewController.dismissKeyboard))
          
          tap.cancelsTouchesInView = false
        //  tap.delegate = self
          view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UIViewController: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        // Don't handle button taps
        return !(touch.view is UIButton)
    }
}

extension UIViewController {
    func addCustomBackButton(with tintColor: UIColor = .white) {
        let backButton = BackButton(frame: .zero)
        backButton.tintColor = tintColor
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        view.addSubview(backButton)
        backButton.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.equalTo(view).offset(12)
            make.height.width.equalTo(50)
            
        }
    }
    
    @objc private func backTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}
