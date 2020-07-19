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
    
    var recipientId = ""
    var recipientAvatarUrl = ""
    var recipientUsername = ""
    @State var doneChatting : Bool = false
    @State  var showMessageView: Bool = false
    @State  var animatingModal: Bool = false
    @State var showFavoriteView : Bool = false
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
    
    func leaveRoom(){
        print("leave room")
        
        
        chatViewModel.leaveRoom(recipientId: recipientId)
        
        
        self.presentationMode.wrappedValue.dismiss()
        
    }
    
    var body: some View {
        
        
        ZStack{
            APP_THEME_COLOR.edgesIgnoringSafeArea(.top)
            //            Spacer(minLength: 100)
            VStack(spacing: 0){
                chatTopview(recipientAvatarUrl: recipientAvatarUrl, recipientUsername: recipientUsername,doneChatting: self.$doneChatting)
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
                        .blur(radius: self.$doneChatting.wrappedValue ? 5 : 0, opaque: false)
//                    
//                    
//                    if self.showFavoriteView {
//                        Fa
//                    }
//                    
                    if self.doneChatting {
                        ZStack {
                            
                            Color("ColorTransparentBlack").edgesIgnoringSafeArea(.all)
                            
                            // MODAL
                            VStack(spacing: 0) {
                                // TITLE
                                Text(LEAVE_ROOM)
                                    .font(Font.custom(FONT, size: 20))
                                    .fontWeight(.heavy)
                                    .padding()
                                    .frame(minWidth: 0, maxWidth: .infinity)
                                    .background(APP_THEME_COLOR)
                                    .foregroundColor(Color.white)
                                
                                Spacer()
                                
                                // MESSAGE
                                
                                VStack(spacing: 16) {
                                    
                                    Text(self.recipientUsername  + END_CHAT)
                                        .font(Font.custom(FONT, size: 15))
                                        .lineLimit(2)
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(Color.gray)
                                        .layoutPriority(1)
                                    
                                    
                                    HStack{
                                        Button(action: {
                                            self.animatingModal = false
                                            //                                         self.presentationMode.wrappedValue.dismiss()
                                            
                                        }) {
                                            Text(CANCEL.uppercased())
                                                .font(Font.custom(FONT, size: 15))
                                                .fontWeight(.semibold)
                                                .accentColor(Color.gray)
                                                .padding(.horizontal, 55)
                                                .padding(.vertical, 15)
                                                .frame(minWidth: 100)
                                                .background(
                                                    Capsule()
                                                        .strokeBorder(lineWidth: 1.75)
                                                        .foregroundColor(Color.gray)
                                            )
                                        }
                                        Button(action: {
                                            
                                            self.animatingModal = false
                                            withAnimation(){
                                                self.doneChatting.toggle()
                                                
                                            }
                                            
                                            
                                            self.leaveRoom()
                                            
                                            withAnimation(){
                                                 self.showFavoriteView.toggle()
                                                 
                                             }
                                            
                                            
                                        }) {
                                            Text(CONFIRM.uppercased())
                                                .font(Font.custom(FONT, size: 15))
                                                .fontWeight(.semibold)
                                                .accentColor(APP_THEME_COLOR)
                                                .padding(.horizontal, 55)
                                                .padding(.vertical, 15)
                                                .frame(minWidth: 100)
                                                .background(
                                                    Capsule()
                                                        .strokeBorder(lineWidth: 1.75)
                                                        .foregroundColor(APP_THEME_COLOR)
                                            )
                                        }
                                        
                                    }
                                }
                                
                                Spacer()
                                
                            }
                            .frame(minWidth: 260, idealWidth: 260, maxWidth: 300, minHeight: 140, idealHeight: 160, maxHeight: 200, alignment: .center)
                            .background(Color.white)
                            .cornerRadius(20)
                            .shadow(color: Color("ColorTransparentBlack"), radius: 6, x: 0, y: 8)
                            .opacity(self.$animatingModal.wrappedValue ? 1 : 0)
                            .offset(y: self.$animatingModal.wrappedValue ? 0 : -100)
                            .animation(Animation.spring(response: 0.6, dampingFraction: 1.0, blendDuration: 1.0))
                            .onAppear(perform: {
                                self.animatingModal = true
                            })
                        }
                    }
                    
                }
                
                HStack{
                    
                    HStack(spacing : 8){
                        
                        TextField(TYPE_MESSAGE, text: self.$chatViewModel.composedMessage)
                        
                        Button(action: self.showPicker) {
                            
                            Image(systemName: "camera.fill").font(.body)
                            
                        }.foregroundColor(.gray)
                        
                        
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
        }.navigationBarHidden(true)
            .navigationBarTitle("")
        
        
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
        HStack {
            if chat.isCurrentUser {
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
                Spacer()
                //
                //                HStack(alignment: .top) {
                //                    Spacer(minLength: 100)
                //                    Text(chat.textMessage).padding().foregroundColor(.white).background(APP_THEME_COLOR).cornerRadius(10).font(.callout)
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
    @Binding var doneChatting : Bool
    
    @Environment(\.presentationMode) var presentation
    
    var body : some View{
        
        ZStack{
            
            HStack(spacing : 10){
                
                Button(action: {
                    
                    self.presentation.wrappedValue.dismiss()
                    
                    
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
                
                Button(action: {
                    self.doneChatting.toggle()
                }) {
                    
                    Image("heart_broken").resizable().frame(width: 25, height: 25)
                }
                
            }.foregroundColor(.white)
                .padding()
            
        }
        
    }
}
