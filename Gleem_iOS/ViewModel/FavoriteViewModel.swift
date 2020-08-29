//
//  FavoriteViewModel.swift
//  Gleem_Dating
//
//  Created by Dustin yang on 7/6/20.
//  Copyright © 2020 Dustin yang. All rights reserved.
//

import SwiftUI
import Firebase

class FavoriteViewModel: ObservableObject {
    @Published var isSucess = false
    @Published var liked : Bool = false
    
    @Published var favoriteUsers = [ActiveVote]()
    @Published var favoriteUsers_ids = [String]()
    
    @Published var error: NSError?
    @Published var isLoading = false
    @State var time = Timer.publish(every: 0.1, on: .main, in: .tracking).autoconnect()
    @Published var lastDoc : QueryDocumentSnapshot!
    //    var splitted: [[User]] = []
    
    func addToMyList(user: ActiveVote) {
        
        guard let dict = try? user.toDictionary() else {return}
        let batch = Ref.FIRESTORE_ROOT.batch()
        
        let likeRef = Ref.FIRESTORE_COLLECTION_LIKED_USERID(userId: User.currentUser()!.id,  userId2: user.id)
        batch.setData(dict, forDocument: likeRef)
        
        if User.currentUser()!.id != user.id {
            
            //            let someoneLikeId = Ref.FIRESTORE_COLLECTION_SOMEOME_LIKED_USERID(userId: user.id).collection("liked").document().documentID
            
            
            let someoneLikeObject = Activity(activityId: User.currentUser()!.id, type: "like", username: User.currentUser()!.username, userId: User.currentUser()!.id, userAvatar: User.currentUser()!.profileImageUrl, message: "", date: Date().timeIntervalSince1970, read: false, age: User.currentUserProfile()!.age, location: User.currentUserProfile()!.location,occupation: User.currentUserProfile()!.occupation, description: User.currentUserProfile()!.description)
            guard let activityDict = try? someoneLikeObject.toDictionary() else { return }
            
            
            let someOneLikeRef  = Ref.FIRESTORE_COLLECTION_SOMEOME_LIKED_USERID(userId: user.id).collection("liked").document(User.currentUser()!.id)
            batch.setData(activityDict, forDocument: someOneLikeRef)
            
            
            print("Batch FIRESTORE_COLLECTION_SOMEOME_LIKED_USERID.")
            
            
            
//            let activityId = Ref.FIRESTORE_COLLECTION_ACTIVITY_USERID(userId: user.id).collection("activity").document().documentID
//            //            let activityId = Ref.FIRESTORE_COLLECTION_ACTIVITY_USERID(userId: user.id).collection("activity").document().documentID
            let activityObject = Activity(activityId: User.currentUser()!.id, type: "like", username: User.currentUser()!.username, userId: User.currentUser()!.id, userAvatar: User.currentUser()!.profileImageUrl, message: "", date: Date().timeIntervalSince1970, read: false, age: User.currentUserProfile()!.age, location: User.currentUserProfile()!.location,occupation: "", description: "")
            guard let activityDict2 = try? activityObject.toDictionary() else { return }
            let activityRef  = Ref.FIRESTORE_COLLECTION_ACTIVITY_USERID(userId: user.id).collection("activity").document(User.currentUser()!.id)
            batch.setData(activityDict2, forDocument: activityRef)
            
            
            
            print("Batch FIRESTORE_COLLECTION_ACTIVITY_USERID.")
            
        }
        
        
        
        batch.commit() { err in
            if let err = err {
                print("Error writing batch \(err)")
            } else {
                print("Batch addToMyList write succeeded.")
                self.isSucess = true
            }
        }
        
        
        
        
        
        
    }
    
    
    func checkLiked2(id: String) -> Bool {
        var result : Bool = false
        Ref.FIRESTORE_COLLECTION_LIKED_USERID(userId: User.currentUser()!.id,  userId2: id).getDocument { (document, error) in
            if let doc = document, doc.exists {
                result = true
            } else {
                result =  false
            }
        }
        return result
    }
    
