//
//  MessagesViewController.swift
//  ChitChat
//
//  Created by ty foskey on 9/16/20.
//  Copyright © 2020 ty foskey. All rights reserved.
//

import UIKit
import SnapKit
import IGListKit

class MessagesViewController: UIViewController {
    
    // MARK: - Properties
    var messages = StubData.createMessage()
    var lastMessage: MessageViewModel?
    var lastMessageView: MessageViewModel?
    var lastSectionController: MessageSectionController?
    let keyboardManager = KeyboardManager()
    var cachedNotification: KeyboardNotification?
    var isFirstLayout = true
    var keyboardHeight: CGFloat = 0
    let backgroundView = UIView()
    
    lazy var collectionView: MessagesCollectionView = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        let layout = UICollectionViewFlowLayout()
        let collection = MessagesCollectionView(frame: frame, collectionViewLayout: layout)
        collection.backgroundColor = .white
        return collection
    }()
    
    lazy var messageInputView: MessageAccessoryView = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 80)
        let footerView = MessageAccessoryView(frame: frame)
      //  footerView.photoButt.addTarget(self, action: #selector(photoTapped), for: .touchUpInside)
      //  footerView.sendButt.addTarget(self, action: #selector(sendText), for: .touchUpInside)
        return footerView
    }()
    
    
    lazy var adapter: ListAdapter = {
        let adapater = ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 0)
        adapater.dataSource = self
        return adapater
    }()
    
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationItem.largeTitleDisplayMode = .never
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = "Tyler"
        adapter.collectionView = collectionView
        adapter.collectionView?.keyboardDismissMode = .interactive
        adapter.scrollViewDelegate = self
        setContraints()
        setKeyboard()
        collectionView.transform = CGAffineTransform(scaleX: 1, y: -1)

        setUpToHideKeyboardOnTapOnView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        isFirstLayout = false
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Set Up
    private func setContraints() {
        collectionView.backgroundColor = .white
        view.addSubview(collectionView)
        view.addSubview(messageInputView)

        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin)
            make.left.right.equalTo(view)
            make.bottom.equalTo(messageInputView.snp.top)
        }
        
        messageInputView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.height.equalTo(80)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottomMargin).offset(0)
        }
    }
    
    
}

extension MessagesViewController: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return messages as [ListDiffable]
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        guard let messageView = object as? MessageViewModel else {
            fatalError("not a message view")
        }
        var shouldHide = messageView.isFrom == true
        if let index = messages.firstIndex(of: messageView), index != messages.count - 1 {
            let afterMessageView = messages[index + 1]
            if messageView.user.id == afterMessageView.user.id, shouldHide != false {
                shouldHide = true
            }
        }
        
        let messageSectionController = MessageSectionController(shouldHide: shouldHide)
     
        return messageSectionController
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
    
    
}

extension MessagesViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if keyboardManager.isKeyboardHidden == false {
            view.endEditing(true)
        }
    }
    
}
