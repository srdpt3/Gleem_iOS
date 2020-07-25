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
            Spacer(minLength: 100)
            
            HStack{
                Spacer()
                
                Text("연결된 상대방이 없습니다").foregroundColor(Color("Color2")).font(.custom(FONT, size: 18)).padding()
                
                //                        .animation(.easeIn(duration: 2))
                Spacer()
            }
            HStack{
                
                Spacer()
                
                LottieView(filename: "no-chat2").frame(width: 200, height: 200).onTapGesture {
                    print("lottie")
                }
                
                
                Spacer()
            }
                
                
                
            .padding(.top, 10)

            
        }.background(Color.white).padding(.horizontal, 10)
            .onDisappear(){
                //               UITableView.appearance().separatorColor = .lightGray
                
                
        }
        .onAppear{
            //           UITableView.appearance().separatorColor = .clear
        }
        //
        //                .padding()
        
        
    }
    
}
