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
    @Published var totalVoted : Int = 0
    @Published var totalSkipped : Int = 0
    @Published var totalFlagged: Int = 0
    
    @Published var votedCards = [String]()
    @Published var isLoading = false
    var updatedValueDict = ["attr1":0 , "attr2":0, "attr3":0, "attr4":0, "attr5":0]
    var buttonTitle : [String] = ["없음", "없음","없음", "없음", "없음"]
    
    
    
    func getNumVoted(){
        self.totalSkipped = 0
        self.totalSkipped = 0
        self.totalVoted = 0

        Ref.FIRESTORE_COLLECTION_MYVOTE.document(User.currentUser()!.id).collection("voted").getDocuments { (snap, error) in
            self.votedCards.removeAll()
            if error != nil {
                print((error?.localizedDescription)!)
                
            }
            
            
            for i in snap!.documents{
                let dict = i.data()
                guard let decoderActivity = try? MyVote.init(fromDictionary: dict) else {return}
                
                let id = i.documentID
                if(id != Auth.auth().currentUser?.uid){
                    self.votedCards.append(decoderActivity.userId)
                    
                    if(decoderActivity.comment == "SKIPPED"){
                        self.totalSkipped = self.totalSkipped + 1
                        
                    }else if(decoderActivity.comment == "FLAGGED"){
                        self.totalFlagged = self.totalFlagged + 1
                        
                    }else{
                        self.totalVoted  = self.totalVoted  + 1
                    }
                }
                
            }
        }
    }
    
    func skip(id: String) {
        
        //batch writing. vote multiple entries
        let batch = Ref.FIRESTORE_ROOT.batch()
        
        //        let myVote = Vote(attr1: 0, attr2 : 0 , attr3 : 1 , attr4: 2, attr5: 0,attrNames:buttonTitle)
        //        guard let dict = try? myVote.toDictionary() else {return}
        let myVoteRef = Ref.FIRESTORE_COLLECTION_MYVOTE_USERID(userId: id)
        
        let myVote = MyVote(userId: id, myVotes: updatedValueDict, attrNames: buttonTitle, voteDate: Date().timeIntervalSince1970, comment: "SKIPPED")
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
    
    
    func flagged(id: String) {
        
        //batch writing. vote multiple entries
        let batch = Ref.FIRESTORE_ROOT.batch()
        
        //        let myVote = Vote(attr1: 0, attr2 : 0 , attr3 : 1 , attr4: 2, attr5: 0,attrNames:buttonTitle)
        //        guard let dict = try? myVote.toDictionary() else {return}
        let myVoteRef = Ref.FIRESTORE_COLLECTION_MYVOTE_USERID(userId: id)
        
        let myVote = MyVote(userId: id, myVotes: updatedValueDict, attrNames: buttonTitle, voteDate: Date().timeIntervalSince1970, comment: "FLAGGED")
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
    
    
    
    
    
    
    
    func persist(id: String , buttonPressed : [Bool], buttonTitle : [String]) {
        
        //batch writing. vote multiple entries
        let batch = Ref.FIRESTORE_ROOT.batch()
        let currentUser = User.currentUser()!
        //Update User Point
        
        let updated_point = currentUser.point_avail + POINT_USE
        let user = User.init(id: currentUser.id, email: currentUser.email, profileImageUrl: currentUser.profileImageUrl, username: currentUser.username, age: currentUser.age, sex: currentUser.sex, createdDate:  currentUser.createdDate, point_avail: updated_point)
        guard let userDict = try? user.toDictionary() else {return}

        
        saveUserLocally(mUserDictionary: userDict as NSDictionary)
        
        
        let firestoreUserId = Ref.FIRESTORE_DOCUMENT_USERID(userId: User.currentUser()!.id)
        batch.updateData(["point_avail" : updated_point], forDocument: firestoreUserId)

        
        
        
        
        
        let voteRef = Ref.FIRESTORE_COLLECTION_ACTIVE_VOTE.document(id)
        for (index, button) in buttonPressed.enumerated() {
            if (button){
                let key = (index == 0 ? "attr1" :  (index == 1 ? "attr2" : (index == 2 ? "attr3" : (index == 3 ? "attr4" : "attr5" ) )))
                print("\(index + 1). \(buttonTitle[index])  \(key)")
                updatedValueDict[key] = 1
                batch.updateData([key : FieldValue.increment(Int64(1))], forDocument: voteRef)
                
            }
        }
        batch.updateData([VOTE_NUMBER : FieldValue.increment(Int64(1))], forDocument: voteRef)
        
        //        let myVote = Vote(attr1: 0, attr2 : 0 , attr3 : 1 , attr4: 2, attr5: 0,attrNames:buttonTitle)
        //        guard let dict = try? myVote.toDictionary() else {return}
        let myVoteRef = Ref.FIRESTORE_COLLECTION_MYVOTE_USERID(userId: id)
        
        let myVote = MyVote(userId: id, myVotes: updatedValueDict, attrNames: buttonTitle, voteDate: Date().timeIntervalSince1970, comment: "")
        guard let dict = try? myVote.toDictionary() else {return}
        batch.setData(dict, forDocument: myVoteRef)
        
        
        let someoneVoteObject = Activity(activityId: User.currentUser()!.id, type: "voted", username: User.currentUser()!.username, userId: User.currentUser()!.id, userAvatar: User.currentUser()!.profileImageUrl, message: "", date: Date().timeIntervalSince1970, read: false, age: User.currentUserProfile()!.age, location: User.currentUserProfile()!.location,occupation: User.currentUserProfile()!.occupation, description: User.currentUserProfile()!.description)
        guard let someOneVotedDict = try? someoneVoteObject.toDictionary() else { return }
        
        
        print("voted")
        let someOneVoteRef  = Ref.FIRESTORE_COLLECTION_WHO_VOTED_USERID(userId: id)
        batch.setData(someOneVotedDict, forDocument: someOneVoteRef)
        
        
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

