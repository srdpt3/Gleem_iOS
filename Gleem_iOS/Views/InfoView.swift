import SwiftUI

struct InfoView: View {
  // MARK: - PROPERTIES
  @Environment(\.presentationMode) var presentationMode
  
  var body: some View {
    ScrollView(.vertical, showsIndicators: false) {
      VStack(alignment: .center, spacing: 20) {
        HeaderComponent()
        
        Spacer(minLength: 10)
        
        Text("어플리케이션 정보")
          .fontWeight(.black)
          .modifier(TitleModifier())
        
        AppInfoView()
        
        Text("크레딧")
          .fontWeight(.black)
          .modifier(TitleModifier())
        
        CreditsView()
        
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

struct InfoView_Previews: PreviewProvider {
  static var previews: some View {
    InfoView()
  }
}

struct AppInfoView: View {
  var body: some View {
    VStack(alignment: .leading, spacing: 10) {
      RowAppInfoView(ItemOne: "어플리케이션", ItemTwo: "Gleem App")
      RowAppInfoView(ItemOne: "플랫폼", ItemTwo: "iPhone")
      RowAppInfoView(ItemOne: "개발자", ItemTwo: "FrontYard Tech")
      RowAppInfoView(ItemOne: "디자인", ItemTwo: "Dustin Yang")
      RowAppInfoView(ItemOne: "회사 홈페이지", ItemTwo: "FrontYardTech.com")
      RowAppInfoView(ItemOne: "버젼", ItemTwo: "1.0.0")
    }
  }
}

struct RowAppInfoView: View {
  // MARK: - PROPERTIES
  var ItemOne: String
  var ItemTwo: String
  
  var body: some View {
    VStack {
      HStack {
        Text(ItemOne).foregroundColor(Color.gray)
        Spacer()
        Text(ItemTwo)
      }
      Divider()
    }
  }
}

struct CreditsView: View {
  var body: some View {
    VStack(alignment: .leading, spacing: 10) {
      HStack {
        Text("테스트").foregroundColor(Color.gray)
        Spacer()
        Text("테스트")
      }
      
      Divider()
      
      Text("Developer").foregroundColor(Color.gray)
      
      Text("")
        .multilineTextAlignment(.leading)
        .font(.footnote)
    }
  }
}
