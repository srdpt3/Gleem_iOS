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
  @Binding var showGuideView: Bool
  @Binding var showInfoView: Bool
  let haptics = UINotificationFeedbackGenerator()
  
  var body: some View {
    HStack {
      Button(action: {
        // ACTION
//        playSound(sound: "sound-click", type: "mp3")
        self.haptics.notificationOccurred(.success)
        self.showInfoView.toggle()
      }) {
        Image(systemName: "info.circle")
          .font(.system(size: 24, weight: .regular))
      }
      .accentColor(Color.primary)
      .sheet(isPresented: $showInfoView) {
        InfoView()
      }
      
      Spacer()
      
      Image("gleem_resized")
        .resizable()
        .scaledToFit()
        .frame(height: 50)
      
      Spacer()
      
      Button(action: {
        // ACTION
//        playSound(sound: "sound-click", type: "mp3")
        self.haptics.notificationOccurred(.success)
        self.showGuideView.toggle()
      }) {
        Image(systemName: "questionmark.circle")
          .font(.system(size: 24, weight: .regular))
      }
      .accentColor(Color.primary)
//      .sheet(isPresented: $showGuideView) {
//        GuideView()
//      }
    }
    .padding()
  }
}

struct HeaderView_Previews: PreviewProvider {
  @State static var showGuide: Bool = false
  @State static var showInfo: Bool = false
  
  static var previews: some View {
    HeaderView(showGuideView: $showGuide, showInfoView: $showInfo)
      .previewLayout(.fixed(width: 375, height: 80))
  }
}
