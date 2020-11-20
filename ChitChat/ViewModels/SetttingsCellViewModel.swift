//
//  SetttingsCellViewModel.swift
//  ChitChat
//
//  Created by ty foskey on 9/26/20.
//  Copyright © 2020 ty foskey. All rights reserved.
//

import IGListKit

class SettingsCellViewModel: ListDiffable {
 
    let text: String
    let cellType: SettingsCellType
    let textColor: UIColor?
    let textFont: UIFont?
    let fontSize: CGFloat = 13.5
    let backgroundColor: UIColor?
    let maxCharCount: Int?
    let placeholderText: String?

    init(text: String, cellType: SettingsCellType, textColor: UIColor? = nil, textFont: UIFont? = nil, backgroundColor: UIColor? = nil, maxCharCount: Int? = nil, placeholderText: String? = nil) {
        self.text = text
        self.cellType = cellType
        self.textColor = textColor
        self.textFont = textFont
        self.backgroundColor = backgroundColor
        self.maxCharCount = maxCharCount
        self.placeholderText = placeholderText
    }
    
    var cellHeight: CGFloat {
        switch cellType {
        case .profilePic: return 190
        case .textField: return 50
        case .text: return getTextHeight()
        }
    }
    
   func getTextHeight() -> CGFloat {
       let approximateWidthofBioText = UIScreen.main.bounds.width - 48
       
       let size = CGSize(width: approximateWidthofBioText, height: 1000)
       
       let attributes = [NSAttributedString.Key.font: textFont ?? UIFont.systemFont(ofSize: fontSize)]
       
       let estimatedFrame = NSString(string: text).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
       
       return CGFloat(estimatedFrame.height + 10)
   }
    
    func diffIdentifier() -> NSObjectProtocol {
         return text as NSObject
     }
     
     func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? SettingsCellViewModel else { return false }
        return self.text == object.text
    }

    
}
