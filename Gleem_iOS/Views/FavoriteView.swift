//
//  FavoriteView.swift
//  Gleem_Dating
//
//  Created by Dustin yang on 7/6/20.
//  Copyright © 2020 Dustin yang. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

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
    @ObservedObject private var matchingViewModel = MatchingViewModel()
    @ObservedObject private var userViewModel = UserViewModel()
    @ObservedObject var textBindingManager = TextBindingManager(limit: 25)
    
    @State var showAlertX : Bool = false
    @State var sendMessage : Bool = false
    @State private var showingModal: Bool = false
    @State private var showMessageView: Bool = false
    @State private var animatingModal: Bool = false
    @State  private var selectedUser: Activity?
    @State private var showInfoView : Bool = false
//    @State private var isVoted : Bool = true
    
    let haptics = UINotificationFeedbackGenerator()
    
    init() {
        if(Reachabilty.HasConnection()){
            
                  self.favoriteViewModel.loadFavoriteUsers()
                  self.activityViewModel.loadSomeOneLike()
        }

      
    }
    
    
    func matched(){
        
        self.chatViewModel.composedMessage = self.textBindingManager.text != "" ?  self.textBindingManager.text : SEND_LIKE_MESSAGE
        print(self.chatViewModel.composedMessage)
        
        let recipient = InboxMessage.init(id: UUID(), lastMessage: "", username: self.selectedUser!.username, type: "", date:  Date().timeIntervalSince1970, userId: self.selectedUser!.userId, avatarUrl: self.selectedUser!.userAvatar, age: self.selectedUser!.age, location: self.selectedUser!.location, occupation: self.selectedUser!.occupation, description: self.selectedUser!.description)
        
        
        self.chatViewModel.sendTextMessage(recipient: recipient, completed: {
            self.chatViewModel.composedMessage = ""
            self.sendMessage = false

        }) { (error) in
            print(error)
        }
        self.matchingViewModel.persistMatching(user: self.selectedUser!)
    }
    
    var body: some View{
        
        VStack(spacing: 10){
            
            GeometryReader{geo in
                VStack{

                    if !self.activityViewModel.someOneLiked.isEmpty {
                        HStack{
                            Text(SOMEONE_LIKED).fontWeight(.heavy).font(Font.custom(FONT, size: 20))
                                .foregroundColor(APP_THEME_COLOR)
                                .shadow(color: Color.black.opacity(0.15), radius: 5, x: 0, y: 5)
                            //                                .shadow(color: Color.white.opacity(0.5), radius: 5, x: -8, y: -8)
                            Spacer()
                            Button(action: {
                                // ACTION
                                //        playSound(sound: "sound-click", type: "mp3")
                                self.haptics.notificationOccurred(.success)
                                self.showInfoView.toggle()
                            }) {
                                Image(systemName: "questionmark.circle")
                                    .font(.system(size: 24, weight: .regular))
                            }.onTapGesture {
                                self.showInfoView = true
                            }.accentColor(APP_THEME_COLOR)
                            
                            
                            //                            .sheet(isPresented: self.$showInfoView, content: {
                            //                                //                                InfoView()
                            //                                print("")
                            //                            })
                            //                             Spacer()
                        }
                        .padding(.horizontal).padding(.top, 5)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                
                                ForEach(self.activityViewModel.someOneLiked, id: \.activityId) { user in
                                    
                                    GeometryReader { geometry in
                                        
                                        SectionView2(user: user, mutualLike: self.favoriteViewModel.favoriteUsers_ids.contains(user.userId) ? true : false)
                                            .rotation3DEffect(Angle(degrees:
                                                Double(geometry.frame(in: .global).minX - 60) / -getAngleMultiplier(bounds: geo)
                                            ), axis: (x: 0, y: 50, z: 0))
                                            .onTapGesture {
                                                if (user.userAvatar != "" ){
                                                    self.showingModal.toggle()
                                                    self.selectedUser = user
                                                }
                                        }
                                        
                                    }
                                    .frame(width: geo.size.height / 5 , height: geo.size.height / 5)
                                }
                            }.padding(.horizontal).padding(.vertical, 6)
                            
                            //                    .padding(.bottom, 30)
                        }.background(Color.white)
                    }
                    
                    //                    else {
                    //                        VStack{
                    //
                    //                            //                        EmptyView()
                    //                            LoadingView(isLoading: self.activityViewModel.isLoading, error: self.activityViewModel.error) {
                    //                                self.activityViewModel.loadSomeOneLike()
                    //                                //                        }
                    //
                    //                            }
                    //                        }
                    //
                    //                    }
                    BannerAdView(bannerId: BANNER_UNIT_ID).frame(width: UIScreen.main.bounds.width, height: 60)

                    
                    VStack(spacing: 10){
                        if !self.favoriteViewModel.favoriteUsers.isEmpty {
                            MainSubViewFavorite(title: "Favorite Votes", users: self.favoriteViewModel.favoriteUsers, mutualLikedUsers: self.activityViewModel.someOneLiked_id)
                                .frame( height: geo.size.height / 1.5 )
                        }
//                        else {
//                            Spacer()
//
//                            LoadingView(isLoading: self.favoriteViewModel.isLoading, error: self.favoriteViewModel.error) {
//                                self.favoriteViewModel.loadFavoriteUsers()
//                            }
//                            Spacer()
//
//                        }
                    }
                    //                    .padding(.bottom, 60)
                    
                    
                    
                }
                .blur(radius: self.$showingModal.wrappedValue ? 5 : 0, opaque: false)
                
                // MARK: - POPUP
                //                       .sheet(isPresented: self.$showMessageView) {
                //
                //                                ZStack {
                //
                //                                    LoadingView2(filename: "heart2")
                //
                //                                }
                //                             ChatView( recipientId: self.selectedUser!.userId, recipientAvatarUrl: self.selectedUser!.userAvatar, recipientUsername: self.selectedUser!.username)
                //                    }
                
                if(self.showMessageView){
                    ZStack {
                        LoadingView2(filename: "heart2")
                    }
                }
                
                
                if self.showingModal {
                    ZStack {
                        
                        Color("ColorTransparentBlack").edgesIgnoringSafeArea(.all)
                        
                        // MODAL
                        VStack(spacing: 0) {
                            // TITLE
                            Text( self.selectedUser!.username + " 에게 말걸기")
                                .font(Font.custom(FONT, size: 20))
                                .fontWeight(.heavy)
                                .padding()
                                .frame(minWidth: 0, maxWidth: .infinity)
                                .background(APP_THEME_COLOR)
                                .foregroundColor(Color.white)
                            
                            Spacer()
                            
                            // MESSAGE
                            
                            VStack(spacing: 15) {
                                
                                
                                //
                                if(User.currentUser()!.point_avail >= POINT_USE){
                                    
                                    HStack{
                                        AnimatedImage(url: URL(string:User.currentUser()!.profileImageUrl))
                                            .resizable().frame(width: 70, height: 70).cornerRadius(15)
                                            .cornerRadius(35)
                                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 8, y: 8)
                                            .shadow(color: Color.white.opacity(0.5), radius: 5, x: -8, y: -8)
                                        
                                        Image("full-heart")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(maxHeight: 30)
                                        
                                        
                                        AnimatedImage(url: URL(string:self.selectedUser!.userAvatar))
                                            .resizable().frame(width: 70, height: 70).cornerRadius(15)
                                            .cornerRadius(35)
                                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 8, y: 8)
                                            .shadow(color: Color.white.opacity(0.5), radius: 5, x: -8, y: -8)
                                        
                                        
                                    }
                                    
                                    Text(MATCHING_CHECK_CURRENT_POINT)
                                        .font(Font.custom(FONT, size: 14))
                                        .lineLimit(2)
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(Color.gray)
                                        .layoutPriority(1)
                                    Text("현재 가진 포인트: " + String(User.currentUser()!.point_avail))
                                        .font(Font.custom(FONT, size: 14))
                                        .lineLimit(2)
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(Color.gray)
                                        .layoutPriority(1)
                                    //
                                    //                                    VStack(alignment: .leading, spacing: 15){
                                    //                                        Text(String(User.currentUserProfile()!.age) + "," + String(User.currentUserProfile()!.location))
                                    //                                                                                      .font(Font.custom(FONT, size: 14))
                                    //                                                                                      .lineLimit(2)
                                    //                                                                                      .multilineTextAlignment(.center)
                                    //                                                                                      .foregroundColor(Color.gray)
                                    //                                                                                      .layoutPriority(1)
//                                        Text(String(User.currentUserProfile()!.age) + "," + String(User.currentUserProfile()!.location))
//                                                                                                    .font(Font.custom(FONT, size: 14))
//                                                                                                    .lineLimit(2)
//                                                                                                    .multilineTextAlignment(.center)
//                                                                                                    .foregroundColor(Color.gray)
//                                                                                                    .layoutPriority(1)
//                                    }
                                    
                                    Text(String(User.currentUserProfile()!.age) + "," + String(User.currentUserProfile()!.location))
                                                                        .font(Font.custom(FONT, size: 14))
                                                                        .lineLimit(2)
                                                                        .multilineTextAlignment(.center)
                                                                        .foregroundColor(Color.gray)
                                                                        .layoutPriority(1)
                                    
                                }else{
                                    Text(NOT_ENOUGH_POINT + String(User.currentUser()!.point_avail))
                                        .font(Font.custom(FONT, size: 14))
                                        .lineLimit(3)
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(Color.gray)
                                        .layoutPriority(1)
                                }
                                
                                
                                VStack(spacing: 5){
                                    Divider().foregroundColor(Color.gray)
                                    HStack{
                                        Image(systemName: "text.bubble")
                                            .resizable().frame(width: 15, height: 15).foregroundColor(Color.gray)
                                          
                                        
                                        TextField("간단한 인삿말을 입력해주세요", text: self.$textBindingManager.text).font(Font.custom(FONT, size: 15))
                                            
                                            .multilineTextAlignment(.center)
                                            .foregroundColor(Color.gray)
                                            .layoutPriority(1)
                                    }
                                    
                                    Text(String(self.textBindingManager.text.count) + " / 25" ) .foregroundColor(Color.gray).font(Font.custom(FONT, size: 10)).padding(.horizontal,20).padding(.top,5)
                                    
                                    
                                } .padding().frame(height: 60)
                                HStack{
                                    Button(action: {
                                        self.showingModal = false
                                        self.animatingModal = false
                                        //                                         self.presentationMode.wrappedValue.dismiss()
                                        self.textBindingManager.text = ""
                                    }) {
                                        Text("취소".uppercased())
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
                                        
                                        self.showingModal = false
                                        self.animatingModal = false
                                        
                                        
                                        if(User.currentUser()!.point_avail >= POINT_USE){
                                            withAnimation(){
                                                self.showMessageView.toggle()
                                                
                                            }
                                            self.matched()
                                            self.userViewModel.updateUserPoint(point: User.currentUser()!.point_avail - POINT_USE)
                                            
                                        }
                                        
                                        
                                    }) {
                                        Text("확인".uppercased())
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
                        .frame(minWidth: 280, idealWidth: 280, maxWidth: 320, minHeight: 320, idealHeight: 340, maxHeight: 380, alignment: .center)
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
                
                if self.showInfoView {
                    ZStack {
                        
                        Color("ColorTransparentBlack").edgesIgnoringSafeArea(.all)
                        
                        // MODAL
                        VStack(spacing: 0) {
                            // TITLE
                            
                            Spacer()
                            VStack(spacing: 5) {
                                
                                Text(INFO_FAVORITE)
                                    .font(Font.custom(FONT, size: 15))
                                    .multilineTextAlignment(.leading)
                                    .lineLimit(2)
                                    .foregroundColor(Color.gray)
                                    .layoutPriority(1) .padding(.horizontal)
                                
                       
                                Button(action: {
                                    
                                    self.showInfoView = false
                                    self.animatingModal = false
                                    
                                }) {
                                    Text("확인".uppercased())
                                        .font(Font.custom(FONT, size: 15))
                                        .fontWeight(.semibold)
                                        .accentColor(APP_THEME_COLOR)
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 5)
                                        .frame(minWidth: 20)
                                        .background(
                                            Capsule()
                                                .strokeBorder(lineWidth: 1.75)
                                                .foregroundColor(APP_THEME_COLOR)
                                    )
                                }
                                
                                
                            }
                            
                            Spacer()
                            
                        }
                        .frame(minWidth: 260, idealWidth: 260, maxWidth: 300, minHeight: 70, idealHeight: 90, maxHeight: 110, alignment: .center)
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(color: Color("ColorTransparentBlack"), radius: 6, x: 0, y: 8)
                        .opacity(self.$animatingModal.wrappedValue ? 1 : 0)
                        .offset(y: self.$animatingModal.wrappedValue ? 0 : -100)
                        .animation(Animation.spring(response: 0.6, dampingFraction: 1.0, blendDuration: 1.0))
                        .onAppear(perform: {
                            self.animatingModal = true
                        })
                        .padding(.vertical, 5)
                    }
                    
                    
                    
                }
                
            }   .alert(isPresented: self.$showMessageView) {
                Alert(title: Text("연결!!!"), message: Text("축하해요 채팅으로 가서 대화를 나눠보세요~"),  dismissButton: .default(Text("OK"), action: {
                    //                        self.presentationMode.wrappedValue.dismiss()
                    //
                    
                }))
                
                
            }
            
        }
        .navigationBarHidden(true)
        .navigationBarTitle("").environment(\.horizontalSizeClass, .compact)
        
        
        
        
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
    let mutualLikedUsers: [String]
    
    @State var show : Bool  = true
    @State var showExpandView : Bool = false
    @State var isVoted : Bool  = true
    @State  var selectedUser : ActiveVote?
    @State var buttonPressed = [true,true,true,true,true]

    var body : some View{
        
         GeometryReader { g in
            ScrollView(.vertical, showsIndicators: false) {
                 
                 HStack{
                     Text(I_LIKED).fontWeight(.heavy).font(Font.custom(FONT, size: 20)).foregroundColor(APP_THEME_COLOR)
                         .shadow(color: Color.black.opacity(0.15), radius: 5, x: 0, y: 5)
                     //                    .shadow(color: Color.white.opacity(0.5), radius: 5, x: -8, y: -8)
                     Spacer()
                     
                 }
                 .padding(.horizontal).padding(.top, 10)
                 
                 
                 VStack(spacing: 5){
                    ForEach(0..<self.users.chunked(3).count){index in
                         
                         HStack(spacing: 8){
                             ForEach(self.users.chunked(3)[index]){i in
                                 
                                 
                                 if(i.imageLocation != ""){
                                     //                                NavigationLink(destination:   ExpandView(user: i, show: self.$show, isVoted: self.$isVoted)) {
                                     FavoriteCard(user: i, mutualLike: self.mutualLikedUsers.contains(i.id) ? true : false).onTapGesture {
                                         withAnimation{
                                             self.showExpandView.toggle()
                                             self.selectedUser = i

                                         }
                                         
                                     }
                                     
                                 }else{
                                     FavoriteCard(user: i, mutualLike: false)
                                 }
                                 
                                 
                             }
                             
                         }
                         .padding(.horizontal, 5)
                         
                     }
                     
                     
                 }
                 
             }.sheet(isPresented: self.$showExpandView){
                 ExpandView(user: self.selectedUser!, updateVoteImage: true, show: self.$show, isVoted:self.$isVoted, buttonPressed : self.buttonPressed, needMoveCard: false)
                           
            }.padding(.bottom, 60)
            
        }
 
    }
}



