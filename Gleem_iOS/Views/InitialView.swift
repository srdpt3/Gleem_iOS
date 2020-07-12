//
//  InitialView.swift
//  Gleem_iOS
//
//  Created by Dustin yang on 7/11/20.
//  Copyright © 2020 Dustin yang. All rights reserved.
//


import Foundation
import SwiftUI

struct InitialView: View {
    
//    @EnvironmentObject var session: SessionStore
    @EnvironmentObject var obs : observer

    func listen() {
//        self.obs.reload()
        obs.listenAuthenticationState()
    }
    
    var body: some View {
        Group {
            if(User.currentUser() != nil || self.obs.isLoggedIn){
            
                ContentView()
            } else {
                LoginView()
            }

        }
        
      .onAppear(perform: listen)
    }
}

