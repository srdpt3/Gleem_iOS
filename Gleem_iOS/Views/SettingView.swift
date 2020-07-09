//
//  SettingView.swift
//  Gleem_Dating
//
//  Created by Dustin yang on 6/29/20.
//  Copyright © 2020 Dustin yang. All rights reserved.
//

import SwiftUI
import StoreKit
import MessageUI
import FirebaseAuth

struct SettingsView: View {
    @State private var result: Result<MFMailComposeResult, Error>? = nil
    @State private var isShowingMailView = false
    @State  var showLoginView = false
    @EnvironmentObject var session: SessionStore
    @State var isSettingsOpen: Bool = true

    var body: some View {
        
        ZStack {
            
            Form {
                Section(header: Text("피드백").foregroundColor(Color("Color2")).font(.subheadline).bold()) {
                    SectionButton(image: "star.circle.fill", label: "앱평가하기", isShowingMailView: $isShowingMailView)
                    
                    SectionButton(image: "envelope.circle.fill", label: "건의사항 보내기", isShowingMailView: $isShowingMailView)
                }
                
                Section(header: Text("어플리케이션 소개 ").foregroundColor(Color("Color2")).font(.subheadline).bold()) {
                    Text("2000억짜리앱").font(.caption)
                    Text("실시간 내 매력투표, 데이터 기반 AI매칭,").font(.caption)
                    
                }
                
                Section(header: Text("크레딧").foregroundColor(Color("Color2")).font(.subheadline).bold()) {
                    VStack(alignment: .leading, spacing: 10){
                        Text("........").font(.footnote)
                    }
                    
                    
                }
                
                
                //                         Section(header: Text("인증").foregroundColor(Color("Color2")).font(.subheadline).bold()) {
                //                             //                    SectionButton(image: "emoji", label: "LogIn", showLoginView: $showLoginView)
                //
                //
                //                             Button(action: {
                //                                 if(Auth.auth().currentUser != nil){
                //                                     self.session.unbind()
                //                                     self.session.logout()
                //
                //                                 }else{
                //
                //                                 }
                //                                 self.showLoginView.toggle()
                //                                 //                        print(Auth.auth().currentUser!.email)
                //                             }) {
                //                                 HStack{
                //                                     Image("로그인").resizable().frame(width: 30, height: 30)   .font(.title)
                //                                     Text(Auth.auth().currentUser != nil ? "로그아웃" : "로그인").foregroundColor(Color("Color2")).font(.subheadline).bold()
                //
                //                                 }
                //
                //                             }
                //
                //
                //                         }
                
                Section(header: Text("개발자").foregroundColor(Color("Color2")).font(.subheadline).bold()) {
                    VStack(alignment: .leading, spacing: 10){
                        
                        Button("FrontYard") {UIApplication.shared.open(URL(string: "www.frontyard.io")!)}
                        
                    }
                    
                    
                }
                
                
                if UIDevice.current.userInterfaceIdiom == .pad {
                    Button(action: {
                        self.isSettingsOpen.toggle()
                    }) {
                        Text("Dismiss")
                    }
                }
            }
            
            
            //            if (showLoginView) {
            //                LoginView(showLoginView: self.$showLoginView)
            //                    .transition(.move(edge: .bottom))
            //                    .animation(.default)
            //            }
            
            if (isShowingMailView) {
                mailView()
                    .transition(.move(edge: .bottom))
                    .animation(.default)
            }
        }  .background(Color.white)
                  .navigationBarTitle("")
                  .navigationBarHidden(true)
            .padding(.bottom, UIApplication.shared.windows.first?.safeAreaInsets.bottom == 0 ? 5 : 0).padding(.top, 40)
                
        
        
    }
    
    private func mailView() -> some View {
        MFMailComposeViewController.canSendMail() ?
            AnyView(MailView(isShowing: $isShowingMailView, result: $result)) :
            AnyView(Text("Can't send emails from this device"))
    }
}

//struct SettingsView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView {
//            SettingsView(isSettingsOpen: Binding.constant(true))
//        }
//    }
//}

struct SectionButton: View {
    let image: String
    let label: String
    
    @Binding var isShowingMailView: Bool
    
    var body: some View {
        Button(action: buttonAction) {
            HStack {
                Image(systemName: image)
                    .font(.title)
                Text(label)
                    .foregroundColor(Color(.label))
            }
        }
    }
    
    func buttonAction() {
        if label == "Rate this app" {
            SKStoreReviewController.requestReview()
        } else {
            self.isShowingMailView.toggle()
        }
    }
}



//MARK: - Mail view
struct MailView: UIViewControllerRepresentable {
    
    @Binding var isShowing: Bool
    @Binding var result: Result<MFMailComposeResult, Error>?
    
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        
        @Binding var isShowing: Bool
        @Binding var result: Result<MFMailComposeResult, Error>?
        
        init(isShowing: Binding<Bool>,
             result: Binding<Result<MFMailComposeResult, Error>?>) {
            _isShowing = isShowing
            _result = result
        }
        
        func mailComposeController(_ controller: MFMailComposeViewController,
                                   didFinishWith result: MFMailComposeResult,
                                   error: Error?) {
            defer {
                isShowing = false
            }
            guard error == nil else {
                self.result = .failure(error!)
                return
            }
            self.result = .success(result)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(isShowing: $isShowing,
                           result: $result)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<MailView>) -> MFMailComposeViewController {
        
        let emailSubjectText = "Gleem Feedback"
        let emailText = "Please write your feedback here."
        let alertTitle = "Sign in to mail"
        let alertMessage = "You are currently not signed into the email application on your iOS device. Please sign in if you wish to send us feedback."
        
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = context.coordinator
        
        if MFMailComposeViewController.canSendMail() {
            composeVC.setToRecipients(["srdpt3@gmail.com"])
            composeVC.setSubject(emailSubjectText)
            composeVC.setMessageBody(emailText, isHTML: false)
        } else {
            let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(OKAction)
            UIApplication.shared.windows.first?.rootViewController?.present(alertController, animated: true, completion:nil)
        }
        
        return composeVC
    }
    
    func updateUIViewController(_ uiViewController: MFMailComposeViewController,
                                context: UIViewControllerRepresentableContext<MailView>) {
    }
}

