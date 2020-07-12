//
//  Chat.swift
//  Gleem_iOS
//
//  Created by Dustin yang on 7/12/20.
//  Copyright © 2020 Dustin yang. All rights reserved.

import Foundation


//struct Chat: Encodable, Decodable {
//    var messageId: String
//    var textMessage: String
//    var avatarUrl: String
//    var photoUrl: String
//    var senderId: String
//    var username: String
//    var date: Double
//}
import Foundation
import FirebaseAuth

struct Chat: Encodable, Decodable {
    var messageId: String
    var textMessage: String
    var avatarUrl: String
    var photoUrl: String
    var senderId: String
    var username: String
    var date: Double
    var type: String
    
    var isCurrentUser: Bool {
        return Auth.auth().currentUser!.uid == senderId
    }
    var isPhoto: Bool {
        return type == "PHOTO"
    }
    var isTextMessage: Bool {
        return type == "TEXT"
    }
}


//
//class Chat {
//    
//    var messageId: String
//    var textMessage: String
//    var avatarUrl: String
//    var photoUrl: String
//    var senderId: String
//    var username: String
//    var date: Double
//    var type: String
//
//    init(_messageId : String, _textMessage: String,_avatarUrl: String, _photoUrl: String,_senderId: String, _username:String, _date : Double, _type : String) {
//        
//        messageId = _messageId
//        textMessage = _textMessage
//        avatarUrl = _avatarUrl
//        photoUrl = _photoUrl
//        senderId = _senderId
//        username = _username
//        date = _date
//        type = _type
//        
//    }
//    
//    
//    init(_dictionary: NSDictionary) {
//        messageId = _dictionary["messageId"] as! String
//        textMessage = _dictionary["textMessage"] as! String
//        avatarUrl = _dictionary["avatarUrl"] as! String
//        photoUrl = _dictionary["photoUrl"] as! String
//        senderId = _dictionary["senderId"] as! String
//        date = _dictionary["date"] as! Double
//        type = _dictionary["type"] as! String
//        username = _dictionary["username"] as! String
//        
////        type = "TEXT"
////        username = "srdpt3@gmail.com"
//
//
//        
//        
//    }
//    
//    var isCurrentUser: Bool {
//        return User.currentUser()!.id == senderId
//     }
//    
//    var isPhoto: Bool {
//        return type == "PHOTO"
//    }
//    var isTextMessage: Bool {
//        return type == "TEXT"
//    }
//    
//}
