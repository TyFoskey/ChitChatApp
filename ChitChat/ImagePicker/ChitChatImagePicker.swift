//
//  ChitChatImagePicker.swift
//  ChitChat
//
//  Created by ty foskey on 9/15/20.
//  Copyright © 2020 ty foskey. All rights reserved.
//

import UIKit
import BSImagePicker

class ChitChatImagePicker: ImagePickerController {
    
    
    init(maxSelection: Int = 1,
         isNumber: Bool = true,
         isSupportingBothMediaTypes: Bool = false,
         unselectOnReachingMax: Bool = true) {
        super.init()
        settings.selection.max = maxSelection
        settings.theme.selectionStyle = isNumber ? .numbered : .checked
        settings.fetch.assets.supportedMediaTypes = isSupportingBothMediaTypes ? [.image, .video] : [.image]
        settings.selection.unselectOnReachingMax = unselectOnReachingMax
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
