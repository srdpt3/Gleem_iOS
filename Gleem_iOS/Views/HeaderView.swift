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
    @EnvironmentObject  var obs : observer
    
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
            }) .accentColor(Color.primary)
            
            
            Spacer(minLength: 70)
            
            Image(APP_LOGO)
                .resizable()
                .scaledToFit()
                .frame(height: 40).padding(.leading, 40)
            
            Spacer(minLength: 0)
            
            
            //            LottieView(filename: "noti").frame(width: 50, height: 50).onTapGesture {
            //                self.haptics.notificationOccurred(.success)
            //                self.showNotification.toggle()
            //            }
            
            Button(action: {
                // ACTION
                //        playSound(sound: "sound-click", type: "mp3")
                
                self.haptics.notificationOccurred(.success)
                self.showNotification.toggle()
                self.obs.newNotification = false
            }) {
                Image(systemName:  "bell.fill")
                    
                    .font(.system(size: 24, weight: .regular))
            }.overlay(
                HStack {
                    Spacer()
                    VStack {
                        Button(action: {
                            self.obs.newNotification = false
                            
                        }, label: {
                           
                                Circle().fill(Color("sleep")).frame(width: 12, height: 12).offset(x: 8,y : 5).opacity(self.obs.newNotification ?  1 : 0)
     
                        })
                            .padding(.trailing, 8)
                            .padding(.top, 8)
                            .buttonStyle(PlainButtonStyle())
                        Spacer()
                    }
                }
            )
                .accentColor(APP_THEME_COLOR)
                
                
                
                
                
                .sheet(isPresented: $showNotification) {
                    //        GuideView()
                    NotificationView().environmentObject(self.obs)
            }
            
            
            Button(action: {
                // ACTION
                //        playSound(sound: "sound-click", type: "mp3")
                self.haptics.notificationOccurred(.success)
                withAnimation{
                    
                    self.showProfile.toggle()
                    
                }
            }) {
                Image(systemName: "person")
                    .font(.system(size: 24, weight: .regular)).foregroundColor(APP_THEME_COLOR)
            }.buttonStyle(PlainButtonStyle())
            
            
        }
        .padding(.horizontal)
    }
}
