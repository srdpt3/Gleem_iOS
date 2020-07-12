//
//  ChatView.swift
//  Instagram
//
//  Created by David Tran on 2/28/20.
//  Copyright © 2020 zero2launch. All rights reserved.
//

import SwiftUI

struct ChatView: View {
    
    @ObservedObject var chatViewModel = ChatViewModel()
    @EnvironmentObject var obs : observer
    
    var recipientId = ""
    var recipientAvatarUrl = ""
    var recipientUsername = ""
    
    func sendTextMessage() {
        chatViewModel.sendTextMessage(recipientId: recipientId, recipientAvatarUrl: recipientAvatarUrl, recipientUsername: recipientUsername, completed: {
            self.clean()
        }) { (errorMessage) in
            self.chatViewModel.showAlert = true
            self.chatViewModel.errorString = errorMessage
            self.clean()
        }
    }
    
    func sendPhoto() {
        chatViewModel.sendPhotoMessage(recipientId: recipientId, recipientAvatarUrl: recipientAvatarUrl, recipientUsername: recipientUsername, completed: {
            
        }) { (errorMessage) in
            self.chatViewModel.showAlert = true
            self.chatViewModel.errorString = errorMessage
        }
    }
    
    func showPicker() {
        self.chatViewModel.showImagePicker = true
    }
    
    func clean() {
        self.chatViewModel.composedMessage = ""
    }
    
    var body: some View {
        VStack {
            //            ScrollView {
            //
            //                if !chatViewModel.chatArray.isEmpty {
            //                    ForEach(chatViewModel.chatArray, id: \.messageId) { chat in
            //                        VStack(alignment: .leading) {
            //                            if chat.isPhoto {
            //                                PhotoMessageRow(chat: chat)
            //                            } else {
            //                                TextMessageRow(chat: chat)
            //                            }
            //                        }.padding(.top, 20)
            //                    }
            //                }
            //            }
            //
            CustomScrollView(scrollToEnd: true) {
                ForEach(self.chatViewModel.chatArray, id: \.messageId) { chat in
                    VStack(alignment: .leading) {
                        if chat.isPhoto {
                            PhotoMessageRow(chat: chat)
                        } else {
                            TextMessageRow(chat: chat)
                        }
                    }.padding(.top, 20)
                }
                
            }
            Spacer()
            //            HStack(spacing: 0) {
            //
            //                ZStack {
            //                    RoundedRectangle(cornerRadius: 20).stroke(Color.gray, lineWidth: 1).padding()
            //
            //                    HStack(spacing: 10) {
            //                        Button(action: {}) {
            //                            Image(systemName: "camera.fill").padding(12).foregroundColor(.white).background(Color.blue).clipShape(Circle())
            //                        }.padding(.leading, 20)
            //
            //                        TextField("Message...", text: $chatViewModel.composedMessage).padding(.top, 30).padding(.bottom, 30)
            //                        Button(action: showPicker) {
            //                            Image(systemName: "photo").imageScale(.large).foregroundColor(.black)
            //                        }
            //                        Button(action: {}) {
            //                            Image(systemName: "mic.fill").imageScale(.large).foregroundColor(.black)
            //                        }
            //                        Button(action: sendTextMessage) {
            //                            Image(systemName: "paperplane").imageScale(.large).foregroundColor(.black).padding(.trailing, 30)
            //                        }
            //                    }
            //
            //                }.frame(height: 60)
            //            }
            
            
            HStack{
                
                HStack(spacing : 8){
                    
                    //                    Button(action: {
                    //
                    //                    }) {
                    //
                    //                        Image("emoji").resizable().frame(width: 20, height: 20)
                    //
                    //                    }.foregroundColor(.gray)
                    
                    TextField("Type Something", text: $chatViewModel.composedMessage)
                    
                    Button(action: {
                        
                    }) {
                        
                        Image(systemName: "camera.fill").font(.body)
                        
                    }.foregroundColor(.gray)
                    
                    Button(action: showPicker) {
                        
                        Image(systemName: "paperclip").font(.body)
                        
                    }.foregroundColor(.gray)
                    
                }.padding()
                    .background(Color("background2"))
                    .clipShape(Capsule())
                
                Button(action: sendTextMessage) {
                    
                    Image(systemName: "paperplane")
                        .resizable()
                        .frame(width: 15, height: 23)
                        .padding(13)
                        .foregroundColor(.white)
                        .background(Color("Color2"))
                        .clipShape(Circle())
                    
                }.foregroundColor(.gray)
                
            }.padding(.horizontal, 15)
                .background(Color.white).edgesIgnoringSafeArea(.bottom)
            
        }.sheet(isPresented: $chatViewModel.showImagePicker, onDismiss: {
            self.sendPhoto()
        }) {
            // ImagePickerController()
            ImagePicker(showImagePicker: self.$chatViewModel.showImagePicker, pickedImage: self.$chatViewModel.image, imageData: self.$chatViewModel.imageData)
        }
        .navigationBarTitle(Text("채팅"), displayMode: .inline).alert(isPresented: $chatViewModel.showAlert) {
            Alert(title: Text("Error"), message: Text(self.chatViewModel.errorString), dismissButton: .default(Text("OK")))
        }.onAppear {
//            self.obs.shoTabBar = false
            self.chatViewModel.recipientId = self.recipientId
            self.chatViewModel.loadChatMessages()
        }.onDisappear {
//            self.obs.shoTabBar = true
            
            if self.chatViewModel.listener != nil {
                self.chatViewModel.listener.remove()
            }
        }
//        .edgesIgnoringSafeArea(.bottom)
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}

import SDWebImageSwiftUI

struct TextMessageRow: View {
    var chat: Chat
    var body: some View {
        Group {
            if !chat.isCurrentUser {
                HStack(alignment: .top) {
                    
                    AnimatedImage(url: URL(string: chat.avatarUrl))
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipShape(Circle()).frame(width: 30, height: 30).clipShape(Circle())
                    Text(chat.textMessage).padding(10).foregroundColor(.black).background(Color(red: 237/255, green: 237/255, blue: 237/255)).cornerRadius(10).font(.callout)
                    Spacer()
                }.padding(.leading, 15).padding(.trailing, 50)
            } else {
                HStack(alignment: .top) {
                    Spacer(minLength: 50)
                    Text(chat.textMessage).padding(10).foregroundColor(.white).background(Color("Color2")).cornerRadius(10).font(.callout)
                }.padding(.trailing, 15)
            }
        }
    }
}


struct PhotoMessageRow: View {
    var chat: Chat
    var body: some View {
        Group {
            if !chat.isCurrentUser {
                HStack(alignment: .top) {
                    
                    AnimatedImage(url: URL(string: chat.avatarUrl)!)
                        
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipShape(Circle()).frame(width: 30, height: 30).clipShape(Circle())
                    
                    
                    AnimatedImage(url: URL(string: chat.photoUrl)!)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 200, height: 200).cornerRadius(10)
                    Spacer()
                }.padding(.leading, 15)
            } else {
                HStack {
                    Spacer()
                    
                    AnimatedImage(url: URL(string: chat.photoUrl)!)
                        .resizable()
                        .aspectRatio(contentMode: .fill).frame(width: 200, height: 200).cornerRadius(10)
                }.padding(.trailing, 15)
            }
        }
    }
}
