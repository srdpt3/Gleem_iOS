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
                    //                    CustomScrollView(scrollToEnd: true) {
                    //                        ForEach(self.chatViewModel.chatArray, id: \.messageId) { chat in
                    //                            VStack(alignment: .leading) {
                    //                                if chat.isPhoto {
                    //                                    PhotoMessageRow(chat: chat)
                    //                                } else {
                    //                                    TextMessageRow(chat: chat)
                    //                                    //                                        .frame(height: 50, alignment: Alignment.leading)
                    //                                }
                    //
                    //
                    //                            }
                    //
                    //                        }
                    //
                    //                    }
                }
                
                HStack{
                  
                    HStack(spacing : 8){
                        
                        //                    Button(action: {
                        //
                        //                    }) {
                        //
                        //                        Image("emoji").resizable().frame(width: 20, height: 20)
                        //
                        //                    }.foregroundColor(.gray)
                        
                        TextField(TYPE_MESSAGE, text: self.$chatViewModel.composedMessage)
                        
                        Button(action: self.showPicker) {
                            
                            Image(systemName: "camera.fill").font(.body)
                            
                        }.foregroundColor(.gray)
                        
                        //                    Button(action: showPicker) {
                        //
                        //                        Image(systemName: "paperclip").font(.body)
                        //
                        //                    }.foregroundColor(.gray)
                        
                    }.padding()
                        .background(Color("Color-2"))
                        .clipShape(Capsule())
                    
                    Button(action: self.sendTextMessage) {
                        
                        Image(systemName: "paperplane")
                            .resizable()
                            .frame(width: 15, height: 23)
                            .padding(15)
                            .foregroundColor(.white)
                            .background(APP_THEME_COLOR)
                            .clipShape(Circle())
                        
                    }.foregroundColor(.gray)
                    
                }.padding(.horizontal, 10)
                    .background(Color.white)
                //                        .edgesIgnoringSafeArea(.bottom).padding(.top, -10)
                
                
                
                
                
                
                
            }.sheet(isPresented: self.$chatViewModel.showImagePicker, onDismiss: {
                self.sendPhoto()
            }) {
                // ImagePickerController()
                ImagePicker(showImagePicker: self.$chatViewModel.showImagePicker, pickedImage: self.$chatViewModel.image, imageData: self.$chatViewModel.imageData)
            }
            //            .navigationBarTitle(Text("채팅"), displayMode: .inline).alert(isPresented: $chatViewModel.showAlert) {
            //                Alert(title: Text("Error"), message: Text(self.chatViewModel.errorString), dismissButton: .default(Text("OK")))
        }
        .onAppear {
            //            self.obs.shoTabBar = false
            self.chatViewModel.recipientId = self.recipientId
            self.chatViewModel.loadChatMessages()
        }
        .onDisappear {
            //            self.obs.shoTabBar = true
            
            if self.chatViewModel.listener != nil {
                self.chatViewModel.listener.remove()
            }
        }.navigationBarHidden(true)
            .navigationBarTitle("")
        
        
    }
    
    
    
    
    //        .edgesIgnoringSafeArea(.bottom)
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
        HStack {
            if chat.isCurrentUser {
                //                HStack(alignment: .top) {
                //
                //                    AnimatedImage(url: URL(string: chat.avatarUrl))
                //                        .resizable()
                //                        .aspectRatio(contentMode: .fill)
                //                        .clipShape(Circle()).frame(width: 30, height: 30).clipShape(Circle())
                //                    Text(chat.textMessage).padding(10).foregroundColor(.black).background(Color(red: 237/255, green: 237/255, blue: 237/255)).cornerRadius(10).font(.callout)
                //                    Spacer()
                Spacer()
                Text(chat.textMessage).multilineTextAlignment(.leading).lineLimit(3)
                    .padding()
                    .background(APP_THEME_COLOR)
                    
                    //                                 .background(Color(red: 237/255, green: 237/255, blue: 237/255))
                    .clipShape(msgTail(mymsg: false))
                    .foregroundColor(.white).padding(.trailing, 15)     .font(.system(size: 15))
                
                
                //                }.padding(.leading, 15).padding(.trailing, 50)
            } else {
                Text(chat.textMessage).multilineTextAlignment(.leading).lineLimit(3)
                    .padding()
                    .background(Color(red: 237/255, green: 237/255, blue: 237/255))
                    .clipShape(msgTail(mymsg: true)).padding(.leading, 15)     .font(.system(size: 15))
                //                    .foregroundColor(.white)
                Spacer()
                //
                //                HStack(alignment: .top) {
                //                    Spacer(minLength: 100)
                //                    Text(chat.textMessage).padding().foregroundColor(.white).background(APP_THEME_COLOR).cornerRadius(10).font(.callout)
            }
            
            //
            //                .padding(.trailing, 15)
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
                    
                    //                    AnimatedImage(url: URL(string: chat.avatarUrl)!)
                    //
                    //                        .resizable()
                    //                        .aspectRatio(contentMode: .fill)
                    //                        .clipShape(Circle()).frame(width: 30, height: 30).clipShape(Circle())
                    
                    
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
    @Environment(\.presentationMode) var presentation
    
    var body : some View{
        
        
        HStack(spacing : 15){
            
            Button(action: {
                
                self.presentation.wrappedValue.dismiss()
                
                
            }) {
                
                Image(systemName: "control").font(.title).rotationEffect(.init(degrees: -90)).padding()
            }
            
            Spacer()
            
            VStack(spacing: 5){
                
                AnimatedImage(url: URL(string: recipientAvatarUrl)).resizable().frame(width: 45, height: 45).clipShape(Circle())
                
                Text(recipientUsername).fontWeight(.heavy)
                
            }.offset(x: 25)
            
            
            Spacer()
            
            Button(action: {
                
            }) {
                
                Image(systemName: "phone.fill").resizable().frame(width: 20, height: 20)
                
            }.padding(.trailing, 25)
            
            Button(action: {
                
            }) {
                
                Image(systemName: "flag").resizable().frame(width: 23, height: 16)
            }
            
        }.foregroundColor(.white)
            .padding()
    }
}
