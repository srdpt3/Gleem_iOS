//
//  UserApi.swift
//  Gleem_Dating
//
//  Created by Dustin yang on 6/29/20.
//  Copyright © 2020 Dustin yang. All rights reserved.
//

import Foundation
import SwiftUI
import FirebaseAuth



class UserApi {
    
    func searchFollowingUser(userId: String, onSuccess: @escaping(_ users: [User]) -> Void) {
        Ref.FIRESTORE_COLLECTION_FOLLOWING(userId: userId).getDocuments { (snapshot, error) in
            var users = [User]()
            
            for document in snapshot!.documents {
                let dict = document.data()
                guard let decoderUser = try? User.init(fromDictionary: dict) else {return}
                
                if decoderUser.id != Auth.auth().currentUser!.uid {
                    users.append(decoderUser)
                }
            }
            
            onSuccess(users)
            
        }
        
    }
    
    func searchFollowerUser(userId: String, onSuccess: @escaping(_ users: [User]) -> Void) {
        Ref.FIRESTORE_COLLECTION_FOLLOWERS(userId: userId).getDocuments { (snapshot, error) in
            
            print("FIRESTORE_COLLECTION_FOLLOWERS \(userId)")
            var users = [User]()
            
            for document in snapshot!.documents {
                let dict = document.data()
                guard let decoderUser = try? User.init(fromDictionary: dict) else {return}
                
                if decoderUser.id != Auth.auth().currentUser!.uid {
                    users.append(decoderUser)
                }
            }
            
            onSuccess(users)
            
        }
        
    }
    
    
    func searchUsers(text: String, onSuccess: @escaping(_ users: [User]) -> Void) {
        Ref.FIRESTORE_COLLECTION_USERS.whereField("keywords", arrayContains: text.lowercased()).getDocuments { (snapshot, error) in
            guard let snap = snapshot else {
                print("Error fetching data")
                return
            }
            print(snap.documents)
            var users = [User]()
            for document in snap.documents {
                let dict = document.data()
                guard let decoderUser = try? User.init(fromDictionary: dict) else {return}
                if decoderUser.id != Auth.auth().currentUser!.uid {
                    users.append(decoderUser)
                }
                
            }
            onSuccess(users)
        }
    }
//    
//    func loadPosts(userId: String, onSuccess: @escaping(_ posts: [MyList]) -> Void) {
//        Ref.FIRESTORE_GET_MYLIST_USERID(userId: userId).getDocuments { (snapshot, error) in
//            
//            guard let snap = snapshot else {
//                print("Error fetching data")
//                return
//            }
//            var posts = [MyList]()
//            for document in snap.documents {
//                let dict = document.data()
//                guard let decoderPost = try? MyList.init(fromDictionary: dict) else {return}
//                
//                posts.append(decoderPost)
//            }
//            onSuccess(posts)
//        }
//    }
//    
//    func isUserLiked(id: Int, onSuccess: @escaping(_ posts: Bool) -> Void) {
//        var result: Bool = false
//        Ref.FIRESTORE_COLLECTION_MYLIST_USERID(userId: Auth.auth().currentUser!.uid, movieId: id).getDocument { (document, error) in
//            if let doc = document, doc.exists {
//                result = true
//            } else {
//                result = false
//            }
//            onSuccess(result)
//
//        }
//        
////        Ref.FIRESTORE_COLLECTION_MYLIST.whereField("movies", arrayContains: id).getDocuments { (snapshot, error) in
////            guard let snap = snapshot else {
////                print("Error fetching data")
////                return
////            }
////
////
////            if(snapshot != nil){
////                result = true
////            }
////
////        }
//    }
}
