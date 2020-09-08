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
    @Binding var reportUser: Bool
    @Binding var rowNum: Int
    var id: Int
    
    
    //    var recipientId = ""
    //    var recipientAvatarUrl = ""
    //    var recipientUsername = ""
    @State var leftRoom : Bool = false
    @State var numChat : Int = 0
    @State var profile_ : String = ""
    @State var flagMessage = false
    @State var selectedFlag = ""
    @State var showFlag = false
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
                
                chatTopview(recipientAvatarUrl: recipient.avatarUrl, recipientUsername: recipient.username, chatArray: self.$chatViewModel.chatArray,showFlag: self.$showFlag)
                
                GeometryReader{_ in
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        
                        if !self.chatViewModel.chatArray.isEmpty {
                            VStack(alignment: .center, spacing: 4){
                                Text(CHAT_LIMIT_NOTIFICATION).foregroundColor(Color("sleep")).font(Font.custom(FONT, size: 13)).padding(.top, 10)
                                
                                Text(CONGRAT_MATCHED).foregroundColor(Color.gray).font(Font.custom(FONT, size: 13)).padding(.top, 5)
                                Text(self.profile_).foregroundColor(Color.gray).font(Font.custom(FONT, size: 12))
                                //                                    .onTapGesture {
                                //                                    self.showFlag.toggle()
                                //                                }
                                //                                Text(self.recipient.age + "입니다").foregroundColor(Color.gray).font(Font.custom(FONT, size: 12))
                                
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
            
            VStack{
                
                Spacer()
                
                ChatFlagView(selectedFlag:self.$selectedFlag,show: self.$showFlag, flagMessage: self.$flagMessage,selected: self.recipient).offset(y: self.showFlag ? (UIApplication.shared.windows.last?.safeAreaInsets.bottom)! + 15 : UIScreen.main.bounds.height)
                    //                    .onTapGesture {
                    //                        withAnimation{
                    //                            self.showFlag.toggle()
                    //
                    //                        }
                    //                }
                    .animation(Animation.spring(response: 0.6, dampingFraction: 1.0, blendDuration: 1.0))
                    .alert(isPresented: $flagMessage) {
                        Alert(
                            title: Text(BLOCKUSER),
                            message: Text(BLOCKMSG),
                            dismissButton: Alert.Button.default(Text(CONFIRM), action: {
                                self.reportUser = true
                                self.rowNum = self.id
                                self.presentationMode.wrappedValue.dismiss()
                                
                                
                            })
                            
                            
                        )
                        
                }
                
                
                
            }.background(Color(UIColor.label.withAlphaComponent(self.showFlag ? 0.2 : 0)).edgesIgnoringSafeArea(.all))
            
        }.onTapGesture(perform: {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        })
        .onAppear {
            self.chatViewModel.recipientId = self.recipient.userId
            self.chatViewModel.loadChatMessages()
            self.numChat = self.chatViewModel.chatArray.count
            
            self.profile_ = self.recipient.username + "님은 " + self.recipient.location + "에 사는 " + self.recipient.age + "입니다"
            
        }
        .onDisappear {
            
            if self.chatViewModel.listener != nil {
                self.chatViewModel.listener.remove()
            }
        }
        .navigationBarHidden(true)
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
    @Binding var showFlag : Bool
    @Environment(\.presentationMode) var presentation
    
    var body : some View{
        
        //        ZStack{
        ZStack{
            HStack(alignment: .center,   spacing : 10){
                
                Button(action: {
                    
                    self.presentation.wrappedValue.dismiss()
                    //                    self.showChatView = false
                    
                }) {
                    
                    Image(systemName: "control").font(.title).rotationEffect(.init(degrees: -90)).padding()
                }.padding(.leading,5)
                
                Spacer(minLength: 100)
                
                VStack(alignment: .center,  spacing: 5){
                    
                    AnimatedImage(url: URL(string: recipientAvatarUrl)).resizable().frame(width: 45, height: 45).clipShape(Circle()).onTapGesture {
                        
                    }
                    
                    //                    Text(recipientUsername).font(Font.custom(FONT, size: 15)).multilineTextAlignment(.leading).lineLimit(1)
                    //                   Text(CHAT_LIMIT_NOTIFICATION).foregroundColor(Color.white).font(Font.custom(FONT, size: 13)).frame(width: 150).padding(.horizontal)
                    
                }.padding(.bottom,5)
                
                Spacer(minLength:  35)
                
                HStack(alignment: .center, spacing: 10){
                    
                    
                    Text(String(self.chatArray.count) + " / 30" ) .foregroundColor(Color.white).font(Font.custom(FONT, size: 14))
                    
                    
                    Button(action: {
                        self.showFlag.toggle()
                        
                    }, label: {
                        
                         Image("heart_broken").resizable().frame(width: 30, height: 30)
                        .foregroundColor(Color.white)
                                                 .shadow(radius: 5)
//                        Image(systemName: "flag.circle.fill")
//                            .font(.title)
                         
                            //                                            .opacity(self.pulsate ? 1 : 0.6)
                            .scaleEffect(1, anchor: .center)
                        //                                            .animation(Animation.easeOut(duration: 1.5).repeatForever(autoreverses: true))
                    })
                }.padding(.trailing,10)
                
                
                
                
                
                
                //                Text(recipientUsername).fontWeight(.heavy)
                
                //                Spacer()
            }.foregroundColor(.white)
            //            .overlay(
            //                    HStack {
            //                        Spacer()
            //
            //                    }
            //                )
        }
        
        //                .padding()
        
        //        }
        
    }
}
