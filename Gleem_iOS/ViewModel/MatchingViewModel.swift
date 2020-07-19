//
//  MatchingViewModel.swift
//  Gleem_iOS
//
//  Created by Dustin yang on 7/19/20.
//  Copyright © 2020 Dustin yang. All rights reserved.
//

import Foundation
import FirebaseAuth
import Firebase
import FirebaseStorage
import SwiftUI


class MatchingViewModel: ObservableObject {
    @Published var matchArray: [Match] =  [Match]()
    @Published var error: NSError?
    @Published var isLoading = false
    
    
    var listener: ListenerRegistration!
    
    func persistMatching(user: Activity) {
      
        Api.Match.persistMatching(user: user)
        
    }
    
    
    
    
     func loadMatching() {
         isLoading = true
         listener = Ref.FIRESTORE_COLLECTION_SOMEOME_LIKED_USERID(userId: User.currentUser()!.id).collection("liked").order(by: "date", descending: true).addSnapshotListener({ (querySnapshot, error) in
             guard let snapshot = querySnapshot else {
                 return
             }
             
             snapshot.documentChanges.forEach { (documentChange) in
                 switch documentChange.type {
                 case .added:
                     //                    var activityArray = [Activity]()
                     print("type: added")
                     let dict = documentChange.document.data()
                     guard let decoderActivity = try? Match.init(fromDictionary: dict) else {return}
                     self.matchArray.append(decoderActivity)
                 case .modified:
                     print("type: modified")
                 case .removed:
                     print("type: removed")
                 }

             }
             
         })
         
         
     }




}

