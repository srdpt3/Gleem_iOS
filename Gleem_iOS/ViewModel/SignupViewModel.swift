//
//  SignupViewModel.swift
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

class SignupViewModel: ObservableObject {
    
    var username: String = ""
    var email: String = ""
    var password: String = ""
    var repassword: String = ""
    var age: String = ""

    //     var image: Image = Image(systemName: "person.fill")
    var image: Image = Image(systemName: "")
    
    var imageData: Data = Data()
    //     @State var gender: String = "male"
    
    var errorString = ""
    @Published var showImagePicker: Bool = false
    @Published var showAlert: Bool = false
    @Published var finishSignUp: Bool = false
    
    //    @Binding var showLoader:
    //
    func signup(username: String, email: String, password: String, age: String, gender: String, completed: @escaping(_ user: User) -> Void,  onError: @escaping(_ errorMessage: String) -> Void) {
        if !username.isEmpty && !email.isEmpty && !password.isEmpty && !age.isEmpty {
            //            self.showLoader()
            AuthService.signupUser(username: username, email: email, password: password, age: age, gender: gender, onSuccess: completed, onError: onError)
        }
        
        
    }
}
