//
//  NotificationView.swift
//  Gleem_iOS
//
//  Created by Dustin yang on 7/13/20.
//  Copyright © 2020 Dustin yang. All rights reserved.
//

import SwiftUI
import SwiftUI
import SDWebImageSwiftUI
struct NotificationView: View {
    
//    @ObservedObject private var activityViewModel = ActivityViewModel()
    @EnvironmentObject  var obs : observer

    
    
    
    init() {
//        self.obs.loadActivities()
    }
    var body: some View {
        
        NavigationView{
            GeometryReader{geo in
             
                VStack(spacing: 10){
                    VStack{
                        Image("Gleem 3D Icon Type Black Transparent_resized").resizable().scaledToFit().frame(height: 70).padding(.top, 10)
                        Text(NOTIFICATION_HEADER).font(Font.custom(FONT, size: 13)).foregroundColor(Color.gray)

                    }
                    Divider()
                    List{
                        if !self.obs.activityArray.isEmpty {
                            ForEach(self.obs.activityArray, id: \.activityId) { activity in
                                HStack {
                                    
                                    if activity.type == "like" {
                                        
                                        ZStack {
                                            NavigationLink(destination: FavoriteView()) {
                                                //                                            EmptyView()
                                                CommentActivityRow(notification: activity)
                                                
                                            }
                                        }
                                        
                                    }else if activity.type == "match"{
                                        MatchedActivityRow(notification: activity)
                                        
                                        
                                        
                                    }else if activity.type == "intro"{
                                        WelcomeActivityRow(notification: activity)
                                        
                                        
                                        
                                    }
                                    else if activity.type == "reject"{
                                        RejectActivityRow(notification: activity)
                                        
                                        
                                    }
                                    
                                    
                                }.padding(8)
                            }
                        }
                        
                        
                    }
                    
                }
                
                
                
                
            }.onAppear(){
                
            }
            .navigationBarTitle(Text(ACTIVITY).font(Font.custom(FONT, size: 20)).foregroundColor(APP_THEME_COLOR)
, displayMode: .inline)
                .onAppear {
                  self.obs.loadActivities()
             }
            .onDisappear {
//                 if self.activityViewModel.listener != nil {
//                     self.activityViewModel.listener.remove()
//
//                 }
              }
            
        }

        
    }
    
    
}


struct CommentActivityRow: View {
    var notification: UserNotification
    var body: some View {
        HStack {
            AnimatedImage(url: URL(string: notification.userAvatar))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipShape(Circle()).frame(width: 40, height: 40)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(notification.username).font(.subheadline).bold()
                Text(notification.typeDescription).font(.caption).font(Font.custom(FONT, size: 15))
            }
            Spacer()
            Text(timeAgoSinceDate(Date(timeIntervalSince1970: notification.date), currentDate: Date(), numericDates: true)).font(.caption).foregroundColor(.gray)
        }
    }
}


struct MatchedActivityRow: View {
    var notification: UserNotification
    var body: some View {
        HStack {
//            
//            Image("Gleem_3D")
//                .resizable()
//                .aspectRatio(contentMode: .fill)
//                .clipShape(Circle()).frame(width: 40, height: 40)
            
            AnimatedImage(url: URL(string: notification.userAvatar))
                 .resizable()
                 .aspectRatio(contentMode: .fill)
                 .clipShape(Circle()).frame(width: 40, height: 40)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(notification.username + "[연결됨]").font(.subheadline).bold()
                Text(notification.typeDescription).font(.caption).font(Font.custom(FONT, size: 15))
            }
            Spacer()
            Text(timeAgoSinceDate(Date(timeIntervalSince1970: notification.date), currentDate: Date(), numericDates: true)).font(.caption).foregroundColor(.gray)
        }
    }
}


struct  WelcomeActivityRow: View {
    var notification: UserNotification
    var body: some View {
        HStack {
            
            Image("Gleem_3D")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipShape(Circle()).frame(width: 40, height: 40)
//            ZStack{
//                LottieView(filename: "welcome").frame(width: 40, height: 40)
//
//            }
            VStack(alignment: .leading, spacing: 5) {
                Text("Welcome").font(.subheadline).bold()
                Text(notification.typeDescription).font(.caption).font(Font.custom(FONT, size: 13))
            }
            Spacer()
            Text(timeAgoSinceDate(Date(timeIntervalSince1970: notification.date), currentDate: Date(), numericDates: true)).font(.caption).foregroundColor(.gray)
        }
    }
}


struct  RejectActivityRow: View {
    var notification: UserNotification
    var body: some View {
        HStack {
            
            Image("fail")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipShape(Circle()).frame(width: 40, height: 40)

            VStack(alignment: .leading, spacing: 5) {
                Text(notification.typeDescription).font(.caption).font(Font.custom(FONT, size: 13))
            }
            Spacer()
            Text(timeAgoSinceDate(Date(timeIntervalSince1970: notification.date), currentDate: Date(), numericDates: true)).font(.caption).foregroundColor(.gray)
        }
    }
}
