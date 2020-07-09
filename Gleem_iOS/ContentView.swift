//
//  ContentView.swift
//  Gleem_Dating
//
//  Created by Dustin yang on 6/28/20.
//  Copyright © 2020 Dustin yang. All rights reserved.
//

import SwiftUI
let screen2 = UIScreen.main

struct ContentView: View {
    
    @EnvironmentObject var obs : observer

    var body: some View {
        subMainView()
    }
}


struct subMainView : View {
    @State var index = 0
    
    
    var body: some View {
        NavigationView{
            VStack(spacing: 0){
                
                
                
                if self.index == 0{
                    
//                   CardListview()

                    CardView()
//                    TempView()
                    
                }
                else if self.index == 1{
                    
                    
                    
                    FavoriteView()
                    
                }
                else if self.index == 2{
                    
                    MyStaticView()
                }
                else{
                    
                    LoginView()
                }
                
                
                CircleTab(index: self.$index)
                //                    .opacity(self.detail ? 0 : 1)
                
            }
        }
    }
    
}


struct CircleTab : View {
    
    @Binding var index : Int
    //    @Binding var detail : Bool
    var body : some View{
        
        
        HStack{
            
            Button(action: {
                
                self.index = 0
                
            }) {
                
                VStack{
                    
                    if self.index != 0{
                        
                        Image(systemName:"rectangle.stack.person.crop").foregroundColor(Color.black.opacity(0.2))
                        
                    }
                    else{
                        
                        Image(systemName:"rectangle.stack.person.crop")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color("Color2"))
                            .clipShape(Circle())
                            .offset(y: -15)
                            .padding(.bottom, -20)
                        
                        Text("카드").foregroundColor(Color.black.opacity(0.7))
                    }
                }
                
                
            }
            
            Spacer(minLength: 15)
            
            Button(action: {
                
                self.index = 1
                
            }) {
                
                VStack{
                    
                    if self.index != 1{
                        
                        Image("Home").resizable().frame(width: 19, height: 19).foregroundColor(Color.black.opacity(0.2))
                    }
                    else{
                        
                        Image("Home")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color("Color2"))
                            .clipShape(Circle())
                            .offset(y: -15)
                            .padding(.bottom, -20)
                        
                        Text("나의매력").foregroundColor(Color.black.opacity(0.7))
                    }
                }
            }
            
            Spacer(minLength: 15)
            
            
            Button(action: {
                
                self.index = 2
                
            }) {
                
                VStack{
                    
                    if self.index != 2{
                        
                        Image("heart").resizable().frame(width: 19, height: 19).foregroundColor(Color.black.opacity(0.2))
                    }
                    else{
                        
                        Image("heart")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color("Color2"))
                            .clipShape(Circle())
                            .offset(y: -15)
                            .padding(.bottom, -20)
                        
                        Text("호감").foregroundColor(Color.black.opacity(0.7))
                    }
                }
            }
            
            Spacer(minLength: 15)
            
            Button(action: {
                
                self.index = 3
                
            }) {
                
                VStack{
                    
                    if self.index != 3{
                        
                        Image(systemName: "paperplane").foregroundColor(Color.black.opacity(0.2))
                    }
                    else{
                        
                        Image(systemName: "paperplane")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color("Color2"))
                            .clipShape(Circle())
                            .offset(y: -15)
                            .padding(.bottom, -20)
                        
                        Text("체팅").foregroundColor(Color.black.opacity(0.7))
                    }
                }
            }
            
            
            
        }.padding(.vertical,-10)
            .padding(.horizontal, 25)
            .background(Color.white)
            .animation(.spring())
        
    }
}

//class Host: UIHostingController<ContentView> {
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
//    }
//}
struct BView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    var body: some View {
        Button(action: { self.mode.wrappedValue.dismiss() })
        { Text("Come back to A") }
    }
}


struct Home : View {
    @State var index = 0
    @State var expand = false
    @EnvironmentObject var obs : observer

    var body: some View {
        NavigationView{
            VStack(spacing: 0){


                ZStack(alignment: .bottom){
                    GeometryReader{_ in
                        VStack{

                            if self.index == 0{
                                CardListview()

                            }else if self.index == 1{
                                FavoriteView()

                            }else if self.index == 2{
                                MyStaticView()


                            }else if self.index == 3{
                               ProfileList(list: ["ABC", "DEF", "GHI", "JKL", "MNO", "PQR"])
                            }

                        }
                    }
                    //                    .background(Color.black.opacity(0.06))


                    ZStack(alignment: .top){
                        Circle().trim(from: 0.5, to: self.expand ? 1:0.5).fill(Color("Color2")).frame(width: screen2.bounds.width, height: screen2.bounds.width)

                        ZStack{
                            Button(action: {

                            }){
                                VStack(spacing: 10){
                                    Image(systemName: "star").font(.title).foregroundColor(.white)
                                    Text("관심대상").foregroundColor(.white)
                                }
                            }.offset(x: -100, y:75)

                            Button(action: {

                            }){
                                VStack(spacing: 10){
                                    Image(systemName: "paperplane").font(.title).foregroundColor(.white)
                                    Text("채팅").foregroundColor(.white)
                                }
                            }.offset(y: 30)


                            Button(action: {

                            }){
                                VStack(spacing: 10){
                                    Image(systemName: "square.and.arrow.up").font(.title).foregroundColor(.white)
                                    Text("공유").foregroundColor(.white)
                                }
                            }.offset(x: 100, y:75)
                        }.opacity(self.expand ? 1 : 0)
                    }.offset(y: screen2.bounds.width /  1.6)




                }.clipped()

                TabBar(index: self.$index, expand : self.$expand)
            }
            .edgesIgnoringSafeArea(.top).navigationBarHidden(true).navigationBarTitle("")
        }



    }
}



