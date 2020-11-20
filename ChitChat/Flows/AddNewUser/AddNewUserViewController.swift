//
//  AddNewUserViewController.swift
//  ChitChat
//
//  Created by ty foskey on 9/26/20.
//  Copyright © 2020 ty foskey. All rights reserved.
//

import UIKit
import IGListKit

class AddNewUserViewController: UIViewController {
    
    // MARK: - Properties
    let searchView = SearchView()
    var users = StubData.createUser()
    let keyboardManager = KeyboardManager()
    
    lazy var adapter: ListAdapter = {
        let adapater = ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 0)
        adapater.dataSource = self
        return adapater
    }()
    
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationItem.largeTitleDisplayMode = .never
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = "Add New Friend"
        setUpToHideKeyboardOnTapOnView()
        setUp()
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
        searchView.searchBar.placeholder = "Search for chit chat user using name or phone number"
        searchView.collectionView.isScrollEnabled = true
        adapter.collectionView = searchView.collectionView
        searchView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin)
            make.left.right.equalTo(view)
            make.bottom.equalTo(view)
        }
    }
    
    // MARK: - Data Manager
     private func getUsers() {
         users = StubData.createUser()
         adapter.performUpdates(animated: true, completion: nil)
     }
    
    // MARK: - Keyboard Manager
    private func setKeyboard() {
        keyboardManager.on(event: .willShow) {[weak self] (notification) in
            guard let strongSelf = self else { return }
            strongSelf.keyboardManager.isKeyboardHidden = false
            
            UIView.animate(withDuration: notification.timeInterval) {
                strongSelf.searchView.collectionBottomConstr.update(offset: -notification.endFrame.height)
            }
            strongSelf.view.layoutIfNeeded()
            
        }
        
        keyboardManager.on(event: .willHide) {[weak self] (notification) in
            guard let strongSelf = self else { return }
            strongSelf.keyboardManager.isKeyboardHidden = true
            UIView.animate(withDuration: notification.timeInterval) {
                strongSelf.searchView.collectionBottomConstr.update(offset: 0)
            }
            strongSelf.view.layoutIfNeeded()
            
        }
        
    }
    
}


// MARK: - List Adapter Datasource
extension AddNewUserViewController: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return users as [ListDiffable]
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        let userSection = UserSectionController(hideSelectedView: true)
        return userSection
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
    
}
