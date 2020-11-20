//
//  SelectedChatsSection.swift
//  ChitChat
//
//  Created by ty foskey on 9/25/20.
//  Copyright © 2020 ty foskey. All rights reserved.
//

import IGListKit

class SelectedChatsCollectionSection: ListSectionController {
    
    // MARK: - Properties
    var chatUsers = [Users]()
    weak var delegate: SelectedUserDelegate?
    
    lazy var adapter: ListAdapter = {
        let adapater = ListAdapter(updater: ListAdapterUpdater(), viewController: self.viewController, workingRangeSize: 0)
        adapater.dataSource = self
        return adapater
    }()
    
    override func didUpdate(to object: Any) {
        adapter.performUpdates(animated: true, completion: nil)
    }
    
    // MARK: - Init
    init(users: [Users]) {
        super.init()
        chatUsers = users
        adapter.performUpdates(animated: true, completion: nil)
    }
    
    override func numberOfItems() -> Int {
        return 1
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext!.containerSize.width, height: 100)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(of: CollectionViewCell.self, for: self, at: 0) as? CollectionViewCell else {
            fatalError("Cannot get CollectionView")
        }
        cell.createCollectionRowType(rowType: .horizontal)
        cell.collectionView.showsHorizontalScrollIndicator = false
        adapter.collectionView = cell.collectionView
        return cell
    }
    
    func updateCell(user: Users) {
        guard let index = chatUsers.firstIndex(of: user) else { return }
        chatUsers.remove(at: index)
        adapter.performUpdates(animated: true, completion: nil)
    }
    
}

// MARK: - List Adapter DataSource
extension SelectedChatsCollectionSection: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        print(chatUsers.count)
        return chatUsers as [ListDiffable]
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        let chatSection = SelectedChatSection()
        chatSection.delegate = self
        return chatSection
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
    
}

// MARK: - Selected User Delegate
extension SelectedChatsCollectionSection: SelectedUserDelegate {
    func didDeselectUser(user: Users) {
        guard let index = chatUsers.firstIndex(of: user) else { return }
        chatUsers.remove(at: index)
        delegate?.didDeselectUser(user: user)
        adapter.performUpdates(animated: true, completion: nil)
    }
}
