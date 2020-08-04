//
//  AuthService.swift
//  Gleem_Dating
//
//  Created by Dustin yang on 6/29/20.
//  Copyright © 2020 Dustin yang. All rights reserved.
//
import SwiftUI

import Foundation
import FirebaseAuth
import Firebase
import FirebaseStorage
class AuthService {
    
    static func signInUser(email: String, password: String, onSuccess: @escaping(_ user: User) -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
               Auth.auth().signIn(withEmail: email, password: password) { (authData, error) in
                   if error != nil {
                        print(error!.localizedDescription)
                        onError(error!.localizedDescription)
                        return
                    }
                   guard let userId = authData?.user.uid else { return }
                    
                   let firestoreUserId = Ref.FIRESTORE_DOCUMENT_USERID(userId: userId)
                   firestoreUserId.getDocument { (document, error) in
                       if let dict = document?.data() {
                        guard let decoderUser = try? User.init(_dictionary: dict as NSDictionary) else {return}
                        saveUserLocally(mUserDictionary: dict as NSDictionary)
                            onSuccess(decoderUser)
                       }
                   }
               }
           

    }
    
    
    static func saveUser(userId: String){
        let firestoreUserId = Ref.FIRESTORE_DOCUMENT_USERID(userId: userId)
        firestoreUserId.getDocument { (document, error) in
            if let dict = document?.data() {
                guard let decoderUser = try? User.init(_dictionary: dict as NSDictionary) else {return}
                saveUserLocally(mUserDictionary: dict as NSDictionary)
                print("Save Locally")
            }
        }
    }
    
    static func signupUser(username: String, email: String, password: String, age: String, gender: String, onSuccess: @escaping(_ user: User) -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
         //Firebase.createAccount(username: username, email: email, password: password, imageData: imageData)
                Auth.auth().createUser(withEmail: email, password: password) { (authData, error) in
                    if error != nil {
                        print(error!.localizedDescription)
                        onError(error!.localizedDescription)
                        return
                    }
                    
                    guard let userId = authData?.user.uid else { return }
                    let user = User.init(id: userId, email: email, profileImageUrl: "", username: username, age: age, sex: gender, createdDate:  Date().timeIntervalSince1970, point_avail: INITIAL_POINT)
                    
                    guard let dict = try? user.toDictionary() else {return}
                    saveUserLocally(mUserDictionary: dict as NSDictionary)
                    
                    let storageAvatarUserId = Ref.STORAGE_AVATAR_USERID(userId: userId)
                    let metadata = StorageMetadata()
                    metadata.contentType = "image/jpg"
        
                    
                    
                    StorageService.saveUser(userId: userId, username: username, email: email, age: age, storageAvatarRef: storageAvatarUserId, gender : gender, onSuccess: onSuccess, onError: onError)
 
                }
    }
}
