//
//  MessageViewModel.swift
//  Instagram
//
//  Created by David Tran on 3/27/20.
//  Copyright © 2020 zero2launch. All rights reserved.
//

import Foundation
import FirebaseAuth
import Firebase
import FirebaseStorage
import SwiftUI
import Combine

class MessageViewModel: ObservableObject {
    
    
    @Published var inboxMessages = [InboxMessage]()
    // let objectWillChange = ObservableObjectPublisher()
    @Published var isInboxLoading : Bool = false
    @Published var finished : String = ""
    
    var listener: ListenerRegistration!
    
    init() {
        UITableView.appearance().separatorColor = .clear
        
    }
    
    func loadInboxMessages() {
        self.isInboxLoading = true
        self.inboxMessages = []
        
        Api.Chat.getInboxMessages(onSuccess: { (inboxMessages) in
            if self.inboxMessages.isEmpty {
                self.inboxMessages = inboxMessages
                self.isInboxLoading = false

            }
        }, onError: { (errorMessage) in
            
        }, newInboxMessage: { (inboxMessage) in
            if !self.inboxMessages.isEmpty {
                self.inboxMessages.append(inboxMessage)
                
            }
            self.isInboxLoading = false
            
        })
        { (listener) in
            self.listener = listener
        }
        //
        //          if self.inboxMessages.isEmpty {
        //            if(isKeyPresentInUserDefaults(key: "signedIn")){
        ////                self.finished = "empty"
        //                removeDefaults(entry: "signedIn")
        //
        //
        //            }
        //          }else{
        //            self.finished = ""
        //        }
        
        print("loadInboxMessages finished")
        //       defer {
        //            objectWillChange.send()
        //        }
        
        
    }
    
    
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
//        ZStack {
//            LoadingView2(filename: "break-heart")
//        }
        //
        
    }
}
