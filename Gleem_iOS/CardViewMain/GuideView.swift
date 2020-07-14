//
//  Created by Robert Petras
//  SwiftUI Masterclass ♥ Better Apps. Less Code.
//  https://swiftuimasterclass.com
//

import SwiftUI

struct GuideView: View {
  // MARK: - PROPERTIES
  @Environment(\.presentationMode) var presentationMode
  
  var body: some View {
    ScrollView(.vertical, showsIndicators: false) {
      VStack(alignment: .center, spacing: 20) {
        HeaderComponent()
        
        Spacer(minLength: 10)
        
        Text("시작하기!")
          .fontWeight(.black)
          .modifier(TitleModifier())
        
        Text("내 사진을 올린후 유저로부터 실시간으로 평가받고, 내 이상형이랑 매칭도 되고...!")
          .lineLimit(nil)
          .multilineTextAlignment(.center)
        
        Spacer(minLength: 10)
        
        VStack(alignment: .leading, spacing: 25) {
          GuideComponent(
            title: "넘기기",
            subtitle: "오른쪽으로 넘기기",
            description: "ㅁㄴㅇㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㄴㅇㄹㅁㄴㅇㄹ.",
            icon: "heart.circle")
          
          GuideComponent(
            title: "매력평가하기 버튼",
            subtitle: "버튼 누르기",
            description: "5개 항목.",
            icon: "xmark.circle")
          
//          GuideComponent(
//            title: "Book",
//            subtitle: "Tap the button",
//            description: "Our selection of honeymoon resorts is perfect setting for you to embark your new life together.",
//            icon: "checkmark.square")
        }
        
        Spacer(minLength: 10)
        
        Button(action: {
          // ACTION
          // print("A button was tapped.")
          self.presentationMode.wrappedValue.dismiss()
        }) {
          Text("계속".uppercased())
            .modifier(ButtonModifier())
        }
      }
      .frame(minWidth: 0, maxWidth: .infinity)
      .padding(.top, 15)
      .padding(.bottom, 25)
      .padding(.horizontal, 25)
    }
  }
}

struct GuideView_Previews: PreviewProvider {
  static var previews: some View {
    GuideView()
  }
}
