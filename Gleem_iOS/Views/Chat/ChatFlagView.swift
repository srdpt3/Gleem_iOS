//
//  ChatFlagView.swift
//  Gleem_iOS
//
//  Created by Dustin yang on 9/1/20.
//  Copyright © 2020 Dustin yang. All rights reserved.
//

import SwiftUI

struct ChatFlagView: View {
    @Binding var selectedFlag : String
    
    @Binding var show : Bool
    @Binding var flagMessage : Bool
    var selected : InboxMessage
    
    //     var updatedValueDict = ["attr1":0 , "attr2":0, "attr3":0, "attr4":0, "attr5":0]
    //     var buttonTitle : [String] = ["없음", "없음","없음", "없음", "없음"]
    
    
    func flagUser(reason: String){
        
        
        let batch = Ref.FIRESTORE_ROOT.batch()
        
        let flag = Flag(id: selected.userId, email: "", imageLocation: "", username: selected.username, reason: reason, reporter: User.currentUser()!.id,   date:  Date().timeIntervalSince1970)
        
        guard let dict = try? flag.toDictionary() else { return }
        let flagId = Ref.FIRESTORE_COLLECTION_FLAG_CHAT_USERID(userId: flag.id).collection("flagged").document().documentID
        let flaggedRef = Ref.FIRESTORE_COLLECTION_FLAG_CHAT_USERID(userId: flag.id).collection("flagged").document(flagId)
        batch.setData(dict, forDocument: flaggedRef)
        
        
        
        batch.commit() { err in
            if let err = err {
                print("Error writing batch \(err)")
            } else {
                print("Batch addToMyList write succeeded.")
            }
        }
        
        withAnimation{
            self.show.toggle()
            self.flagMessage.toggle()
        }
        //
        self.selectedFlag = ""
    }
    
    var body : some View{
        
        VStack(alignment: .leading, spacing: 10) {
            
            HStack{
                Text(FLAG_USER_CHAT).font(.custom(FONT, size: CGFloat(BUTTON_TITLE_FONT_SIZE)))       .foregroundColor(APP_THEME_COLOR)
                Spacer()
                Button(action: {
                    // ACTION
                    self.show.toggle()
                    self.selectedFlag = ""
                    //                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(Color.white)
                        .shadow(radius: 10)
                        .opacity( 1 )
                        .scaleEffect(1.5 , anchor: .center)
                })
            }
            //            .padding(.trailing, 15)
            Divider()
            ForEach(chat_flag_option,id: \.self){i in
                
                Button(action: {
                    
                    self.selectedFlag = i
                    
                }) {
                    
                    HStack{
                        
                        Text(i).font(.custom(FONT, size: 14))
                        
                        Spacer()
                        
                        ZStack{
                            
                            Circle().fill(self.selectedFlag == i ? APP_THEME_COLOR : Color.black.opacity(0.2)).frame(width: 18, height: 18)
                            
                            if self.selectedFlag == i{
                                
                                Circle().stroke(Color("Color9"), lineWidth: 4).frame(width: 25, height: 25)
                            }
                        }
                        
                        
                        
                    }.foregroundColor(.black)
                    
                }.padding(.top)
            }
            
            HStack{
                
                
                Spacer()
                
                Button(action: {
                    
                    
                    self.flagUser(reason: self.selectedFlag)
                    
                }) {
                    
                    Text(BLOCK_BUTTON).padding(.vertical).padding(.horizontal,30).foregroundColor(.white)
                    
                }
                .background(
                    
                    self.selectedFlag != "" ?
                        
                        LinearGradient(gradient: .init(colors: [Color("myvote"),Color("sleep")]), startPoint: .leading, endPoint: .trailing) :
                        
                        LinearGradient(gradient: .init(colors: [Color.black.opacity(0.2),Color.black.opacity(0.2)]), startPoint: .leading, endPoint: .trailing)
                    
                )
                    .clipShape(Capsule())
                    .disabled(self.selectedFlag != "" ? false : true)
                
                
            }.padding(.top)
            
        }.padding(.vertical)
            .padding(.horizontal,20)
            .padding(.bottom,(UIApplication.shared.windows.last?.safeAreaInsets.bottom)!)
            .background(Color.white)
            .cornerRadius(30)
    }
}
