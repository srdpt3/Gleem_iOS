//
//  observer.swift
//  Gleem_Dating
//
//  Created by Dustin yang on 6/28/20.
//  Copyright © 2020 Dustin yang. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseAuth

class observer : ObservableObject{
    
    @Published var users = [ActiveVote]()
    @Published var totalCount = 0
    
    @Published var last = 0
    @Published var isLoading = false
    @Published var error: NSError?
    @Published var cardViews = [MainCardView]()
    
    @Published var index = -1;
    @Published var isLoggedIn = false
    
    
    //    init() {
    //                       self.reload()
    //
    //
    //    }
    //
    var handle: AuthStateDidChangeListenerHandle?
    
    
    
    func getCurrentCard() -> MainCardView {
        return self.cardViews.first!
    }
    
    func listenAuthenticationState() {
        handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            if let user = user {
                self.reload()
                print("listenAuthenticationState \(user.email)")
                //                let firestoreUserId = Ref.FIRESTORE_DOCUMENT_USERID(userId: user.uid)
                //                firestoreUserId.getDocument { (document, error) in
                //                    if let dict = document?.data() {
                ////                        guard let decoderUser = try? User.init(fromDictionary: dict) else {return}
                //                        guard let decoderUser = try? User.init(_dictionary: dict as NSDictionary) else {return}
                //                        saveUserLocally(mUserDictionary: dict as NSDictionary)
                //                    }
                //                }
                //
                
                
                self.isLoggedIn = true
            } else {
                print("isLoogedIn is false")
                self.isLoggedIn = false
                //                self.userSession = nil
                
            }
        })
    }
     func moveCards() {
        self.cardViews.removeFirst()
        print("lastCardIndex \(index) asdfas \(self.totalCount)")
        
        if(self.index ==  self.users.count){
            print("reload")
                   
            self.reload()
            self.index = 2
        }else{
            
            let u = self.users[self.index % self.users.count]
            let newCardView = MainCardView(user: u)
            self.cardViews.append(newCardView)
            self.index += 1
            self.last += 1
            
            
        }
    }
    
    func logout() {
        
        do {
            cardViews.removeAll()
            users.removeAll()
            
            try Auth.auth().signOut()
            
            
            resetDefaults()
            URLCache.shared.removeAllCachedResponses()

            //            unbind()
        } catch  {
            print("Logout Failed")
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
    
    func createCardView(){
        self.cardViews.removeAll()
        var indexRange = 0
        
        if(self.totalCount <= 2 && self.totalCount > 0){
            indexRange = self.totalCount
        }else if self.totalCount > 2 {
            indexRange = 2
        }
        
        for index in 0..<indexRange {
            cardViews.append(MainCardView(user: users[index]))
        }
        self.index = self.cardViews.count
        
        print("reload \( self.index )")
    }
    
    
    func reload(){
        self.isLoading = true
        Ref.FIRESTORE_COLLECTION_ACTIVE_VOTE.getDocuments { (snap, err) in
            self.users.removeAll()
            
            if err != nil{
                print((err?.localizedDescription)!)
                self.error = (err?.localizedDescription as! NSError)
                return
            }
            
            for i in snap!.documents{
                
                let id = i.documentID
                if(id != Auth.auth().currentUser?.uid){
                    
                    let dict = i.data()
                    
                    guard let decoderPost = try? ActiveVote.init(fromDictionary: dict) else {return}
                    
                    self.users.append(decoderPost)
                    
                    
                    //
                    //                    let email = i.get("email") as! String
                    //                    let username = i.get("username") as! String
                    //                    let age = i.get("age") as! String
                    //                    let sex = i.get("sex") as! String
                    //                    let profileImageUrl = i.get("profileImageUrl") as! String
                    //
                    //
                    //                    let attr1 = _dictionary["attr1"] as! Int
                    //                    let attr2 = _dictionary["attr2"] as! Int
                    //                    let attr3 = _dictionary["attr3"] as! Int
                    //                    let attr4 = _dictionary["attr4"] as! Int
                    //                    let attr5 = _dictionary["attr5"] as! Int
                    //                    let attrNames = _dictionary["attrNames"] as! [String]
                    //                    let numVote = _dictionary["numVote"] as! Int
                    //
                    //                    let createdDate = _dictionary["createdDate"] as! Double
                    //                    let lastModifiedDate = _dictionary["lastModifiedDate"] as! Double
                    //
                    //
                    //
                    //                    self.users.append(ActiveVote(attr1: attr1, attr2: <#T##Int#>, attr3: <#T##Int#>, attr4: <#T##Int#>, attr5: <#T##Int#>, attrNames: <#T##[String]#>, numVote: <#T##Int#>, createdDate: <#T##Double#>, lastModifiedDate: <#T##Double#>, id: <#T##String#>, email: <#T##String#>, profileImageUrl: <#T##String#>, username: <#T##String#>, age: <#T##String#>, sex: <#T##String#>))
                    //
                    //
                    //
                    //
                }
                
            }
            print("self.users.count \(self.users.count)")
            self.isLoading = false
            self.totalCount = self.users.count
            self.last = 0
            self.createCardView()
        }

    }
    
    
   
    
}


