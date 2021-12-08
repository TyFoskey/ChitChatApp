//
//  ChatsViewController.swift
//  ChitChat
//
//  Created by ty foskey on 9/16/20.
//  Copyright © 2020 ty foskey. All rights reserved.
//

import UIKit
import IGListKit
import FirebaseAuth

class ChatsViewController: UIViewController {
    
    var chats = [ChatViewModel]()
    let menuView = MenuView()
    let chatsManager = ChatsManager()
    var onGoToMessages: ((ChatViewModel) -> Void)?
    var onCreateNewMessage: (() -> Void)?
    var onAddNewUser:(() -> Void)?
    var onGoToSettings: (() -> Void)?
    var state: CollectionState = .loading
    var loadingToken = "loadingToken"
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .systemBackground
        return collection
    }()
    
    lazy var adapter: ListAdapter = {
        let adapater = ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 0)
        adapater.dataSource = self
        return adapater
    }()
    
    let imageName = "gearshape.fill"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("chats loading")
        print(Auth.auth().currentUser?.uid, "current uid for chats")
        navigationItem.title = "Chats"
        UINavigationBar.appearance().prefersLargeTitles = true
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.largeTitleTextAttributes =
            [NSAttributedString.Key.foregroundColor: Constants.colors.secondaryColor,
           ]
        let imageSymbolConfiguration = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
        let image = UIImage(systemName: imageName, withConfiguration: imageSymbolConfiguration)
        let barItem = UIBarButtonItem(image: image, style: .done, target: self, action: #selector(settingsTapped))
        navigationItem.rightBarButtonItem = barItem
        setConstraints()
        menuView.delegate = self
        chatsManager.delegate = self
        chatsManager.fetchChats()
    }
    
    private func setConstraints() {
        view.addSubview(collectionView)
        adapter.collectionView = collectionView
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        view.addSubview(menuView)
        menuView.snp.makeConstraints { (make) in
            make.trailing.equalTo(view)
            make.width.equalTo(150)
            make.height.equalTo(100)
            make.bottom.equalTo(collectionView).offset(-50)
        }
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Actions
    @objc private func settingsTapped() {
        onGoToSettings?()
    }
}

// MARK: - IGListkit DataSource
extension ChatsViewController: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        var objects = chats as [ListDiffable]
        if state == .loading {
            objects.insert(loadingToken as ListDiffable, at: 0)
        }
        return objects as [ListDiffable]
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        if let _ = object as? String {
            let spinnerSection = SpinnerSection(height: view.bounds.height)
            return spinnerSection
        }
        let chatsSectionController = ChatSectionController()
        chatsSectionController.delegate = self
        return chatsSectionController
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return EmptyChatsView()
    }
    
}

// MARK: - Chats Manager Delegate
extension ChatsViewController: ChatsManagerDelegate {
    func newChat(chat: ChatViewModel) {
        state = .success
        if let index = chats.firstIndex(where: { $0.id == chat.id }) {
            if chat == chats[index] {
                return
            }
            chats.remove(at: index)
        }
        chats.insert(chat, at: 0)
        adapter.performUpdates(animated: true, completion: nil)
        print("new convo")
    }
    
    func showError(error: Error) {
        print(error, "chats error")
    }
    
    func setChats(chats: [ChatViewModel]) {
        state = .success
        self.chats = chats.sorted(by: { $0.messageView.message.creationDate > $1.messageView.message.creationDate})
        self.adapter.performUpdates(animated: true, completion: nil)
        chatsManager.observeNewConversation()
    }
    
    func noChats() {
        state = .success
        adapter.performUpdates(animated: true, completion: nil)
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
    func goToMessages(chatViewModel: ChatViewModel, isRead: Bool) {
        print("going to messages")
        onGoToMessages?(chatViewModel)
    }
}
