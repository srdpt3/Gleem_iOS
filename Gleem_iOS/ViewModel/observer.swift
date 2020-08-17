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
    @Published var showTab : Bool = false
    @Published var gender : String = ""
    
    @Published var last = 0
    @Published var isLoading = false
    @Published var isInBoxLoading = false
    
    @Published var isVoteLoading = false
    @Published var isReloading = false
    
    @Published var activityArray = [Activity]()
    
    
    
    @Published var error: NSError?
    @Published var cardViews = [MainCardView]()
    
    @Published var index = -1;
    @Published var isLoggedIn = false
    
    @Published var votedCards = [String]()
    @Published var updateVoteImage : Bool = false
    
    var handle: AuthStateDidChangeListenerHandle?
    
    func getNewCards(){
        self.isVoteLoading = true
        
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
            print("voted count \(self.votedCards)")
            self.isVoteLoading = false
            
            
            print("vote finished")
            self.reload()
            
        }
    }
    
    func getCurrentCard() -> MainCardView {
        return self.cardViews.first!
    }
    
    func checkUserUploadVote() {
        
        Ref.FIRESTORE_COLLECTION_ACTIVE_VOTE_USERID(userId: User.currentUser()!.id).getDocument { (document, error) in
            if let document = document, document.exists {
                self.updateVoteImage = true
            }
        }
    }
    
    func listenAuthenticationState() {
        handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            if let user = user {
                
                print("listenAuthenticationState \(user.uid)")
                let firestoreUserId = Ref.FIRESTORE_DOCUMENT_USERID(userId: user.uid)
                firestoreUserId.getDocument { (document, error) in
                    if let dict = document?.data() {

                        //                        guard let decoderUser = try? User.init(fromDictionary: dict) else {return}
                        guard let decoderUser = try? User.init(_dictionary: dict as NSDictionary) else {return}
                        saveUserLocally(mUserDictionary: dict as NSDictionary)
                        self.checkUserUploadVote()

                        self.loadActivities()
                        self.getNewCards()
                        
                        
                        
                    }
                }
                
                
                
                //                if(!self.isVoteLoading && !self.votedCards.isEmpty){
                //                    print("vote finished")
                //                    self.reload()
                //                }
                
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
        
        
        if(self.users.count == 1 &&  index == 1){
            self.getNewCards()
            
        }
        
        if(self.users.count == 2 &&  index == 2){
            self.index += 1
            self.last += 1
            
        }else{
            
            if(self.index > self.users.count ){
                print("reload")
                
                self.getNewCards()
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
    
    func resetCache(){
        resetDefaults()
        URLCache.shared.removeAllCachedResponses()
    }
    
    func logout() {
        
        do {
            
            cardViews.removeAll()
            users.removeAll()
            resetCache()
            try Auth.auth().signOut()
            
            
            
            
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
    
    @Published var inboxMessages: [InboxMessage] = [InboxMessage]()
    // let objectWillChange = ObservableObjectPublisher()
    
    var listener: ListenerRegistration!
    

    func createCardView(){
        self.cardViews.removeAll()
        
        //Filtering
        //        if(!votedCards.isEmpty && !users.isEmpty){
        //
        //            for index in (0..<users.count).reversed() {
        //                let u = users[index]
        //                if votedCards.contains(u.id){
        //                    users.remove(at: index)
        //                    print("contained  \(u.id)")
        //                }
        //
        //            }
        //
        //            print("filtered User : \(users.count)")
        //
        //        }
        
        if(!users.isEmpty){
            var indexRange = 0
            
            if(self.users.count <= 2 && self.users.count > 0){
                indexRange = self.users.count
            }else if self.users.count > 2 {
                indexRange = 2
            }
            
            for index in 0..<indexRange {
                cardViews.append(MainCardView(user: users[index]))
            }
            self.index = self.cardViews.count
            
            print("reload \( self.index )")
        }
        
    }
    
    
    func reload(){
        //        DispatchQueue.main.async {
        self.isReloading = true
        let whereField = User.currentUser()!.sex == "female" ? "male" : "female"
        
        Ref.FIRESTORE_COLLECTION_ACTIVE_VOTE.whereField("sex", isEqualTo: whereField )
            .limit(to: 30)
            //            .order(by: "createdDate",descending: true)
            .getDocuments { (snap, err) in
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
                    }
                    
                }
                print("self.users.count \(self.users.count)")
                
                
                self.isReloading = false
                self.last = 0
                self.createCardView()
        }
        
        
        
        
        
    }
    
    func loadActivities() {
        //        isLoading = true
        
        listener = Ref.FIRESTORE_COLLECTION_ACTIVITY_USERID(userId: User.currentUser()!.id).collection("activity").order(by: "date", descending: true).addSnapshotListener({ (querySnapshot, error) in
            guard let snapshot = querySnapshot else {
                return
            }
            self.activityArray.removeAll()
            
            snapshot.documentChanges.forEach { (documentChange) in
                switch documentChange.type {
                case .added:
                    //                    var activityArray = [Activity]()
                    print("type: added")
                    //                    self.send()
                    
                    let dict = documentChange.document.data()
                    guard let decoderActivity = try? Activity.init(fromDictionary: dict) else {return}
                    
                    if(!decoderActivity.read) {
                        if(decoderActivity.type == "like"){
                            //                        self.send()
                            self.setNotification(msg:"누군가 나에게 끌림을 주었습니다")
                            self.updateRead(docId: decoderActivity.activityId)
                            print("liked")
                            
                        }else if(decoderActivity.type == "match"){
                            //                        self.send()
                            self.setNotification(msg:"축하해요! 이성과 연결이 되었습니다.")
                            print("matched")
                            self.updateRead(docId: decoderActivity.activityId)
                            
                        }
                        
                    }
                    
                    print(decoderActivity.activityId)
                    
                    
                    
                    self.activityArray.append(decoderActivity)
                case .modified:
                    print("type: modified")
                    let dict = documentChange.document.data()
                    guard let decoderActivity = try? Activity.init(fromDictionary: dict) else {return}
                    
                    if(!decoderActivity.read) {
                        if(decoderActivity.type == "like"){
                            //                        self.send()
                            self.setNotification(msg:"누군가 나에게 끌림을 주었습니다")
                            self.updateRead(docId: decoderActivity.activityId)
                            print("liked")
                            
                        }else if(decoderActivity.type == "match"){
                            //                        self.send()
                            self.setNotification(msg:"축하해요! 이성과 연결이 되었습니다.")
                            print("matched")
                            self.updateRead(docId: decoderActivity.activityId)
                            
                        }
                        
                    }
                case .removed:
                    print("type: removed")
                }
                
            }
            
        })
        
        
    }
    
    func setNotification(msg: String){
        let manager = LocalNotificationManager()
        manager.requestPermission()
        manager.addNotification(title: msg)
        manager.scheduleNotifications()
    }
    
    func  updateRead(docId : String){
        let firestoreUserId = Ref.FIRESTORE_COLLECTION_ACTIVITY_USERID(userId: User.currentUser()!.id).collection("activity").document(docId)
        firestoreUserId.updateData([
            "read": true
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
}


