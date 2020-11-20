//
//  CustomTextView.swift
//  ChitChat
//
//  Created by ty foskey on 9/16/20.
//  Copyright © 2020 ty foskey. All rights reserved.
//

import UIKit

class CustomTextView: UITextView {
    
  //  weak var customPasteDelegate: PasteDelegate?
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(paste(_:)) {
            return true
        } else {
            return super .canPerformAction(action, withSender: sender)
        }
    }
    
    override var canResignFirstResponder: Bool {
        return true
    }
    
    override func paste(_ sender: Any?) {
        //   let data: Data = UIPasteboard.generalPasteboard.dataForPasteboardType("public.png")
        let images = UIPasteboard.general.images
        let hasImages = UIPasteboard.general.hasImages
        if let images = images, hasImages == true {
        //    customPasteDelegate?.paste(with: images)
        } else {
            guard let textString = UIPasteboard.general.string else {print("no image no string"); return}
            let text = NSAttributedString(string: textString)
            let attributedString = self.attributedText.mutableCopy() as! NSMutableAttributedString
            attributedString.replaceCharacters(in: self.selectedRange, with: text)
            self.text = attributedString.string
            self.delegate?.textViewDidChange!(self)
        }
    }
    
    
    
}
