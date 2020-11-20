//
//  MessageSectionController.swift
//  ChitChat
//
//  Created by ty foskey on 9/21/20.
//  Copyright © 2020 ty foskey. All rights reserved.
//

import Foundation
import IGListKit

class MessageSectionController: ListSectionController {
    
    var messageViewModel: MessageViewModel!
    var showProfilePic: Bool!
   // weak var delegate: MessageCellDelegate?
    
    
    init(shouldHide: Bool) {
        showProfilePic = shouldHide
    }
    
    override func didUpdate(to object: Any) {
        messageViewModel = object as? MessageViewModel
    }
    
    
    override func numberOfItems() -> Int {
        return 1
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        let height = messageViewModel.cellHeight - (showProfilePic && messageViewModel.isFrom == false ? 16 : 0)
        return CGSize(width: collectionContext!.containerSize.width, height: height)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        print(messageViewModel.messageKind, "messageKind")
        switch messageViewModel.messageKind {
        case .text:
            let cell = collectionContext!.dequeueReusableCell(of: MessageTextCell.self, for: self, at: index) as! MessageTextCell
            cell.transform = CGAffineTransform(scaleX: 1, y: -1)
            cell.messageViewModel = messageViewModel
            cell.profileImageView.isHidden = showProfilePic
         //   cell.delegate = delegate
            return cell
            
       
        case .photo:
            let cell = collectionContext!.dequeueReusableCell(of: MessageImageCell.self, for: self, at: index) as! MessageImageCell
            cell.messageViewModel = messageViewModel
            return cell
            
        }
    }
    
    func hideProfileImage() {
        guard let cell = collectionContext!.cellForItem(at: 0, sectionController: self) as? MessageTextCell else { return }
        cell.profileImageView.isHidden = true
    }
    
}
