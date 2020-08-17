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
    @State var error : Bool = false
    @State private var activeAlert: ActiveAlert = .first
    //    @State var misMatchPassword : Bool = false
    //    @State var filloutError : Bool = false
    
    func signUp() {
        //        self.showLoader.toggle()
        //        if signupViewModel.imageData.isEmpty {
        //            self.error = true
        //            self.activeAlert = ActiveAlert.first
        //            return
        //
        //
        //        }
        
        print( signupViewModel.age)
        if signupViewModel.username.isEmpty || signupViewModel.email.isEmpty || signupViewModel.password.isEmpty || signupViewModel.repassword.isEmpty ||  signupViewModel.age == ""{
            self.error = true
            
            self.activeAlert = ActiveAlert.second
            
            return
            
            
        }
        
        if signupViewModel.password !=  signupViewModel.repassword{
            self.error = true
            
            self.activeAlert = ActiveAlert.third
            
            return
            
            
        }
        
        
        
        
        signupViewModel.signup(username: signupViewModel.username, email: signupViewModel.email, password: signupViewModel.password, age: signupViewModel.age, gender: self.gender,  completed: { (user) in
            print("SignUp \(user.email)")
            //            self.showLoader.toggle()
            self.finishSignUp = true
            
            self.clean()
        }) { (errorMessage) in
            
            
            print("Error: \(errorMessage)")
            self.signupViewModel.showAlert = true
            self.signupViewModel.errorString = errorMessage
        }
        
        
        
        
        
    }
    
    func clean() {
        
        self.presentationMode.wrappedValue.dismiss()
        self.signupViewModel.username = ""
        self.signupViewModel.email = ""
        self.signupViewModel.password = ""
        self.signupViewModel.repassword = ""
        
        //         @Binding var show : Bool
        
    }
    
    var body: some View {
        ZStack{
            
            VStack(spacing: 20){
                //                HStack{
                //
                //                    Text(PROFILE_UPLOAD).font(.custom(FONT, size: 16)).foregroundColor(Color.black.opacity(0.3))
                //
                //                    ZStack{
                //                        LottieView(filename: "profile").frame(width: 80, height: 80)
                //                            .clipShape(Circle()).padding(.bottom, 10).padding(.top, 20).zIndex(1)
                //                            .onTapGesture {
                //                                print("Tapped")
                //                                self.signupViewModel.showImagePicker = true
                //                        }
                //                        .opacity( signupViewModel.imageData.count > 0 ? 0 : 1)
                //
                //                        signupViewModel.image.resizable().frame(width: 80, height: 80).foregroundColor(APP_THEME_COLOR).cornerRadius(40)
                //                            .padding(.bottom, 10).padding(.top, 10)
                //
                //
                //                    }
                //
                //
                //                }
                
                
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
                    //
                    
                    //                    Text().font(.custom(FONT, size: 16)).foregroundColor(Color.black.opacity(0.3))
                    
                    DropDown(age: $signupViewModel.age).padding(.top)
                    Spacer()
                    Group{
                        Text(GENDER).font(.custom(FONT, size: 16)).foregroundColor(Color.black.opacity(0.3)).padding(.top)
                        Topbar(selected: self.$gender).padding(.top)
                    }
                    
                    
                    
                    
                }.padding(.vertical)
                
                Button(action: {
                    
                    self.signUp()
                    //                    self.error = true
                }) {
                    HStack {
                        Spacer()
                        Text(TEXT_SIGN_UP).fontWeight(.bold).foregroundColor(Color.white)
                        Spacer()
                    }
                    
                }
                .padding()
                    
                .modifier(SigninButtonModifier2())
                
                
                Divider()
                Text(TEXT_SIGNUP_NOTE).font(.footnote).foregroundColor(.gray).padding().lineLimit(nil)
                Spacer()
                
            }.padding()
                .background(Color.white)
                .cornerRadius(5)
                .padding()
                .alert(isPresented: self.$error) {
                    
                    switch activeAlert {
                    case .first:
                        return   Alert(title: Text(ERROR), message: Text(PROFILE_UPLOAD).font(.custom(FONT, size: 17)), dismissButton: .default(Text(CONFIRM).font(.custom(FONT, size: 17)).foregroundColor(APP_THEME_COLOR), action: {
                            
                        }))
                    case .second:
                        
                        return   Alert(title: Text(ERROR), message: Text(FILLOUT_INFO).font(.custom(FONT, size: 17)), dismissButton: .default(Text(CONFIRM).font(.custom(FONT, size: 17)).foregroundColor(APP_THEME_COLOR), action: {
                        }))
                    case .third:
                        
                        return  Alert(title: Text(ERROR), message: Text(MiMATCH_PASSWORD).font(.custom(FONT, size: 17)), dismissButton: .default(Text(CONFIRM).font(.custom(FONT, size: 17)).foregroundColor(APP_THEME_COLOR), action: {
                        }))
                        
                    }
                    
            }
                
            .sheet(isPresented: $signupViewModel.showImagePicker) {
                ImagePicker(showImagePicker: self.$signupViewModel.showImagePicker, pickedImage: self.$signupViewModel.image, imageData: self.$signupViewModel.imageData)
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .edgesIgnoringSafeArea(.all)
            .background(Color("Color-2").edgesIgnoringSafeArea(.all))
            //            if self.showLoader {
            //                GeometryReader{_ in
            //
            //                    Loader()
            //
            //                }.background(Color.white.edgesIgnoringSafeArea(.all))
            //            }
            
        }
        
        //        .alert(isPresented: self.$finishSignUp) {
        //            Alert(title: Text("완료"), message: Text("가입이 성공적으로 완료 되었습니다"),  dismissButton: .default(Text("OK"), action: {
        //                self.showSignupView.toggle()
        //                self.finishSignUp = false
        //                //                        self.presentationMode.wrappedValue.dismiss()
        //                //
        //
        //            }))
        //        }
        
    }
    
    
}



