//
//  ChartViewModel.swift
//  Gleem_Dating
//
//  Created by Dustin yang on 7/2/20.
//  Copyright © 2020 Dustin yang. All rights reserved.
//

import SwiftUI

class ChartViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var voteData: Vote?
    @Published var error: NSError?
    
    //    @Published var voteData : [Int]?
    
    
    
    //    func loadChartData(userId: String) {
    //        Ref.FIRESTORE_COLLECTION_VOTE.getDocuments { (snapshot, error) in
    //            print("asdfasdf")
    //            guard let snap = snapshot else {
    //                print("Error fetching data")
    //                return
    //            }
    //            //            var data : Vote?
    //            for document in snap.documents {
    //
    //                if(document.documentID == userId){
    //                    let dict = document.data()
    //                    guard let decoderPost = try? Vote.init(fromDictionary: dict) else {return}
    //                    self.voteData?.append(decoderPost.attr1)
    //                    self.voteData?.append(decoderPost.attr2)
    //                    self.voteData?.append(decoderPost.attr3)
    //                    self.voteData?.append(decoderPost.attr4)
    //                    self.voteData?.append(decoderPost.attr5)
    //
    //                    //                        print(decoderPost)
    //                }
    //
    //            }
    //
    //        }
    //    }
    
    
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
                data = Vote(attr1: attr1, attr2: attr2, attr3: attr3, attr4: attr4, attr5: attr5, attrNames: attrNames, numVote: numVote, createdDate: createdDate, lastModifiedDate: lastModifiedDate)
                
                
                
                //                    guard let decoderPost = try? Vote.init(fromDictionary: dict) else {return}
//                data = decoderPost
                self.isLoading = false
                
            }else{
                data = Vote(attr1: 0, attr2: 0, attr3: 0, attr4: 0, attr5: 0, attrNames: [], numVote: 0, createdDate: 0, lastModifiedDate: 0)
            }
            
            //            }
            onSuccess(data!)
            
            
        }
        //
        //            Ref.FIRESTORE_COLLECTION_VOTE.getDocuments { (snapshot, error) in
        //
        //                guard let snap = snapshot else {
        //                    print("Error fetching data")
        //                    self.error = error as! NSError
        //                    return
        //                }
        //                var data : Vote?
        //                for document in snap.documents {
        //
        //                    if(document.documentID == userId){
        //                        let dict = document.data()
        //                        guard let decoderPost = try? Vote.init(fromDictionary: dict) else {return}
        //                        data = decoderPost
        //                        print(decoderPost)
        //                        self.isLoading = false
        //
        //                    }
        //
        //                }
        //                onSuccess(data!)
        //            }
    }
    
    
    
}
