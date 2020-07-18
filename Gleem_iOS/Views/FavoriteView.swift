//
//  FavoriteView.swift
//  Gleem_Dating
//
//  Created by Dustin yang on 7/6/20.
//  Copyright © 2020 Dustin yang. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI
import AlertX

struct FavoriteView: View {
    
    var body: some View {
        FavoriteHome()
    }
}


struct FavoriteHome : View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject private var favoriteViewModel = FavoriteViewModel()
    @ObservedObject private var activityViewModel = ActivityViewModel()
    @ObservedObject private var chatViewModel = ChatViewModel()
    @State var showAlertX : Bool = false
    @State var sendMessage : Bool = false
    @State private var showingModal: Bool = false
    @State private var animatingSymbol: Bool = false
    @State private var animatingModal: Bool = false
    @State  private var selectedUser: Activity?
    
    init() {
        self.favoriteViewModel.loadFavoriteUsers()
        self.activityViewModel.loadActivities()
    }
    
    //    func sendMessage(){
    //
    //        let user = selectedUser!
    //        if(self.sendMessage){
    //            self.presentationMode.wrappedValue.dismiss()
    //            self.chatViewModel.composedMessage = SEND_LIKE_MESSAGE
    //            self.chatViewModel.sendTextMessage(recipientId: user.userId, recipientAvatarUrl: user.userAvatar, recipientUsername: user.username, completed: {
    //                self.chatViewModel.composedMessage = ""
    //                self.sendMessage = false
    //                //                self.presentationMode.wrappedValue.dismiss()
    //
    //            }) { (error) in
    //                print(error)
    //            }
    //
    //        }
    //    }
    
    var body: some View{
        
        VStack(spacing: 10){
            
            
            GeometryReader{geo in
                VStack{
                    
                    
                    if !self.activityViewModel.activityArray.isEmpty {
                        HStack{
                            Text(SOMEONE_LIKED).fontWeight(.heavy).font(Font.custom(FONT, size: 20))
                                .foregroundColor(APP_THEME_COLOR)
                            Spacer()
                            
                        }
                        .padding(.horizontal)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                
                                ForEach(self.activityViewModel.activityArray, id: \.activityId) { user in
                                    
                                    GeometryReader { geometry in
                                        
                                        SectionView2(user: user)
                                            .rotation3DEffect(Angle(degrees:
                                                Double(geometry.frame(in: .global).minX - 60) / -getAngleMultiplier(bounds: geo)
                                            ), axis: (x: 0, y: 50, z: 0))
                                            .onTapGesture {
                                                
                                                self.showingModal.toggle()
                                                self.selectedUser = user
                                                
                                        }
                                        
                                        
                                    }
                                    .frame(width: geo.size.height / 4.5 , height: geo.size.height / 4.5)
                                }
                            }.padding()
                            
                            //                    .padding(.bottom, 30)
                        }.background(Color.white)
                    } else {
                        Spacer()
                        EmptyView()
                        LoadingView(isLoading: self.activityViewModel.isLoading, error: self.activityViewModel.error) {
                            self.activityViewModel.loadActivities()
                        }
                        Spacer()
                        
                    }
                    
                    
                    VStack(spacing: 10){
                        if !self.favoriteViewModel.favoriteUsers.isEmpty {
                            MainSubViewFavorite(title: "Favorite Votes", users: self.favoriteViewModel.favoriteUsers)
                                .frame( height: geo.size.height / 1.5 )
                        } else {
                            Spacer()
                            
                            LoadingView(isLoading: self.favoriteViewModel.isLoading, error: self.favoriteViewModel.error) {
                                self.favoriteViewModel.loadFavoriteUsers()
                            }
                            Spacer()
                            
                        }
                    }
                    
                    
                    
                    
                }  .blur(radius: self.$showingModal.wrappedValue ? 5 : 0, opaque: false)
                // MARK: - POPUP
                if self.showingModal {
                    ZStack {
                        Color("ColorTransparentBlack").edgesIgnoringSafeArea(.all)
                        
                        // MODAL
                        VStack(spacing: 0) {
                            // TITLE
                            Text("상대방이랑 채팅하기")
                                .font(Font.custom(FONT, size: 20))
                                .fontWeight(.heavy)
                                .padding()
                                .frame(minWidth: 0, maxWidth: .infinity)
                                .background(Color("Color2"))
                                .foregroundColor(Color.white)
                            
                            Spacer()
                            
                            // MESSAGE
                            VStack(spacing: 16) {
                                Image("Gleem 3D Icon Type Black Transparent_resized")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxHeight: 72)
                                //
                                Text("상대방에게 채팅요청시 1포인트가 소모됩니다. \n현재 가진 포인트: " + String(User.currentUser()!.point_avail))
                                    .font(Font.custom(FONT, size: 15))
                                    .lineLimit(2)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Color.gray)
                                    .layoutPriority(1)
                                
                                
                                HStack{
                                    Button(action: {
                                        self.showingModal = false
                                        self.animatingModal = false
                                        
                                    }) {
                                        Text("취소".uppercased())
                                            .font(Font.custom(FONT, size: 15))
                                            .fontWeight(.semibold)
                                            .accentColor(Color.gray)
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 8)
                                            .frame(minWidth: 120)
                                            .background(
                                                Capsule()
                                                    .strokeBorder(lineWidth: 1.75)
                                                    .foregroundColor(Color.gray)
                                        )
                                    }.padding().padding(.leading, 12)
                                    Button(action: {
                                        self.showingModal = false
                                        self.animatingModal = false
                                        let user = self.selectedUser!
                                        
                                        self.presentationMode.wrappedValue.dismiss()
                                        self.chatViewModel.composedMessage = SEND_LIKE_MESSAGE
                                        self.chatViewModel.sendTextMessage(recipientId: user.userId, recipientAvatarUrl: user.userAvatar, recipientUsername: user.username, completed: {
                                            self.chatViewModel.composedMessage = ""
                                            self.sendMessage = false
                                            //                self.presentationMode.wrappedValue.dismiss()
                                            
                                        }) { (error) in
                                            print(error)
                                        }
                                        
                                        
                                        
                                        
                                    }) {
                                        Text("확인".uppercased())
                                            .font(Font.custom(FONT, size: 15))
                                            .fontWeight(.semibold)
                                            .accentColor(Color("Color2"))
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 8)
                                            .frame(minWidth: 120)
                                            .background(
                                                Capsule()
                                                    .strokeBorder(lineWidth: 1.75)
                                                    .foregroundColor(Color("Color2"))
                                        )
                                    }.padding().padding(.trailing, 12)
                                    
                                }
                            }
                            
                            Spacer()
                        }
                        .frame(minWidth: 260, idealWidth: 260, maxWidth: 300, minHeight: 240, idealHeight: 260, maxHeight: 300, alignment: .center)
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
            
        }
        .navigationBarHidden(true)
        .navigationBarTitle("")
        
        
        
        
        
    }
}
func getAngleMultiplier(bounds: GeometryProxy) -> Double {
    if bounds.size.width > 500 {
        return 80
    } else {
        return 20
    }
}

