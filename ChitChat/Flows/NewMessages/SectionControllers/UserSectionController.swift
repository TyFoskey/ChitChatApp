//
//  UserSectionController.swift
//  ChitChat
//
//  Created by ty foskey on 9/26/20.
//  Copyright © 2020 ty foskey. All rights reserved.
//

import IGListKit

class UserSectionController: ListSectionController {
    
    var user: Users!
    let hideSelectedView: Bool
    var isSelected = false
    weak var delegate: UserCellDelegate?
    
    init(hideSelectedView: Bool? = nil) {
        self.hideSelectedView = hideSelectedView ?? false
    }
    
    override func didUpdate(to object: Any) {
        self.user = object as? Users
    }
    
    override func numberOfItems() -> Int {
        return 1
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext!.containerSize.width, height: 75)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(of: UserCell.self, for: self, at: index) as? UserCell else {
            fatalError("Cannot get user cell")
        }
        
        cell.selectedView.isHidden = hideSelectedView
        cell.user = user
        return cell
    }
    
    override func didSelectItem(at index: Int) {
        changeIsSelected(index: index)
        delegate?.didSelectedUser(user: user)
    }
    
    func changeIsSelected(index: Int) {
        isSelected = !isSelected
        guard let cell = collectionContext?.cellForItem(at: index, sectionController: self) as? UserCell else {
            return
        }
        cell.setSelectedView(isSelected: isSelected)
    }
}
