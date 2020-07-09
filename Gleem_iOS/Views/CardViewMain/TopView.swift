//
//  TopView.swift
//  Gleem_Dating
//
//  Created by Dustin yang on 6/28/20.
//  Copyright © 2020 Dustin yang. All rights reserved.
//

import SwiftUI

struct TopView : View {
    
    @Binding var show : Bool
    @State var showBlockAlert = false
    @Environment(\.presentationMode) var presentation
    
    var body : some View{
        
        
        HStack(spacing: 20){
            Button(action: {
                
            }){
                Image("gleem_resized").resizable().frame(width: 90, height: 35)
                
            }.buttonStyle(PlainButtonStyle())
            
            Spacer()
            Button(action: {
                
            }){
                Image(systemName: "magnifyingglass").resizable().frame(width: 20, height: 22).foregroundColor(.white)
            }
            
            Button(action: {
                self.showBlockAlert.toggle()
                print("block")
            }){
                Image(systemName: "flag").resizable().frame(width: 20, height: 20).foregroundColor(.white)
            }
        }
        .padding()
        .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top).background(Color("Color9"))
        .alert(isPresented: self.$showBlockAlert) {
            Alert(title: Text("Error"), message: Text(BLOCKUSER),  dismissButton: .default(Text("OK"), action: {
                //                self.showLoader.toggle()
                //                self.showAlert.toggle()
                
            }))
        }
    }
}
