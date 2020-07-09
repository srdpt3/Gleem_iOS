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
        
        Ref.FIRESTORE_COLLECTION_VOTE_USERID(userId: userId).addSnapshotListener { (querySnapshot, error) in
            guard let document = querySnapshot else {
                print("No documents")
                return
            }
            
            var data : Vote?
//            for document in documents {
                
                if(document.documentID == userId){
                    let dict = document.data()
                    guard let decoderPost = try? Vote.init(fromDictionary: dict) else {return}
                    data = decoderPost
                    print(decoderPost)
                    self.isLoading = false
                    
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
