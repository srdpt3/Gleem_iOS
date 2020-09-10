//
//  UploadView.swift
//  Gleem_Dating
//
//  Created by Dustin yang on 7/1/20.
//  Copyright © 2020 Dustin yang. All rights reserved.
//
import SwiftUI
struct UploadView: View {
    
    // intializing Four Image cards...
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject  var obs : observer

    var vote : Vote
    let characterLimit = 10
    
    @Binding var noVotePic : Bool
    @Binding var uploadComplete : Bool
    
    @State var image: Image = Image("profilepic")
    
    @State var images : [Data] = [Data()]
    @State var imagePicker = false
    @State var index = 0
    @State var showProfile = false
    @State var customAttr: String = ""
    @State var showAlert : Bool = false
    @State private var activeAlert: ActiveAlert = .first
    
    
    @State private var entry = ""
    @State var buttonPressed = [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false]
    @State  var buttonTitle = [String]()
    
    let haptics = UINotificationFeedbackGenerator()
    
    @ObservedObject var attributeViewModel = AttributeViewModel()
    @ObservedObject var uploadViewModel = UploadViewModel()
    @ObservedObject var historyViewModel = HistoryViewModel()
    
    
    
    
    func clean() {
        self.buttonPressed = [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false]
    }
    
    func checkAttrSelected() -> Bool{
        // Check any button is presssed
        self.buttonTitle.removeAll()
        var count = 0
        for (index, button) in buttonPressed.enumerated() {
            if (button){
                count = count + 1
                if(!attributeViewModel.buttonAttributes.isEmpty){
                    self.buttonTitle.append(attributeViewModel.buttonAttributes[index])
                    
                }
            }
        }
        if(count != 5){
            return true
        }
        return false
    }
    
    
    //    init(){
    //
    //    }
    
    
    var body: some View {
        
        ZStack{
            VStack(spacing: 25){
                
                HStack{
                    Spacer()
                    Text(PHOTOUPLOAD).font(Font.custom(FONT, size: 25)).foregroundColor(APP_THEME_COLOR).multilineTextAlignment(.leading).lineLimit(2)
                    Spacer()
                    
                }
                .padding(.top, 25)
                
                HStack(spacing: 15){
                    
                    ZStack{
                        
                        
                        
                        if self.images[0].count == 0{
                            
                            LottieView(filename: "plus").frame(width: 100, height: 100)
                                .clipShape(Circle()).padding(.bottom, 10).padding(.top, 10).zIndex(1)
                                .onTapGesture {
                                    print("Tapped")
                                    self.index = 0
                                    self.haptics.notificationOccurred(.success)
                                    
                                    self.imagePicker.toggle()
                            }
                            .opacity(self.images[0].count > 0 ? 0 : 1)
                        }
                        else{
                            
                            Image(uiImage: UIImage(data: self.images[0])!)
                                .resizable()
                                .renderingMode(.original)
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 150, height: 150)
                                .cornerRadius(10)
                            
                        }
                        
                        
                    } .frame(width: 150, height: 150)
                    Text(SELECT_ATTRIBUTES).font(Font.custom(FONT, size: 14)).foregroundColor(Color.gray)
                    
                    
                }
                if(!self.attributeViewModel.buttonAttributes.isEmpty){
                    VStack(alignment: .leading, spacing: 10){
                        HStack(spacing : 10){
                            
                            AttrButtonView(isPressed: self.$buttonPressed[0],title:self.attributeViewModel.buttonAttributes[0])
                            AttrButtonView(isPressed: self.$buttonPressed[1],title:self.attributeViewModel.buttonAttributes[1])
                            AttrButtonView(isPressed: self.$buttonPressed[2],title:self.attributeViewModel.buttonAttributes[2])
                            
                            
                        }.padding(.horizontal, 3)
                        //                    ChartView().frame(width: UIScreen.main.bounds.width, height: 300)
                        HStack(spacing : 10){
                            AttrButtonView(isPressed: self.$buttonPressed[3],title:self.attributeViewModel.buttonAttributes[3])
                            //                        Spacer()
                            AttrButtonView(isPressed: self.$buttonPressed[4],title:self.attributeViewModel.buttonAttributes[4])
                            
                        }.padding(.horizontal, 3)
                        HStack(spacing : 10){
                            
                            AttrButtonView(isPressed: self.$buttonPressed[7],title:self.attributeViewModel.buttonAttributes[7])
                            //                        Spacer()
                            AttrButtonView(isPressed: self.$buttonPressed[8],title:self.attributeViewModel.buttonAttributes[8])
                            //                            AttrButtonView(isPressed: self.$buttonPressed[8],title:buttonTitle[8])
                            
                        }.padding(.horizontal,3)
                        HStack(spacing : 10){
                            AttrButtonView(isPressed: self.$buttonPressed[9],title:self.attributeViewModel.buttonAttributes[9])
                            
                            AttrButtonView(isPressed: self.$buttonPressed[5],title:self.attributeViewModel.buttonAttributes[5])
                            AttrButtonView(isPressed: self.$buttonPressed[12],title:self.attributeViewModel.buttonAttributes[12])
                            
                        }.padding(.horizontal, 3)
                        
                        HStack(spacing : 10){
                            AttrButtonView(isPressed: self.$buttonPressed[16],title:self.attributeViewModel.buttonAttributes[16])
                            
                            //                        Spacer()
                            //                            AttrButtonView(isPressed: self.$buttonPressed[8],title:buttonTitle[8])
                            AttrButtonView(isPressed: self.$buttonPressed[10],title:self.attributeViewModel.buttonAttributes[10])
                            
                        }.padding(.horizontal, 3)
                        
                        
                        HStack(spacing : 10){
                            AttrButtonView(isPressed: self.$buttonPressed[14],title:self.attributeViewModel.buttonAttributes[14])
                            AttrButtonView(isPressed: self.$buttonPressed[15],title:self.attributeViewModel.buttonAttributes[15])
                            
                            //                        Spacer()
                            //                                                AttrButtonView(isPressed: self.$buttonPressed[7],title:self.attributeViewModel.buttonAttributes[7])
                            //                            AttrButtonView(isPressed: self.$buttonPressed[8],title:buttonTitle[8])
                            
                        }.padding(.horizontal, 3)
                        HStack(spacing : 10){
                            AttrButtonView(isPressed: self.$buttonPressed[13],title:self.attributeViewModel.buttonAttributes[13])
                            
                            AttrButtonView(isPressed: self.$buttonPressed[11],title:self.attributeViewModel.buttonAttributes[11])
                            AttrButtonView(isPressed: self.$buttonPressed[6],title:self.attributeViewModel.buttonAttributes[6])
                            
                            
                        }.padding(.horizontal, 3)
                        
                        //                        HStack(alignment: .center) {
                        //
                        //                            TextField("10자 내외 직접입력 ..".uppercased(), text: $entry)
                        //                                .keyboardType(.emailAddress)
                        //                                .font(.subheadline)
                        //                                //                    .textFieldStyle(RoundedBorderTextFieldStyle())
                        //                                .padding(.leading)
                        //                                .frame(height: 44)
                        //                                .background(
                        //                                    Capsule()
                        //                                        .strokeBorder(lineWidth: 1.75)
                        //                                        .foregroundColor(APP_THEME_COLOR)
                        //                            )
                        //                                .onTapGesture {
                        //                                    //                                                     self.isFocused = true
                        //                            }
                        //                            //                            frame(height: 136)
                        //                            //                            .frame(maxWidth: 712)
                        //                            //                            .background(BlurView(style: .systemMaterial))
                        //                            //                            .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                        //                            //                            .shadow(color: Color.black.opacity(0.15), radius: 20, x: 0, y: 20)
                        //                            //                            .padding(.horizontal)
                        //
                        //
                        //                            //                            TextField("10자 내외 직접입력 ..", text: $customAttr)
                        //                            //                                .textFieldStyle(CustomStyle()).disabled(entry.count > (characterLimit - 1))
                        //
                        //                        }.padding(.horizontal)
                    }.background(Color.clear)
                    
                    Button(action: {
                        
                        if(self.checkAttrSelected()){
                            self.showAlert.toggle()
                            self.activeAlert = ActiveAlert.first
                            
                        }else{
                            self.uploadPicture()
                            self.haptics.notificationOccurred(.success)
                            
                        }
                        
                    }) {
                        
                        Text("올리기")  .font(.custom(FONT, size: 20))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.vertical, 15)
                            .padding(.horizontal, 60)
                            .background(APP_THEME_COLOR)
                            .clipShape(Capsule())
                            .shadow(color: Color.black.opacity(0.3), radius: 5, x: 5, y: 5)
                            .shadow(color: Color.white.opacity(0.5), radius: 5, x: -8, y: -8)
                    }
                    .padding(.bottom, 15)
                        // Disabling button by verifying all images...
                        .opacity(self.verifyImages() ? 1 : 0.35)
                        .disabled(self.verifyImages() ? false : true)
                    
                    
                    Spacer()
                }
                
          
                
            }
            
