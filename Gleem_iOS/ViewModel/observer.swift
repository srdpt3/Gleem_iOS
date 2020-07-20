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
    
    @Published var votedCards = [String]()
    
    
    var handle: AuthStateDidChangeListenerHandle?
    
    func getNumVoted(){
        Ref.FIRESTORE_COLLECTION_MYVOTE.document(Auth.auth().currentUser!.uid).collection("voted").getDocuments { (snap, error) in
            self.votedCards.removeAll()
            if error != nil {
                print((error?.localizedDescription)!)
                
            }
            for i in snap!.documents{
                
                let id = i.documentID
                if(id != Auth.auth().currentUser?.uid){
                    self.votedCards.append(id)
                }
                
            }
            
            self.reload()
        }
    }
    
    func getCurrentCard() -> MainCardView {
        return self.cardViews.first!
    }
    
    func listenAuthenticationState() {
        handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            if let user = user {
                self.getNumVoted()
                print("listenAuthenticationState \(user.uid)")
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
        
        
        if(self.users.count == 2 &&  index == 2){
            self.index += 1
            self.last += 1
            
        }else{
            
            if(self.index > self.users.count ){
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
                    if self.votedCards.contains(id) {
                        print("contained " +  id)
                    }
                    
                    
                    //                    else{
                    //                        let dict = i.data()
                    //                        guard let decoderPost = try? ActiveVote.init(fromDictionary: dict) else {return}
                    //                        self.users.append(decoderPost)
                    //                    }
                    
                    
                    
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


