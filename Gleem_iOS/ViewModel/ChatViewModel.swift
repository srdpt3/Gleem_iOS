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
    
    
    func sendTextMessage(recipient: InboxMessage, completed: @escaping() -> Void,  onError: @escaping(_ errorMessage: String) -> Void) {
        if !composedMessage.isEmpty {
            Api.Chat.sendMessages(message: composedMessage, recipient: recipient, onSuccess: completed, onError: onError)
        } else {
            showAlert = true
            errorString = "Please fill in all fields"
        }
        return
    }
    
    func sendPhotoMessage(recipient: InboxMessage, completed: @escaping() -> Void,  onError: @escaping(_ errorMessage: String) -> Void) {
        if !imageData.isEmpty {
            Api.Chat.sendPhotoMessages(recipient: recipient, imageData: imageData, onSuccess: completed, onError: onError)
            
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
