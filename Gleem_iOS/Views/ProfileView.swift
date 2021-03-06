//
//  ProfileView.swift
//  Gleem_iOS
//
//  Created by Dustin yang on 7/13/20.
//  Copyright © 2020 Dustin yang. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProfileView: View {
    
    @Binding var profile_show : Bool
    
  
    var body: some View {
        
        
        
        Profile(profile_show : self.$profile_show)
    }
}

//struct ProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileView()
//    }
//}

struct Profile : View {
    @ObservedObject var voteViewModel = VoteViewModel()
    @ObservedObject var matchingViewModel = MatchingViewModel()
    @Binding var profile_show : Bool

    
    var body : some View{
        
        ZStack{
            
            ZStack{
                if(User.currentUser()!.profileImageUrl != ""){
                    AnimatedImage(url: URL(string: User.currentUser()!.profileImageUrl)!).resizable().aspectRatio(contentMode: .fill).frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/1.5, alignment: .center).edgesIgnoringSafeArea(.all)
                    
                }else{
                    VStack{
                        Text(NOVOTEIMAGE)
                            .font(.custom(FONT, size: CGFloat(13))).foregroundColor(Color("sleep")).padding(.horizontal)
                        Image("Gleem_3D").resizable().scaledToFit().frame(width: UIScreen.main.bounds.width / 2 , height: UIScreen.main.bounds.height/3, alignment: .center).edgesIgnoringSafeArea(.all)
                        
                    }

                }
            }
            
            
            VStack{
                
                HStack{

                    Spacer()
                    
                    Button(action: {
                        self.profile_show.toggle()
                        
                    }) {
                        
                        Image("close").renderingMode(.original).resizable().frame(width: 20, height: 20)
                    }
                }
                
                Spacer()
                
                ZStack(alignment: .top) {
                    
                    VStack(alignment: .leading, spacing: 10){
                        
                        HStack{
                            
                            VStack(alignment: .leading, spacing: 10) {
                                
                                Text(User.currentUser()!.username).font(Font.custom(FONT, size: 20))
                                Text(MY_AGE + User.currentUser()!.age).font(Font.custom(FONT, size: 15))
                                
                            }
                            
                            Spacer()
                            
                            HStack(spacing: 8){
                                
                                Image("map").resizable().frame(width: 15, height: 20)
                                
                                Text(User.currentUserProfile()!.location).font(Font.custom(FONT, size: 20))
                                
                            }.padding(8)
                                .background(Color.black.opacity(0.1))
                                .cornerRadius(10)
                        }.padding(.top,35)
                        
                        VStack(alignment: .leading, spacing: 10){
                            Text(NUM_GLEEM_POINT + String(User.currentUser()!.point_avail)).font(.subheadline).font(Font.custom(FONT, size: 15))
                            HStack{
                                Text(NUM_I_VOTED +  String(self.voteViewModel.totalVoted)).font(Font.custom(FONT, size: 15))
                                Spacer()
                                Text(NUM_MATCHED + String(self.matchingViewModel.totalMatched)).font(Font.custom(FONT, size: 15))
                                
                            }
                            
                            
                            HStack{
                                Text(NUM_SKIPPED + String(self.voteViewModel.totalSkipped)).font(Font.custom(FONT, size: 15))
                                Spacer()
                                Text(NUM_FLAGGED + String(self.voteViewModel.totalFlagged)).font(Font.custom(FONT, size: 15))
                            }
                            
                            
                            
                        }.padding(.top)
                        
                        
                    }.padding()
                        .background(Blurview())
                        .clipShape(BottomShape())
                        .cornerRadius(25)
                    
                    ZStack{
                        
                        Button(action: {
                            
                        }) {
                            
                            Image(User.currentUser()!.sex ==  "male" ? "male" : "female").renderingMode(.original).resizable()
                                .frame(width: 20, height: 20)
                                .padding(20)
                                .background(Color.white)
                                .clipShape(Circle())
                        }
                        
                        Circle().stroke(APP_THEME_COLOR, lineWidth: 5).frame(width: 70, height: 70)
                        
                    }.offset(y: -35)
                    
                    //                    HStack{
                    //
                    ////                        Button(action: {
                    ////
                    ////                        }) {
                    ////
                    ////                            Image("heart").renderingMode(.original).resizable()
                    ////                                .frame(width: 25, height: 20)
                    ////                                .padding()
                    ////                                .background(Color.white)
                    ////                                .clipShape(Circle())
                    ////                        }
                    //
                    //                        Spacer()
                    //
                    //                        Button(action: {
                    //
                    //                        }) {
                    //
                    //                            Image(User.currentUser()!.sex ==  "male" ? "male" : "female").renderingMode(.original).resizable()
                    //                                .frame(width: 25, height: 25)
                    //                                .padding()
                    //                                .background(Color.white)
                    //                                .clipShape(Circle())
                    //                        }
                    //                        }.offset(y: -25)
                    //                        .padding(.horizontal,35)
                }
                
            }.padding()
        }.onAppear{
            self.voteViewModel.getNumVoted()
            self.matchingViewModel.getNumMatched()
            
        }
        
    }
}

struct BottomShape : Shape {
    
    func path(in rect: CGRect) -> Path {
        
        return Path{path in
            
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: rect.width, y: 0))
            path.addArc(center: CGPoint(x: rect.width / 2, y: 0), radius: 42, startAngle: .zero, endAngle: .init(degrees: 180), clockwise: false)
            
        }
    }
}


struct Blurview : UIViewRepresentable {
    
    func makeUIView(context: UIViewRepresentableContext<Blurview>) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialLight))
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Blurview>) {
        
        
    }
}

