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
    @Environment(\.presentationMode) var presentationMode
    //    @Binding var showChatView: Bool
    
    var recipient : InboxMessage
//    var recipientId = ""
//    var recipientAvatarUrl = ""
//    var recipientUsername = ""
    
    @State var leftRoom : Bool = false
    @State var numChat : Int = 0
    
    
    func sendTextMessage() {
        //        self.hide_keyboard()
        if(self.chatViewModel.chatArray.count < 30){
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            chatViewModel.sendTextMessage(recipient : recipient, completed: {
                self.clean()
            }) { (errorMessage) in
                self.chatViewModel.showAlert = true
                self.chatViewModel.errorString = errorMessage
                self.clean()
            }
        }
        
    }
    
    func sendPhoto() {
        chatViewModel.sendPhotoMessage(recipient : recipient, completed: {
            
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
                
                chatTopview(recipientAvatarUrl: recipient.avatarUrl, recipientUsername: recipient.username, chatArray: self.$chatViewModel.chatArray)

                GeometryReader{_ in
                                 
                    ScrollView(.vertical, showsIndicators: false) {
                        
                        if !self.chatViewModel.chatArray.isEmpty {
                            VStack(alignment: .center, spacing: 4){
                                Text(CHAT_LIMIT_NOTIFICATION).foregroundColor(APP_THEME_COLOR).font(Font.custom(FONT, size: 13)).padding(.top, 10)
                                
                                Text(CONGRAT_MATCHED).foregroundColor(APP_THEME_COLOR).font(Font.custom(FONT, size: 12))
                                Text(self.recipient.username + "님은 지금 현재" + self.recipient.location + "에 사는 ").foregroundColor(Color.gray).font(Font.custom(FONT, size: 12)).padding(.top, 5)
                                Text(self.recipient.age + "입니다").foregroundColor(Color.gray).font(Font.custom(FONT, size: 12))

//                                    + self.recipient.age + "입니다")
//

                            }
                            
                            
                            Divider().foregroundColor(APP_THEME_COLOR)
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
                        
                        TextField("메세지를 입력해주세요", text: self.$chatViewModel.composedMessage)
                        
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
            self.chatViewModel.recipientId = self.recipient.userId
            self.chatViewModel.loadChatMessages()
            self.numChat = self.chatViewModel.chatArray.count
            
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
                Spacer(minLength: 50)
                
                Text(chat.textMessage).multilineTextAlignment(.leading).lineLimit(3)
                    .padding()
                    .background(APP_THEME_COLOR)
                    
                    .clipShape(msgTail(mymsg: false))
                    .foregroundColor(.white).padding(.trailing, 5)     .font(.system(size: 15))
                
                
            } else {
                Text(chat.textMessage).multilineTextAlignment(.leading).lineLimit(3)
                    .padding()
                    .background(Color(red: 237/255, green: 237/255, blue: 237/255))
                    .clipShape(msgTail(mymsg: true)).padding(.leading, 5)     .font(.system(size: 15))
                Spacer(minLength: 50)
                
                
            }
            
        }
        .padding(chat.isCurrentUser ? .leading : .trailing, 10)
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
    
    @EnvironmentObject var obs : observer
    var recipientAvatarUrl = ""
    var recipientUsername = ""
    @Binding var chatArray: [Chat]
    
    @Environment(\.presentationMode) var presentation
    
    var body : some View{
        
        //        ZStack{
        
        HStack(alignment: .center,   spacing : 10){
            
            Button(action: {
                
                self.presentation.wrappedValue.dismiss()
                //                    self.showChatView = false
                
            }) {
                
                Image(systemName: "control").font(.title).rotationEffect(.init(degrees: -90)).padding()
            }.padding(.leading,15)
            
            Spacer(minLength:  60)
            
            VStack(alignment: .center,  spacing: 5){
                
                AnimatedImage(url: URL(string: recipientAvatarUrl)).resizable().frame(width: 40, height: 40).clipShape(Circle())
                
                Text(recipientUsername).font(Font.custom(FONT, size: 15)).multilineTextAlignment(.leading).lineLimit(1)
                //                   Text(CHAT_LIMIT_NOTIFICATION).foregroundColor(Color.white).font(Font.custom(FONT, size: 13)).frame(width: 150).padding(.horizontal)
                
            }
            
            Spacer(minLength:  55)
            
            VStack(alignment: .leading,  spacing: 5){
                
                Text(String(self.chatArray.count) + " / 30" ) .foregroundColor(Color.white).font(Font.custom(FONT, size: 14))
            }.padding(.trailing,15)
            
            
            //                Text(recipientUsername).fontWeight(.heavy)
            
            //                Spacer()
        }.foregroundColor(.white)
        //                .padding()
        
        //        }
        
    }
}
