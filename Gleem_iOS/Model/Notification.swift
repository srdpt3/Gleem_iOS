//
//  Notification.swift
//  Gleem_iOS
//
//  Created by Dustin yang on 7/13/20.
//  Copyright © 2020 Dustin yang. All rights reserved.
//

import Foundation
import FirebaseAuth

struct Activity: Encodable, Decodable {
    
    var activityId: String
    var type: String
    var username: String
    var userId: String
    var userAvatar: String
    var message: String
    var date: Double
    
    var typeDescription: String {
        var output = ""
        switch type {
        case "matched":
            output = MATCHED_MESSAGE
        case "info":
            output = message
        case "like":
            output = LIKED_MESSAGE
        default:
            output = ""
        }
        
        return output
    }
    
}