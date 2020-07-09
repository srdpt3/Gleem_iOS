//
//  Vote.swift
//  Gleem_Dating
//
//  Created by Dustin yang on 7/2/20.
//  Copyright © 2020 Dustin yang. All rights reserved.
//

import SwiftUI

import Foundation
import FirebaseAuth
struct Vote: Encodable, Decodable {
    var attr1 : Int
    var attr2: Int
    var attr3: Int
    var attr4: Int
    var attr5: Int
    var attrNames: [String]
    var numVote: Int
    var createdDate: Double
    var lastModifiedDate: Double


    
    
    
    init(attr1: Int, attr2: Int, attr3: Int, attr4: Int, attr5: Int,attrNames: [String], numVote: Int, createdDate: Double, lastModifiedDate: Double) {
        self.attr1 = attr1
        self.attr2 = attr2
        self.attr3 = attr3
        self.attr4 = attr4
        self.attr5 = attr5
        
        
        self.attrNames = attrNames
        self.numVote = numVote
        self.createdDate = createdDate
        self.lastModifiedDate = lastModifiedDate

        
    }
    init(_dictionary: NSDictionary) {
        attr1 = _dictionary["attr1"] as! Int
        attr2 = _dictionary["attr2"] as! Int
        attr3 = _dictionary["attr3"] as! Int
        attr4 = _dictionary["attr4"] as! Int
        attr5 = _dictionary["attr5"] as! Int
        attrNames = _dictionary["attrNames"] as! [String]
        numVote = _dictionary["numVote"] as! Int

        createdDate = _dictionary["createdDate"] as! Double
        lastModifiedDate = _dictionary["lastModifiedDate"] as! Double


    }
}
