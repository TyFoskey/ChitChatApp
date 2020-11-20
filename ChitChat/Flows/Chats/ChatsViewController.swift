//
//  ChatsViewController.swift
//  ChitChat
//
//  Created by ty foskey on 9/16/20.
//  Copyright © 2020 ty foskey. All rights reserved.
//

import UIKit
import IGListKit

class ChatsViewController: UIViewController {
    
    var chats = [ChatViewModel]()
    let menuView = MenuView()
    var onGoToMessages: (() -> Void)?
    var onCreateNewMessage: (() -> Void)?
    var onAddNewUser:(() -> Void)?
    var onGoToSettings: (() -> Void)?
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = UIColor(red: 240, green: 240, blue: 240, alpha: 1)
        return collection
    }()
    
    lazy var adapter: ListAdapter = {
        let adapater = ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 0)
        adapater.dataSource = self
        return adapater
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Chats"
        UINavigationBar.appearance().prefersLargeTitles = true
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.largeTitleTextAttributes =
            [NSAttributedString.Key.foregroundColor: Constants.colors.secondaryColor,
           ]
        setConstraints()
        menuView.delegate = self
    }
    
    private func setConstraints() {
        view.addSubview(collectionView)
        adapter.collectionView = collectionView
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        view.addSubview(menuView)
        menuView.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.width.equalTo(230)
            make.height.equalTo(60)
            make.bottom.equalTo(collectionView).offset(-30)
        }
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - IGListkit DataSource
extension ChatsViewController: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        chats = StubData.createChatView()
        return chats as [ListDiffable]
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        let chatsSectionController = ChatSectionController()
        chatsSectionController.delegate = self
        return chatsSectionController
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return EmptyChatsView()
    }
    
}


// MARK: - Menu Delegate
extension ChatsViewController: MenuViewDelegate {
    func goToNewMesssages() {
        onCreateNewMessage?()
    }
    
    func addNewUser() {
        onAddNewUser?()
    }
    
    func goToSettings() {
        onGoToSettings?()
    }
}

// MARK: - Chats Delegate
extension ChatsViewController: ChatDelegate {
    func goToMessages(chatKey: String, chatUser: [Users], isRead: Bool) {
        print("going to messages")
        onGoToMessages?()
    }
}
