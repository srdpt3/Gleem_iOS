//
//  SignUpView.swift
//  FrontYard
//
//  Created by Dustin yang on 6/14/20.
//  Copyright © 2020 Dustin yang. All rights reserved.
//

import SwiftUI
struct SignUpView: View {
    @Environment(\.presentationMode) var presentationMode

    @ObservedObject var signupViewModel = SignupViewModel()
    @State var images : [Data] = [Data()]
    @State var index = 0
    
    //    @Binding  var showLoginView : Bool
    
    @Binding var showSignupView : Bool
    //    @Binding var showSignInView : Bool
    @State var showLoader : Bool = false
    @State var agree = false
    @State var gender = "male"
    @State var finishSignUp : Bool = false

    func signUp() {
        self.showLoader.toggle()
        
        signupViewModel.signup(username: signupViewModel.username, email: signupViewModel.email, password: signupViewModel.password, imageData: signupViewModel.imageData, gender: self.gender,  completed: { (user) in
            print("SignUp \(user.email)")
            self.showLoader.toggle()
            self.finishSignUp = true

            self.clean()
        }) { (errorMessage) in
            
            
            print("Error: \(errorMessage)")
            self.signupViewModel.showAlert = true
            self.signupViewModel.errorString = errorMessage
        }
        
        
    }
    
    func clean() {
        
//      self.presentationMode.wrappedValue.dismiss()
        
        self.signupViewModel.username = ""
        self.signupViewModel.email = ""
        self.signupViewModel.password = ""
        self.signupViewModel.repassword = ""
        //         @Binding var show : Bool
        
    }
    
    var body: some View {
        ZStack{
 
            VStack(spacing: 20){
                HStack{
                    signupViewModel.image.resizable().aspectRatio(contentMode: .fill).frame(width: 80, height: 80)
                        .clipShape(Circle()).padding(.bottom, 10).padding(.top, 10)
                        .onTapGesture {
                            print("Tapped")
                            self.signupViewModel.showImagePicker = true
                    }
                    Topbar(selected: self.$gender).padding(.top)

//                    VStack{
//                        //                        Spacer()
//                        //                        Text("성별").foregroundColor(Color.black.opacity(0.1))
//                        Spacer()
//                        
//                    }
//                    
                    
                }
                
                
                //                UsernameTextField(username: $signupViewModel.username)
                //                EmailTextField(email: $signupViewModel.email)
                CustomTF(value: $signupViewModel.username, isemail: false, username: true)
                CustomTF(value: $signupViewModel.email, isemail: true)
                
                VStack(alignment: .leading) {
                    CustomTF(value: $signupViewModel.password, isemail: false, reenter: false,username: false)
                    CustomTF(value: $signupViewModel.repassword, isemail: false,reenter: true)
                    
                    //                    PasswordTextField(password: $signupViewModel.password)
                    Text(TEXT_SIGNUP_PASSWORD_REQUIRED).font(.footnote).foregroundColor(.gray).padding([.leading])
                }
                HStack{
                    
                    Button(action: {
                        
                        self.agree.toggle()
                        
                    }) {
                        
                        ZStack{
                            
                            Circle().fill(Color.black.opacity(0.05)).frame(width: 20, height: 20)
                            
                            if self.agree{
                                
                                Image("check").resizable().frame(width: 10, height: 10)
                                    .foregroundColor(Color("Color1"))
                            }
                        }
                        
                    }
                    
                    Text(TERM_AGREEMENT2).font(.caption)
                        .foregroundColor(Color.black.opacity(0.1))
                    
                    Spacer()
                    
                }
                Button(action: {
                    
                    self.signUp()
                }) {
                    HStack {
                        Spacer()
                        Text(TEXT_SIGN_UP).fontWeight(.bold).foregroundColor(Color.white)
                        Spacer()
                    }
                    
                }
                .padding()
                .modifier(SigninButtonModifier2())
                .alert(isPresented: $signupViewModel.showAlert) {
                    Alert(title: Text("Error"), message: Text(self.signupViewModel.errorString),  dismissButton: .default(Text("OK"), action: {
                        self.showLoader.toggle()
                        
                    }))
                }
                .alert(isPresented: self.$finishSignUp) {
                    Alert(title: Text("완료"), message: Text("가입이 성공적으로 완료 되었습니다"),  dismissButton: .default(Text("OK"), action: {
                          ContentView()
                        self.showSignupView = false
                        self.finishSignUp = false
//                        self.presentationMode.wrappedValue.dismiss()
//
                        
                    }))
                }
                
                Divider()
                Text(TEXT_SIGNUP_NOTE).font(.footnote).foregroundColor(.gray).padding().lineLimit(nil)
                Spacer()
                
            }.padding()
                .background(Color.white)
                .cornerRadius(5)
                .padding()
                
                .sheet(isPresented: $signupViewModel.showImagePicker) {
                    //                ImagePicker(showPicker: self.$signupViewModel.showImagePicker,  imageData: self.$signupViewModel.imageData)
                    ImagePicker(showImagePicker: self.$signupViewModel.showImagePicker, pickedImage: self.$signupViewModel.image, imageData: self.$signupViewModel.imageData)
            }
//                .KeyboardResponsive()
                .navigationBarTitle("")
                .navigationBarHidden(true)
                .edgesIgnoringSafeArea(.all)
                .background(Color("Color-2").edgesIgnoringSafeArea(.all))
            if self.showLoader {
                GeometryReader{_ in
                    
                    Loader()
                    
                }.background(Color.black.opacity(0.35).edgesIgnoringSafeArea(.all))
            }
            
        }
        
  
    }
    
    
}



struct Topbar : View {
    
    @Binding var selected : String
    
    var body : some View{
        
        HStack{
            
            Button(action: {
                
                self.selected = "male"
                print("male")
                
            }) {
                
                Image("male")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .padding(.vertical,6)
                    .padding(.horizontal,15)
                    .background(self.selected == "male" ? Color.white : Color.clear)
                    .clipShape(Capsule())
            }
//            .foregroundColor(self.selected ==  "male" ?  Color("Color1"): .gray)
            
            Button(action: {
                
                self.selected = "female"
                print("female")
                
                
            }) {
                
                Image("female")
                    .resizable()
                    .frame(width: 25, height: 20)
                    .padding(.vertical,6)
                    .padding(.horizontal,15)
                    .background(self.selected == "female" ? Color.white : Color.clear)
                    .clipShape(Capsule())
            }
            .foregroundColor(self.selected == "female" ? Color("myvote") : .gray)
            
        }.padding(8)
            .background(Color("Color-2"))
            .clipShape(Capsule())
            .animation(.default)
    }
}
