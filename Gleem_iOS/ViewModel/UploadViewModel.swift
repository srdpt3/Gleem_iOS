//
//  UploadViewModel.swift
//  Gleem_Dating
//
//  Created by Dustin yang on 7/1/20.
//  Copyright © 2020 Dustin yang. All rights reserved.
//

import SwiftUI
import FirebaseAuth
import Firebase
import FirebaseStorage

class UploadViewModel: ObservableObject {
    @Published var isSucess = false
    @Published var isLoading = false
    //     var buttonPressed = [Bool]()
    var selectedButton = [String]()
    func uploadVote(buttonPressed : [Bool], buttonTitle : [String],imageData: Data) {
        self.isLoading = true
        let date: Double = Date().timeIntervalSince1970
        let myVote = Vote(attr1: 0, attr2 : 0 , attr3 : 0 , attr4: 0, attr5: 0,attrNames:buttonTitle, numVote: 0, createdDate: date, lastModifiedDate: date, imageLocation: "")
        
        let storageAvatarUserId = Ref.STORAGE_VOTE_PIC_USERID(userId: UUID().uuidString)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        StorageService.saveVotePicture(myVote: myVote , userId: User.currentUser()!.id, imageData: imageData, metadata: metadata, storageAvatarRef: storageAvatarUserId)
        
        Ref.FIRESTORE_COLLECTION_WHO_VOTED.document(User.currentUser()!.id).collection("voted").getDocuments { (snapshot, error) in
            if error == nil {
                print("error for deleting someone voted me")
            }
            
            for doc in snapshot!.documents {
                doc.reference.delete()
                
                
            }
        }
        
        
        
        self.isLoading = false

        
 
    }
}



