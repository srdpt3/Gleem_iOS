//
//  MessagesView.swift
//  Gleem_iOS
//
//  Created by Dustin yang on 7/12/20.
//  Copyright © 2020 Dustin yang. All rights reserved.
//
import SwiftUI
//import URLImage
import SDWebImageSwiftUI
struct MessagesView: View {
    
    var body: some View {
        //        NavigationView {
        HomeView()
        
        
        
    }
}
struct HomeView : View {
    
    var body : some View{
        
        ZStack{
            APP_THEME_COLOR.edgesIgnoringSafeArea(.top)
            VStack{
                topView()
            }
        }
    }
}

struct MessageSubView: View {
    @ObservedObject var messageViewModel = MessageViewModel()
    @State var doneChatting : Bool = false
    @State var reportUser : Bool = false
    
    @State var indexSet : IndexSet = IndexSet()
    @State  var showMessageView: Bool = false
    @State  var animatingModal: Bool = false
    @State var showFavoriteView : Bool = false
    @State var userID : String = ""
    @State var userNickName : String = ""
    @State var rowNum : Int = 0
    
    @EnvironmentObject  var obs : observer
    
    init(){
        self.messageViewModel.loadInboxMessages()
        
    }
    var body: some View{
        ZStack{
       
   
            if(Reachabilty.HasConnection()){
                List {
                     if !messageViewModel.inboxMessages.isEmpty  {
                         
                         //                    ForEach(messageViewModel.inboxMessages, id: \.id) { inboxMessage in
                         ForEach(Array(self.messageViewModel.inboxMessages.enumerated()), id: \.offset) { index, inboxMessage in
                             
                             //                         recipientId: inboxMessage.userId, recipientAvatarUrl: inboxMessage.avatarUrl, recipientUsername: inboxMessage.username
                             NavigationLink(destination:ChatView(recipient: inboxMessage,reportUser: self.$reportUser ,rowNum: self.$rowNum, id: index))  {
                                 HStack {
                                     AnimatedImage(url: URL(string: inboxMessage.avatarUrl)!)
                                         .resizable()
                                         .aspectRatio(contentMode: .fill)
                                         .clipShape(Circle())
                                         .frame(width: 50, height: 50)
                                     VStack(alignment: .leading, spacing: 5) {
                                         Text(inboxMessage.username).font(.headline).bold()
                                         Text(inboxMessage.lastMessage).font(.custom(FONT, size: 13)).foregroundColor(Color.black.opacity(0.7)).lineLimit(2)
                                     }
                                     Spacer()
                                     VStack(spacing: 5) {
                                         Text(timeAgoSinceDate(Date(timeIntervalSince1970: inboxMessage.date), currentDate: Date(), numericDates: true)).font(.caption).padding(.leading, 15)
                                     }
                                     
                                     
                                     
                                 }.padding(10)
                             }
                             
                         }
                         .onDelete(perform: delete).onAppear{
                             if(self.reportUser){
                                 self.removeUser(rowNum: self.rowNum)
                                 
                             }
                         }
                     } else{
                        if(!self.messageViewModel.isInboxLoading){
                            ZStack{
                                EmptyChattingView()
                              }
                        }
                        
                         
                     }
                     //                BannerAdView(bannerId: BANNER_UNIT_ID).frame(width: UIScreen.main.bounds.width, height: 60)
                     
                 }.onAppear(){
                     //                self.messageViewModel.loadInboxMessages()
                 }
                 .blur(radius: self.$doneChatting.wrappedValue ? 5 : 0, opaque: false)
                 
            
                
            }else{
                ZStack{
                                           EmptyChattingView()
                                       }
            }
 
      
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
                            
                            HStack{
                                Text(self.userNickName  + END_CHAT)
                                    .font(Font.custom(FONT, size: 15))
                                    .lineLimit(2)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Color.gray)
                                    .layoutPriority(1)
                                
                                Button(action: {
                                }) {
                                    
                                    Image("heart_broken").resizable().frame(width: 30, height: 30).foregroundColor(Color("sleep"))
                                }
                            }
                            
                            
                            
                            HStack{
                                Button(action: {
                                    self.animatingModal = false
                                    self.doneChatting.toggle()
                                    
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
                                    
                                    withAnimation(){
                                        self.doneChatting.toggle()
                                        
                                    }
                                    self.messageViewModel.leaveRoom(recipientId: self.userID)
                                    
                                    self.indexSet.forEach {
                                        self.messageViewModel.inboxMessages.remove(at: $0)
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
            
            
            
        }.navigationBarTitle("").navigationBarHidden(true)
        
        
    }
    
    
    
    private func delete(with indexSet: IndexSet) {
        let index = indexSet[indexSet.startIndex]
        self.userNickName = messageViewModel.inboxMessages[index].username
        self.userID =   messageViewModel.inboxMessages[index].userId
        self.doneChatting = true
        self.indexSet = indexSet
        
        
    }
    
    private func removeUser(rowNum:Int){
        self.userID = self.messageViewModel.inboxMessages[rowNum].userId
        print("reported user \(self.userID)")
        self.reportUser  = false
        self.messageViewModel.inboxMessages.remove(at: rowNum)
       self.messageViewModel.leaveRoom(recipientId: self.userID)
        
    }
}

struct topView : View {
    
    var body : some View{
        
        VStack(alignment: .center){
            Spacer()
            Image("gleem_logo_all_white")
                .resizable()
                .scaledToFit()
                .frame(height: 40)
            //            HStack(spacing: 15){
            //
            //                Text(MESSAGEVIEW_TITLE).fontWeight(.heavy).font(.system(size: 23))
            //
            //                Spacer()
            //                //
            //                //                                Button(action: {
            //                //
            //                //                                }) {
            //                //
            //                //                                    Image(systemName: "magnifyingglass").resizable().frame(width: 20, height: 20)
            //                //                                }
            //                //
            //                //                                Button(action: {
            //                //
            //                //                                }) {
            //                //
            //                //                                    Image("menu").resizable().frame(width: 20, height: 20)
            //                //                                }
            //
            //            }
            //            .foregroundColor(Color.white)
            //            .padding()
            Text(NOTIFICATION_HEADER).font(Font.custom(FONT, size: 13)).foregroundColor(Color.white)
            
            GeometryReader{_ in
                
                MessageSubView().clipShape(Rounded())
            }
        }
        
        
    }
}

struct Rounded : Shape {
    
    func path(in rect: CGRect) -> Path {
        
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: .topLeft, cornerRadii: CGSize(width: 45, height: 45))
        return Path(path.cgPath)
    }
}

struct LazyView<Content: View>: View {
    let build: () -> Content
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    var body: Content {
        build()
    }
}
