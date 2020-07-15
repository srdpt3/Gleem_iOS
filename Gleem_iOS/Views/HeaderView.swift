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
        HStack {
            Button(action: {
                // ACTION
                //        playSound(sound: "sound-click", type: "mp3")
                self.haptics.notificationOccurred(.success)
                self.showInfoView.toggle()
                print(self.showInfoView)
            }) {
                Image(systemName: "info.circle")
                    .font(.system(size: 24, weight: .regular))
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
                .frame(height: 50)
            
            Spacer(minLength: 50)
            
            Button(action: {
                // ACTION
                //        playSound(sound: "sound-click", type: "mp3")
                
                self.haptics.notificationOccurred(.success)
                self.showNotification.toggle()
            }) {
                Image(systemName:  BELL)
                    
                    .font(.system(size: 24, weight: .regular))
            }
            .accentColor(Color("bell"))
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
                    .font(.system(size: 24, weight: .regular))
            }.buttonStyle(PlainButtonStyle())
            
            
        }
        .padding()
    }
}
