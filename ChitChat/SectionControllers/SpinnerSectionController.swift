//
//  SpinnerSectionController.swift
//  ChitChat
//
//  Created by ty foskey on 12/5/21.
//  Copyright © 2021 ty foskey. All rights reserved.
//

import IGListKit

class SpinnerSection: ListSectionController {
    
    let height: CGFloat?
    let width: CGFloat?
    let newInset: UIEdgeInsets?
    let showSpinner: Bool?
    
    init(height: CGFloat? = nil, width: CGFloat? = nil, inset: UIEdgeInsets? = nil, showSpinner: Bool? = nil) {
        self.height = height
        self.width = width
        self.newInset = inset
        self.showSpinner = showSpinner
    }
    
    override func numberOfItems() -> Int {
        return 1
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
      //  print(height, "the height")
        return CGSize(width: width ?? collectionContext!.containerSize.width, height: height ?? collectionContext!.containerSize.height)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = collectionContext!.dequeueReusableCell(of: SpinnerCell.self, for: self, at: index) as! SpinnerCell
        cell.backgroundColor = .systemBackground
        cell.activityIndicator.startAnimating()
        cell.activityIndicator.isHidden = !(showSpinner ?? true)
        return cell
    }
}
