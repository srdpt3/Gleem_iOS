//
//  SwipeDetailsView.swift
//  Gleem_Dating
//
//  Created by Dustin yang on 6/28/20.
//  Copyright © 2020 Dustin yang. All rights reserved.
//
import SwiftUI
import SDWebImageSwiftUI


struct SwipeDetailsView : View {

    var name = ""
    var age = ""
    var image = ""
    var height : CGFloat = 0

    var body : some View{
        
        ZStack(alignment: .center) {
            AnimatedImage(url: URL(string: image)!).resizable().frame(width: (UIScreen.main.bounds.width )/1.1, height: (UIScreen.main.bounds.height) / 1.6)
            .shadow(color: Color("Color-2"), radius: 20, x: 0, y: 10).cornerRadius(10)
                
                .contextMenu{
                VStack{
                    Button(action: {
                        print("blocked")
                    }){
                        HStack {
                            Text("차단및 신고하기")
                            Image(systemName: "flag")
                            
                        }
                    }
                    
                }
                
            }
            
            
            VStack{
                
                Spacer()
                
                HStack{
                    
                    VStack(alignment: .leading, content: {
                        
                        Text(name).font(.system(size: 25)).fontWeight(.heavy).foregroundColor(.white)
                        Text(age).foregroundColor(.white)
                    })
                    
                    Spacer()
                }
                
                }
            .padding(.bottom, 30).padding(.leading, 30)
            
            
           }.frame(height: height).padding(.top, 15)
                          
        
    }
}
