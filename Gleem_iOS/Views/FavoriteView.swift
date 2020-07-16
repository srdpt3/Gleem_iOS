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
    
    
    init() {
        self.favoriteViewModel.loadFavoriteUsers()
        self.activityViewModel.loadActivities()
    }
    
    func sendMessage(user: Activity){

        
        if(self.sendMessage){
            self.presentationMode.wrappedValue.dismiss()
            self.chatViewModel.composedMessage = SEND_LIKE_MESSAGE
            self.chatViewModel.sendTextMessage(recipientId: user.userId, recipientAvatarUrl: user.userAvatar, recipientUsername: user.username, completed: {
                self.chatViewModel.composedMessage = ""
                self.sendMessage = false
//                self.presentationMode.wrappedValue.dismiss()

            }) { (error) in
                print(error)
            }
            
        }
    }
    
    var body: some View{
        
        VStack(spacing: 10){
            
            
            GeometryReader{geo in
                VStack{
                    
                    HStack{
                        Text(SOMEONE_LIKED).fontWeight(.heavy).font(Font.custom(FONT, size: 20))
                            .foregroundColor(APP_THEME_COLOR)
                        Spacer()
                        
                    }
                    .padding(.horizontal)
                    if !self.favoriteViewModel.favoriteUsers.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                //                                    ForEach(self.activityViewModel.activityArray) { user in
                                ForEach(self.activityViewModel.activityArray, id: \.activityId) { user in
                                    GeometryReader { geometry in
                                        //                                            NavigationLink(destination: ChatView(recipientId: user.id, recipientAvatarUrl: user.imageLocation, recipientUsername: user.username)){
                                        
                                        SectionView2(user: user)
                                            .rotation3DEffect(Angle(degrees:
                                                Double(geometry.frame(in: .global).minX - 60) / -getAngleMultiplier(bounds: geo)
                                            ), axis: (x: 0, y: 50, z: 0))
                                            .onTapGesture {
                                                
                                                self.showAlertX.toggle()
                                                
                               
                                                //                                                                  AlertX(title: Text("AlertX Title"),
                                                //                                                                         message: Text("An optional message indicating some action goes here..."),
                                                //                                                                         primaryButton: .cancel(),
                                                //                                                                         secondaryButton: .default(Text("Done"), action: {
                                                //                                                                          // Some action
                                                //                                                                         }),
                                                //                                                                         theme: .graphite(withTransparency: true, roundedCorners: true),
                                                //                                                                         animation: .classicEffect())
                                                //
                                                
                                                
                                                
                                        }.alertX(isPresented: self.$showAlertX, content: {
                                            
                                            AlertX(title: Text("상대방이랑 채팅하기").font(Font.custom(FONT, size: 20))
                                                .foregroundColor(APP_THEME_COLOR),
                                                   message: Text("채팅하기에 1포인트가 소모됩니다. \n현재 가진 포인트: " + String(User.currentUser()!.point_avail)),
                                                   primaryButton: .cancel(),
                                                   secondaryButton: .default(Text("확인"), action: {
                                                    self.sendMessage.toggle()
//                                                    self.sendMessage(user: user)
//                                                    self.presentationMode.wrappedValue.dismiss()
                                                   }
                                                    
                                                ),
                                                   theme: .light(withTransparency: true, roundedCorners: true),
                                                   animation: .classicEffect())
                                        })
                                        
                                        
                                        
                                        
                                    }
                                    .frame(width: geo.size.height / 4.5 , height: geo.size.height / 4.5)
                                }
                            }.padding()
                            
                            //                    .padding(.bottom, 30)
                        }.background(Color.black.opacity(0.06))
                    } else {
                        Spacer()
                        
                        LoadingView(isLoading: self.favoriteViewModel.isLoading, error: self.favoriteViewModel.error) {
                            self.favoriteViewModel.loadFavoriteUsers()
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
                Text(I_LIKED).fontWeight(.heavy).font(Font.custom(FONT, size: 20)) .foregroundColor(APP_THEME_COLOR)
                Spacer()
                
            }
            .padding(.horizontal)
            
            
            VStack(spacing: 20){
                ForEach(0..<users.chunked(3).count){index in
                    
                    HStack(spacing: 8){
                        ForEach(self.users.chunked(3)[index]){i in
                            
                            NavigationLink(destination: ExpandView(user: i, show: self.$show, isVoted: self.$isVoted)) {
                                FavoriteCard(user: i)
                                
                            }
                            Spacer()
                            
                            
                        }
                    }.padding(.horizontal, 5)
                    
                }
            }
            
            
        }
        
        
    }
}
//
//struct MainSubViewFavorite2: View{
//    let title: String
//    let users: [ActiveVote]
//    @State var show : Bool  = false
//
//    @State var showExpandView : Bool = false
//    @State var isVoted : Bool  = true
//    //    var user : User?
//    @State var selectedUser : User?
//
//    var body : some View{
//
//        VStack(alignment: .leading) {
//            HStack{
//
//                Text("나에게 끌림").fontWeight(.heavy).font(.headline)
//                    .foregroundColor(Color("Color2"))
//                //                Spacer()
//
//
//            }.padding(.leading, 12)
//
//            ScrollView(.horizontal, showsIndicators: false) {
//                HStack(spacing: 12) {
//                    HStack(spacing : 12){
//                        ForEach(self.users) { i in
//
//                            FavoriteCard2(user: i).onTapGesture {
//                                self.show.toggle()
//                            }.blur(radius: 5)
//                                .padding(.leading, i.id == self.users.first!.id ? 12 : 0)
//                                .padding(.trailing, i.id == self.users.last!.id ? 12 : 0)
//                        }
//                    }
//
//
//
//                }
//            }
//
//        }
//
//
//
//    }
//
//
//}
//



