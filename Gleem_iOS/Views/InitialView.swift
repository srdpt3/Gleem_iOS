//
//  InitialView.swift
//  Gleem_iOS
//
//  Created by Dustin yang on 7/11/20.
//  Copyright © 2020 Dustin yang. All rights reserved.
//


import Foundation
import SwiftUI
enum ActiveAlert {
    case first, second, third
}
struct InitialView: View {
    
//    @EnvironmentObject var session: SessionStore
    @EnvironmentObject var obs : observer
    @State var noConnection : Bool = false
    @State var showSplash = true

    func listen() {
        //        self.obs.reload()
        
        if(Reachabilty.HasConnection()){
            self.obs.isReloading = true
            obs.listenAuthenticationState()
            self.noConnection = false
        }else{
            self.noConnection = true
        }
        
    }
    
    var body: some View {
        NavigationView{
            ZStack{
                
                if(!SplashScreen.shouldAnimate){
                    
                    if(self.obs.isLoggedIn){
                        ContentView()
                            
                    }else{
                        LoginView()
                    }
                    
                    
                }
                
                SplashScreen()
                    .opacity(showSplash ? 1 : 0).animation(.easeInOut(duration: 1))

                    .onAppear {
                        self.listen()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                            SplashScreen.shouldAnimate = false
                            withAnimation() {
                                self.showSplash = false
                            }
                        }
                }
            }
        }
        
        
        
        //
        //        .onAppear(perform: listen).alert(isPresented: $noConnection) {
        //            Alert(
//                title: Text(ERROR),
//                message: Text(NO_CONNECTION),
//                dismissButton: .default(Text(CONFIRM)))
//
//
//
//
//        }
    }
}

