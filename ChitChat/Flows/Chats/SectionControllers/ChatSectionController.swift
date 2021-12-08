//
//  ChatSectionController.swift
//  ChitChat
//
//  Created by ty foskey on 9/16/20.
//  Copyright © 2020 ty foskey. All rights reserved.
//

import IGListKit

class ChatSectionController: ListSectionController {
    
    var chatView: ChatViewModel!
    weak var delegate: ChatDelegate?
    
    override func didUpdate(to object: Any) {
        guard let object = object as? ChatViewModel else {return}
        chatView = object
    }
    
    override func numberOfItems() -> Int {
        return 1
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext!.containerSize.width, height: 100)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        if chatView.users.count == 1 {
            guard let cell = collectionContext?.dequeueReusableCell(of: ChatCell.self, for: self, at: index) as? ChatCell else { fatalError("Missing context or wrong chat single cell type") }
            cell.chatView = chatView
            return cell
        } else {
            guard let cell = collectionContext?.dequeueReusableCell(of: MultiChatCell.self, for: self, at: index) as? MultiChatCell else { fatalError("Missing context or wrong chat multi cell type") }
            cell.chatViewModel = chatView
            return cell
        }
      
    }
    
    override func didSelectItem(at index: Int) {
        print("did select")
        delegate?.goToMessages(chatViewModel: chatView, isRead: chatView.messageView.message.isRead ?? true)
    }
}