            // <--- the view modifier
        } .padding(.horizontal).KeyboardResponsive()
            
            .background(Color.clear.edgesIgnoringSafeArea(.all))
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .sheet(isPresented: self.$imagePicker) {
                ImagePicker(showImagePicker: self.$imagePicker, pickedImage: self.$image, imageData: self.$images[self.index])
        }.padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top).onAppear{
            self.attributeViewModel.loadAttributes()
        } .alert(isPresented: self.$showAlert) {
            
            
            switch activeAlert {
            case .first:
                return Alert(title: Text(ERROR), message: Text(SELECT_ATTRIBUTES),  dismissButton: .default(Text("OK"), action: {
                    
                }))
            case .second:
                
                return Alert(title: Text(COMPLETE), message: Text(UPLOAD_SUCCESSFUL),  dismissButton: .default(Text("OK"), action: {
                    self.clean()
                    self.presentationMode.wrappedValue.dismiss()
                }))
            case .third:
                
                return  Alert(title: Text(ERROR), message: Text("").font(.custom(FONT, size: 17)), dismissButton: .default(Text(CONFIRM).font(.custom(FONT, size: 17)).foregroundColor(APP_THEME_COLOR), action: {
                }))
                
            }
            
            
            
            
            
        }.onAppear{
            print(self.noVotePic)
            print(self.vote)
        }
        
        
    }
    
    
    func uploadPicture(){
        uploadViewModel.uploadVote(buttonPressed: buttonPressed, buttonTitle: self.buttonTitle, imageData: self.images[0])
        self.uploadComplete = true
        self.obs.updateVoteImage = true
        self.clean()
        self.presentationMode.wrappedValue.dismiss()
        //
        
        
        
        if(!self.noVotePic && self.vote.imageLocation != ""){
            historyViewModel.persistPastVoteData(vote: self.vote)
            //            if(!historyViewModel.isLoading){
            //            }
            
        }
        self.uploadComplete = true
        //        self.showAlert.toggle()
        //         self.activeAlert = ActiveAlert.second
    }
    
    func hide_keyboard()
    {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func verifyImages()->Bool{
        
        var status = true
        
        for i in self.images{
            
            if i.count == 0{
                
                status = false
            }
        }
        
        return status
    }
}


public struct CustomStyle : TextFieldStyle {
    public func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(7)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(Color.black, lineWidth: 1)
        )
    }
    
}

