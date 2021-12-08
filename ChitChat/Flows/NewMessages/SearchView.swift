//
//  NewMessageView.swift
//  ChitChat
//
//  Created by ty foskey on 9/25/20.
//  Copyright © 2020 ty foskey. All rights reserved.
//

import UIKit
import SnapKit

class SearchView: UIView {
    
    // MARK: - Properties
    let searchBar = UISearchBar()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .systemBackground
        collection.isScrollEnabled = false
        return collection
    }()
    
    var collectionBottomConstr: Constraint!
    
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
        addSubview(searchBar)
        addSubview(collectionView)
        
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Search for users"
        searchBar.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self)
        }
        
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(searchBar.snp.bottom)
            make.left.right.equalTo(self)
            collectionBottomConstr = make.bottom.equalTo(self).constraint
            collectionBottomConstr.isActive = true
        }
    }
}
