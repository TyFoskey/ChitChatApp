//
//  Message.swift
//  ChitChat
//
//  Created by ty foskey on 9/8/20.
//  Copyright © 2020 ty foskey. All rights reserved.
//

import UIKit

class Message: SnapshotProtocol {
    
    var messageText: String?
    var fromId: String
    var toId: String
    var creationDate: Double
    var id: String
    var type: String
    var users: [Users]?
    var photoUrl: String?
    var imageWidth: NSNumber?
    var imageHeight: NSNumber?
    var isRead: Bool? = true
    var localImage: UIImage?
    
   init(messageText: String?, creationDate: Double, toId: String, fromId: String, type: String, id: String, imageUrl: String? = nil, imageWidth: NSNumber? = nil, imageHeight: NSNumber? = nil, isShare: Bool, username: String? = nil, title: String? = nil, postId: String? = nil, localImage: UIImage? = nil) {
          
          self.messageText = messageText
          self.creationDate = creationDate
          self.toId = toId
          self.fromId = fromId
          self.type = type
          self.id = id
          self.photoUrl = imageUrl
          self.imageWidth = imageWidth
          self.imageHeight = imageHeight
          self.localImage = localImage
      }
      
      required init(snapDict: [String : Any], key: String) {
          self.messageText = snapDict["messageText"] as? String
          self.creationDate = snapDict["creationDate"] as! Double
          self.toId = snapDict["toId"] as! String
          self.fromId = snapDict["fromId"] as! String
          self.type = snapDict["type"] as! String
          self.id = key
          self.photoUrl = snapDict["imageUrl"] as? String
          self.imageWidth = snapDict["imageWidth"] as? NSNumber
          self.imageHeight = snapDict["imageHeight"] as? NSNumber
      }
    
}

// MARK: - Equatable
extension Message: Equatable {
    static func == (lhs: Message, rhs: Message) -> Bool {
        return lhs.messageText == rhs.messageText &&
            lhs.creationDate == rhs.creationDate &&
            lhs.toId == rhs.toId &&
            lhs.fromId == rhs.fromId &&
            lhs.type == rhs.type &&
            lhs.id == rhs.id &&
            lhs.photoUrl == rhs.photoUrl &&
            lhs.imageWidth == rhs.imageWidth &&
            lhs.imageHeight == rhs.imageHeight &&
            lhs.localImage == rhs.localImage &&
            lhs.users == rhs.users &&
            lhs.isRead == rhs.isRead
        
    }
}
