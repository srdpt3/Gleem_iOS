
import SwiftUI


struct RadioButtons : View {
    @EnvironmentObject  var obs : observer
    
    @Binding var selected : String
    @Binding var show : Bool
    
    
    func flagPicture(reason: String){
        print("flag")
        
        let currentVote = self.obs.getCurrentCard().user
        let flag = Flag(id: currentVote.id, email: currentVote.email, imageLocation: currentVote.imageLocation, username: currentVote.username, reason: reason, reporter: User.currentUser()!.id,   date:  Date().timeIntervalSince1970)
        
        Api.Flag.reportCard(flag: flag)
        
        
        print(flag)
        self.show.toggle()
        print("asdfasdf selected \(self.selected)")
        self.obs.moveCards()
        
        self.selected = ""
    }
    
    var body : some View{
        
        VStack(alignment: .leading, spacing: 10) {
            
            Text(FLAGPICTURE_TITLE).font(.custom(FONT, size: CGFloat(BUTTON_TITLE_FONT_SIZE)))       .foregroundColor(APP_THEME_COLOR)
            Divider()
            ForEach(data,id: \.self){i in
                
                Button(action: {
                    
                    self.selected = i
                    
                }) {
                    
                    HStack{
                        
                        Text(i).font(.custom(FONT, size: 14))
                        
                        Spacer()
                        
                        ZStack{
                            
                            Circle().fill(self.selected == i ? APP_THEME_COLOR : Color.black.opacity(0.2)).frame(width: 18, height: 18)
                            
                            if self.selected == i{
                                
                                Circle().stroke(Color("Color9"), lineWidth: 4).frame(width: 25, height: 25)
                            }
                        }
                        
                        
                        
                    }.foregroundColor(.black)
                    
                }.padding(.top)
            }
            
            HStack{
                
                //                Spacer()
                //                Button(action: {
                //
                //                    self.show.toggle()
                //
                //
                //                }) {
                //
                //                    Text(CACEL_BLOCK_BUTTON).padding(.vertical).padding(.horizontal,10).foregroundColor(.white)
                //
                //                }
                //                .background(
                //
                //
                //                        LinearGradient(gradient: .init(colors: [Color("Color"),Color("Color1")]), startPoint: .leading, endPoint: .trailing)
                //
                ////                        LinearGradient(gradient: .init(colors: [Color.black.opacity(0.2),Color.black.opacity(0.2)]), startPoint: .leading, endPoint: .trailing)
                //
                //                )   .clipShape(Capsule())
                //                    .disabled(self.selected != "" ? false : true)
                
                Spacer()
                
                Button(action: {
                    
                    
                    
                    self.flagPicture(reason: self.selected)
                    
                }) {
                    
                    Text(BLOCK_BUTTON).padding(.vertical).padding(.horizontal,30).foregroundColor(.white)
                    
                }
                .background(
                    
                    self.selected != "" ?
                        
                        LinearGradient(gradient: .init(colors: [Color("myvote"),Color("sleep")]), startPoint: .leading, endPoint: .trailing) :
                        
                        LinearGradient(gradient: .init(colors: [Color.black.opacity(0.2),Color.black.opacity(0.2)]), startPoint: .leading, endPoint: .trailing)
                    
                )
                    .clipShape(Capsule())
                    .disabled(self.selected != "" ? false : true)
                
                
            }.padding(.top)
            
        }.padding(.vertical)
            .padding(.horizontal,20)
            .padding(.bottom,(UIApplication.shared.windows.last?.safeAreaInsets.bottom)!)
            .background(Color.white)
            .cornerRadius(30)
    }
}



