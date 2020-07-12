//
//  Created by Robert Petras
//  SwiftUI Masterclass ♥ Better Apps. Less Code.
//  https://swiftuimasterclass.com 
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
                //                self.haptics.notificationOccurred(.success)
                self.showVotingScreen.toggle()
            }) {
                Text(self.isVoted ? BUTTONNAME_AFTER_VOTE : BUTTONNAME )
                    .font(.system(.subheadline, design: .rounded))
                    .fontWeight(.heavy)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .accentColor(Color("Color2"))
                    .background(
                        Capsule().stroke(Color("Color2"), lineWidth: 2)
                )
            } .animation(.linear)
                
                .sheet(isPresented: self.$showVotingScreen) {
                    ExpandView(user: self.obs.users[self.obs.last], show: self.$showVotingScreen, isVoted:self.$isVoted)
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
