//
//  CardView.swift
//  Gleem_Dating
//
//  Created by Dustin yang on 7/7/20.
//  Copyright © 2020 Dustin yang. All rights reserved.
//

import SwiftUI

struct CardView: View {
    
    @State var showLiked = false
    @State var showBlockAlert = false
    @EnvironmentObject var obs : observer
    @State var showMenu = false
    
    var body: some View{
        
        ZStack{
            
            
            VStack(spacing: 20){
                
                
                Text("").padding(.top, 100)
                //                        TopView(show: $showLiked).padding(.bottom, -30)
                SwipeView().padding(.top, 20)
                
                Spacer()
                
                VStack(spacing: 20){
                    
                    Spacer()
                    BottomView().listRowInsets(EdgeInsets(top: 16, leading: 0, bottom: 16, trailing: 0))
                    
                }.padding(.top, 40)
                
                
                
                //                        BottomView().listRowInsets(EdgeInsets(top: 16, leading: 0, bottom: 16, trailing: 0)).padding(.top, 20)
                
                
                
                //                    TopView(show: $showLiked).padding(.bottom, -15)
                //
                //                        SwipeView(users: self.obs.users).padding(.bottom, 10).padding(.top, 10)
                //
                //
                //
                //                    BottomView().listRowInsets(EdgeInsets(top: 16, leading: 0, bottom: 16, trailing: 0))
                
                
                
                
                
                
                
            }      .padding()
                //            .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top).background(Color("Color9"))
                .alert(isPresented: self.$showBlockAlert) {
                    Alert(title: Text("Error"), message: Text(BLOCKUSER),  dismissButton: .default(Text("OK"), action: {
                        //                self.showLoader.toggle()
                        //                self.showAlert.toggle()
                        
                    }))
            }
            .navigationBarTitle(
                Text("")
                , displayMode: .inline)
                .navigationBarItems(
                    
                    leading:
                    HStack{
                        
                        Image("bg")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .clipShape(Circle())
                        //   Image("gleem_resized")
                        //                      .resizable()
                        //                      .foregroundColor(.white)
                        //                      .aspectRatio(contentMode: .fit)
                        //                      .frame(width: 70, height: 50, alignment: .center)
                        //                      .padding(UIScreen.main.bounds.size.width/4+30)
                    }
                    
                    
                    , trailing:
                    
                    
                    
                    
                    Button(action: {
                        
                        withAnimation{
                            
                            self.showMenu.toggle()
                        }
                        
                    }, label: {
                        
                        
                        Image("menu")
                            .renderingMode(.original)
                            .resizable()
                            .frame(width: 15, height: 15)
                        
                        //                        Image("menu")
                        //                            .renderingMode(.original)
                        //                            .resizable()
                        //                            .frame(width: 15, height: 15)
                    }).buttonStyle(PlainButtonStyle())
            )
            
            
            if self.showMenu{
                
                GeometryReader{_ in
                    
                    MenuView()
                    
                }.background(
                    
                    Color.black.opacity(0.65)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            
                            withAnimation{
                                
                                self.showMenu.toggle()
                            }
                    }
                    
                )
            }
        }
        
        
        
        
        
        
        //
        //        //
        //                    .navigationBarItems(leading:
        //                        HStack {
        //                            Button(action: {
        //                                print("Farrow.lef...")
        //
        //                            }) {
        //                                Image(systemName: "arrow.left")
        //                            }.foregroundColor(Color.black)
        //
        //                            Image("gleem_resized")
        //                                .resizable()
        //                                .foregroundColor(.white)
        //                                .aspectRatio(contentMode: .fit)
        //                                .frame(width: 70, height: 50, alignment: .center)
        //                                .padding(UIScreen.main.bounds.size.width/4+30)
        //                        }
        //                        ,trailing:
        //
        //                        HStack {
        //
        //                            Button(action: {
        //                                self.showBlockAlert.toggle()
        //                                print("Flag button pressed...")
        //                            }) {
        //                                Image(systemName: "flag").resizable().frame(width: 20, height: 20)
        //                            }.foregroundColor(Color.black)
        //                        }
        //
        //
        //
        //
        //
        //            .navigationBarTitle(Text(""), displayMode: .inline)
        //            .navigationBarItems(trailing:
        //                Button(action: {
        //                    self.showBlockAlert.toggle()
        //                    print("Flag button pressed...")
        //                }) {
        //                    Image(systemName: "flag").resizable().frame(width: 20, height: 20).foregroundColor(.white)
        //
        //                }
        //        )
    }
    //        .navigationTitle("").navigationBarHidden(true)
    
}


