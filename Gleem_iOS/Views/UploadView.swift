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
    
    var noVotePic : Bool
    var vote : Vote
    @State var image: Image = Image("profilepic")
    
    @State var images : [Data] = [Data()]
    @State var imagePicker = false
    @State var index = 0
    @State var showProfile = false
    @State var customAttr: String = ""
    @State var showAlert : Bool = false
    let characterLimit = 10
    @State private var entry = ""
    @State var buttonPressed = [false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false]
    @State  var buttonTitle = [String]()
    let haptics = UINotificationFeedbackGenerator()
    
    @ObservedObject var attributeViewModel = AttributeViewModel()
    @ObservedObject var uploadViewModel = UploadViewModel()
    
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
                        //                        Image(uiImage: UIImage(data: self.images[0])!)
                        //                                                          .resizable()
                        //                                                          .renderingMode(.original)
                        //                                                          .aspectRatio(contentMode: .fill)
                        //                                                          .frame(width: 160, height: 160)
                        //                                                          .cornerRadius(10)
                        
                        //                           signupViewModel.image.resizable().frame(width: 80, height: 80).foregroundColor(APP_THEME_COLOR).cornerRadius(40)
                        //                               .padding(.bottom, 10).padding(.top, 10)
                        //
                        
                    } .frame(width: 150, height: 150)
                    Text(SELECT_ATTRIBUTES).font(Font.custom(FONT, size: 14)).foregroundColor(Color.gray)
                    //
                    //                    Button(action: {
                    //
                    //                        self.index = 0
                    //                        self.imagePicker.toggle()
                    //                        self.haptics.notificationOccurred(.success)
                    //
                    //
                    //                    }) {
                    //
                    //                        ZStack{
                    //
                    //                            if self.images[0].count == 0{
                    //
                    //                                RoundedRectangle(cornerRadius: 10)
                    //                                    .fill(Color("Color-2"))
                    //
                    //                                Image(systemName: "plus")
                    //                                    .font(.system(size: 24, weight: .bold)).foregroundColor(APP_THEME_COLOR)
                    //                            }
                    //                            else{
                    //
                    //                                Image(uiImage: UIImage(data: self.images[0])!)
                    //                                    .resizable()
                    //                                    .renderingMode(.original)
                    //                                    .aspectRatio(contentMode: .fill)
                    //                                    .frame(width: 160, height: 160)
                    //                                    .cornerRadius(10)
                    //                            }
                    //                        }
                    //                            // Fixed Height...
                    //                        .frame(width: 160, height: 160)
                    //
                    //                        Text(SELECT_ATTRIBUTES).font(Font.custom(FONT, size: 14)).foregroundColor(Color.gray)
                    //                    }
                    
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
                
                else{

                    LoadingView(isLoading: self.attributeViewModel.isLoading, error: self.attributeViewModel.error) {
                        self.attributeViewModel.loadAttributes()
                    }

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
            Alert(title: Text("Error"), message: Text("5개의 항목을 선택해주세요"),  dismissButton: .default(Text("OK"), action: {
                //                self.showLoader.toggle()
                //                self.showAlert.toggle()
                
            }))
        }
        
    }
    
    
    func uploadPicture(){
        uploadViewModel.uploadVote(buttonPressed: buttonPressed, buttonTitle: self.buttonTitle, imageData: self.images[0])
        self.clean()
        self.presentationMode.wrappedValue.dismiss()
        
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