struct FavoriteCard2: View {
    let user: ActiveVote
    
    var body: some View {
        VStack {
            AnimatedImage(url: URL(string:self.user.imageLocation))
                .resizable().frame(width :  (UIScreen.main.bounds.width ) / 3, height:  (UIScreen.main.bounds.height ) / 8).cornerRadius(20).aspectRatio(contentMode: .fit)
            
            HStack {
                
                Text(user.username).font(.footnote).lineLimit(1)
            }
            
            
            
            
        } .padding(.all, 8)
            .frame(width: (UIScreen.main.bounds.width - 25) / 3.1)
            .background(Color("Color-2"))
            .cornerRadius(15)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 8, y: 8)
            .shadow(color: Color.white.opacity(0.5), radius: 5, x: -8, y: -8)
        
        
        
    }
    
}



struct FavoriteCard: View {
    let user: ActiveVote
    //    @Namespace var namespace
    
    var body: some View {
        VStack {
            
            ZStack(alignment: Alignment(horizontal: .trailing, vertical: .top)) {
                AnimatedImage(url: URL(string:self.user.imageLocation))
                    .resizable().frame(width: (UIScreen.main.bounds.width - 35) / 3, height: (UIScreen.main.bounds.height ) / 5.2).cornerRadius(15)
                
                
                Button(action: {
                    
                }){
                    Image(systemName: "heart.fill")
                        .foregroundColor(.red)
                        .padding(.all,5)
                        .background(Color.white)
                        .clipShape(Circle())
                }   .padding(.all,5)
                
                
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
    var width: CGFloat = 160
    var height: CGFloat = 160
    
    var body: some View {
        VStack {
            
            AnimatedImage(url: URL(string:self.user.userAvatar))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 160)
            
        }
        .padding(.horizontal, 20)
        .frame(width: width, height: height)
        .background(Color.white)
        .cornerRadius(30)
        .shadow(color: Color("Color2").opacity(0.3), radius: 20, x: 0, y: 20)
    }
}




extension Array{
    func chunked(_ size: Int)->[[Element]]{
        stride(from: 0, to: count, by: size).map{
            Array(self[$0 ..< Swift.min($0+size, count)])
        }
    }
}


