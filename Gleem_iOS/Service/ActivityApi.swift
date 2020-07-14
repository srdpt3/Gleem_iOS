//
//  ActivityApi.swift
//  Gleem_iOS
//
//  Created by Dustin yang on 7/13/20.
//  Copyright © 2020 Dustin yang. All rights reserved.
//



import Foundation
import FirebaseAuth
import FirebaseStorage
import Firebase

class ActivityApi {
    var activityArray = [Activity]()

    
//    
//    func loadActivities(onSuccess: @escaping(_ activityArray: [Activity]) -> Void, newActivity: @escaping(Activity) -> Void, deleteActivity: @escaping(Activity) -> Void, listener: @escaping(_ listenerHandle: ListenerRegistration) -> Void) {
//        guard let userId = Auth.auth().currentUser?.uid else {
//                return
//        }
//        let listenerFirestore =  Ref.FIRESTORE_COLLECTION_SOMEOME_LIKED.document(userId).collection("liked").order(by: "date", descending: false).addSnapshotListener({ (querySnapshot, error) in
//            guard let snapshot = querySnapshot else {
//                   return
//            }
//
//            snapshot.documentChanges.forEach { (documentChange) in
//                  switch documentChange.type {
//                  case .added:
//
//                      print("type: added")
//                      let dict = documentChange.document.data()
//                      guard let decoderActivity = try? Activity.init(fromDictionary: dict) else {return}
//                      newActivity(decoderActivity)
//                      self.activityArray.append(decoderActivity)
//                      onSuccess(self.activityArray)
//                  case .modified:
//                      print("type: modified")
//                  case .removed:
//                      print("type: removed")
//                      let dict = documentChange.document.data()
//                       guard let decoderActivity = try? Activity.init(fromDictionary: dict) else {return}
//                       deleteActivity(decoderActivity)
//                  }
//            }
//            
//        })
//        
//        listener(listenerFirestore)
//    }
}
