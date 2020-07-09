//
//  UserViewModel.swift
//  Gleem_Dating
//
//  Created by Dustin yang on 6/29/20.
//  Copyright © 2020 Dustin yang. All rights reserved.
//

import SwiftUI

class UserViewModel: ObservableObject {
  
       @Published var users: [User] = []
       @Published var isLoading = false
       @Published var error: NSError?
       var buttonPressed = [Bool]()
        let  buttonTitle = [String]()
       
       
       func searchFollowerUsers(userId: String) {
           isLoading = true
           //Api.User.searchUsers(text: searchText)
           UserApi().searchFollowerUser(userId: userId) { (users) in
               self.users = users
               print("searchFollowerUsers \(self.users.count)")
               
               
               self.isLoading = false
               
           }
       }
    
    
}

func saveUserLocally(mUserDictionary: NSDictionary) {
    print("SAved Locally")
    UserDefaults.standard.set(mUserDictionary, forKey: "currentUser")
    UserDefaults.standard.synchronize()
}


func resetDefaults() {
    print("resetDefaults")
    
    let defaults = UserDefaults.standard
    let dictionary = defaults.dictionaryRepresentation()
    dictionary.keys.forEach { key in
        defaults.removeObject(forKey: key)
    }
}


