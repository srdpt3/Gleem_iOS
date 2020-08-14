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
    
    static func saveChatPhoto(messageId: String, senderId: String, senderUsername: String, senderAvatarUrl: String, recipientId: String, recipientAvatarUrl: String, recipientUsername: String, imageData: Data, metadata: StorageMetadata, storageChatRef: StorageReference, onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
        storageChatRef.putData(imageData, metadata: metadata) { (storageMetadata, error) in
            if error != nil {
                onError(error!.localizedDescription)
                return
            }
            storageChatRef.downloadURL { (url, error) in
                if let metaImageUrl = url?.absoluteString {
                    let chat = Chat(messageId: messageId, textMessage: "", avatarUrl: senderAvatarUrl, photoUrl: metaImageUrl, senderId: senderId, username: senderUsername, date: Date().timeIntervalSince1970, type: "PHOTO")
                    
                    guard let dict = try? chat.toDictionary() else { return }
                    
                    Ref.FIRESTORE_COLLECTION_CHATROOM(senderId: senderId, recipientId: recipientId).document(messageId).setData(dict) { (error) in
                        if error == nil {
                            Ref.FIRESTORE_COLLECTION_CHATROOM(senderId: recipientId, recipientId: senderId).document(messageId).setData(dict)
                            
                            let inboxMessage1 = InboxMessage(lastMessage: "사진", username: recipientUsername, type: "PHOTO", date: Date().timeIntervalSince1970, userId: recipientId, avatarUrl: recipientAvatarUrl)
                            let inboxMessage2 = InboxMessage(lastMessage: "사진", username: senderUsername, type: "PHOTO", date: Date().timeIntervalSince1970, userId: senderId, avatarUrl: senderAvatarUrl)
                            
                            guard let inboxDict1 = try? inboxMessage1.toDictionary() else { return }
                            guard let inboxDict2 = try? inboxMessage2.toDictionary() else { return }
                            
                            Ref.FIRESTORE_COLLECTION_INBOX_MESSAGES_DOCUMENT_USERID(senderId: senderId, recipientId: recipientId).setData(inboxDict1)
                            Ref.FIRESTORE_COLLECTION_INBOX_MESSAGES_DOCUMENT_USERID(senderId: recipientId, recipientId: senderId).setData(inboxDict2)
                            onSuccess()
                        } else {
                            onError(error!.localizedDescription)
                        }
                    }
                    
                }
            }
        }
        
    }
    
    
    static func saveVotePicture(myVote:Vote, userId: String, imageData: Data, metadata: StorageMetadata, storageAvatarRef: StorageReference){
        
        
        storageAvatarRef.putData(imageData, metadata: metadata) { (storageMetadata, error) in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            
            storageAvatarRef.downloadURL { (url, error) in
                if let metaImageUrl = url?.absoluteString {
                    
                    //                    guard let dict = try? myVote.toDictionary() else {return}
                    
                    
                    let firestoreUserId = Ref.FIRESTORE_DOCUMENT_USERID(userId: User.currentUser()!.id)
                    
                    firestoreUserId.updateData([
                        "profileImageUrl": metaImageUrl
                    ]) { err in
                        if let err = err {
                            print("Error updating document: \(err)")
                        } else {
                            print("Document successfully updated")
                        }
                    }
                    
                    
                    
                    
                    let user = User.currentUser()!
                    
                    let user_update = User.init(id: user.id, email: user.email, profileImageUrl: metaImageUrl, username: user.username, age: user.age, sex: user.sex, createdDate: user.createdDate, point_avail: user.point_avail)
                    guard let dict = try? user_update.toDictionary() else {return}
                    saveUserLocally(mUserDictionary: dict as NSDictionary)
                    
                    
                    
                    //                    let user =  User(id: userId, email: "test@gmail.com", profileImageUrl:  metaImageUrl, username: "test", age: "30", sex:"male",    swipe:0, degree: 0)
                    let data = ActiveVote(attr1: myVote.attr1, attr2: myVote.attr1, attr3: myVote.attr1, attr4: myVote.attr1, attr5: myVote.attr1, attrNames: myVote.attrNames, numVote: myVote.numVote, createdDate: myVote.createdDate, lastModifiedDate: myVote.lastModifiedDate, id: userId, email: user.email, imageLocation: metaImageUrl, username: user.username, age: user.age, sex: user.sex)
                    
                    guard let finalDict = try? data.toDictionary() else {return}
                    
                    
                    //                    let finalDict = dict.merging(userDict) { (_, new) in new }
                    
                    Ref.FIRESTORE_COLLECTION_ACTIVE_VOTE_USERID(userId:userId).setData(finalDict) { (error) in
                        if error != nil {
                            print(error!.localizedDescription)
                            return
                            
                        }
                    }
                    
                    
                    
                    Ref.FIRESTORE_COLLECTION_PENDING_VOTE_USERID(userId:userId).setData(finalDict) { (error) in
                        if error != nil {
                            print(error!.localizedDescription)
                            return
                            
                        }
                    }
                    
                    
                }
            }
            
        }
    }
    
    static func saveUser(userId: String, username: String, email: String, age: String, storageAvatarRef: StorageReference, gender: String,  onSuccess: @escaping(_ user: User) -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
        
        let batch = Ref.FIRESTORE_ROOT.batch()
        
        let user = User.init(id: userId, email: email, profileImageUrl: "", username: username, age: age, sex: gender, createdDate:  Date().timeIntervalSince1970, point_avail: INITIAL_POINT)
        
        guard let dict = try? user.toDictionary() else {return}
        saveUserLocally(mUserDictionary: dict as NSDictionary)
        
        if let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest() {
            changeRequest.displayName = username
            changeRequest.commitChanges { (error) in
                if error != nil {
                    onError(error!.localizedDescription)
                    return
                }
            }
        }
        let firestoreUserId = Ref.FIRESTORE_DOCUMENT_USERID(userId: userId)
        
        batch.setData(dict, forDocument: firestoreUserId)
        
        
        let activityId = Ref.FIRESTORE_COLLECTION_ACTIVITY_USERID(userId: userId).collection("activity").document().documentID
        let activityObject = Activity(activityId: activityId, type: "intro", username: User.currentUser()!.username, userId: User.currentUser()!.id, userAvatar: "", message: "", date: Date().timeIntervalSince1970)
        guard let activityDict = try? activityObject.toDictionary() else { return }
        
        
        let activityRef  = Ref.FIRESTORE_COLLECTION_ACTIVITY_USERID(userId:userId).collection("activity").document(activityId)
        batch.setData(activityDict, forDocument: activityRef)
        
        
        batch.commit() { err in
            if let err = err {
                print("Error writing batch \(err)")
            } else {
                print("Batch persistMatching write succeeded.")
                
            }
        }
        
    }
    
    
    static func saveAvatar(userId: String, username: String, email: String, imageData: Data, metadata: StorageMetadata, storageAvatarRef: StorageReference, gender: String,  onSuccess: @escaping(_ user: User) -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
        storageAvatarRef.putData(imageData, metadata: metadata) { (storageMetadata, error) in
            if error != nil {
                onError(error!.localizedDescription)
                return
            }
            
            storageAvatarRef.downloadURL { (url, error) in
                if let metaImageUrl = url?.absoluteString {
                    
                    
                    let batch = Ref.FIRESTORE_ROOT.batch()
                    
                    let user = User.init(id: userId, email: email, profileImageUrl: metaImageUrl, username: username, age: "N/A", sex: gender, createdDate:  Date().timeIntervalSince1970, point_avail: INITIAL_POINT)
                    
                    guard let dict = try? user.toDictionary() else {return}
                    saveUserLocally(mUserDictionary: dict as NSDictionary)
                    
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
                    
                    batch.setData(dict, forDocument: firestoreUserId)
                    
                    
                    let activityId = Ref.FIRESTORE_COLLECTION_ACTIVITY_USERID(userId: userId).collection("activity").document().documentID
                    let activityObject = Activity(activityId: activityId, type: "intro", username: User.currentUser()!.username, userId: User.currentUser()!.id, userAvatar: metaImageUrl, message: "", date: Date().timeIntervalSince1970)
                    guard let activityDict = try? activityObject.toDictionary() else { return }
                    
                    
                    let activityRef  = Ref.FIRESTORE_COLLECTION_ACTIVITY_USERID(userId:userId).collection("activity").document(activityId)
                    batch.setData(activityDict, forDocument: activityRef)
                    
                    //                    let userInfor = ["username": username, "email": email, "profileImageUrl": metaImageUrl]
                    //                    let user = User.init(uid: userId, email: email, profileImageUrl: metaImageUrl, username: username, bio: "", keywords: username.splitStringToArray())
                    //                    let user = User.init(uid: userId, email: email, profileImageUrl: metaImageUrl, username: username, bio: "")
                    
                    
                    
                    //
                    //                        guard let decoderUser = try? User.init(fromDictionary: dict) else {return}
                    //                        print(decoderUser.username)
                    
                    //                    firestoreUserId.setData() { (error) in
                    //                        if error != nil {
                    //                            onError(error!.localizedDescription)
                    //                            return
                    //                        }
                    //                        onSuccess(user)
                    //                    }
                    
                    batch.commit() { err in
                        if let err = err {
                            print("Error writing batch \(err)")
                        } else {
                            print("Batch persistMatching write succeeded.")
                            onSuccess(user)
                            
                            
                            //
                            //                    LottieView(filename: "fireworks")
                            //                                   .frame(width: 300, height: 300)
                            
                            
                            
                        }
                    }
                    
                }
            }
            
        }
    }
}
