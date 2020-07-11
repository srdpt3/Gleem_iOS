//
//  observer.swift
//  Gleem_Dating
//
//  Created by Dustin yang on 6/28/20.
//  Copyright © 2020 Dustin yang. All rights reserved.
//

import SwiftUI
import Firebase

class observer : ObservableObject{
    
    @Published var users = [User]()
    @Published var totalCount = 0
    
    @Published var last = -1
    @Published var isLoading = false
    @Published var error: NSError?
    @Published var cardViews = [MainCardView]()
    
    @Published var index = -1;
    @Published var isLoggedIn = false
    
    
    init() {
        DispatchQueue.main.async {
            self.reload()
        }
    }
    
    var userSession: User?
    var handle: AuthStateDidChangeListenerHandle?
    
    func listenAuthenticationState() {
        handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            if let user = user {
                print("listenAuthenticationState \(user.email)")
                let firestoreUserId = Ref.FIRESTORE_DOCUMENT_USERID(userId: user.uid)
                firestoreUserId.getDocument { (document, error) in
                    if let dict = document?.data() {
                        guard let decoderUser = try? User.init(fromDictionary: dict) else {return}
                        self.userSession = decoderUser
                    }
                }
                self.isLoggedIn = true
            } else {
                print("isLoogedIn is false")
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
        //        var views = [MainCardView]()
        for index in 0..<2 {
            cardViews.append(MainCardView(user: users[index]))
        }
        //           return views
        self.index = self.cardViews.count
        
        print("reload \( self.index )")
        
    }
    
    
    func reload(){
        self.isLoading = true
        self.users.removeAll()
        
        let db = Firestore.firestore()
        db.collection("users").getDocuments { (snap, err) in
            
            if err != nil{
                
                print((err?.localizedDescription)!)
                self.error = (err?.localizedDescription as! NSError)
                
                return
            }
            
            for i in snap!.documents{
                let id = i.documentID
                let email = i.get("email") as! String
                let username = i.get("username") as! String
                let age = i.get("age") as! String
                let sex = i.get("sex") as! String
                
                let profileImageUrl = i.get("profileImageUrl") as! String
                self.users.append(User(id: id, email: email, profileImageUrl: profileImageUrl, username: username, age: age, sex: sex, swipe: 0, degree: 0))
            }
            print("self.users.count \(self.users.count)")
            self.isLoading = false
            self.totalCount = self.users.count
            self.last = -1
            self.createCardView()
        }
        
    }
    
    
    func update(id : User,value : CGFloat,degree : CGFloat){
        
        for i in 0..<self.users.count{
            
            if self.users[i].id == id.id{
                
                self.users[i].swipe = value
                self.users[i].degree = degree
                self.last = i
                self.index = self.index - 1
                break
            }
            
            
        }
        //        self.users.remove(at: self.last )
        
        print(self.index)
        if(self.index  ==  0 && self.last != -1){
            print("emptu")
            self.users.removeAll()
            self.reload()
        }
    }
    func update2(id : User,value : CGFloat,degree : CGFloat){
        
        for i in 0..<self.users.count{
            if self.users[i].id == id.id{
                self.users[i].swipe = value
            }
        }
    }
    
    
    //    func updateDB(id : User,status : String){
    //
    //        let db = Firestore.firestore()
    //
    //        db.collection("users").document(id.u).updateData(["status":status]) { (err) in
    //
    //            if err != nil{
    //
    //                print(err!.localizedDescription)
    //                return
    //            }
    //
    //            print("success")
    //
    ////            for i in 0..<self.users.count{
    ////
    ////                if self.users[i].id == id.id{
    ////                    self.users[i].swipe = 500
    ////                    //                    if status == "liked"{
    ////                    //                        print("liked")
    ////                    //
    ////                    //                        self.users[i].swipe = 500
    ////                    //                    }
    ////                    //                    else if status == "reject"{
    ////                    //
    ////                    //                        self.users[i].swipe = -500
    ////                    //                    }
    ////                    //                    else{
    ////                    //                        print("ㅁㄴㅇㄹㅁㄴㅇ")
    ////                    //
    ////                    //                        self.users[i].swipe = 0
    ////                    //                    }
    ////                }
    ////            }
    //
    //            if status == "voted"{
    //
    //                db.collection("voted").document(id.id).setData(["name":id.name,"age":id.age,"image":id.image]) { (err) in
    //
    //                    if err != nil{
    //
    //                        print((err?.localizedDescription)!)
    //                        return
    //                    }
    //                }
    //            }
    //
    //
    //        }
    //    }
    
}


