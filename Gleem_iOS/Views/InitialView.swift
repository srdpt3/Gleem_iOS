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
            Group {
                if(obs.isLoggedIn && Reachabilty.HasConnection()){
                    ContentView()
                } else {
                    LoginView()
                }
                
            }
        }
            
            
        .onAppear(perform: listen).alert(isPresented: $noConnection) {
            Alert(
                title: Text(ERROR),
                message: Text(NO_CONNECTION),
                dismissButton: .default(Text(CONFIRM)))
            
            
            
            
        }
    }
}

