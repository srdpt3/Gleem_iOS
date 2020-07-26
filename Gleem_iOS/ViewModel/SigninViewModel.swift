//
//  SigninViewModel.swift
//  FrontYard
//
//  Created by Dustin yang on 6/14/20.
//  Copyright © 2020 Dustin yang. All rights reserved.
//

import Foundation
import FirebaseAuth
import Firebase
import FirebaseStorage
import SwiftUI

class SigninViewModel: ObservableObject {
    
    var email: String = ""
    var password: String = ""
    
    var errorString = ""
    
    @Published var showAlert: Bool = false

    @Published var success: Bool = false
    @Published var show : Bool = false
    
    func signin(email: String, password: String, completed: @escaping(_ user: User) -> Void,  onError: @escaping(_ errorMessage: String) -> Void) {
        if !email.isEmpty && !password.isEmpty {
            AuthService.signInUser(email: email, password: password, onSuccess: completed, onError: onError)
            print("SigninViewModel  signin ")
            success = true
        } else {
            showAlert = true
            errorString = FILLOUT_INFO
        }
       
    }
}