    func checkLiked(id: String) {
        
        Ref.FIRESTORE_COLLECTION_LIKED_USERID(userId: User.currentUser()!.id,  userId2: id).getDocument { (document, error) in
            if let doc = document, doc.exists {
                self.liked = true
            } else {
                self.liked  = false
            }
        }
    }
    
    
    func removeFromList(id : String){
        Ref.FIRESTORE_COLLECTION_LIKED_USERID(userId: User.currentUser()!.id,  userId2: id).getDocument { (document, error) in
            if let doc = document, doc.exists {
                doc.reference.delete()
                print("Removed sucessfully from liked : \(id) ")
                
            }
            
            
        }
        
        Ref.FIRESTORE_COLLECTION_SOMEOME_LIKED_USERID(userId: id).getDocument { (document, error) in
            if let doc = document, doc.exists {
                doc.reference.delete()
                print("Removed sucessfully from someone_liked : \(id) ")
                
            }
        }
    }
    
    
    
    func loadFavoriteUsers() {
        isLoading = true
        favoriteUsers.removeAll()
        favoriteUsers_ids.removeAll()
        Ref.FIRESTORE_GET_LIKED_USERID_COLLECTION(userId: User.currentUser()!.id).order(by: "createdDate",descending: true).limit(to: 30).getDocuments { (snapshot, error) in
            if(error != nil){
                print((error?.localizedDescription)!)
                //                self.error = (error?.localizedDescription as! NSError)
            }
            
            for document in snapshot!.documents {
                
                let dict = document.data()
                guard let decoderPost = try? ActiveVote.init(fromDictionary: dict) else {return}
                
                self.favoriteUsers.append(decoderPost)
                self.favoriteUsers_ids.append(decoderPost.id)
            }
            self.isLoading = false
            while (self.favoriteUsers.count < 12){
                let activeUser = ActiveVote(attr1: 0, attr2: 0, attr3: 0, attr4: 0, attr5: 0, attrNames: [], numVote: 0, createdDate: 0, lastModifiedDate: 0, id: "", email: "", imageLocation: "", username: "", age: "", sex: "",location: "", occupation: "", description: "")
                self.favoriteUsers.append(activeUser)
            }
            
            while (self.favoriteUsers.count % 3 != 0){
                let activeUser = ActiveVote(attr1: 0, attr2: 0, attr3: 0, attr4: 0, attr5: 0, attrNames: [], numVote: 0, createdDate: 0, lastModifiedDate: 0, id: "", email: "", imageLocation: "", username: "", age: "", sex: "", location: "", occupation: "", description: "")
                self.favoriteUsers.append(activeUser)
                
            }
            
            
            self.lastDoc = snapshot!.documents.last
            
            
        }
        
        
    }
    
    
    func updateFavoriteUsers() {
        isLoading = true
        //        favoriteUsers.removeAll()
        //        favoriteUsers_ids.removeAll()
        if self.lastDoc != nil{
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                
                print(self.favoriteUsers.count)
                
                Ref.FIRESTORE_GET_LIKED_USERID_COLLECTION(userId: User.currentUser()!.id).order(by: "createdDate",descending: false).start(afterDocument: self.lastDoc).limit(to: 9).getDocuments { (snapshot, error) in
                    if(error != nil){
                        print((error?.localizedDescription)!)
                        //                self.error = (error?.localizedDescription as! NSError)
                    }
                    self.favoriteUsers.removeLast()
                    for document in snapshot!.documents {
                        
                        let dict = document.data()
                        guard let decoderPost = try? ActiveVote.init(fromDictionary: dict) else {return}
                        
                        self.favoriteUsers.append(decoderPost)
                        self.favoriteUsers_ids.append(decoderPost.id)
                    }
                    self.isLoading = false
                    
                    if (self.favoriteUsers.isEmpty){
                        while (self.favoriteUsers.count < 12){
                            let activeUser = ActiveVote(attr1: 0, attr2: 0, attr3: 0, attr4: 0, attr5: 0, attrNames: [], numVote: 0, createdDate: 0, lastModifiedDate: 0, id: "", email: "", imageLocation: "", username: "", age: "", sex: "", location: "",occupation: "", description: "")
                            self.favoriteUsers.append(activeUser)
                        }
                        
                    }else{
                        while (self.favoriteUsers.count % 3 != 0){
                            let activeUser = ActiveVote(attr1: 0, attr2: 0, attr3: 0, attr4: 0, attr5: 0, attrNames: [], numVote: 0, createdDate: 0, lastModifiedDate: 0, id: "", email: "", imageLocation: "", username: "", age: "", sex: "", location:"",occupation: "", description: "")
                            self.favoriteUsers.append(activeUser)
                        }
                    }
                    print("final \(self.favoriteUsers.count)")
                    
                    self.lastDoc = snapshot!.documents.last
                    
                }
            }
        }
        
        
        
        
        
        
        //        self.splitted = self.favoriteUsers.chunked(3)
        
        
    }
}

