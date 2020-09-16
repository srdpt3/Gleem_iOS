//
//  EmptyChattingView.swift
//  Gleem_iOS
//
//  Created by Dustin yang on 7/24/20.
//  Copyright © 2020 Dustin yang. All rights reserved.
//

import SwiftUI

struct EmptyChattingView: View {
    //    init(){
    //
    //    }
    var body: some View{
        
        
        VStack(alignment: .center){
            Spacer(minLength: UIScreen.main.bounds.height / 1.5)
            
            HStack{
                Spacer()
                
                Text(NO_MATCHED_USER).foregroundColor(Color("Color2")).font(.custom(FONT, size: 18)).padding()
                    .shadow(color: Color.black.opacity(0.15), radius: 5, x: 0, y: 5)
                //                        .animation(.easeIn(duration: 2))
                Spacer()
            }
            HStack(alignment: .center){
                
                Spacer()
                
       LottieView(filename: "no-chat2").frame(width: 220, height: 220).offset(x: 20)
        .onTapGesture {
                    print("lottie")
                }
                
                
                Spacer()
            }
                
                
                
//            .padding(.top, 10)
            
            
        }.background(Color.white).padding(.horizontal, 10)
            .onDisappear(){
                
        }
        .onAppear{
        }
        
        
    }
    
}
