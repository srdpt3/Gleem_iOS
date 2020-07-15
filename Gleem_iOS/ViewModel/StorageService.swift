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
                            
                            let inboxMessage1 = InboxMessage(lastMessage: "PHOTO", username: recipientUsername, type: "PHOTO", date: Date().timeIntervalSince1970, userId: recipientId, avatarUrl: recipientAvatarUrl)
                            let inboxMessage2 = InboxMessage(lastMessage: "PHOTO", username: senderUsername, type: "PHOTO", date: Date().timeIntervalSince1970, userId: senderId, avatarUrl: senderAvatarUrl)
                            
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
                    
                    guard let dict = try? myVote.toDictionary() else {return}
                    
                    let user = User.currentUser()
                    //                    let user =  User(id: userId, email: "test@gmail.com", profileImageUrl:  metaImageUrl, username: "test", age: "30", sex:"male",    swipe:0, degree: 0)
                    let data = ActiveVote(attr1: myVote.attr1, attr2: myVote.attr1, attr3: myVote.attr1, attr4: myVote.attr1, attr5: myVote.attr1, attrNames: myVote.attrNames, numVote: myVote.numVote, createdDate: myVote.createdDate, lastModifiedDate: myVote.lastModifiedDate, id: userId, email: user!.email, imageLocation: metaImageUrl, username: user!.username, age: user!.age, sex: user!.sex)
                    
                    guard let finalDict = try? data.toDictionary() else {return}
                    
                    
                    //                    let finalDict = dict.merging(userDict) { (_, new) in new }
                    
                    Ref.FIRESTORE_COLLECTION_ACTIVE_VOTE_USERID(userId:userId).setData(finalDict) { (error) in
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
                    //                    let userInfor = ["username": username, "email": email, "profileImageUrl": metaImageUrl]
                    //                    let user = User.init(uid: userId, email: email, profileImageUrl: metaImageUrl, username: username, bio: "", keywords: username.splitStringToArray())
                    //                    let user = User.init(uid: userId, email: email, profileImageUrl: metaImageUrl, username: username, bio: "")
                    
                    let user = User.init(id: userId, email: email, profileImageUrl: metaImageUrl, username: username, age: "30", sex: "male", createdDate:  Date().timeIntervalSince1970, point_avail: 1)
                    
                    guard let dict = try? user.toDictionary() else {return}
                    saveUserLocally(mUserDictionary: dict as NSDictionary)
                    
                    //
                    //                        guard let decoderUser = try? User.init(fromDictionary: dict) else {return}
                    //                        print(decoderUser.username)
                    
                    firestoreUserId.setData(dict) { (error) in
                        if error != nil {
                            onError(error!.localizedDescription)
                            return
                        }
                        onSuccess(user)
                    }
                }
            }
            
        }
    }
}
