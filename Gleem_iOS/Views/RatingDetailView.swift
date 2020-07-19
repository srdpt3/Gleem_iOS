//
//  RatingDetailView.swift
//  Gleem_iOS
//
//  Created by Dustin yang on 7/13/20.
//  Copyright © 2020 Dustin yang. All rights reserved.
//

import SwiftUI

struct RatingDetailView: View {
    
//    var recipe: Recipe

    
    var body: some View {
          HStack(alignment: .center, spacing: 12) {
            HStack(alignment: .center, spacing: 2) {
              Image(systemName: "person.2")
              Text("투표수: 5")
            }
            HStack(alignment: .center, spacing: 2) {
              Image(systemName: "clock")
              Text("업로드된 날짜: 5일전")
            }
            HStack(alignment: .center, spacing: 2) {
              Image(systemName: "flame")
                Text("성별 :" + (User.currentUser()?.sex == "male" ? "남자" : "여자" ))
            }
          }
          .font(.footnote)
          .foregroundColor(Color.gray)
        }
    }


struct RatingDetailView_Previews: PreviewProvider {
    static var previews: some View {
        RatingDetailView()
    }
}
