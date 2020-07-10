//
//  MainCardView.swift
//  Gleem_iOS
//
//  Created by Dustin yang on 7/9/20.
//  Copyright © 2020 Dustin yang. All rights reserved.
//

import SwiftUI

import SDWebImageSwiftUI

struct MainCardView: View, Identifiable {
  // MARK: - PROPERTIES
  
  let id = UUID()
  var user: User
  
  var body: some View {
//    Image(honeymoon.image)
     AnimatedImage(url: URL(string:self.user.profileImageUrl))
        .resizable().frame(height: 550)
      .cornerRadius(24)
//      .scaledToFit()
        .frame(minWidth: 0, maxWidth: .infinity)
      .overlay(
        VStack(alignment: .center, spacing: 12) {
            Text(user.username.uppercased())
            .foregroundColor(Color.white)
            .font(.largeTitle)
            .fontWeight(.bold)
            .shadow(radius: 1)
            .padding(.horizontal, 18)
            .padding(.vertical, 4)
            .overlay(
              Rectangle()
                .fill(Color.white)
                .frame(height: 1),
              alignment: .bottom
          )
            Text(user.age.uppercased())
            .foregroundColor(Color.black)
            .font(.footnote)
            .fontWeight(.bold)
            .frame(minWidth: 85)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(
              Capsule().fill(Color.white)
            )
        }
        .frame(minWidth: 300)
        .padding(.bottom, 50),
        alignment: .bottom
      )
  }
}

//struct MainCardView_Previews: PreviewProvider {
//  static var previews: some View {
//    MainCardView(honeymoon: honeymoonData[0])
//      .previewLayout(.fixed(width: 375, height: 600))
//  }
//}



var honeymoonData: [Destination] = [
 
  Destination(
    place: "Paris",
    country: "France",
    image: "photo-paris-france"
  ),
 
  Destination(
    place: "Seoraksan",
    country: "South Korea",
    image: "photo-seoraksan-southkorea"
  ),
  Destination(
    place: "New York",
    country: "USA",
    image: "photo-newyork-usa"
  ),
  Destination(
    place: "Tulum",
    country: "Mexico",
    image: "photo-tulum-mexico"
  ),
  Destination(
    place: "London",
    country: "United Kingdom",
    image: "photo-london-uk"
  ),
  Destination(
    place: "Yosemite",
    country: "USA",
    image: "photo-yosemite-usa"
  )
]


struct Destination {
  var place: String
  var country: String
  var image: String
}
