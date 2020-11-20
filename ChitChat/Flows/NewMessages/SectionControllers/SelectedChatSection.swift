//
//  SelectedChatSection.swift
//  ChitChat
//
//  Created by ty foskey on 9/25/20.
//  Copyright © 2020 ty foskey. All rights reserved.
//

import IGListKit

class SelectedChatSection: ListSectionController {
    
    var user: Users!
    weak var delegate: SelectedUserDelegate?
    
    override func didUpdate(to object: Any) {
        self.user = object as? Users
    }
    
    override func numberOfItems() -> Int {
        return 1
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: 110, height: collectionContext!.containerSize.height)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(of: SingleUserCell.self, for: self, at: index) as? SingleUserCell else {
            fatalError("Cannot get single user selected chat cell")
        }
        
        cell.delegate = delegate
        cell.user = user
        return cell
        
    }
        
}
