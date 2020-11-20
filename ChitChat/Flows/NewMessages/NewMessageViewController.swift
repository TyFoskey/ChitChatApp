//
//  NewMessageViewController.swift
//  ChitChat
//
//  Created by ty foskey on 9/25/20.
//  Copyright © 2020 ty foskey. All rights reserved.
//

import UIKit
import SnapKit
import IGListKit

class NewMessageViewController: UIViewController {
    
    // MARK: - Properties
    let searchView = SearchView()
    let keyboardManager = KeyboardManager()
    var selectedUsers = [Users]()
    var users = [Users]()
    var objects = [ListDiffable]()
    
    lazy var adapter: ListAdapter = {
        let adapater = ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 0)
        adapater.dataSource = self
        return adapater
    }()
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationItem.largeTitleDisplayMode = .never
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = "New Chat"
        adapter.collectionView = searchView.collectionView
        setUp()
        setUpToHideKeyboardOnTapOnView()
        setKeyboard()
        getUsers()
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - SetUp
    private func setUp() {
        view.addSubview(searchView)
        searchView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin)
            make.left.right.equalTo(view)
            make.bottom.equalTo(view)
        }
    }
    
    
    // MARK: - Data Manager
    private func getUsers() {
        users = StubData.createUser()
        objects.append(NewChatTokens.searchUsers.rawValue as ListDiffable)
        adapter.performUpdates(animated: true, completion: nil)
    }
    
    // MARK: - Keyboard Manager
    private func setKeyboard() {
        keyboardManager.on(event: .willShow) {[weak self] (notification) in
            guard let strongSelf = self else { return }
            strongSelf.keyboardManager.isKeyboardHidden = false
            if let index = strongSelf.objects.firstIndex(where: {$0.isEqual(toDiffableObject: NewChatTokens.chats.rawValue as ListDiffable) }) {
                strongSelf.objects.remove(at: index)
            }
            UIView.animate(withDuration: notification.timeInterval) {
                strongSelf.adapter.performUpdates(animated: true, completion: nil)
                strongSelf.searchView.collectionBottomConstr.update(offset: -notification.endFrame.height + 60)
            }
            strongSelf.view.layoutIfNeeded()

        }
        
        keyboardManager.on(event: .willHide) {[weak self] (notification) in
            guard let strongSelf = self else { return }
            strongSelf.keyboardManager.isKeyboardHidden = true
            strongSelf.objects.insert(NewChatTokens.chats.rawValue as ListDiffable, at: 0)
            UIView.animate(withDuration: notification.timeInterval) {
                strongSelf.adapter.performUpdates(animated: true, completion: nil)
                strongSelf.searchView.collectionBottomConstr.update(offset: 0)
            }
            strongSelf.view.layoutIfNeeded()

        }
        
    }
    
}


// MARK: - List Adapter DataSource
extension NewMessageViewController: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return objects
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        guard let obj = object as? String else {
            fatalError("Error not returning a new chat token")
        }
        
        print("getting tokens", obj)
        switch obj {
        case NewChatTokens.chats.rawValue:
            let selectedChatsSection = SelectedChatsCollectionSection(users: selectedUsers)
            selectedChatsSection.delegate = self
            return selectedChatsSection
        case NewChatTokens.searchUsers.rawValue:
            let searchUsersSection = SearchUsersCollectionSectionController(users: users)
            searchUsersSection.delegate = self
            return searchUsersSection
        default:
            fatalError("Error not a chat token raw value")
        }
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
    
    private func checkSelectedUsers() {
        if selectedUsers.count == 0 {
            objects.remove(at: 0)
            adapter.performUpdates(animated: true, completion: nil)
        }
    }
}

// MARK: - Selected User Delegate
extension NewMessageViewController: SelectedUserDelegate {
    func didDeselectUser(user: Users) {
        guard let index = selectedUsers.firstIndex(of: user) else { return }
        selectedUsers.remove(at: index)
        guard let searchUsersCollectionSection = adapter.sectionController(forSection: 1) as? SearchUsersCollectionSectionController else { return }
        searchUsersCollectionSection.updateCell(user: user)
        
        checkSelectedUsers()
        
    }
    
}

// MARK: - UserCelll Delegate
extension NewMessageViewController: UserCellDelegate {
    func didSelectedUser(user: Users) {
        if let index = selectedUsers.firstIndex(of: user) {
            // remove from the list
            selectedUsers.remove(at: index)
            guard let selectedChatsSection = adapter.sectionController(forSection: 0) as? SelectedChatsCollectionSection else { return }
            selectedChatsSection.updateCell(user: user)
            checkSelectedUsers()
        } else {
            // adds to the list
            selectedUsers.append(user)
            if let selectedChatsCollectionSection = adapter.sectionController(forSection: 0) as? SelectedChatsCollectionSection {
                // array of users already exists just adds on to it
                selectedChatsCollectionSection.chatUsers.append(user)
                selectedChatsCollectionSection.adapter.performUpdates(animated: true, completion: nil)
            } else {
                // the start of the list so must initialize the selected chats collection section
                objects.insert(NewChatTokens.chats.rawValue as ListDiffable, at: 0)
                adapter.performUpdates(animated: true, completion: nil)
            }
        }
    }
}
