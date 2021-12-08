//
//  CollectionViewCell.swift
//  ChitChat
//
//  Created by ty foskey on 9/25/20.
//  Copyright © 2020 ty foskey. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .systemBackground
        return collection
    }()
    
    let bottomView = UIView()
    
    // MARK: - View lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Setup
    private func setUp() {
        addSubview(collectionView)
        addSubview(bottomView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        bottomView.backgroundColor = UIColor.secondarySystemBackground
        bottomView.snp.makeConstraints { (make) in
            make.bottom.equalTo(self)
            make.left.right.equalTo(self)
            make.height.equalTo(2)
        }
        
    }
    
    func createCollectionRowType(rowType: RowType) {
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        let isHorizontal = rowType == .horizontal
        layout.scrollDirection =  isHorizontal == true ? .horizontal : .vertical
        collectionView.bounces = isHorizontal == true ? false : true
        bottomView.isHidden = isHorizontal == true ? false : true
    }
    
}
