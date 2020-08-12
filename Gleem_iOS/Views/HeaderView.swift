//
//  HeaderView.swift
//  Gleem_iOS
//
//  Created by Dustin yang on 7/9/20.
//  Copyright © 2020 Dustin yang. All rights reserved.
//
import SwiftUI

struct HeaderView: View {
    // MARK: - PROPERTIES
    @Binding var showProfile : Bool
    @Binding var showInfoView : Bool
    @State var showNotification : Bool = false
    
    //    @State var showProfile = false
    @State var viewState = CGSize.zero
    let haptics = UINotificationFeedbackGenerator()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        HStack(alignment: .center){
            Button(action: {
                // ACTION
                //        playSound(sound: "sound-click", type: "mp3")
                self.haptics.notificationOccurred(.success)
                self.showInfoView.toggle()
            }) {
                Image(systemName: "info.circle")
                    .font(.system(size: 24, weight: .regular)).foregroundColor(APP_THEME_COLOR)
            } .onTapGesture {
                self.showInfoView = true
            }
            .sheet(isPresented: self.$showInfoView, content: {
                InfoView()
            })
                .accentColor(Color.primary)
            //          .sheet(isPresented: $showInfoView) {
            //
            //                        InfoView()
            //                    }
            
            Spacer()
            
            Image(APP_LOGO)
                .resizable()
                .scaledToFit()
                .frame(height: 40).padding(.leading, 40)
            
            Spacer(minLength: 20)
            
            
            LottieView(filename: "noti").frame(width: 50, height: 50).onTapGesture {
                self.haptics.notificationOccurred(.success)
                self.showNotification.toggle()
            }
                
                //            Button(action: {
                //                // ACTION
                //                //        playSound(sound: "sound-click", type: "mp3")
                //
                //                self.haptics.notificationOccurred(.success)
                //                self.showNotification.toggle()
                //            }) {
                //                Image(systemName:  BELL)
                //
                //                    .font(.system(size: 24, weight: .regular))
                //            }
                //            .accentColor(Color("bell"))
                .sheet(isPresented: $showNotification) {
                    //        GuideView()
                    NotificationView()
            }
            
            
            Button(action: {
                // ACTION
                //        playSound(sound: "sound-click", type: "mp3")
                self.haptics.notificationOccurred(.success)
                withAnimation{
                    
                    self.showProfile.toggle()
                    
                }
            }) {
                Image("menu").resizable().frame(width: 20, height: 20)
                    .font(.system(size: 24, weight: .regular)).foregroundColor(APP_THEME_COLOR)
            }.buttonStyle(PlainButtonStyle())
            
            
        }
        .padding(.horizontal)
    }
}