struct FavoriteCard: View {
    let user: ActiveVote
    var mutualLike: Bool
    //    @Namespace var namespace
    
    var body: some View {
        VStack {
            
            ZStack(alignment: Alignment(horizontal: .trailing, vertical: .top)) {
                
                if(self.user.imageLocation != ""){
                    AnimatedImage(url: URL(string:self.user.imageLocation))
                        .resizable().aspectRatio(contentMode: .fill).frame(width: (UIScreen.main.bounds.width  ) / 3.1, height: (UIScreen.main.bounds.height ) / 6).cornerRadius(15)
                        .background(Color("Color-2"))
                        .cornerRadius(15)
                        .shadow(color: Color.black.opacity(0.3), radius: 1, x: 1, y: 1)
                        .shadow(color: Color.white.opacity(0.5), radius: 5, x: -8, y: -8)
                        //                        .shadow(color: Color.white.opacity(0.5), radius: 5, x: -8, y: -8)
                        
                        
                        .overlay(
                            HStack {
                                Spacer()
                                VStack {
                                    Button(action: {
                                        
                                        
                                    }, label: {
                                        Image(mutualLike ?  "full-heart" : "half-heart").resizable().frame(width: 25, height: 25)
                                        //                                            .foregroundColor(Color.white)
                                        //                                            .shadow(radius: 3)
                                        //                                            .opacity(self.pulsate ? 1 : 0.6)
                                        //                                            .scaleEffect(self.pulsate ? 1.3 : 0.9, anchor: .center)
                                        //                                            .animation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true))
                                    })
                                        .padding(.trailing, 8)
                                        .padding(.top, 8)
                                        .buttonStyle(PlainButtonStyle())
                                    Spacer()
                                }
                            }
                    )
                }
                else{
                    Image("")
                        .resizable().aspectRatio(contentMode: .fill).frame(width: (UIScreen.main.bounds.width  ) / 3.2, height: (UIScreen.main.bounds.height ) / 6).cornerRadius(15)
                        .background(Color("Color-2"))
                        .cornerRadius(15)
                        .shadow(color: Color.black.opacity(0.3), radius: 1, x: 1, y: 1)
                        .shadow(color: Color.white.opacity(0.5), radius: 5, x: -8, y: -8)
                    
                }
                
                
            }
            
            
        }
            
        .padding(.all, 8)
        .frame(width: (UIScreen.main.bounds.width  - 35 ) / 3, height: (UIScreen.main.bounds.height ) / 5.8)
        .background(Color("Color-2"))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
        //            .shadow(color: Color.white.opacity(0.5), radius: 5, x: -8, y: -8)
        
        
        
    }
    
}


