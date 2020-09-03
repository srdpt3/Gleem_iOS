//
//  LoginView.swift
//  FrontYard
//
//  Created by Dustin yang on 6/14/20.
//  Copyright © 2020 Dustin yang. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var signinViewModel = SigninViewModel()
    @State var showSignupView : Bool = false
    let universalSize = UIScreen.main.bounds
    @State var isAnimated = false
    @State var resetLink : Bool = false
    @State private var activeAlert: ActiveAlert = .first
    
    
    
    func signIn() {
        
        signinViewModel.signin(email: signinViewModel.email, password: signinViewModel.password, completed: { (user) in
            print("login: \(user.email)")
            self.hide_keyboard()
            self.clean()
        }) { (errorMessage) in
            print("Error: \(errorMessage)")
            self.signinViewModel.showAlert = true
            self.activeAlert = ActiveAlert.first
            self.signinViewModel.errorString = errorMessage
            
            
        }
        
    }
    
    func clean() {
        //        self.showLoginView.toggle()
        self.presentationMode.wrappedValue.dismiss()
        self.showSignupView.toggle()
        self.signinViewModel.email = ""
        self.signinViewModel.password = ""
        
    }
    
    func reset(){
        signinViewModel.resetPasswordFor(email: signinViewModel.email) { (error) in
            if (error != nil){
                return
            }
            
            
            
        }
    }
    
    
    //    func getSinWave(interval:CGFloat, amplitude: CGFloat = 100 ,baseline:CGFloat = UIScreen.main.bounds.height/2) -> Path {
    //        Path{path in
    //            path.move(to: CGPoint(x: 0, y: baseline
    //            ))
    //            path.addCurve(
    //                to: CGPoint(x: 1*interval,y: baseline),
    //                control1: CGPoint(x: interval * (0.35),y: amplitude + baseline),
    //                control2: CGPoint(x: interval * (0.65),y: -amplitude + baseline)
    //            )
    //            path.addCurve(
    //                to: CGPoint(x: 2*interval,y: baseline),
    //                control1: CGPoint(x: interval * (1.35),y: amplitude + baseline),
    //                control2: CGPoint(x: interval * (1.65),y: -amplitude + baseline)
    //            )
    //            path.addLine(to: CGPoint(x: 2*interval, y: universalSize.height))
    //            path.addLine(to: CGPoint(x: 0, y: universalSize.height))
    //
    //
    //        }
    //
    //    }
    var body: some View {
        
        ZStack {
            //
            //                NavigationLink(destination: SignUpView(showSignupView: self.$showSignupView), isActive: self.$showSignupView) {
            //                                                 Text("")
            //                                     }
            //
            
            
            ScrollView(.vertical, showsIndicators: false){
                
                
                
                VStack {
                    HStack{
                        Spacer()
                        Image("shape").foregroundColor(Color("Color2"))
                    }
                    
                    VStack{
                        Image("Gleem 3D Icon Type Black Transparent_resized").resizable().scaledToFit().frame(width: 200, height: 150)
                        Image("name").padding(.top,10)
                        
                    }.offset(y: -122)
                        .padding(.bottom,-132)
                    
                    //                        EmailTextField(email: $signinViewModel.email)
                    //                        PasswordTextField(password: $signinViewModel.password)
                    //
                    VStack(spacing: 20){
                        CustomTF(value: $signinViewModel.email, isemail: true)
                        
                        CustomTF(value: $signinViewModel.password, isemail: false)
                        
                        HStack{
                            
                            Spacer()
                            
                            Button(action: {
                                //                                self.resetLink = true
                                self.signinViewModel.showAlert = true
                                self.activeAlert = ActiveAlert.second
                                self.reset()
                            }) {
                                
                                Text("비밀번호를 잊어버렸습니다").foregroundColor(Color.black.opacity(0.1)).font(.custom(FONT, size: 15))
                            }
                        }
                        
                        
                        
                        
                        SigninButton(action: signIn, label: TEXT_SIGN_IN).alert(isPresented: $signinViewModel.showAlert) {
                            Alert(title: Text(ERROR), message: Text(self.signinViewModel.errorString), dismissButton: .default(Text(CONFIRM), action: {
                                
                            }))
                            
                        }
                        
                        //                                    Text("소셜미디어로 로그인하기").fontWeight(.bold).font(.custom(FONT, size: 15))
                        //
                        //                                    SocialMedia()
                        
                    }.padding()
                        .background(Color.white)
                        .cornerRadius(5)
                        .padding()
                    
                    
                    
                    
                    
                    Button(action: {
                        self.showSignupView.toggle()
                        self.signinViewModel.show.toggle()
                    }){
                        HStack {
                            Text(TEXT_NEED_AN_ACCOUNT).font(.footnote).foregroundColor(.gray)
                            Text(TEXT_SIGN_UP).foregroundColor(APP_THEME_COLOR)
                        }
                    }
                    
                    Spacer()
                    //                        Spacer()
                    
                }
                
                
                
                
            }
            //                .edgesIgnoringSafeArea(.all).padding()
            
            
            //                                getSinWave(interval: universalSize.width, amplitude: 130, baseline: -50 + universalSize.height/1.7)
            //                                    .foregroundColor(Color.init(red: 0.3, green: 0.6, blue: 1).opacity(0.4))
            //                                    .offset(x: isAnimated ? -1*universalSize.width : 0)
            //                                    .animation(
            //                                        Animation.linear(duration: 2)
            //                                            .repeatForever(autoreverses: false)
            //                                )
            //                                getSinWave(interval: universalSize.width*1.2, amplitude: 130, baseline: 50 + universalSize.height/1.7)
            //                                    .foregroundColor(Color.init(red: 0.3, green: 0.6, blue: 1).opacity(0.4))
            //                                    .offset(x: isAnimated ? -1*(universalSize.width*1.2) : 0)
            //                                    .animation(
            //                                        Animation.linear(duration: 5)
            //                                            .repeatForever(autoreverses: false)
            //                                )
            //                                Spacer()
            
        }.onAppear(){
            self.isAnimated = true
            
        }.KeyboardResponsive()
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .edgesIgnoringSafeArea(.all)
            .background(Color("Color-2").edgesIgnoringSafeArea(.all))
            .accentColor(Color.black)
            .sheet(isPresented: self.$signinViewModel.show) {
                
                SignUpView(showSignupView: self.$signinViewModel.show)
        }
        .alert(isPresented: self.$signinViewModel.showAlert) {
            
            switch activeAlert {
            case .first:
                if(self.signinViewModel.errorString == "There is no user record corresponding to this identifier. The user may have been deleted."){
                    self.signinViewModel.errorString = NO_ACCOUNT
                }else if(self.signinViewModel.errorString == "The password is invalid or the user does not have a password."){
                    self.signinViewModel.errorString = MiMATCH_PASSWORD_ERROR
                }
                
                return   Alert(title: Text(ERROR), message: Text(self.signinViewModel.errorString).font(.custom(FONT, size: 17)), dismissButton: .default(Text(CONFIRM).font(.custom(FONT, size: 17)).foregroundColor(APP_THEME_COLOR), action: {
                    
                }))
            case .second:
                
                return Alert(title: Text(SENT_LINK).font(.custom(FONT, size: 15 )), message: Text(CONFIRM_EMAIL).font(.custom(FONT, size: 13)), dismissButton: .default(Text(CONFIRM).font(.custom(FONT, size: 15)).foregroundColor(APP_THEME_COLOR), action: {
                }))
            case .third:
                
                return  Alert(title: Text(ERROR), message: Text("").font(.custom(FONT, size: 17)), dismissButton: .default(Text(CONFIRM).font(.custom(FONT, size: 17)).foregroundColor(APP_THEME_COLOR), action: {
                }))
                
            }
            
        }
        
        
        
    }
    func hide_keyboard()
    {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

//struct LoginView_Previews: PreviewProvider {
//    static var previews: some View {
//        LoginView()
//    }
//}


struct SocialMedia : View {
    
    var body : some View{
        
        HStack(spacing: 40){
            
            Button(action: {
                
            }) {
                
                Image("fb").renderingMode(.original)
            }
            
            Button(action: {
                
            }) {
                
                Image("twitter").renderingMode(.original)
            }
        }
    }
}

struct CustomTF : View {
    
    @Binding var value : String
    var isemail = false
    var reenter = false
    var username = false
    
    var body : some View{
        
        VStack(spacing: 8){
            
            HStack{
                Text(self.isemail ? TEXT_EMAIL : self.username ? TEXT_USERNAME : (self.reenter ? TEXT_PASSWORD_REENTER : TEXT_PASSWORD)).foregroundColor(Color.black.opacity(0.1)).font(.custom(FONT, size: 16))
                Spacer()
            }
            
            HStack{
                if self.isemail || self.username {
                    TextField("", text: self.$value)
                }
                else{
                    
                    SecureField("", text: self.$value)
                }
                
                
                Button(action: {
                    
                }) {
                    
                    Image(systemName: self.isemail ? "envelope.fill" :  (self.username ? "person.fill" :  "eye.slash.fill")).foregroundColor(APP_THEME_COLOR)
                }
            }
            
            Divider()
        }
    }
}