struct MainSubViewFavorite: View{
    let title: String
    let users: [ActiveVote]
    @State var show : Bool  = false
    @State var showExpandView : Bool = false
    @State var isVoted : Bool  = true
    //    var user : User?
    
    var body : some View{
        
        
        ScrollView(.vertical, showsIndicators: false) {
            
            HStack{
                Text(I_LIKED).fontWeight(.heavy).font(Font.custom(FONT, size: 20)).foregroundColor(APP_THEME_COLOR)
                Spacer()
                
            }
            .padding(.horizontal)
            
            
            VStack(spacing: 20){
                ForEach(0..<users.chunked(3).count){index in
                    
                    HStack(spacing: 8){
                        ForEach(self.users.chunked(3)[index]){i in
                            
                            NavigationLink(destination: ExpandView(user: i, show: self.$show, isVoted: self.$isVoted)) {
                                FavoriteCard(user: i)
                                //                                Text(String(index))
                            }
                            
                            //                            Text(String(index))
                            //                            if(index <= 1){
                            //                                Spacer()
                            //
                            //                            }
                            
                            
                            
                            
                        }
                        
                    }
                    .padding(.horizontal, 5)
                    
                }
                
                
            }
            
            
        }
        
        
    }
}



struct FavoriteCard: View {
    let user: ActiveVote
    //    @Namespace var namespace
    
