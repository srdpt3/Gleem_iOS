//
//  FooterView.swift
//  Gleem_iOS
//
//  Created by Dustin yang on 7/14/20.
//  Copyright © 2020 Dustin yang. All rights reserved.
//
import SwiftUI

struct FooterView: View {
    // MARK: - PROPERTIES
    @Binding var isVoted: Bool
    @Binding var showVotingScreen: Bool
    
    @EnvironmentObject  var obs : observer
    
    let haptics = UINotificationFeedbackGenerator()
    
    var body: some View {
        
        HStack {
            
            Spacer()
            
            Button(action: {
                // ACTION
                //        playSound(sound: "sound-click", type: "mp3")
                self.haptics.notificationOccurred(.success)
                
                //                self.fireworkController.addFirework(sparks: 10)
                withAnimation{
                    self.showVotingScreen.toggle()
                }
            }) {
                Text(self.isVoted ? BUTTONNAME_AFTER_VOTE : BUTTONNAME )
                    //                    .font(.custom("CookieRun Regular", size: 18))
                    .font(.custom(FONT, size: CGFloat(BUTTON_TITLE_FONT_SIZE)))
                    .font(.system(.subheadline, design: .rounded))
                    .fontWeight(.heavy)
                    .padding(.horizontal, 25)
                    .padding(.vertical, 15)
                    .accentColor(APP_THEME_COLOR)
                //                    .background(
                //                        ZStack{
                //                            Color.white
                //                            RoundedRectangle(cornerRadius: 16, style: .continuous).foregroundColor(.white).blur(radius: 4)
                //                                .offset(x: -8, y: -8)
                //                            RoundedRectangle(cornerRadius: 16, style: .continuous).foregroundColor(Color.white)
                //                                .padding().blur(radius: 2)
                //                                .offset(x: 2, y: 2)
                //                        }
                //                )
                //                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                //                    .background(
                //                        Capsule().stroke(APP_THEME_COLOR, lineWidth: 2)
                //                )
            } .animation(.spring())
                .background(Color("Color-2"))
                .cornerRadius(15)
                .shadow(color: Color.black.opacity(0.3), radius: 5, x: 5, y: 5)
                            .shadow(color: Color.white.opacity(0.5), radius: 5, x: -8, y: -8)
                
                .frame(maxWidth: .infinity,
                       maxHeight: .infinity)
                
                .sheet(isPresented: self.$showVotingScreen) {
                    ExpandView(user: self.obs.users[self.obs.last], updateVoteImage: self.obs.updateVoteImage, show: self.$showVotingScreen, isVoted:self.$isVoted)
                        .animation(.spring(response: 0.5, dampingFraction: 0.7, blendDuration: 0))
                    
                    //                        shrinking the view in background...
                    //                    .scaleEffect(self.show ? 1 : 0)
                    //                    .frame(width: self.show ? nil : 0, height: self.show ? nil : 0)
            }
            
            Spacer()
            
            
        }
        .padding()
    }
}
