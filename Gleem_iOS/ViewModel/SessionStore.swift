//
//  SessionStore.swift
//  Gleem_Dating
//
//  Created by Dustin yang on 6/29/20.
//  Copyright © 2020 Dustin yang. All rights reserved.
//

import Foundation
import Combine
import FirebaseAuth

class SessionStore: ObservableObject {
    
    @Published var isLoggedIn = false
    @Published  var userSession: User?
    
    var handle: AuthStateDidChangeListenerHandle?
    func listenAuthenticationState() {
        
        
        handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            if let user = user {
                print("listenAuthenticationState + \(user.uid)")
                Ref.FIRESTORE_DOCUMENT_USERID(userId:  user.uid).getDocument { (snapshot, error) in
                    
                    guard let snapshot = snapshot else { return }
     
                    if snapshot.exists {
                        guard let user = try? User.init(_dictionary: (snapshot.data())! as NSDictionary) else {return}
                        saveUserLocally(mUserDictionary: snapshot.data() as! NSDictionary)
                        self.userSession = user
                        self.isLoggedIn = true
                    } else {
                        print("there is no user, save new in firestore")
                    }
                }
                
            } else {
                self.isLoggedIn = false
                self.userSession = nil
            
            }

        })
    }
    
    
    func logout() {
        do {
            try Auth.auth().signOut()
            resetDefaults()

        } catch  {
            
        }
    }
    
    // stop listening for auth changes
    func unbind() {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    deinit {
        unbind()
    }
}


class UserStore: ObservableObject {
    @Published var isLogged: Bool = UserDefaults.standard.bool(forKey: "isLogged") {
        didSet {
            UserDefaults.standard.set(self.isLogged, forKey: "isLogged")
        }
    }
    @Published var showLogin = false
}
