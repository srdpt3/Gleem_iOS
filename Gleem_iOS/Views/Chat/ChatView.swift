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
    @Environment(\.presentationMode) var presentationMode
    //    @Binding var showChatView: Bool
    var recipientId = ""
    var recipientAvatarUrl = ""
    var recipientUsername = ""
    
    @State var leftRoom : Bool = false
    
    
    func sendTextMessage() {
//        self.hide_keyboard()

        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
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
        
        
        ZStack{
            APP_THEME_COLOR.edgesIgnoringSafeArea(.top)
            //            Spacer(minLength: 100)
            VStack(spacing: 0){
                chatTopview(recipientAvatarUrl: recipientAvatarUrl, recipientUsername: recipientUsername)
                GeometryReader{_ in
                    ScrollView(.vertical, showsIndicators: false) {
                        
                        if !self.chatViewModel.chatArray.isEmpty {
                            ForEach(self.chatViewModel.chatArray, id: \.messageId) { chat in
                                VStack(alignment: .leading) {
                                    if chat.isPhoto {
                                        PhotoMessageRow(chat: chat)
                                    } else {
                                        TextMessageRow(chat: chat)
                                    }
                                }
                            }
                        }
                    }.padding(.horizontal, 15)
                        .background(Color.white)
                        .clipShape(Rounded())
                    //                    
                    //                    
                    //                    if self.showFavoriteView {
                    //                        Fa
                    //                    }
                    //                    
                    
                    
                }
                
                HStack{
                    
                    HStack(spacing : 8){
                        
                        TextField("asdfasfd", text: self.$chatViewModel.composedMessage)
                        
                        Button(action: self.showPicker) {
                            
                            Image(systemName: "camera.fill").font(.body)
                            
                        }.foregroundColor(.gray)
                        
                        
                    }.padding()
                        .background(Color("Color-2"))
                        .clipShape(Capsule()).KeyboardResponsive()
                    
                    Button(action: self.sendTextMessage) {
                        
                        Image(systemName: "paperplane")
                            .resizable()
                            .frame(width: 15, height: 23)
                            .padding(15)
                            .foregroundColor(.white)
                            .background(APP_THEME_COLOR)
                            .clipShape(Circle())
                        
                    }.foregroundColor(.gray)    .modifier(KeyboardObserving()).edgesIgnoringSafeArea(.bottom)
                    
                }.padding(.horizontal, 10)
                    .background(Color.white)
            }.sheet(isPresented: self.$chatViewModel.showImagePicker, onDismiss: {
                self.sendPhoto()
            }) {
                ImagePicker(showImagePicker: self.$chatViewModel.showImagePicker, pickedImage: self.$chatViewModel.image, imageData: self.$chatViewModel.imageData)
            }
            
        }
        .onAppear {
            self.chatViewModel.recipientId = self.recipientId
            self.chatViewModel.loadChatMessages()
            
        }
        .onDisappear {
            
            if self.chatViewModel.listener != nil {
                self.chatViewModel.listener.remove()
            }
        }    .navigationBarHidden(true)
            .navigationBarTitle("")
        
        
    }
    
    
    
}


import SDWebImageSwiftUI

struct TextMessageRow: View {
    var chat: Chat
    
    var body: some View {
        HStack {
            if chat.isCurrentUser {
                Spacer()
                Text(chat.textMessage).multilineTextAlignment(.leading).lineLimit(3)
                    .padding()
                    .background(APP_THEME_COLOR)
                    
                    .clipShape(msgTail(mymsg: false))
                    .foregroundColor(.white).padding(.trailing, 15)     .font(.system(size: 15))
                
                
            } else {
                Text(chat.textMessage).multilineTextAlignment(.leading).lineLimit(3)
                    .padding()
                    .background(Color(red: 237/255, green: 237/255, blue: 237/255))
                    .clipShape(msgTail(mymsg: true)).padding(.leading, 15)     .font(.system(size: 15))
                Spacer()
                
            }
            
        }
        .padding(chat.isCurrentUser ? .leading : .trailing, 55)
        .padding(.vertical,5)
    }
}

struct msgTail : Shape {
    
    var mymsg : Bool
    
    func path(in rect: CGRect) -> Path {
        
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topLeft,.topRight,mymsg ? .bottomLeft : .bottomRight], cornerRadii: CGSize(width: 25, height: 25))
        return Path(path.cgPath)
    }
}

struct PhotoMessageRow: View {
    var chat: Chat
    var body: some View {
        Group {
            if !chat.isCurrentUser {
                HStack(alignment: .top) {
                    
                    
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



struct chatTopview : View {
    
    //    @EnvironmentObject var data : msgDatas
    var recipientAvatarUrl = ""
    var recipientUsername = ""
    //    @Binding var showChatView: Bool
    
    @Environment(\.presentationMode) var presentation
    
    var body : some View{
        
        ZStack{
            
            HStack(spacing : 10){
                
                Button(action: {
                    
                    self.presentation.wrappedValue.dismiss()
                    //                    self.showChatView = false
                    
                }) {
                    
                    Image(systemName: "control").font(.title).rotationEffect(.init(degrees: -90)).padding()
                }
                
                Spacer()
                
                VStack(spacing: 5){
                    
                    AnimatedImage(url: URL(string: recipientAvatarUrl)).resizable().frame(width: 45, height: 45).clipShape(Circle())
                    
                    Text(recipientUsername).fontWeight(.heavy)
                    
                }
                .offset(x: -10)
                
                Spacer()
                
                
                
            }.foregroundColor(.white)
                .padding()
            
        }
        
    }
}
