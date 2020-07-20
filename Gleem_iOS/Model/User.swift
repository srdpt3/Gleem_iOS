//
//  Users.swift
//  Gleem_Dating
//
//  Created by Dustin yang on 6/29/20.
//  Copyright © 2020 Dustin yang. All rights reserved.
//

import Foundation
import FirebaseAuth

struct User: Encodable, Decodable ,Identifiable{
    //    var id: ObjectIdentifier
    
    var id : String
    var email: String
    var profileImageUrl: String
    var username: String
    var age: String
    var sex: String
    var createdDate : Double
    var point_avail : Int
    
    
    init(id: String, email: String, profileImageUrl: String, username: String, age: String, sex:String, createdDate : Double, point_avail: Int) {
        self.id = id
        self.email = email
        self.profileImageUrl = profileImageUrl
        self.username = username
        self.age = age
        self.sex = sex
        self.createdDate = createdDate
        self.point_avail = point_avail
        
    }
    init(_dictionary: NSDictionary) {
        id = _dictionary["id"] as! String
        email = _dictionary["email"] as! String
        profileImageUrl = _dictionary["profileImageUrl"] as! String
        username = _dictionary["username"] as! String
        age = _dictionary["age"] as! String
        sex = _dictionary["sex"] as! String
        createdDate = _dictionary["createdDate"] as! Double
        point_avail = _dictionary["point_avail"] as! Int
        
        
    }
    
    
    static func currentUser() -> User? {
        
        if Auth.auth().currentUser != nil {
            if let dictionary = UserDefaults.standard.object(forKey: "currentUser") {
                print(User.init(_dictionary: dictionary as! NSDictionary))
                
                return User.init(_dictionary: dictionary as! NSDictionary)
            }
        }
        
//        
//        return User(id: "63gIkD569ywBbqfuqEx4", email: "test@gmail.com", profileImageUrl: "https://www.thesprucepets.com/thmb/mERLXPcXz4U9G702HlsORXJqZrU=/4231x2380/smart/filters:no_upscale()/adorable-white-pomeranian-puppy-spitz-921029690-5c8be25d46e0fb000172effe.jpg", username: "test", age: "29", sex: "male", createdDate: 0, point_avail: 0)
        return nil
    }
    
    
    
}
