//
//  ExpandView.swift
//  Gleem_Dating
//
//  Created by Dustin yang on 6/29/20.
//  Copyright © 2020 Dustin yang. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct ExpandView: View {
    
    var user : ActiveVote
    @Environment(\.horizontalSizeClass) var sizeClass
    
    @State var updateVoteImage : Bool = false
    @Binding var show : Bool
    @Binding var isVoted: Bool
    //    @State var voted: Bool = false
    @State var voteData:[Double] = []
    //    @State var voteData = [Int.random(in: 0 ..< 100),Int.random(in: 0 ..< 100),Int.random(in: 0 ..< 100),Int.random(in: 0 ..< 100),Int.random(in: 0 ..< 100)]
    @State var ymax = 100
    @State var windowHeightDeno = 1.65
    @State var buttonPressed = [false,false,false,false,false]
    @State var needMoveCard: Bool = true
    var selectedButton = [String]()
    @State var buttonTitle : [String] = ["없음", "없음","없음", "없음", "없음"]
    
    @ObservedObject private var voteViewModel = VoteViewModel()
    @ObservedObject private var chartViewModel = ChartViewModel()
    @ObservedObject  private var favoriteViewModel = FavoriteViewModel()
    @EnvironmentObject  var obs : observer
    
    @State private var pulsate: Bool = false
    @Environment(\.presentationMode) var presentationMode
    let haptics = UINotificationFeedbackGenerator()
    @State var showHeart : Bool = false
    
    //    @State var buttonSelected: Bool = false
    
    
    func persist() {
        
        //        withAnimation{
        //            self.isVoted = true
        //
        //
        //        }
        //
        //        self.isVoted = true
        //        self.obs.moveCards()
        self.voteViewModel.persist(id: user.id, buttonPressed: self.buttonPressed, buttonTitle:self.user.attrNames)
        self.loadChartData()
    }
    
    func loadChartData(){
        self.chartViewModel.loadChartData(userId: user.id) { (vote) in
            
            self.voteData.removeAll()
            
            if(vote.numVote == 0){
                self.voteData = [10,10,10,10,10]
            }else{
                let attr1 = (Double(vote.attr1) / Double(vote.numVote) * 100).roundToDecimal(0)
                let attr2 = (Double(vote.attr2) / Double(vote.numVote) * 100).roundToDecimal(0)
                let attr3 = (Double(vote.attr3) / Double(vote.numVote) * 100).roundToDecimal(0)
                let attr4 = (Double(vote.attr4) / Double(vote.numVote) * 100).roundToDecimal(0)
                let attr5 = (Double(vote.attr5) / Double(vote.numVote) * 100).roundToDecimal(0)
                self.voteData = [attr1, attr2, attr3, attr4, attr5]
                
                if(attr1 > 80 ||  attr2 > 80  || attr3 > 80  || attr4 > 80  || attr5 > 80 ){
                    self.ymax  = 100
                }else if(attr1 > 70 ||  attr2 > 70  || attr3 > 70  || attr4 > 70  || attr5 > 70 ){
                    self.ymax  = 80
                }else  if(attr1 > 60 ||  attr2 > 60  || attr3 > 60  || attr4 > 60  || attr5 > 60 ){
                    self.ymax  = 70
                }else if(attr1 > 50 ||  attr2 > 50  || attr3 > 50  || attr4 > 50  || attr5 > 50 ){
                    self.ymax  = 60
                }else  if(attr1 > 40 ||  attr2 > 40  || attr3 > 40  || attr4 > 40  || attr5 > 40 ){
                    self.ymax  = 50
                }else if(attr1 > 30 ||  attr2 > 30  || attr3 > 30  || attr4 > 30  || attr5 > 30 ){
                    self.ymax  = 40
                }else if(attr1 > 20 ||  attr2 > 20  || attr3 > 20  || attr4 > 20  || attr5 > 20 ){
                    self.ymax  = 30
                }else{
                    self.ymax = 20
                }                //
            }
            
            
        }
    }
    
    func addToMyList(){
        if(User.currentUser() != nil){
            if(self.favoriteViewModel.liked){
                self.favoriteViewModel.removeFromList(id: user.id)
            }else{
                
                // Add to the list
                if(self.updateVoteImage){
                    self.favoriteViewModel.addToMyList(user: user)
                }
            }
            self.favoriteViewModel.liked.toggle()
            
        }
    }
    
    func checkAttrSelected() -> Bool{
        // Check any button is presssed
        for (_, button) in buttonPressed.enumerated() {
            if (button){
                return true;
            }
        }
        return false
    }
    
    
    var body: some View{
        
        ScrollView(.vertical, showsIndicators: false, content: {
            
            GeometryReader{reader in
                
                // Type 2 Parollax....
                if reader.frame(in: .global).minY > -UIScreen.main.bounds.height * 0.55 {
                    ZStack(alignment: .topTrailing) {
                        AnimatedImage(url: URL(string: self.user.imageLocation))
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            //                            .aspectRatio(contentMode: .fit)
                            // moving View Up....
                            //                            .offset(y: -reader.frame(in: .global).minY)
                            // going to add parallax effect....
                            .frame(width: UIScreen.main.bounds.width, height:  reader.frame(in: .global).minY > 0 ? reader.frame(in: .global).minY +  UIScreen.main.bounds.height * 0.55: UIScreen.main.bounds.height * 0.55)
                            .scaledToFill()
                            .clipped()
                        
                    }
                    .background(Color.black.opacity(0.06)).edgesIgnoringSafeArea(.top)
                        
                    .onAppear() {
                        self.pulsate.toggle()
                    }
                }
                
                
                
            }  // default frame...
                .frame(height: UIScreen.main.bounds.height / CGFloat(self.windowHeightDeno))
            //                            .clipShape(CustomShape(corner: .bottomLeft, radii: 30))
            //                            .background(Color.black.opacity(0.5).edgesIgnoringSafeArea(.top)
            
            VStack{
                Group {
                    
                    VStack(alignment: .leading,spacing: 15){
                        if(!self.buttonPressed[0] && !self.buttonPressed[1] && !self.buttonPressed[2] && !self.buttonPressed[3] && !self.buttonPressed[4]){
                            VStack(alignment: .center, spacing: 10) {
                                
                                Spacer()
                                
                                
                                HStack(spacing: 10){
                                    Spacer()
                                    Text(RATING_TEXT)
                                        //                                            .font(.system(size: 20, weight: .bold))
                                        .font(.custom(FONT, size: CGFloat(UIScreen.main.bounds.height < 896.0 ? 15: 18)))
                                        
                                        .foregroundColor(APP_THEME_COLOR)
                                    
                                    
                                    
                                    if(Int(self.user.numVote)  >= 10){
                                        ForEach(1...5,id: \ .self){_ in
                                            Image(systemName: "star.fill")
                                                .foregroundColor(.yellow)
                                        }
                                    }else{
                                        //                                        let star = Int(self.user.numVote / 2)
                                        if(Int(self.user.numVote) > 2){
                                            ForEach(1...Int(self.user.numVote / 2) ,id: \ .self){_ in
                                                Image(systemName: "star.fill")
                                                    .foregroundColor(.yellow)
                                            }
                                            
                                            ForEach((Int(self.user.numVote / 2) + 1)...5 ,id: \ .self){_ in
                                                Image(systemName: "star")
                                                    .foregroundColor(.yellow)
                                            }
                                        }else{
                                            ForEach(1...5 ,id: \ .self){_ in
                                                Image(systemName: "star")
                                                    .foregroundColor(.yellow)
                                            }
                                        }
                                        
                                    }
                                    
                                    HStack(alignment: .center, spacing: 2) {
                                        //                                        Image("event").resizable().frame(width: 18, height: 18).foregroundColor(Color.gray)
                                        Text(String(" / 20대 중반")).font(.custom(FONT, size: CGFloat(UIScreen.main.bounds.height < 896.0 ? 15: 18)))
                                            
                                            .foregroundColor(APP_THEME_COLOR)
                                    }
                                    
                                    Spacer()
                                }.padding(.bottom, 10)
                                
                                HStack{
                                    Spacer()
                                    RatingDetailView(card: user)
                                    Spacer()
                                    
                                }
                                
                            }
                            
                            
                            VStack(alignment: .leading, spacing: 12){
                                if(user.attrNames[0].count + user.attrNames[1].count + user.attrNames[2].count  <= 12 ){
                                    HStack(spacing : 8){
                                        Spacer()
                                        
                                        Button(user.attrNames[0], action: {
                                            self.buttonPressed[0].toggle()
                                            self.persist()
                                            //            self.buttonSelected.toggle()
                                        }).buttonStyle(NeumorphicButtonStyle(bgColor: Color("Color-2"), isPressed:  self.$buttonPressed[0]))
                                        
                                        
                                        Button(user.attrNames[1], action: {
                                            self.buttonPressed[1].toggle()
                                            self.persist()
                                            
                                            //            self.buttonSelected.toggle()
                                        }).buttonStyle(NeumorphicButtonStyle(bgColor: Color("Color-2"), isPressed:  self.$buttonPressed[1]))
                                        
                                        Button(user.attrNames[2], action: {
                                            self.buttonPressed[2].toggle()
                                            self.persist()
                                            
                                            //            self.buttonSelected.toggle()
                                        }).buttonStyle(NeumorphicButtonStyle(bgColor: Color("Color-2"), isPressed:  self.$buttonPressed[2]))
                                        
                                        Spacer()
                                        
                                    }.padding(.horizontal, 5)
                                    
                                    HStack(spacing : 8){
                                        Spacer()
                                        Button(user.attrNames[3], action: {
                                            self.buttonPressed[3].toggle()
                                            self.persist()
                                            
                                        }).buttonStyle(NeumorphicButtonStyle(bgColor: Color("Color-2"), isPressed:  self.$buttonPressed[3]))
                                        
                                        
                                        Button(user.attrNames[4], action: {
                                            self.buttonPressed[4].toggle()
                                            self.persist()
                                        }).buttonStyle(NeumorphicButtonStyle(bgColor: Color("Color-2"), isPressed:  self.$buttonPressed[4]))
                                        
                                        Spacer()
                                        
                                    }.padding(.horizontal, 5)
                                }else{
                                    HStack(spacing : 8){
                                        
                                        Button(user.attrNames[0], action: {
                                            self.buttonPressed[0].toggle()
                                            self.persist()
                                            //            self.buttonSelected.toggle()
                                        }).buttonStyle(NeumorphicButtonStyle(bgColor: Color("Color-2"), isPressed:  self.$buttonPressed[0]))
                                        
                                        
                                        Button(user.attrNames[1], action: {
                                            self.buttonPressed[1].toggle()
                                            self.persist()
                                            
                                            //            self.buttonSelected.toggle()
                                        }).buttonStyle(NeumorphicButtonStyle(bgColor: Color("Color-2"), isPressed:  self.$buttonPressed[1]))
                         
                                        Spacer()
                                        
                                    }.padding(.horizontal, 20)
                                    
                                    HStack(spacing : 8){
                                        Button(user.attrNames[2], action: {
                                            self.buttonPressed[2].toggle()
                                            self.persist()
                                            
                                        }).buttonStyle(NeumorphicButtonStyle(bgColor: Color("Color-2"), isPressed:  self.$buttonPressed[2]))
                                        
                                        
                                        Button(user.attrNames[3], action: {
                                            self.buttonPressed[3].toggle()
                                            self.persist()
                                        }).buttonStyle(NeumorphicButtonStyle(bgColor: Color("Color-2"), isPressed:  self.$buttonPressed[3]))
                                        
                                        Spacer()
                                        
                                    }.padding(.horizontal, 20)
                                    
                                    HStack(alignment: .top,spacing : 8){
                    
                                          
                                  
                                          Button(user.attrNames[4], action: {
                                              self.buttonPressed[4].toggle()
                                              self.persist()
                                          }).buttonStyle(NeumorphicButtonStyle(bgColor: Color("Color-2"), isPressed:  self.$buttonPressed[4]))
                                          
                                          Spacer()
                                          
                                      }.padding(.horizontal, 20)
                                }
                                
                                
                                
                                
                                
                                BannerAdView(bannerId: BANNER_UNIT_ID).frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height < 896.0 ? 70 : 90)
                                Spacer()
                            }
                        }
                        else{
                            VStack(alignment: .center, spacing: 0) {
                                if !self.voteData.isEmpty {
                                    
                                    ZStack{
                                        Text(self.user.username + USER_RESULT.uppercased()).font(.custom(FONT, size: CGFloat(15))).padding().foregroundColor(APP_THEME_COLOR).offset(y: 10).offset(x: -15)
                                        
                                    }.zIndex(1)
                                    
                                    ChartView(data: self.$voteData, totalNum: self.$ymax, categories: self.user.attrNames)
                                        .frame(height: (UIScreen.main.bounds.height) / 3)
                                    
                                } else {
                                    LoadingView(isLoading: self.chartViewModel.isLoading, error: self.chartViewModel.error) {
                                        self.loadChartData()
                                    }
                                }
                            }  .onAppear{
                                self.windowHeightDeno = 2
                                self.loadChartData()
                                
                            }  .animation(Animation.spring(response: 0.6, dampingFraction: 1.0, blendDuration: 1.0))  
                                
                                .cornerRadius(20)
                            //                            .offset(y: -100)
                            
                        }
                    }.overlay(
                        HStack {
                            Spacer()
                            VStack {
                                
                                if(self.buttonPressed[0] || self.buttonPressed[1] || self.buttonPressed[2] || self.buttonPressed[3] || self.buttonPressed[4]) {
                                    
                                    HStack{
                                        
                                        
                                        Button(action: {
                                            // ACTION
                                            self.haptics.notificationOccurred(.success)
                                            self.isVoted = true
                                            
                                            if(self.needMoveCard){
                                                self.obs.moveCards()
                                            }
                                            
                                            self.presentationMode.wrappedValue.dismiss()
                                        }, label: {
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundColor(Color.white)
                                                .shadow(radius: 10)
                                                .opacity( 1 )
                                                .scaleEffect(1.8 , anchor: .center)
                                        })
                                            .padding(.trailing, 15).buttonStyle(PlainButtonStyle()).padding(.top, 30)
                                    }
                                    
                                    
                                    Spacer()
                                    
                                    Button(action:self.addToMyList) {
                            
                                        
                                        Image(self.favoriteViewModel.liked == true ? "full-heart" : "empty-heart").resizable().frame(width: 30, height: 30).aspectRatio(contentMode: .fit)
                                            .foregroundColor(Color.white)
                                            //                                            .shadow(radius: 8)
                                            .opacity(1)
                                            .scaleEffect(self.showHeart ? 1.9 : 1.2, anchor: .center).onAppear{
                                                self.showHeart.toggle()
                                        }
            
                                    }
                                        
                                        
                                    .buttonStyle(PlainButtonStyle()).padding(.trailing, 30).padding(.top, UIScreen.main.bounds.height / 3.7)
                                    .animation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true))
                                    
                                    
                                }
                                Spacer()
                            }
                        }
                    )
                        //                    .padding(.top, 35)
                        .background(Color.white)
                        .cornerRadius(20)
                    
                    
                }
            }
            
            
        })
            .edgesIgnoringSafeArea(.all)
            .background(Color.white.edgesIgnoringSafeArea(.all))
            .onAppear{
                self.favoriteViewModel.checkLiked(id: self.user.id)
        }.onDisappear{
            //            withAnimation{
            //                //                         self.showVotingScreen.toggle()
            //                self.obs.moveCards()
            //            }
        }
        
    }
    
}
