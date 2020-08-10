//
//  HistoryViewModel.swift
//  Gleem_iOS
//
//  Created by Dustin yang on 8/9/20.
//  Copyright © 2020 Dustin yang. All rights reserved.
//

import SwiftUI
import FirebaseAuth
import Firebase
import FirebaseStorage

class HistoryViewModel: ObservableObject {
    @Published var isSucess = false
    @Published var isLoading = false
    @Published var historicData  = [Vote]()
    
    //     var buttonPressed = [Bool]()
    var selectedButton = [String]()
    
    func persistPastVoteData(vote: Vote) {
        isLoading = true
        
        //        let date: Double = Date().timeIntervalSince1970
        
        guard let finalDict = try? vote.toDictionary() else {return}
        
        Ref.FIRESTORE_COLLECTION_HISTORIC_VOTE_DATA_USERID(voteId: UUID().uuidString).setData(finalDict) { (error) in
            if error != nil {
                print(error!.localizedDescription)
                return
                
            }
            
            self.isLoading = true
        }
        
    }
    func loadHistoricData() {
        isLoading = true
        
        //        let date: Double = Date().timeIntervalSince1970
        
        
        Ref.FIRESTORE_COLLECTION_HISTORIC_VOTE_DATA.document(User.currentUser()!.id).collection("past_vote").order(by: "lastModifiedDate", descending: true).limit(to: 10).getDocuments { (snapshot, error) in
            self.historicData.removeAll()
            if error != nil {
                print(error!.localizedDescription)
                return
                
            }
            for document in snapshot!.documents {
                let dict = document.data()
                guard let decoderUser = try? Vote.init(fromDictionary: dict) else {return}
                self.historicData.append(decoderUser)
            }
            
        }
        
        
    }
    
    
    
}

