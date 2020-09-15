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
    @Binding var uploadComplete : Bool
    @Environment(\.horizontalSizeClass) var sizeClass
    
    let haptics = UINotificationFeedbackGenerator()
    
    var body: some View {
        
        HStack(spacing: 22){
            
            //            if UIScreen.main.bounds.height < 896.0{
            Spacer()
            VStack { voteButtonView(isVoted: self.$isVoted, showVotingScreen: self.$showVotingScreen, height: UIScreen.main.bounds.height < 896.0 ? 50 : 60, uploadComplete: self.$uploadComplete)}.offset(y: 5)
            VStack { ArrowView(height: UIScreen.main.bounds.height < 896.0 ? 50 : 60, uploadComplete: self.$uploadComplete) }.offset(y: 5)
            Spacer()
            
            
        }
    }
}


struct voteButtonView : View {
    @Binding var isVoted: Bool
    @Binding var showVotingScreen: Bool
    @EnvironmentObject  var obs : observer
    @State var noVotePic : Bool = false
    var height: CGFloat
    @Binding var uploadComplete : Bool
    
    @State var error : Bool = false
    @State var showUploadView : Bool = false
    
    
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
                    withAnimation{
                        self.showVotingScreen.toggle()
                    }
                }
                
                
                
            }) {
                
                HStack(alignment: .center, spacing:5) {
                    Spacer()
                    Image(systemName: "suit.heart")
                        .font(.custom(FONT, size: CGFloat(UIScreen.main.bounds.height < 896.0 ? BUTTON_TITLE_FONT_SIZE : 20)))
                    .accentColor(APP_THEME_COLOR)

                    Text(BUTTONNAME)
                        //                    .font(.custom("CookieRun Regular", size: 18))
                        .font(.custom(FONT, size: CGFloat(UIScreen.main.bounds.height < 896.0 ? BUTTON_TITLE_FONT_SIZE : 20)))
//                        .font(.system(.subheadline, design: .rounded))
                        .fontWeight(.heavy)
                       
                        //                        .padding(.vertical, 15)
                        .accentColor(APP_THEME_COLOR)
                    Spacer()

                } .padding(.vertical, self.height / 2)
                
                
                
            } .background(Color("Color-3")).frame(height: self.height)
                .animation(.spring())
//                .background(Color.black.opacity(0.02))
                .cornerRadius(25)
                .shadow(color: Color.black.opacity(0.15), radius: 5, x: 0, y: 5)
                .sheet(isPresented: self.$showVotingScreen) {
                    ExpandView(user: self.obs.users[self.obs.last], updateVoteImage: self.obs.updateVoteImage, show: self.$showVotingScreen, isVoted:self.$isVoted)
                        .environmentObject(self.obs)
                    
                    //                        .animation(.spring(response: 0.5, dampingFraction: 0.7, blendDuration: 0))
                    
                    //                        shrinking the view in background...
                    //                    .scaleEffect(self.show ? 1 : 0)
                    //                    .frame(width: self.show ? nil : 0, height: self.show ? nil : 0)
            }
            
        }
        .alert(isPresented: self.$error) {
            return Alert(title: Text("투표 사진을 먼저 등록해주세요"), message: Text(NOVOTEIMAGE), primaryButton: Alert.Button.default(Text(PHOTOUPLOAD_FROM_MAIN), action: {
                self.showUploadView.toggle()
            }), secondaryButton: Alert.Button.cancel(Text(CONFIRM), action: {})
            )
            
        }
            
        .sheet(isPresented: self.$showUploadView) {
            
            UploadView(vote: Vote(attr1: 0, attr2 : 0 , attr3 : 0 , attr4: 0, attr5: 0,attrNames:["없음", "없음","없음", "없음", "없음"], numVote: 0, createdDate: Date().timeIntervalSince1970, lastModifiedDate: Date().timeIntervalSince1970, imageLocation: ""), noVotePic: self.$noVotePic,uploadComplete: self.$uploadComplete).environmentObject(self.obs)
            
        }
        
    }
}

struct ArrowView : View {
    let haptics = UINotificationFeedbackGenerator()
    @EnvironmentObject  var obs : observer
    @ObservedObject private var voteViewModel = VoteViewModel()
    var height: CGFloat
    @State var error : Bool = false
    
    @State var noVotePic : Bool = false
    @Binding var uploadComplete : Bool
    @State var showUploadView : Bool = false
    var body: some View{
        Group{
            Button(action: {
                // ACTION
                
                if(!self.obs.updateVoteImage){
                    self.error = true
                    
                }else{
                    
                    self.haptics.notificationOccurred(.success)
                    
                    self.voteViewModel.skip(id: self.obs.users[self.obs.last].id)
                    
                    withAnimation{
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
            
        }  .sheet(isPresented: self.$showUploadView) {
            
            UploadView(vote: Vote(attr1: 0, attr2 : 0 , attr3 : 0 , attr4: 0, attr5: 0,attrNames:["없음", "없음","없음", "없음", "없음"], numVote: 0, createdDate: Date().timeIntervalSince1970, lastModifiedDate: Date().timeIntervalSince1970, imageLocation: ""), noVotePic: self.$noVotePic,uploadComplete: self.$uploadComplete).environmentObject(self.obs)
            
        }
        .alert(isPresented: self.$error) {
            return Alert(title: Text("투표 사진을 먼저 등록해주세요"), message: Text(NOVOTEIMAGE), primaryButton: Alert.Button.default(Text(PHOTOUPLOAD_FROM_MAIN), action: {
                self.showUploadView.toggle()
            }), secondaryButton: Alert.Button.cancel(Text(CONFIRM), action: {
                
                
                
            })
            )
            
            
            
            
            
        }
        
        
    }
    
}
