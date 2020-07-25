//
//  MainCardView.swift
//  Gleem_iOS
//
//  Created by Dustin yang on 7/14/20.
//  Copyright © 2020 Dustin yang. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct MainCardView: View, Identifiable {
  // MARK: - PROPERTIES
  
  let id = UUID()
  var user: ActiveVote
  
  var body: some View {
//    Image(honeymoon.image)
    AnimatedImage(url: URL(string:self.user.imageLocation))
        .resizable().frame(height: 550)
      .cornerRadius(24)
//      .scaledToFit()
        .frame(minWidth: 0, maxWidth: .infinity)
      .overlay(
        VStack(alignment: .center, spacing: 12) {
            Spacer()
            Text(user.username.uppercased()).font(Font.custom(FONT_BOLD, size: 30))
            .foregroundColor(Color.white)
//                .font(.title)
            .fontWeight(.bold)
            .shadow(radius: 1)
            .padding(.horizontal, 18)
            .padding(.vertical, 4)
//            .overlay(
//              Rectangle()
//                .fill(Color.white)
//                .frame(height: 1),
//              alignment: .bottom
//          )
//            Text(user.age.uppercased())
//            .foregroundColor(Color.black)
//            .font(.footnote)
//            .fontWeight(.bold)
//            .frame(minWidth: 85)
//            .padding(.horizontal, 10)
//            .padding(.vertical, 5)
//            .background(
//              Capsule().fill(Color.white)
//            )
        }
        .frame(minWidth: 300)
        .padding(.bottom, 50),
        alignment: .bottom
      )
  }
}
