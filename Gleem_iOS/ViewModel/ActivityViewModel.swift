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
import UserNotifications

class ActivityViewModel: ObservableObject {
    @Published var error: NSError?
    @Published var isLoading = false
    @Published var activityArray = [Activity]()
    @Published var someOneLiked = [Activity]()

    var listener: ListenerRegistration!
    
    func loadSomeOneLike() {
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
                    guard let decoderActivity = try? Activity.init(fromDictionary: dict) else {return}
                    if(decoderActivity.type == "like"){
                        self.send()
                    }
                    self.someOneLiked.append(decoderActivity)
                case .modified:
                    print("type: modified")
                case .removed:
                    print("type: removed")
                }

            }
            
            if (self.someOneLiked.isEmpty){
                let activity = Activity(activityId: "", type: "", username: "", userId: "", userAvatar: "", message: "", date: 0)
                self.someOneLiked.append(activity)
            }
            
            
        })
        
        
    }
    
    
    func loadActivities() {
        isLoading = true
        listener = Ref.FIRESTORE_COLLECTION_ACTIVITY_USERID(userId: User.currentUser()!.id).collection("activity").order(by: "date", descending: true).addSnapshotListener({ (querySnapshot, error) in
            guard let snapshot = querySnapshot else {
                return
            }
            
            snapshot.documentChanges.forEach { (documentChange) in
                switch documentChange.type {
                case .added:
                    //                    var activityArray = [Activity]()
                    print("type: added")
//                    self.send()

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
    
    func send(){
        print("send notification")
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.badge,.sound]) { (_, _) in
            
        }
        
        let content = UNMutableNotificationContent()
        content.title = "끌림 +1"
        content.body = "누군가 나에게 끌림을 주었습니다"
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let req = UNNotificationRequest(identifier: "req", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(req, withCompletionHandler: nil)
    }
    
}
