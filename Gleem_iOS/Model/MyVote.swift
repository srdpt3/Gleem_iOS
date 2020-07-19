//
//  MyVote.swift
//  Gleem_Dating
//
//  Created by Dustin yang on 7/2/20.
//  Copyright © 2020 Dustin yang. All rights reserved.
//

import SwiftUI
import Foundation

struct MyVote: Encodable, Decodable {
    var userId: String
    var myVotes: [String:Int]
    var attrNames: [String]
    var voteDate: Double
    
    
    init(userId: String, myVotes: [String:Int], attrNames: [String],voteDate: Double ) {
        self.userId = userId
        self.myVotes = myVotes
        self.attrNames = attrNames
        self.voteDate = voteDate
        
        
        
    }
    init(_dictionary: NSDictionary) {
        userId = _dictionary["userId"] as! String
        myVotes = _dictionary["imamyVotesgeURL"] as! [String:Int]
        attrNames = _dictionary["attrNames"] as! [String]
        voteDate = _dictionary["voteDate"] as! Double
        
    }
    
    
}
