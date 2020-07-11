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
    @State var image: Image = Image("profilepic")
    
    @State var images : [Data] = [Data()]
    @State var imagePicker = false
    @State var index = 0
    @State var showProfile = false
    @State var customAttr: String = ""
    @State var showAlert : Bool = false
    let characterLimit = 10
    @State private var entry = ""
    @State var buttonPressed = [false,false,false,false,false,false,false,false]
    @State  var buttonTitle = [String]()
    
    @ObservedObject var attributeViewModel = AttributeViewModel()
    @ObservedObject var uploadViewModel = UploadViewModel()
    
    func clean() {
        self.buttonPressed = [false,false,false,false,false,false,false,false]
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
    var body: some View {
        
        ZStack{
            VStack(spacing: 35){
                
                HStack{
                    Spacer(minLength: 0)
                    Text("사진 올리기")
                        .font(.title)
                        .foregroundColor(.black)
                        .fontWeight(.bold)
                    
                    Spacer(minLength: 0)
                }
                .padding(.top, 25)
                
                HStack(spacing: 15){
                    
                    Button(action: {
                        
                        self.index = 0
                        self.imagePicker.toggle()
                        
                    }) {
                        
                        ZStack{
                            
                            if self.images[0].count == 0{
                                
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color("Color-3"))
                                
                                Image(systemName: "plus")
                                    .font(.system(size: 24, weight: .bold)).foregroundColor(.white)
                            }
                            else{
                                
                                Image(uiImage: UIImage(data: self.images[0])!)
                                    .resizable()
                                    .renderingMode(.original)
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 200, height: 200)
                                    .cornerRadius(10)
                            }
                        }
                            // Fixed Height...
                            .frame(width: 200, height: 200)
                    }
                    
                }
                if(!self.attributeViewModel.buttonAttributes.isEmpty){
                    VStack(spacing: 8){
                        HStack(spacing : 2){
                            
                            AttrButtonView(isPressed: self.$buttonPressed[0],title:self.attributeViewModel.buttonAttributes[0])
                            AttrButtonView(isPressed: self.$buttonPressed[1],title:self.attributeViewModel.buttonAttributes[1])
                            AttrButtonView(isPressed: self.$buttonPressed[2],title:self.attributeViewModel.buttonAttributes[2])
                            
                            
                        }.padding(.horizontal, 2)
                        //                    ChartView().frame(width: UIScreen.main.bounds.width, height: 300)
                        HStack(spacing : 2){
                            AttrButtonView(isPressed: self.$buttonPressed[3],title:self.attributeViewModel.buttonAttributes[3])
                            //                        Spacer()
                            AttrButtonView(isPressed: self.$buttonPressed[4],title:self.attributeViewModel.buttonAttributes[4])
                            
                        }.padding(.horizontal, 2)
                        HStack(spacing : 2){
                            AttrButtonView(isPressed: self.$buttonPressed[5],title:self.attributeViewModel.buttonAttributes[5])
                            
                            AttrButtonView(isPressed: self.$buttonPressed[6],title:self.attributeViewModel.buttonAttributes[6])
                            //                        Spacer()
                            AttrButtonView(isPressed: self.$buttonPressed[7],title:self.attributeViewModel.buttonAttributes[7])
                            //                            AttrButtonView(isPressed: self.$buttonPressed[8],title:buttonTitle[8])
                            
                        }.padding(.horizontal, 2)
                        
                        HStack(alignment: .center) {
                            
                            TextField("10자 내외 직접입력 ..".uppercased(), text: $entry)
                                .keyboardType(.emailAddress)
                                .font(.subheadline)
                                //                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.leading)
                                .frame(height: 44)
                                .onTapGesture {
                                    //                                                     self.isFocused = true
                            }
                            //                            frame(height: 136)
                            //                            .frame(maxWidth: 712)
                            //                            .background(BlurView(style: .systemMaterial))
                            //                            .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                            //                            .shadow(color: Color.black.opacity(0.15), radius: 20, x: 0, y: 20)
                            //                            .padding(.horizontal)
                            
                            
                            //                            TextField("10자 내외 직접입력 ..", text: $customAttr)
                            //                                .textFieldStyle(CustomStyle()).disabled(entry.count > (characterLimit - 1))
                            
                        }.padding(.horizontal)
                    }.background(Color.clear)
                    
                    Button(action: {
                        
                        if(self.checkAttrSelected()){
                            self.showAlert.toggle()
                        }else{
                            self.uploadPicture()
                        }
                        
                    }) {
                        
                        Text("올리기")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 45)
                            .background(Color("Color2"))
                            .clipShape(Capsule())
                    }
                    .padding(.top, 10)
                        // Disabling button by verifying all images...
                        .opacity(self.verifyImages() ? 1 : 0.35)
                        .disabled(self.verifyImages() ? false : true)
                    
                    
                    Spacer()
                }else{
                    
                    LoadingView(isLoading: self.attributeViewModel.isLoading, error: self.attributeViewModel.error) {
                        self.attributeViewModel.loadAttributes(sex: "male")
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
            self.attributeViewModel.loadAttributes(sex: "male")
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



