//
//  SearchUsersCollectionSectionController.swift
//  ChitChat
//
//  Created by ty foskey on 9/26/20.
//  Copyright © 2020 ty foskey. All rights reserved.
//

import IGListKit

class SearchUsersCollectionSectionController: ListSectionController {
    
    // MARK: - Properties
    let users: [Users]
    weak var delegate: UserCellDelegate?
    
    lazy var adapter: ListAdapter = {
        let adapater = ListAdapter(updater: ListAdapterUpdater(), viewController: self.viewController, workingRangeSize: 0)
        adapater.dataSource = self
        return adapater
    }()
    
    // MARK: - Init
    init(users: [Users]) {
        print(users.count, "user count")
        self.users = users
        super.init()
    }
    
    override func numberOfItems() -> Int {
        return 1
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext!.containerSize.width, height: collectionContext!.containerSize.height - 50)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(of: CollectionViewCell.self, for: self, at: index) as? CollectionViewCell else {
            fatalError("Cannot get collection view cell")
        }
        cell.createCollectionRowType(rowType: .vertical)
        cell.collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
        cell.collectionView.verticalScrollIndicatorInsets.bottom = 60
        adapter.collectionView = cell.collectionView
        return cell
    }
    
    func updateCell(user: Users) {
        guard let index = users.firstIndex(of: user), let userSection = adapter.sectionController(forSection: index) as? UserSectionController else { return }
        userSection.changeIsSelected(index: 0)
    }
    
}

extension SearchUsersCollectionSectionController: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return users as [ListDiffable]
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        let userSection = UserSectionController()
        userSection.delegate = delegate
        return userSection
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
    
    
}
