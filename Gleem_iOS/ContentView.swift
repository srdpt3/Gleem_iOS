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
    
    
    var body: some View {
        subMainView()
    }
}


struct subMainView : View {
    @EnvironmentObject var obs : observer
    @State var index = 0
    var body: some View {
        
        VStack(spacing: 0){
            
            if self.index == 0{
                CardListview()
            }
            else if self.index == 1{
                MyStaticView()
                //                         .environmentObject(self.obs)
            }
            else if self.index == 2{
                FavoriteView()
            }
            else if self.index == 3{
                MessagesView()
            }
            //                Spacer()
            CircleTab(index: self.$index)
                .background(Color.white.edgesIgnoringSafeArea(.bottom))
                .opacity(self.obs.isLoading == true ? 0 : 1)
                .opacity(self.obs.showTab == true  ? 0 : 1)
            
            
            
            //                        .offset(y:self.obs.showTab == true ? 50 : 0 )
            
            
            
            
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
                        Image(systemName:"rectangle.stack.person.crop").resizable().frame(width: 19, height: 19).foregroundColor(Color.black.opacity(0.2))
                    }
                    else{
                        
                        Image(systemName:"rectangle.stack.person.crop")
                            .resizable()
                            .frame(width: 15, height: 15)
                            .foregroundColor(.white)
                            .padding()
                            .background(APP_THEME_COLOR)
                            .clipShape(Circle())
                            .offset(y: -15)
                            .padding(.bottom, -20)
                        Text(index1).font(.custom(FONT, size: CGFloat(TABBAR_FONT_SIZE))).foregroundColor(Color.black.opacity(0.7)).font(.caption).foregroundColor(.gray)
                    }
                }
                
                
            }
            
            Spacer(minLength: 10)
            
            Button(action: {
                
                self.index = 1
                
            }) {
                
                VStack{
                    
                    if self.index != 1{
                        
                        Image("Statistics").resizable().frame(width: 19, height: 19).foregroundColor(Color.black.opacity(0.2)).font(.caption).foregroundColor(.gray)
                    }
                    else{
                        
                        Image("Statistics")
                            .resizable()
                            .frame(width: 15 , height: 15)
                            .foregroundColor(.white)
                            .padding()
                            .background(APP_THEME_COLOR)
                            .clipShape(Circle())
                            .offset(y: -15)
                            .padding(.bottom, -20)
                        
                        Text(index2).font(.custom(FONT, size: CGFloat(TABBAR_FONT_SIZE))).foregroundColor(Color.black.opacity(0.7)).font(.caption).foregroundColor(.gray)
                    }
                }
            }
            
            Spacer(minLength: 10)
            
            
            Button(action: {
                
                self.index = 2
                
            }) {
                
                VStack{
                    
                    if self.index != 2{
                        
                        Image("fav").resizable().frame(width: 19, height: 19).foregroundColor(Color.black.opacity(0.2))
                    }
                    else{
                        
                        Image("fav")
                            .resizable()
                            .frame(width: 15, height: 15)
                            .foregroundColor(.white)
                            .padding()
                            .background(APP_THEME_COLOR)
                            .clipShape(Circle())
                            .offset(y: -15)
                            .padding(.bottom, -20)
                        
                        Text(index3).font(.custom(FONT, size: CGFloat(TABBAR_FONT_SIZE))).foregroundColor(Color.black.opacity(0.7)).font(.caption).foregroundColor(.gray)
                    }
                }
            }
            
            Spacer(minLength: 10)
            
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
                            .frame(width: 15, height: 15)
                            .foregroundColor(.white)
                            .padding()
                            .background(APP_THEME_COLOR)
                            .clipShape(Circle())
                            .offset(y: -15)
                            .padding(.bottom, -20)
                        
                        Text(index4).font(.custom(FONT, size: CGFloat(TABBAR_FONT_SIZE))).foregroundColor(Color.black.opacity(0.7))
                    }
                }
            }
            
            
            
        }.padding(.vertical,-10)
            .padding(.horizontal, 25)
            .animation(.spring())
        
        //            .animation(.spring(response: 0.8, dampingFraction: 1, blendDuration: 1))
        
    }
}

//class Host: UIHostingController<ContentView> {
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
//    }
//}
//struct BView: View {
//    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
//    var body: some View {
//        Button(action: { self.mode.wrappedValue.dismiss() })
//        { Text("Come back to A") }
//    }
//}


