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
    @Binding var showNofiticationView : Bool
    
    //    @State var showProfile = false
    @State var viewState = CGSize.zero
    //    let haptics = UINotificationFeedbackGenerator()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        
            
            HStack {
                Button(action: {
                    // ACTION
                    //        playSound(sound: "sound-click", type: "mp3")
                    //                self.haptics.notificationOccurred(.success)
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
                
                Spacer(minLength: 50)
                Image(APP_LOGO)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 60, alignment: .center)
                
                 Spacer(minLength: 50)
                
                HStack(spacing: 10){
                    
                    //                NavigationLink(destination: NotificationView(), isActive: self.$showNofiticationView){
                    
                    Button(action: {
                        // ACTION
                        //        playSound(sound: "sound-click", type: "mp3")
                        //                self.haptics.notificationOccurred(.success)
                        self.showNofiticationView.toggle()
                    }) {
                        Image(systemName: BELL)
                            
                            .font(.system(size: 24, weight: .regular))
                    }
                    .sheet(isPresented: self.$showNofiticationView, content: {
                        NotificationView()
                    })
                        .accentColor(Color.primary)
                    //                }
                    
                    //                .sheet(isPresented: self.$showNofiticationView) {
                    //                                       //        GuideView()
                    //                    NotificationView(showNofiticationView: self.$showNofiticationView )
                    //                  }
                    //            .sheet(isPresente
                    
                    
                    //            Spacer()
                    //                Button(action: {
                    //                    // ACTION
                    //                    //        playSound(sound: "sound-click", type: "mp3")
                    //                    //                self.haptics.notificationOccurred(.success)
                    //                    //                self.showProfile.toggle()
                    //                }) {
                    //                    Image(systemName: "flag")
                    //
                    //                        .font(.system(size: 24, weight: .regular))
                    //                }
                    //                .accentColor(Color.primary)
                    //                //            .sheet(isPresented: $showGuideView) {
                    //                //                //        GuideView()
                    //                //                MenuView()
                    //                //            }
                    //                //
                    //                //
                    //
                    
                    
                    Button(action: {
                        // ACTION
                        //        playSound(sound: "sound-click", type: "mp3")
                        //                self.haptics.notificationOccurred(.success)
                        self.showProfile.toggle()
                    }) {
                        Image("menu").resizable().frame(width: 20, height: 20)
                            .font(.system(size: 24, weight: .regular))
                    }.buttonStyle(PlainButtonStyle())
                }
                
                
                
                
                
                
                //
                //                MenuView()
                //                    .background(Color.black.opacity(0.001))
                //                    .offset(y: self.showProfile ? 0 : screen.height)
                //                    .offset(y: self.viewState.height)
                //                    .animation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0))
                //                    .onTapGesture {
                //                        self.showProfile.toggle()
                //                }
                //                .gesture(
                //                    DragGesture().onChanged { value in
                //                        self.viewState = value.translation
                //                    }
                //                    .onEnded { value in
                //                        if self.viewState.height > 50 {
                //                            self.showProfile = false
                //                        }
                //                        self.viewState = .zero
                //                    }
                //                )
                
            }
            .padding()
            
      
        
    }
}
