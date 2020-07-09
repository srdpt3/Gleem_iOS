//
//  VoteViewModel.swift
//  Gleem_Dating
//
//  Created by Dustin yang on 7/2/20.
//  Copyright © 2020 Dustin yang. All rights reserved.
//

import SwiftUI
import Firebase

class VoteViewModel: ObservableObject {
    @Published var isSucess = false
    @Published var error: NSError?
    @Published var voted : Bool = false
    @Published var liked : Bool = false

    @Published var isLoading = false
    var updatedValueDict = ["attr1":0 , "attr2":0, "attr3":0, "attr4":0, "attr5":0]
    
    func persist(id: String , buttonPressed : [Bool], buttonTitle : [String]) {
        
        //batch writing. vote multiple entries
        let batch = Ref.FIRESTORE_ROOT.batch()
        let voteRef = Ref.FIRESTORE_COLLECTION_VOTE.document(id)
        
        for (index, button) in buttonPressed.enumerated() {
            if (button){
                print("\(index + 1). \(buttonTitle[index])")
                updatedValueDict[updatedValueDict[index].key] = 1
                batch.updateData([updatedValueDict[index].key : FieldValue.increment(Int64(1))], forDocument: voteRef)
                
            }
        }
        batch.updateData([VOTE_NUMBER : FieldValue.increment(Int64(1))], forDocument: voteRef)
        
        //        let myVote = Vote(attr1: 0, attr2 : 0 , attr3 : 1 , attr4: 2, attr5: 0,attrNames:buttonTitle)
        //        guard let dict = try? myVote.toDictionary() else {return}
        let myVoteRef = Ref.FIRESTORE_COLLECTION_MYVOTE_USERID(userId: id)
        
        let myVote = MyVote(userId: id, myVotes: updatedValueDict, attrNames: buttonTitle)
        guard let dict = try? myVote.toDictionary() else {return}
        batch.setData(dict, forDocument: myVoteRef)
        
        batch.commit() { err in
            if let err = err {
                print("Error writing batch \(err)")
            } else {
                print("Batch write succeeded.")
                self.isSucess = true
            }
        }
        
        
        
    }
    
    func checkVoted(id: String) {
        
        Ref.FIRESTORE_COLLECTION_MYVOTE_USERID(userId: id).getDocument { (document, error) in
            if let doc = document, doc.exists {
                self.voted = true
            } else {
                self.voted  = false
            }
            
        }
        
        
    }
    
 
    
}

