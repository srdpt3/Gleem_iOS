//
//  InboxMessage.swift
//  Gleem_iOS
//
//  Created by Dustin yang on 7/12/20.
//  Copyright © 2020 Dustin yang. All rights reserved.
//

import Foundation

struct InboxMessage: Encodable, Decodable, Identifiable {
    var id = UUID()
    var lastMessage: String
    var username: String
    var type: String
    var date: Double
    var userId: String
    var avatarUrl: String
}

//
//class InboxMessage {
//    
//    
//    var id  : String
//    var lastMessage: String
//    var username: String
//    var type: String
//    var date: Double
//    var userId: String
//    var avatarUrl: String
//    
//    init(id: String, lastMessage: String, username: String, type: String, date: Double, userId: String, avatarUrl: String) {
//        self.id = id
//        self.lastMessage = lastMessage
//        self.username = username
//        self.type = type
//        self.date = date
//        self.userId = userId
//        self.avatarUrl = avatarUrl
//    }
//    
//    
//    init(_dictionary: NSDictionary) {
//        id = _dictionary["id"] as! String
//        lastMessage = _dictionary["lastMessage"] as! String
//        username = _dictionary["username"] as! String
//        type = _dictionary["type"] as! String
//        date = _dictionary["date"] as! Double
//        avatarUrl = _dictionary["avatarUrl"] as! String
//        userId = _dictionary["userId"] as! String
//    }
//}
