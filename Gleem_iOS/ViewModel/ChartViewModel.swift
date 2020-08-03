//
//  ChartViewModel.swift
//  Gleem_Dating
//
//  Created by Dustin yang on 7/2/20.
//  Copyright © 2020 Dustin yang. All rights reserved.
//

import SwiftUI
import Foundation

class ChartViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var voteData: Vote?
    @Published var error: NSError?
    
    //    @Published var voteData : [Int]?
    
    @Published var someOneVoted = [Activity]()

//    var listener: ListenerRegistration!
    
    func loadSomeoneVoted() {
        isLoading = true
        self.someOneVoted.removeAll()
        Ref.FIRESTORE_COLLECTION_WHO_VOTED.document(User.currentUser()!.id).collection("voted").order(by: "date", descending: true).addSnapshotListener({ (querySnapshot, error) in
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
                    self.someOneVoted.append(decoderActivity)
                case .modified:
                    print("type: modified")
                case .removed:
                    print("type: removed")
                }
                
            }

            
        })
        
        
    }
    
    func loadChartData(userId: String, onSuccess: @escaping(_ data: Vote) -> Void) {
        
        Ref.FIRESTORE_COLLECTION_ACTIVE_VOTE_USERID(userId: userId).addSnapshotListener { (querySnapshot, error) in
            guard let document = querySnapshot else {
                print("No documents")
                return
            }
            
            var data : Vote?
          
            if(document.documentID == userId && document.data() != nil){
                let _dictionary = document.data()!
                let attr1 = _dictionary["attr1"] as! Int
                let attr2 = _dictionary["attr2"] as! Int
                let attr3 = _dictionary["attr3"] as! Int
                let attr4 = _dictionary["attr4"] as! Int
                let attr5 = _dictionary["attr5"] as! Int
                let attrNames = _dictionary["attrNames"] as! [String]
                let numVote = _dictionary["numVote"] as! Int
                
                let createdDate = _dictionary["createdDate"] as! Double
                let lastModifiedDate = _dictionary["lastModifiedDate"] as! Double
                let imageLocation = _dictionary["imageLocation"] as! String

                data = Vote(attr1: attr1, attr2: attr2, attr3: attr3, attr4: attr4, attr5: attr5, attrNames: attrNames, numVote: numVote, createdDate: createdDate, lastModifiedDate: lastModifiedDate, imageLocation: imageLocation)
                
 
                self.isLoading = false
                
            }else{
                data = Vote(attr1: 0, attr2: 0, attr3: 0, attr4: 0, attr5: 0, attrNames: [], numVote: 0, createdDate: 0, lastModifiedDate: 0, imageLocation : User.currentUser()!.profileImageUrl)
            }
            
            onSuccess(data!)
            
            
        }

    }
    
    
    
}
