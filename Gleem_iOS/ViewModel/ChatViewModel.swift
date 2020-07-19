//
//  ChatViewModel.swift
//  Instagram
//
//  Created by David Tran on 3/15/20.
//  Copyright © 2020 zero2launch. All rights reserved.
//

import Foundation
import FirebaseAuth
import Firebase
import FirebaseStorage
import SwiftUI


class ChatViewModel: ObservableObject {
    
    @Published var composedMessage: String = ""
    var imageData: Data = Data()
    var errorString = ""
    var image: Image = Image(systemName: IMAGE_PHOTO)
    @Published var showAlert: Bool = false
    @Published var showImagePicker: Bool = false
    
    
    @Published var chatArray: [Chat] = []
    @Published var isLoading = false
    var recipientId = ""
    var listener: ListenerRegistration!
    
    
    func leaveRoom(recipientId: String){
        //        batch writing. vote multiple entries
        
        guard let senderId = Auth.auth().currentUser?.uid else { return }
        // Delete CHAT
        
        Ref.FIRESTORE_COLLECTION_CHATROOM(senderId: senderId, recipientId: recipientId).getDocuments { (documents, err) in
            if err != nil{
                return
            }
            
            for document in documents!.documents {
                print(document.documentID)
                document.reference.delete()
                print("Removed sucessfully from ChatRoom : " + recipientId + " " + senderId)
            }
            
            Ref.FIRESTORE_COLLECTION_CHATROOM(senderId: recipientId, recipientId: senderId).getDocuments { (documents, err) in
                if err != nil{
                    return
                }
                
                for document in documents!.documents {
                    print(document.documentID)
                    document.reference.delete()
                    print("Removed sucessfully from ChatRoom : " + senderId + " " + recipientId)
                }
            }
            
            // DElete CHAT
            Ref.FIRESTORE_COLLECTION_INBOX_MESSAGES_DOCUMENT_USERID(senderId: senderId, recipientId: recipientId).getDocument { (document, error) in
                if error == nil {
                    print("persist sucessfully to my vote")
                }
                
                if let doc = document, document!.exists {
                    doc.reference.delete()
                    print("Removed sucessfully from Message inbox1 : " + senderId + " " + recipientId)
                    
                    
                    Ref.FIRESTORE_COLLECTION_INBOX_MESSAGES_DOCUMENT_USERID(senderId: recipientId, recipientId: senderId).getDocument { (document, error) in
                        if error == nil {
                            print("persist sucessfully to my vote")
                        }
                        
                        if let doc = document, document!.exists {
                            doc.reference.delete()
                            print("Removed sucessfully from Message inbox2 : " + recipientId + " " + senderId)
                            
                        }
                        
                        
                    }
                    
                }
            }
            
        }
        
        
    }
    
    
    
    func loadChatMessages() {
        self.chatArray = []
        self.isLoading = true
        
        Api.Chat.getChatMessages(withUser: recipientId, onSuccess: { (chatMessages) in
            //self.chatArray.removeAll()
            if self.chatArray.isEmpty {
                self.chatArray = chatMessages
            }
        }, onError: { (errorMessage) in
            
        }, newChatMessage: { (chat) in
            if !self.chatArray.isEmpty {
                self.chatArray.append(chat)
            }
        }) { (listener) in
            self.listener = listener
            
            
            
        }
        
        
    }
    
    
    func sendTextMessage(recipientId: String, recipientAvatarUrl: String, recipientUsername: String, completed: @escaping() -> Void,  onError: @escaping(_ errorMessage: String) -> Void) {
        if !composedMessage.isEmpty {
            Api.Chat.sendMessages(message: composedMessage, recipientId: recipientId, recipientAvatarUrl: recipientAvatarUrl, recipientUsername: recipientUsername, onSuccess: completed, onError: onError)
        } else {
            showAlert = true
            errorString = "Please fill in all fields"
        }
        return
    }
    
    func sendPhotoMessage(recipientId: String, recipientAvatarUrl: String, recipientUsername: String, completed: @escaping() -> Void,  onError: @escaping(_ errorMessage: String) -> Void) {
        if !imageData.isEmpty {
            Api.Chat.sendPhotoMessages(recipientId: recipientId, recipientAvatarUrl: recipientAvatarUrl, recipientUsername: recipientUsername, imageData: imageData, onSuccess: completed, onError: onError)
            
        } else {
            showAlert = true
            errorString = "Please fill in all fields"
        }
    }
    
    //    func sharePost(completed: @escaping() -> Void,  onError: @escaping(_ errorMessage: String) -> Void) {
    //          if !caption.isEmpty && !imageData.isEmpty {
    //             //AuthService.signupUser(username: username, email: email, password: password, imageData: imageData, onSuccess: completed, onError: onError)
    //            Api.Post.uploadPost(caption: caption, imageData: imageData, onSuccess: completed, onError: onError)
    //
    //          } else {
    //              showAlert = true
    //              errorString = "Please fill in all fields"
    //          }
    //
    //    }
}
