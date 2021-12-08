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
    let chatTitle: String
    let messagesManager: MessagesManager
    var messages = [MessageViewModel]()
    let keyboardManager = KeyboardManager()
    var isFirstLayout = true
    var keyboardHeight: CGFloat = 0
    let spinnerToken = "spinner"
    var state: CollectionState = .loading
    var inputViewHeightConstr: Constraint!
    var inputHeight: CGFloat = 70
    
    lazy var collectionView: MessagesCollectionView = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        let layout = UICollectionViewFlowLayout()
        let collection = MessagesCollectionView(frame: frame, collectionViewLayout: layout)
        collection.backgroundColor = .systemBackground
        return collection
    }()
    
    lazy var messageInputView: MessageAccessoryView = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 70)
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
        view.backgroundColor = .systemBackground
        navigationController?.navigationItem.largeTitleDisplayMode = .never
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = chatTitle
        adapter.collectionView = collectionView
        adapter.collectionView?.keyboardDismissMode = .interactive
        adapter.scrollViewDelegate = self
        setContraints()
        setKeyboard()
        collectionView.transform = CGAffineTransform(scaleX: 1, y: -1)
        messagesManager.delgate = self
        messageInputView.delegate = self
        messagesManager.fetchMessages()
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            self.messages = StubData.createMessage()
//            self.state = .success
//            self.adapter.performUpdates(animated: true, completion: nil)
//        }
        setUpToHideKeyboardOnTapOnView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        messagesManager.observeNewMessages()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        isFirstLayout = false
    }
    
    init(chatId: String, users: [Users], title: String) {
        self.messagesManager = MessagesManager(chatId: chatId, users: users)
        self.chatTitle = title
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Set Up
    private func setContraints() {
        collectionView.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        view.addSubview(messageInputView)

        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin)
            make.left.right.equalTo(view)
            make.bottom.equalTo(messageInputView.snp.top)
        }
        
        messageInputView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            inputViewHeightConstr = make.height.equalTo(70).constraint
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottomMargin).offset(0)
        }
    }
    
    
}

extension MessagesViewController: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        var objects = messages as [ListDiffable]
        if state == .loading {
            objects.insert(spinnerToken as ListDiffable, at: 0)
        }
        return objects
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        
        if let _ = object as? String {
            let height: CGFloat = state == .loading ? view.bounds.height : 50
            return SpinnerSection(height: height)
        }
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

extension MessagesViewController: MessagesManagerDelegate {
    func setMessages(messages: [MessageViewModel]) {
        let sortedMessages = messages.sorted(by: { $0.message.creationDate > $1.message.creationDate})
        self.messages.append(contentsOf: sortedMessages)
        state = .success
        adapter.performUpdates(animated: true, completion: nil)
    }
    
    func showError(error: String) {
        
    }
    
    func newMessage(message: MessageViewModel) {
        messages.insert(message, at: 0)
        adapter.performUpdates(animated: true, completion: nil)
    }
    
    func deletedMessage(message: MessageViewModel) {
        
    }

}


extension MessagesViewController: MessageAccessoryDelegate {
    func sendTapped() {
        print("send tapped")
        guard let text = messageInputView.textView.text else { return }
        messagesManager.sendMessage(text: text)
        messageInputView.textView.text = ""
    }
    
    func textDidChangeHeight(height: CGFloat) {
        guard height != inputHeight else  { return }
        inputViewHeightConstr.update(offset: height)
        view.updateConstraints()
        inputHeight = height
    }
    
    func textDidChange(textView: UITextView) {
        
    }
    
    
}
