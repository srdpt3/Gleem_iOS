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
    @Environment(\.horizontalSizeClass) var sizeClass
    
    let haptics = UINotificationFeedbackGenerator()
    
    var body: some View {
        
        HStack(spacing: 22){
            
            //            if UIScreen.main.bounds.height < 896.0{
            Spacer()
            VStack { voteButtonView(isVoted: self.$isVoted, showVotingScreen: self.$showVotingScreen, height: UIScreen.main.bounds.height < 896.0 ? 50 : 60).offset(y: -10)}
            VStack { ArrowView(height: UIScreen.main.bounds.height < 896.0 ? 50 : 60).offset(y: -10) }
            Spacer()
            //            } else {
            //                 VStack { voteButtonView(isVoted: self.$isVoted, showVotingScreen: self.$showVotingScreen,  height: 100) }
            //                 Spacer().frame(height: 0)
            //                 VStack { ArrowView(height: 100) }
            
            //                Spacer()
            //                VStack { voteButtonView(isVoted: self.$isVoted, showVotingScreen: self.$showVotingScreen, height: 70).offset(y: -10)}
            //                VStack { ArrowView(height: 70).offset(y: -10) }
            //                Spacer()
            //            }
            
            
        }
        //        .padding(10)
    }
}


struct voteButtonView : View {
    @Binding var isVoted: Bool
    @Binding var showVotingScreen: Bool
    @EnvironmentObject  var obs : observer
    
    var height: CGFloat
    @State var error : Bool = false
    
    
    let haptics = UINotificationFeedbackGenerator()
    var body: some View{
        Group{
            Button(action: {
                // ACTION
                //        playSound(sound: "sound-click", type: "mp3")
                if(!self.obs.updateVoteImage){
                    self.error = true
                }else{
                    self.haptics.notificationOccurred(.success)
                    
                    //                self.fireworkController.addFirework(sparks: 10)
                    withAnimation{
                        self.showVotingScreen.toggle()
                    }
                }
                
                
                
            }) {
                Text(BUTTONNAME)
                    //                    .font(.custom("CookieRun Regular", size: 18))
                    .font(.custom(FONT, size: CGFloat(UIScreen.main.bounds.height < 896.0 ? BUTTON_TITLE_FONT_SIZE : 20)))
                    .font(.system(.subheadline, design: .rounded))
                    .fontWeight(.heavy)
                    .padding(self.height / 2)
                    //                        .padding(.vertical, 15)
                    .accentColor(APP_THEME_COLOR)
                
            } .background(Color("Color-3")).frame(height: self.height)
                .animation(.spring())
                .background(Color.white)
                .cornerRadius(15)
                .shadow(color: Color.black.opacity(0.15), radius: 5, x: 0, y: 5)
                
                //                .shadow(color: Color.white.opacity(0.5), radius: 5, x: -8, y: -8)
                //
                //                .frame(maxWidth: .infinity,
                //                       maxHeight: .infinity)
                
                .sheet(isPresented: self.$showVotingScreen) {
                    ExpandView(user: self.obs.users[self.obs.last], updateVoteImage: self.obs.updateVoteImage, show: self.$showVotingScreen, isVoted:self.$isVoted)
                        .environmentObject(self.obs)
                    
                    //                        .animation(.spring(response: 0.5, dampingFraction: 0.7, blendDuration: 0))
                    
                    //                        shrinking the view in background...
                    //                    .scaleEffect(self.show ? 1 : 0)
                    //                    .frame(width: self.show ? nil : 0, height: self.show ? nil : 0)
            }
            
        }.alert(isPresented: self.$error) {
            return Alert(title: Text("투표 사진을 먼저 등록해주세요").font(.custom(FONT, size: CGFloat(UIScreen.main.bounds.height < 896.0 ? BUTTON_TITLE_FONT_SIZE : 15))), message: Text(NOVOTEIMAGE).font(.custom(FONT, size: 12)), dismissButton: .default(Text(CONFIRM).font(.custom(FONT, size: 15)).foregroundColor(APP_THEME_COLOR), action: {
            }))
            
            
            
            
        }
        
    }
}

struct ArrowView : View {
    let haptics = UINotificationFeedbackGenerator()
    @EnvironmentObject  var obs : observer
    var height: CGFloat
    @State var error : Bool = false
    
    var body: some View{
        Group{
            Button(action: {
                // ACTION
                
                if(!self.obs.updateVoteImage){
                    self.error = true
                    
                }else{
                    
                    self.haptics.notificationOccurred(.success)
                    
                    
                    
                    //                self.fireworkController.addFirework(sparks: 10)
                    withAnimation{
                        //                         self.showVotingScreen.toggle()
                        self.obs.moveCards()
                    }
                }
                
                
            }, label: {
                
                
                
                Image(systemName: "xmark")
                    .padding(self.height / 2)
                    .accentColor(APP_THEME_COLOR)
                    .foregroundColor(APP_THEME_COLOR)
                    .shadow(radius: 8)
                    .opacity( 1 )
                    .scaleEffect( 1.0, anchor: .center)
                
            })
                .animation(.spring())
                .background(Color("Color-3")).frame(width: self.height, height: self.height)
                .cornerRadius(self.height / 2)
                .shadow(color: Color.black.opacity(0.15), radius: 5, x: 0, y: 5)
            
            //                .shadow(color: Color.black.opacity(0.3), radius: 1, x: 1, y: 1)
            //                .shadow(color: Color.white.opacity(0.5), radius: 5, x: -8, y: -8)
            
            //            Text("다음카드 보기")
            //                .font(.custom(FONT, size: 14))
            //                .font(.system(.subheadline, design: .rounded))
            //                .fontWeight(.heavy)
            //                //                            .padding(.horizontal, 30)
            //                //                            .padding(.vertical, 15)
            //                .accentColor(APP_THEME_COLOR)
        }
        .alert(isPresented: self.$error) {
            return Alert(title: Text("투표 사진을 먼저 등록해주세요"), message: Text(NOVOTEIMAGE).font(.custom(FONT, size: 14)), dismissButton: .default(Text(CONFIRM).font(.custom(FONT, size: 15)).foregroundColor(APP_THEME_COLOR), action: {
            }))
            
            
            
            
        }
    }
    
}
