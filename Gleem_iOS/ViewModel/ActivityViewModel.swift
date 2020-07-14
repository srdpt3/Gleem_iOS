//
//  ActivityViewModel.swift
//  Gleem_iOS
//
//  Created by Dustin yang on 7/13/20.
//  Copyright © 2020 Dustin yang. All rights reserved.
//


import Foundation
import SwiftUI
import Firebase


class ActivityViewModel: ObservableObject {
    @Published var error: NSError?
    @Published var isLoading = false
    @Published var activityArray = [Activity]()
    var listener: ListenerRegistration!
    
    func loadActivities() {
        isLoading = true
        listener = Ref.FIRESTORE_COLLECTION_SOMEOME_LIKED_USERID(userId: User.currentUser()!.id).collection("liked").order(by: "date", descending: false).addSnapshotListener({ (querySnapshot, error) in
            guard let snapshot = querySnapshot else {
                return
            }
            
            snapshot.documentChanges.forEach { (documentChange) in
                switch documentChange.type {
                case .added:
                    //                    var activityArray = [Activity]()
                    print("type: added")
                    let dict = documentChange.document.data()
                    guard let decoderActivity = try? Activity.init(fromDictionary: dict) else {return}
                    self.activityArray.append(decoderActivity)
                case .modified:
                    print("type: modified")
                case .removed:
                    print("type: removed")
                }

            }
            
        })
        
        
    }
    
}
