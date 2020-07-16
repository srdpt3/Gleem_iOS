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
    
    @ObservedObject var messageViewModel = MessageViewModel()
    
    
    var body: some View {
        //        NavigationView {
        
        HomeView()
        //        }
        
        
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
    var body: some View{
        List {
            if !messageViewModel.inboxMessages.isEmpty {
                ForEach(messageViewModel.inboxMessages, id: \.id) { inboxMessage in
                    NavigationLink(destination: ChatView(recipientId: inboxMessage.userId, recipientAvatarUrl: inboxMessage.avatarUrl, recipientUsername: inboxMessage.username)) {
                        HStack {
                            AnimatedImage(url: URL(string: inboxMessage.avatarUrl)!)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .clipShape(Circle())
                                .frame(width: 50, height: 50)
                            VStack(alignment: .leading, spacing: 5) {
                                Text(inboxMessage.username).font(.headline).bold()
                                Text(inboxMessage.lastMessage).font(.subheadline).lineLimit(2)
                            }
                            Spacer()
                            VStack(spacing: 5) {
                                Text(timeAgoSinceDate(Date(timeIntervalSince1970: inboxMessage.date), currentDate: Date(), numericDates: true)).font(.caption).padding(.leading, 15)
                                //                                 Text("2").padding(8).background(Color.blue).foregroundColor(Color.white).clipShape(Circle())
                            }
                            
                        }.padding(10)
                    }
                    
                }
            }
            
        }.navigationBarTitle("").navigationBarHidden(true)
            
            //            .navigationBarTitle(Text("Messages"), displayMode: .inline)
            .onDisappear {
                if self.messageViewModel.listener != nil {
                    self.messageViewModel.listener.remove()
                }
        }
        //            .onAppear() {
        //                if self.messageViewModel.listener != nil {
        //                    self.messageViewModel.loadInboxMessages()
        //                }
        //        }
    }
    
}

struct topView : View {
    
    var body : some View{
        
        VStack{
            
            HStack(spacing: 15){
                
                Text(MESSAGEVIEW_TITLE).fontWeight(.heavy).font(.system(size: 23))
                
                Spacer()
                
                //                Button(action: {
                //
                //                }) {
                //
                //                    Image(systemName: "magnifyingglass").resizable().frame(width: 20, height: 20)
                //                }
                //
                //                Button(action: {
                //
                //                }) {
                //
                //                    Image("menu").resizable().frame(width: 20, height: 20)
                //                }
                
            }
            .foregroundColor(Color.white)
            .padding()
            
            GeometryReader{_ in
                
                MessageSubView().clipShape(Rounded())
            }
        }
        
        
    }
}

struct Rounded : Shape {
    
    func path(in rect: CGRect) -> Path {
        
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: .topLeft, cornerRadii: CGSize(width: 55, height: 55))
        return Path(path.cgPath)
    }
}