struct TabBar : View {
    @Binding var index : Int
    @Binding var expand : Bool
    var body: some View {
        HStack{
            Button(action: {
                self.index = 0
                
            }){
                Image(systemName:"rectangle.stack.person.crop").resizable().frame(width: 25, height: 25)
                    .foregroundColor(self.index == 0 ? Color("Color2"):Color.black.opacity(0.3))
            }
            
            
            Spacer(minLength:  0 )
            
            Button(action: {
                self.index = 1
                
            }){
                Image("heart").resizable().frame(width: 25, height: 25)
                    .foregroundColor(self.index == 1 ? Color("Color2"):Color.black.opacity(0.3))
            }
            Spacer(minLength:  0 )
            
            
//            Button(action: {
//
//                withAnimation(Animation.default.speed(0.6)){
//                    self.expand.toggle()
//                }
//                //                  self.index = 1
//
//            }){
//                //                Image(self.expand ? "xmark" : "29"   ).resizable().frame(width: 25, height: 25)
//                Image(self.expand ? "cancel" : "50"   ).resizable().frame(width: 50, height: 50).cornerRadius(25).foregroundColor(Color("Color"))
//                    .font(.title)
//            }.offset(x: 0, y: -20).buttonStyle(PlainButtonStyle())
//            Spacer(minLength:  0 )
            
            
            Button(action: {
                self.index = 2
                
            }){
                Image(systemName: "chat").resizable().frame(width: 25, height: 25)
                    .foregroundColor(self.index == 2 ? Color("Color2"):Color.black.opacity(0.3))
            }
            Spacer(minLength:  0 )
            
            Button(action: {
                self.index = 3
            }){
                Image("Home").resizable().frame(width: 25, height: 25)
                    .foregroundColor(self.index == 3 ? Color("Color2"):Color.black.opacity(0.3))
            }
        }
        .padding(.horizontal, 35)
        .padding(.top , 10)
        .padding(.bottom, UIApplication.shared.windows.first?.safeAreaInsets.bottom == 0 ? 5 : 0)
        .padding(.top, -10)
        .background(Color.black.opacity(0.06).edgesIgnoringSafeArea(.bottom))
    }
}


struct TabBar2 : View {
    @Binding var index : Int
    @Binding var expand : Bool
    var body: some View {
        HStack{
            Button(action: {
                self.index = 0
                
            }){
                Image(systemName:"rectangle.stack.person.crop").resizable().frame(width: 25, height: 25)
                    .foregroundColor(self.index == 0 ? Color("Color2"):Color.black.opacity(0.3))
            }
            
            
            Spacer(minLength:  0 )
            
            Button(action: {
                self.index = 1
                
            }){
                Image("add_pic").resizable().frame(width: 25, height: 25)
                    .foregroundColor(self.index == 1 ? Color("Color2"):Color.black.opacity(0.3))
            }
            Spacer(minLength:  0 )
            
            
//            Button(action: {
//
//                withAnimation(Animation.default.speed(0.6)){
//                    self.expand.toggle()
//                }
//                //                  self.index = 1
//
//            }){
//                //                Image(self.expand ? "xmark" : "29"   ).resizable().frame(width: 25, height: 25)
//                Image(self.expand ? "cancel" : "50"   ).resizable().frame(width: 50, height: 50).cornerRadius(25).foregroundColor(Color("Color"))
//                    .font(.title)
//            }.offset(x: 0, y: -20).buttonStyle(PlainButtonStyle())
//            Spacer(minLength:  0 )
            
            
            Button(action: {
                self.index = 2
                
            }){
                Image(systemName: "heart").resizable().frame(width: 25, height: 25)
                    .foregroundColor(self.index == 2 ? Color("Color2"):Color.black.opacity(0.3))
            }
            Spacer(minLength:  0 )
            
            Button(action: {
                self.index = 3
            }){
                Image("settings").resizable().frame(width: 25, height: 25)
                    .foregroundColor(self.index == 3 ? Color("Color2"):Color.black.opacity(0.3))
            }
        }
        .padding(.horizontal, 35)
        .padding(.top , 10)
        .padding(.bottom, UIApplication.shared.windows.first?.safeAreaInsets.bottom == 0 ? 5 : 0)
        .padding(.top, -10)
        .background(Color.black.opacity(0.06).edgesIgnoringSafeArea(.bottom))
    }
}

