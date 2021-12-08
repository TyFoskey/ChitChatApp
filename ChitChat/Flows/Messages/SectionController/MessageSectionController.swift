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
        let height = messageViewModel.cellHeight
        return CGSize(width: collectionContext!.containerSize.width, height: height)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        print(messageViewModel.isFrom, "isFrom")
        if messageViewModel.isFrom == true {
            let cell = collectionContext!.dequeueReusableCell(of: FromMessageTextCell.self, for: self, at: index) as! FromMessageTextCell
           // cell.transform = CGAffineTransform(scaleX: 1, y: -1)
            cell.messageViewModel = messageViewModel
            //   cell.delegate = delegate
            return cell
        } else {
            let cell = collectionContext!.dequeueReusableCell(of: ToMessageTextCell.self, for: self, at: index) as! ToMessageTextCell
           // cell.transform = CGAffineTransform(scaleX: 1, y: -1)
            cell.messageViewModel = messageViewModel
            //   cell.delegate = delegate
            return cell
        }
    }
    
//    func hideProfileImage() {
//        guard let cell = collectionContext!.cellForItem(at: 0, sectionController: self) as? MessageTextCell else { return }
//        cell.profileImageView.isHidden = true
//    }
    
}
