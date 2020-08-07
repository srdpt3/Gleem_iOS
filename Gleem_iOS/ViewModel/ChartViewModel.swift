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
//    @Published var voteData: Vote?
    @Published var error: NSError?
    
    //    @Published var voteData : [Int]?
    
    @Published var someOneVoted = [Activity]()

    //    var listener: ListenerRegistration!
    
    
    @Published var vote : Vote?
    
//    @Published var totalNum : Int = 0
//    @Published var voteData:[Double] = []
//    @Published var voteNum:[Int] = []
//    @Published var buttonTitle : [String] = ["없음", "없음","없음", "없음", "없음"]
//    @Published var noVotePic : Bool = false
//    @Published var votePiclocation : String = ""
//    @Published var date : Double = 0
//
//    @State var ymax : Int = 100

    
    
    
//    func loadChartData(){
//
//        self.loadChartData(userId: User.currentUser()!.id) { (vote) in
//            self.vote = vote
//            if vote.attrNames.count == 0 {
//                self.noVotePic = true
//                self.voteData = [0,0,0,0,0]
//                self.totalNum = 0
////                self.obs.updateVoteImage = false
////                self.uploadMsg = NEW_UPLOAD2
//                return
//            }else{
//
////                self.uploadMsg = NEW_UPLOAD
//
////                self.obs.updateVoteImage = true
//                self.voteData.removeAll()
//                self.voteNum.removeAll()
//                self.buttonTitle.removeAll()
//                if(vote.numVote == 0){
//                    self.voteData = [0,0,0,0,0]
//                    self.totalNum = 0
//                }else{
//                    let attr1 = (Double(vote.attr1) / Double(vote.numVote) * 100).roundToDecimal(0)
//                    let attr2 = (Double(vote.attr2) / Double(vote.numVote) * 100).roundToDecimal(0)
//                    let attr3 = (Double(vote.attr3) / Double(vote.numVote) * 100).roundToDecimal(0)
//                    let attr4 = (Double(vote.attr4) / Double(vote.numVote) * 100).roundToDecimal(0)
//                    let attr5 = (Double(vote.attr5) / Double(vote.numVote) * 100).roundToDecimal(0)
//
//                    self.voteData = [attr1, attr2, attr3, attr4, attr5]
//
//                    if(attr1 > 80 ||  attr2 > 80  || attr3 > 80  || attr4 > 80  || attr5 > 80 ){
//                        self.ymax  = 100
//                    }else if(attr1 > 70 ||  attr2 > 70  || attr3 > 70  || attr4 > 70  || attr5 > 70 ){
//                        self.ymax  = 80
//                    }else  if(attr1 > 60 ||  attr2 > 60  || attr3 > 60  || attr4 > 60  || attr5 > 60 ){
//                        self.ymax  = 70
//                    }else if(attr1 > 50 ||  attr2 > 50  || attr3 > 50  || attr4 > 50  || attr5 > 50 ){
//                        self.ymax  = 60
//                    }else  if(attr1 > 40 ||  attr2 > 40  || attr3 > 40  || attr4 > 40  || attr5 > 40 ){
//                        self.ymax  = 50
//                    }else if(attr1 > 30 ||  attr2 > 30  || attr3 > 30  || attr4 > 30  || attr5 > 30 ){
//                        self.ymax  = 40
//                    }else if(attr1 > 20 ||  attr2 > 20  || attr3 > 20  || attr4 > 20  || attr5 > 20 ){
//                        self.ymax  = 30
//                    }else{
//                        self.ymax = 20
//                    }
//
//                    //                    if(self.voteData.max()! < 98.0 ){
//                    //                        self.ymax = Int(self.voteData.max()!) + 2
//                    //
//                    //                    }else{
//                    //                                             self.ymax = Int(self.voteData.max()!)
//                    //                    }
//
//                }
//
//                self.voteNum.append(vote.attr1)
//                self.voteNum.append(vote.attr2)
//                self.voteNum.append(vote.attr3)
//                self.voteNum.append(vote.attr4)
//                self.voteNum.append(vote.attr5)
//
//                self.totalNum = vote.numVote
//                //                self.totalNum = 100
//                //                print(self.voteData)
//                //                print( self.totalNum)
//                self.date = vote.createdDate
//                self.buttonTitle = vote.attrNames
//                self.votePiclocation = vote.imageLocation
//            }
//
//
//
//        }
//    }

    func loadSomeoneVoted() {
        isLoading = true
        self.someOneVoted.removeAll()
        Ref.FIRESTORE_COLLECTION_WHO_VOTED.document(User.currentUser()!.id).collection("voted").order(by: "date", descending: true).limit(to: 6).addSnapshotListener({ (querySnapshot, error) in
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
                    
//
                    if(self.someOneVoted.count == 1 && self.someOneVoted[0].userAvatar == ""){
                        self.someOneVoted.removeAll()
                    }
                    
                    self.someOneVoted.append(decoderActivity)
                case .modified:
                    print("type: modified")
                case .removed:
                    print("type: removed")
                }
                
            }
            if (self.someOneVoted.isEmpty){
                let activity = Activity(activityId: "", type: "", username: "", userId: "", userAvatar: "", message: "", date: 0)
                self.someOneVoted.append(activity)
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