    var body: some View {
        VStack {
            
            ZStack(alignment: Alignment(horizontal: .trailing, vertical: .top)) {
                
                if(self.user.imageLocation != ""){
                    AnimatedImage(url: URL(string:self.user.imageLocation))
                        .resizable().frame(width: (UIScreen.main.bounds.width  ) / 3.1, height: (UIScreen.main.bounds.height ) / 5.2).cornerRadius(15)
                        .background(Color("Color-2"))
                        .cornerRadius(15)
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 8, y: 8)
                        .shadow(color: Color.white.opacity(0.5), radius: 5, x: -8, y: -8)
                        
                        
                        .overlay(
                            HStack {
                                Spacer()
                                VStack {
                                    Button(action: {
                                        
                                        
                                    }, label: {
                                        Image(systemName: "heart.fill")
                                            .font(.title)
                                            .foregroundColor(Color.white)
                                            .shadow(radius: 5)
                                            //                                            .opacity(self.pulsate ? 1 : 0.6)
                                            //                                            .scaleEffect(self.pulsate ? 1.3 : 0.9, anchor: .center)
                                            .animation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true))
                                    })
                                        .padding(.trailing, 20)
                                        .padding(.top, 24)
                                    
                                    Spacer()
                                }
                            }
                    )
                }
                else{
                    Image("")
                        .resizable().frame(width: (UIScreen.main.bounds.width  ) / 3.1, height: (UIScreen.main.bounds.height ) / 5.2).cornerRadius(15)
                        .background(Color("Color-2"))
                        .cornerRadius(15)
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 8, y: 8)
                        .shadow(color: Color.white.opacity(0.5), radius: 5, x: -8, y: -8)
                    
                    
                }
                
                
                
                
                
                //                Button(action: {
                //
                //                }){
                //                    Image(systemName: "heart.fill")
                //                    .frame(width: (UIScreen.main.bounds.width - 25) / 3)
                //                        .foregroundColor(.red)
                //                        .padding(.all,5)
                //                        .background(Color.white)
                //                        .clipShape(Circle())
                //                }   .padding(.all,5)
                
                
            }
            
            
        } .padding(.all, 8)
            .frame(width: (UIScreen.main.bounds.width - 35) / 3, height: (UIScreen.main.bounds.height ) / 5.2)
            .background(Color("Color-2"))
            .cornerRadius(15)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 8, y: 8)
            .shadow(color: Color.white.opacity(0.5), radius: 5, x: -8, y: -8)
        
        
        
    }
    
}


struct SectionView2: View {
    var user: Activity
    var width: CGFloat = UIScreen.main.bounds.height  / 5
    //    var height: CGFloat = 180
    
    var body: some View {
        VStack {
            
            AnimatedImage(url: URL(string:self.user.userAvatar))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: width)
            
        }
        .padding(.horizontal, 20)
        .frame(width: width, height: width)
        .background(Color.white)
        .cornerRadius(30)
        .shadow(color: Color.gray.opacity(0.2), radius: 20, x: 0, y: 20)
    }
}





extension Array{
    func chunked(_ size: Int)->[[Element]]{
        stride(from: 0, to: count, by: size).map{
            Array(self[$0 ..< Swift.min($0+size, count)])
        }
    }
}