struct Topbar : View {
    
    @Binding var selected : String
    
    var body : some View{
        
        HStack{
            
            Button(action: {
                
                withAnimation{
                    self.selected = "male"
                    
                }
                print("male")
                
            }) {
                
                Image("male")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .padding(.vertical,6)
                    .padding(.horizontal,15)
                    .background(self.selected == "male" ? Color.white : Color.clear)
                    .clipShape(Capsule()).animation(.default)
            }
            //            .foregroundColor(self.selected ==  "male" ?  Color("Color1"): .gray)
            
            Button(action: {
                
                withAnimation{
                    self.selected = "female"
                    
                }
                print("female")
                
                
            }) {
                
                Image("female")
                    .resizable()
                    .frame(width: 25, height: 20)
                    .padding(.vertical,6)
                    .padding(.horizontal,15)
                    .background(self.selected == "female" ? Color.white : Color.clear)
                    .clipShape(Capsule()).animation(.default)
            }
            .foregroundColor(self.selected == "female" ? Color("myvote") : .gray)
            
        }.padding(8)
            .background(Color("Color-2"))
            //            .background(LinearGradient(gradient: .init(colors:   [Color("Color5"),Color("Color11")]), startPoint: .top, endPoint: .bottom))
            
            .clipShape(Capsule())
            .animation(.default)
    }
}



struct DropDown: View {
    @Binding var age : String
    @State var expand = false
    var body: some View{
        VStack(alignment: .leading, spacing: 18, content: {
            
            HStack{
                Text(age == "" ? AGE: age).foregroundColor(APP_THEME_COLOR).font(.custom(FONT, size: 15))
                Image(systemName: expand ?  "chevron.up" :  "chevron.down").resizable().frame(width: 10, height: 10).foregroundColor(Color("Color2"))
            }.onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                self.expand.toggle()
            }
            if(expand){
                
                Button(action: {
                    self.age = "10대 후반"
                    self.expand.toggle()
                }){
                    Text("10대 후반").font(.custom(FONT, size: 16))
                }.foregroundColor(APP_THEME_COLOR)
                
                Button(action: {
                    self.age = "20대 초반"
                    self.expand.toggle()
                }){
                    Text("20대 초반").font(.custom(FONT, size: 16))
                }.foregroundColor(APP_THEME_COLOR)
                Button(action: {
                    self.age = "20대 중후반"
                    
                    self.expand.toggle()
                }){
                    Text("20대 중후반").font(.custom(FONT, size: 16))
                }.foregroundColor(APP_THEME_COLOR)
                
                Button(action: {
                    self.age = "30대 초반"
                    
                    self.expand.toggle()
                }){
                    Text("30대 초반").font(.custom(FONT, size: 16))
                    
                }.foregroundColor(APP_THEME_COLOR)
                
                Button(action: {
                    self.age = "30대 중후반"
                    self.expand.toggle()
                }){
                    Text("30대 중후반").font(.custom(FONT, size: 16))
                }.foregroundColor(APP_THEME_COLOR)
                
                
                
                Button(action: {
                    self.age = "40대 초반"
                    
                    self.expand.toggle()
                }){
                    Text("40대 초반").font(.custom(FONT, size: 16))
                }.foregroundColor(APP_THEME_COLOR)
                
                
                Button(action: {
                    self.age = "40대 중후반"
                    
                    self.expand.toggle()
                }){
                    Text("40대 중후반").font(.custom(FONT, size: 16))
                }.foregroundColor(APP_THEME_COLOR)
                
            }
            
            
            
            
        })
            .padding()
            .background(Color("Color-2"))
            //            .background(LinearGradient(gradient: .init(colors:   [Color("Color5"),Color("Color11")]), startPoint: .top, endPoint: .bottom))
            .cornerRadius(20)
            .animation(Animation.spring(response: 0.6, dampingFraction: 1.0, blendDuration: 1.0))    }
    
}
