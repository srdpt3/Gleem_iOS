//
//  StorageService.swift
//  Gleem_Dating
//
//  Created by Dustin yang on 6/29/20.
//  Copyright © 2020 Dustin yang. All rights reserved.
//



import Foundation
import Firebase

class StorageService {
    
    
    static func saveVotePicture(myVote:Vote, userId: String, imageData: Data, metadata: StorageMetadata, storageAvatarRef: StorageReference){
        
        
        storageAvatarRef.putData(imageData, metadata: metadata) { (storageMetadata, error) in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            
            storageAvatarRef.downloadURL { (url, error) in
                if let metaImageUrl = url?.absoluteString {
                    
                    guard let dict = try? myVote.toDictionary() else {return}
                    
                    
                    //                    vote["imageLocation"] = url
                    
                    Ref.FIRESTORE_COLLECTION_VOTE_USERID(userId:userId).setData(dict) { (error) in
                        if error != nil {
                            print(error!.localizedDescription)
                            return
                            
                        }
                    }
                    let user =  User(id: userId, email: "test@gmail.com", profileImageUrl:  metaImageUrl, username: "test", age: "30", sex:"maile",    swipe:0, degree: 0)
                    guard let userDict = try? user.toDictionary() else {return}
                    
                    
                    Ref.FIRESTORE_DOCUMENT_USERID(userId:userId).setData(userDict) { (error) in
                        if error != nil {
                            print(error!.localizedDescription)
                            return
                            
                        }
                    }
                    
                }
            }
            
        }
    }
    
    
    
    
    static func saveAvatar(userId: String, username: String, email: String, imageData: Data, metadata: StorageMetadata, storageAvatarRef: StorageReference, onSuccess: @escaping(_ user: User) -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
        storageAvatarRef.putData(imageData, metadata: metadata) { (storageMetadata, error) in
            if error != nil {
                onError(error!.localizedDescription)
                return
            }
            
            storageAvatarRef.downloadURL { (url, error) in
                if let metaImageUrl = url?.absoluteString {
                    if let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest() {
                        changeRequest.photoURL = url
                        changeRequest.displayName = username
                        changeRequest.commitChanges { (error) in
                            if error != nil {
                                onError(error!.localizedDescription)
                                return
                            }
                        }
                    }
                    
                    let firestoreUserId = Ref.FIRESTORE_DOCUMENT_USERID(userId: userId)
                    //                        let userInfor = ["username": self.username, "email": self.email, "profileImageUrl": metaImageUrl]
                    //                    let user = User.init(uid: userId, email: email, profileImageUrl: metaImageUrl, username: username, bio: "", keywords: username.splitStringToArray())
                    ////                    let user = User.init(uid: userId, email: email, profileImageUrl: metaImageUrl, username: username, bio: "")
                    //
                    //                    guard let dict = try? user.toDictionary() else {return}
                    //                    saveUserLocally(mUserDictionary: dict as NSDictionary)
                    //
                    //                    //
                    //                    //                        guard let decoderUser = try? User.init(fromDictionary: dict) else {return}
                    //                    //                        print(decoderUser.username)
                    //
                    //                    firestoreUserId.setData(dict) { (error) in
                    //                        if error != nil {
                    //                            onError(error!.localizedDescription)
                    //                            return
                    //                        }
                    //                        onSuccess(user)
                    //                    }
                }
            }
            
        }
    }
}
