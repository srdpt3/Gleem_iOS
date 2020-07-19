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


class MessageViewModel: ObservableObject {
  

   @Published var inboxMessages: [InboxMessage] = [InboxMessage]()
//    private let objectWillChange = ObservableObjectPublisher()

   var listener: ListenerRegistration!
    
//    init() {
//        loadInboxMessages()
//    }
   
   func loadInboxMessages() {
//    defer {
//              objectWillChange.send(())
//          }
       self.inboxMessages = []
       
       Api.Chat.getInboxMessages(onSuccess: { (inboxMessages) in
           if self.inboxMessages.isEmpty {
               self.inboxMessages = inboxMessages
           }
       }, onError: { (errorMessage) in

       }, newInboxMessage: { (inboxMessage) in
           if !self.inboxMessages.isEmpty {
               self.inboxMessages.append(inboxMessage)
           }
       }) { (listener) in
           self.listener = listener
       }
       

   }
}
