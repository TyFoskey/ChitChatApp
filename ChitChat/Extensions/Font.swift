//
//  Font.swift
//  ChitChat
//
//  Created by ty foskey on 9/15/20.
//  Copyright © 2020 ty foskey. All rights reserved.
//

import UIKit

extension UILabel: ChangableFont {
    
    func getFont() -> UIFont? {
        return font
    }
}

extension UITextField: ChangableFont {
    
    func getFont() -> UIFont? {
        return font
    }
}

extension ChangableFont {
    
    var rangedAttributes: [RangedAttributes] {
        guard let attributedText = attributedText else {
            return []
        }
        var rangedAttributes: [RangedAttributes] = []
        let fullRange = NSRange(
            location: 0,
            length: attributedText.string.count
        )
        attributedText.enumerateAttributes(
            in: fullRange,
            options: []
        ) { (attributes, range, stop) in
            guard range != fullRange, !attributes.isEmpty else { return }
            rangedAttributes.append(RangedAttributes(attributes, inRange: range))
        }
        return rangedAttributes
    }
    
    func changeFont(ofText text: String, with font: UIFont) {
        guard let range = (self.attributedText?.string ?? self.text)?.range(ofText: text) else { return }
        changeFont(inRange: range, with: font)
    }
    
    func changeFont(inRange range: NSRange, with font: UIFont) {
        add(attributes: [.font: font], inRange: range)
    }
    
    func changeTextColor(ofText text: String, with color: UIColor) {
        guard let range = (self.attributedText?.string ?? self.text)?.range(ofText: text) else { return }
        changeTextColor(inRange: range, with: color)
    }
    
    func changeTextColor(inRange range: NSRange, with color: UIColor) {
        add(attributes: [.foregroundColor: color], inRange: range)
    }
    
    func add(attributes: [NSAttributedString.Key: Any], inRange range: NSRange) {
        guard !attributes.isEmpty else { return }
        
        var rangedAttributes: [RangedAttributes] = self.rangedAttributes
        
        var attributedString: NSMutableAttributedString
        
        if let attributedText = attributedText {
            attributedString = NSMutableAttributedString(attributedString: attributedText)
        } else if let text = text {
            attributedString = NSMutableAttributedString(string: text)
        } else {
            return
        }
        
        rangedAttributes.append(RangedAttributes(attributes, inRange: range))
        
        rangedAttributes.forEach { (rangedAttributes) in
            attributedString.addAttributes(
                rangedAttributes.attributes,
                range: rangedAttributes.range
            )
        }
        
        attributedText = attributedString
    }
    
    func resetFontChanges() {
        guard let text = text else { return }
        attributedText = NSMutableAttributedString(string: text)
    }
}

extension String {
    
    func range(ofText text: String) -> NSRange {
        let fullText = self
        let range = (fullText as NSString).range(of: text)
        return range
    }
}
