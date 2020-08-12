//
//  MenuView.swift
//  Gleem_iOS
//
//  Created by Dustin yang on 7/8/20.
//  Copyright © 2020 Dustin yang. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI
struct MenuView: View {
    
    var body: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 16) {
                HStack{
                    Spacer()
                    Text(String(User.currentUser()!.username)).font(Font.custom(FONT, size: 18))
                    Text("-")
                    Text((User.currentUser()!.profileImageUrl == "" ? "70" : "100") + PROFILE_COMPLETE).font(Font.custom(FONT, size: 18))
                    
                    Spacer()
                    
                }
                
                Color.white
                    //                    APP_THEME_COLOR
                    .frame(width: User.currentUser()!.profileImageUrl == "" ? 71 : 130, height: 6)
                    .cornerRadius(3)
                    .frame(width: 110, height: 6, alignment: .leading)
                    .background(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)).opacity(0.08))
                    .cornerRadius(3)
                    .padding()
                    .frame(width: 130, height: 24)
                    .background(Color.black.opacity(0.1))
                    .cornerRadius(12)
                
                
                //                MenuRow(title: PROFILE, icon: "person" , index : 0)
                MenuRow(title: PROFILE, icon: "gear" , index : 0)
//                MenuRow(title: BILLING, icon: "creditcard" , index : 1)
                MenuRow(title:  User.currentUser() != nil ? LOGOUT : LOGIN, icon: "person.crop.circle" , index : 2)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 280)
            .background(BlurView(style: .systemMaterial))
            .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
            .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 20)
            .padding(.horizontal, 30)
            .overlay(
                
                ZStack{
                    if(User.currentUser()!.profileImageUrl == ""){
                        
                        Image("Gleem_3D").resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 60, height: 60)
                            .clipShape(Circle())
                            .offset(y: -150)
                        
                    }else{
                        
                        
                        AnimatedImage(url: URL(string: User.currentUser()!.profileImageUrl)!).resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 60, height: 60)
                            .clipShape(Circle())
                            .offset(y: -150)
                        
                    }
                }
                
                
            )
        }     .background(Color.black.opacity(0.001))
            .padding(.bottom, 30)
    }
}

//struct MenuView_Previews: PreviewProvider {
//    static var previews: some View {
//        MenuView()
//    }
//}

struct MenuRow: View {
    @EnvironmentObject var obs: observer
    
    var title: String
    var icon: String
    var index : Int  = 0
    @State var show : Bool = false
    @State var profile_show : Bool = false
    @State var account_show : Bool = false
    @State var payment_show : Bool = false
    
    var body: some View {
        Button(action: {
            
            if self.index == 0 {
                
                withAnimation{
                    self.show.toggle()
                }
            }
            
            if self.index == 1 {
                
                withAnimation{
                    self.show.toggle()
                }
            }
            
            if self.index == 2 {
                self.obs.logout()
                
            }
        }){
            HStack(spacing: 16) {
                Image(systemName: icon).renderingMode(.original)
                    .font(.system(size: 20, weight: .light))
                    .imageScale(.large)
                    .frame(width: 32, height: 32)
                    .foregroundColor(Color(#colorLiteral(red: 0.662745098, green: 0.7333333333, blue: 0.831372549, alpha: 1)))
                
                Text(title).font(Font.custom(FONT, size: 20))
                    .frame(width: 120, alignment: .leading)
            }
        }.buttonStyle(PlainButtonStyle())
            
        .sheet(isPresented: self.$show) {
            if(self.index  == 0){
                ProfileView(profile_show: self.$show).animation(.spring())

            }else if(self.index  == 1){
                PaymentView().animation(.spring())
            }
        }
//        .sheet(isPresented: self.$payment_show) {
//            PaymentView().animation(.spring())
//        }
        
        
        
        
        
        
    }
    
    
    
}
