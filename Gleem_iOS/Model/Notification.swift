//
//  Notification.swift
//  Gleem_iOS
//
//  Created by Dustin yang on 7/13/20.
//  Copyright © 2020 Dustin yang. All rights reserved.
//

import Foundation
import FirebaseAuth

struct UserNotification: Encodable, Decodable {
    
    var activityId: String
    var type: String
    var username: String
    var userId: String
    var userAvatar: String
    var message: String
    var date: Double
    var read: Bool
    var location: String
    
    var typeDescription: String {
        var output = ""
        switch type {
        case "match":
            output = MATCHED_MESSAGE
        case "info":
            output = message
        case "like":
            output = LIKED_MESSAGE
        case "intro":
            output = WELCOME_GLEEM
        case "reject":
            output = REJECT_VOTE_IMAGE
        case "match_requested":
            output = ""
        default:
            output = ""
        }
        
        return output
    }
    
}
