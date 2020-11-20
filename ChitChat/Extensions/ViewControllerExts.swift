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
