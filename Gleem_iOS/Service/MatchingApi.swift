//
//  MatchingApi.swift
//  Gleem_iOS
//
//  Created by Dustin yang on 7/19/20.
//  Copyright © 2020 Dustin yang. All rights reserved.
//

import SwiftUI

import SwiftUI

class MatchingApi{
    
    func persistMatching(user: Activity){
        
        let match = Match(date: Date().timeIntervalSince1970)
        guard let matchDict = try? match.toDictionary() else { return }
        
        let batch = Ref.FIRESTORE_ROOT.batch()
        
        
        // Matching
        let matchRef = Ref.FIRESTORE_COLLECTION_MATCH_USERID(userId: User.currentUser()!.id, userId2: user.userId)
        batch.setData(matchDict, forDocument: matchRef)
        
    
        // Activity
        let activityId = Ref.FIRESTORE_COLLECTION_ACTIVITY_USERID(userId: user.userId).collection("activity").document().documentID
        let activityObject = Activity(activityId: activityId, type: "match", username: User.currentUser()!.username, userId: User.currentUser()!.id, userAvatar: User.currentUser()!.profileImageUrl, message: "", date: Date().timeIntervalSince1970, read: false, age: user.age, location: user.location,occupation: user.occupation, description: user.description)
        guard let activityDict = try? activityObject.toDictionary() else { return }
           let activityRef  = Ref.FIRESTORE_COLLECTION_ACTIVITY_USERID(userId: user.userId).collection("activity").document(activityId)
        batch.setData(activityDict, forDocument: activityRef)

        
        
        let activityId2 = Ref.FIRESTORE_COLLECTION_ACTIVITY_USERID(userId: User.currentUser()!.id).collection("activity").document().documentID
        let activityObject2 = Activity(activityId: activityId2, type: "match_request", username: user.username, userId: user.userId, userAvatar: user.userAvatar, message: "", date: Date().timeIntervalSince1970, read: false,  age: User.currentUserProfile()!.age, location: User.currentUserProfile()!.location,occupation: User.currentUserProfile()!.occupation, description: User.currentUserProfile()!.description)
        guard let activityDict2 = try? activityObject2.toDictionary() else { return }
        
        
        let activityRef2  = Ref.FIRESTORE_COLLECTION_ACTIVITY_USERID(userId: User.currentUser()!.id).collection("activity").document(activityId2)
        batch.setData(activityDict2, forDocument: activityRef2)
        print("Batch FIRESTORE_COLLECTION_ACTIVITY_USERID.")
        
        let someOnelikedRef =  Ref.FIRESTORE_COLLECTION_SOMEOME_LIKED_USERID(userId:User.currentUser()!.id).collection("liked").document(user.userId)
        
        batch.deleteDocument(someOnelikedRef)
        let someOnelikedRef2 =  Ref.FIRESTORE_COLLECTION_SOMEOME_LIKED_USERID(userId:user.userId).collection("liked").document(User.currentUser()!.id)
        
        batch.deleteDocument(someOnelikedRef2)
        
        
        //Delete from both I liked and oppoent's liked tables
        let iLikedRef =  Ref.FIRESTORE_COLLECTION_LIKED_USERID(userId:User.currentUser()!.id, userId2: user.userId)
        batch.deleteDocument(iLikedRef)
        let iLikedRef2 =  Ref.FIRESTORE_COLLECTION_LIKED_USERID(userId:user.userId, userId2: User.currentUser()!.id)
        batch.deleteDocument(iLikedRef2)
        
        
        //        //
        //        //
        //        let ilikedRef =  Ref.FIRESTORE_COLLECTION_LIKED_USERID(userId: User.currentUser()!.id).collection("liked").document(user.userId)
        //        batch.deleteDocument(ilikedRef)
        
        batch.commit() { err in
            if let err = err {
                print("Error writing batch \(err)")
            } else {
                print("Batch persistMatching write succeeded.")
                
                

//       
//                    LottieView(filename: "fireworks")
//                                   .frame(width: 300, height: 300)
           
                
                
            }
        }
        
        
        
        
    }
    
}