struct SectionView2: View {
    var user: Activity
    var mutualLike: Bool
    
    var width: CGFloat = UIScreen.main.bounds.height  / 5.5
    //    var height: CGFloat = 180
    
    var body: some View {
        VStack {
            
            
            if(self.user.userAvatar == "" ){
//                VStack{
                    Image("")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: width)
                        .background(Color("Color-2"))
                        .shadow(color: Color.black.opacity(0.3), radius: 1, x: 1, y: 1)
                        .shadow(color: Color.white.opacity(0.5), radius: 5, x: -8, y: -8)
//                    Text("현재 끌림을준 \n유저가 없습니다").font(Font.custom(FONT, size: 13))
//                        .foregroundColor(Color.gray)
                    
//                }
                
                
            }else{
                AnimatedImage(url: URL(string:self.user.userAvatar))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: width)
                    .shadow(color: Color.black.opacity(0.3), radius: 1, x: 1, y: 1)
                    .shadow(color: Color.white.opacity(0.5), radius: 5, x: -8, y: -8)
                    .overlay(
                        HStack {
                            Spacer()
                            VStack {
                                Button(action: {
                                    
                                    
                                }, label: {
                                    Image(mutualLike ? "full-heart" : "").resizable().frame(width: 25, height: 25)
                                    //                                            .foregroundColor(Color.white)
                                    //                                            .shadow(radius: 3)
                                    //                                            .opacity(self.pulsate ? 1 : 0.6)
                                    //                                            .scaleEffect(self.pulsate ? 1.3 : 0.9, anchor: .center)
                                    //                                            .animation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true))
                                })
                                    .padding(.trailing, 8)
                                    .padding(.top, 8)
                                    .buttonStyle(PlainButtonStyle())
                                Spacer()
                            }
                        }
                )
            }
            
            
            
        }
        .padding(.horizontal, 20)
        .frame(width: width, height: width)
        .background(Color.white)
        .cornerRadius(30)
        //        .shadow(color: Color.gray.opacity(0.2), radius: 20, x: 0, y: 20)
    }
}





extension Array{
    func chunked(_ size: Int)->[[Element]]{
        stride(from: 0, to: count, by: size).map{
            Array(self[$0 ..< Swift.min($0+size, count)])
        }
    }
}



class TextBindingManager: ObservableObject {
    @Published var text = "" {
        didSet {
            if text.count > characterLimit && oldValue.count <= characterLimit {
                text = oldValue
            }
        }
    }
    let characterLimit: Int
    
    init(limit: Int = 5){
        characterLimit = limit
    }
}
