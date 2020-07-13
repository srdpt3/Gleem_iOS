//
//  Loader.swift
//  Gleem_Dating
//
//  Created by Dustin yang on 6/29/20.
//  Copyright © 2020 Dustin yang. All rights reserved.
//

import SwiftUI


struct Loader : View {
    var textmsg = ""
    @State var animate = false
    var body: some View{
        VStack{

            Image("50").resizable().frame(width: 50, height: 50).cornerRadius(25).foregroundColor(Color("Color"))
                .rotationEffect(.init(degrees: self.animate ? 360 : 0)).animation(Animation.linear(duration: 1.1 ).repeatForever(autoreverses: false)).padding(.top, 20)
            Text(textmsg).padding(.all, 10).foregroundColor(APP_THEME_COLOR)
        }.background(Color.white).cornerRadius(20).onAppear(){
            self.animate.toggle()
        }
    }
}



struct Loader_Previews: PreviewProvider {
    static var previews: some View {
        
               GeometryReader{_ in
                   
                   Loader()
                   
               }.background(Color.black.opacity(0.3).edgesIgnoringSafeArea(.all))
         
        
//        Loader()
    }
}
