//
//  Match.swift
//  Gleem_iOS
//
//  Created by Dustin yang on 7/19/20.
//  Copyright © 2020 Dustin yang. All rights reserved.
//


import SwiftUI
import Foundation

struct Match:  Encodable, Decodable{
    var date: Double

    init(date: Double) {
        self.date = date
    }
    
    init(_dictionary: NSDictionary) {
        date = _dictionary["date"] as! Double
    }
}
