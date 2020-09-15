import SwiftUI

struct InfoView: View {
  // MARK: - PROPERTIES
  @Environment(\.presentationMode) var presentationMode
  
  var body: some View {
    ScrollView(.vertical, showsIndicators: false) {
      VStack(alignment: .center, spacing: 20) {
        HeaderComponent()
        
        Spacer(minLength: 10)
        
        Text(APP_INFO)
          .fontWeight(.black)
          .modifier(TitleModifier())
        
        AppInfoView()
        
        Text(APP_CREDIT)
          .fontWeight(.black)
          .modifier(TitleModifier())
        
        CreditsView()
        
        Spacer(minLength: 10)
        
        Button(action: {
          // ACTION
          // print("A button was tapped.")
          self.presentationMode.wrappedValue.dismiss()
        }) {
          Text(CONTINUE.uppercased()).font(Font.custom(FONT, size: 20))
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
      RowAppInfoView(ItemOne: NAME_, ItemTwo: APP_NAME)
      RowAppInfoView(ItemOne: APP_PLATFORM, ItemTwo: MIN_REQUIREMENT)
      RowAppInfoView(ItemOne: COMPANY, ItemTwo: COMPANY_NAME )
//      RowAppInfoView(ItemOne: "", ItemTwo: "Dustin Yang")
      RowAppInfoView(ItemOne: HOMEPAGE, ItemTwo: COMPANY_HOMEPAGE)
      RowAppInfoView(ItemOne: VERSION, ItemTwo: APP_VERSION)
        
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
        Text(ItemOne).foregroundColor(Color.gray).font(Font.custom(FONT, size: 16))
        Spacer()
        Text(ItemTwo).font(Font.custom(FONT, size: 16))
      }
      Divider()
    }
  }
}

struct CreditsView: View {
  var body: some View {
    VStack(alignment: .leading, spacing: 10) {
      HStack {
        Text(DEVELOPER_).foregroundColor(Color.gray).font(Font.custom(FONT, size: 16))
        Spacer()
        Text(DEVELOPER).font(Font.custom(FONT, size: 16))
      }
      
      Divider()
      
//      Text("Developer").foregroundColor(Color.gray)
//
//      Text("")
        .multilineTextAlignment(.leading)
        .font(.footnote)
    }
  }
}
