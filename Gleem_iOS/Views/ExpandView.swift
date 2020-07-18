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
    @Binding var show : Bool
    @Binding var isVoted: Bool
    //    @State var voted: Bool = false
    @State var voteData:[Double] = []
    //    @State var voteData = [Int.random(in: 0 ..< 100),Int.random(in: 0 ..< 100),Int.random(in: 0 ..< 100),Int.random(in: 0 ..< 100),Int.random(in: 0 ..< 100)]
    
    @State var buttonPressed = [false,false,false,false,false]
    var selectedButton = [String]()
    
    @ObservedObject private var voteViewModel = VoteViewModel()
    @ObservedObject private var chartViewModel = ChartViewModel()
    @ObservedObject  private var favoriteViewModel = FavoriteViewModel()
    @State private var pulsate: Bool = false
    @Environment(\.presentationMode) var presentationMode

    //    @State var buttonSelected: Bool = false
    
    
    func persist() {
        //                                     self.topRatedState.loadMovies(with: .topRated)
        self.voteViewModel.persist(id: user.id, buttonPressed: self.buttonPressed, buttonTitle:self.user.attrNames)
        self.loadChartData()
    }
    
    func loadChartData(){
        self.chartViewModel.loadChartData(userId: user.id) { (vote) in
            
            self.voteData.removeAll()
            
            if(vote.numVote == 0){
                self.voteData = [10,10,10,10,10]
            }else{
                self.voteData.append((Double(vote.attr1) / Double(vote.numVote) * 100).roundToDecimal(0))
                self.voteData.append((Double(vote.attr2) / Double(vote.numVote) * 100).roundToDecimal(0))
                self.voteData.append((Double(vote.attr3) / Double(vote.numVote) * 100).roundToDecimal(0))
                self.voteData.append((Double(vote.attr4) / Double(vote.numVote) * 100).roundToDecimal(0))
                self.voteData.append((Double(vote.attr5) / Double(vote.numVote) * 100).roundToDecimal(0))
            }
            
            print(self.voteData)
            
        }
    }
    
    func addToMyList(){
        if(User.currentUser() != nil){
            if(self.favoriteViewModel.liked){
                self.favoriteViewModel.removeFromList(id: user.id)
            }else{
                
                // Add to the list
                self.favoriteViewModel.addToMyList(user: user)
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
                if reader.frame(in: .global).minY > -460 {
                    ZStack(alignment: .topTrailing) {
                        AnimatedImage(url: URL(string: self.user.imageLocation))
                            .resizable()
                            //                            .aspectRatio(contentMode: .fit)
                            // moving View Up....
                            .offset(y: -reader.frame(in: .global).minY)
                            // going to add parallax effect....
                            .frame(width: UIScreen.main.bounds.width, height:  reader.frame(in: .global).minY > 0 ? reader.frame(in: .global).minY + 460 : 460)
                            .scaledToFit()
                        //
                        //                        Button(action: {
                        //
                        //                            withAnimation{
                        //                                self.show.toggle()
                        //                            }
                        //
                        //                        }) {
                        //
                        //                            Image(systemName: "xmark")
                        //                                .foregroundColor(.white)
                        //                                .padding()
                        //                                .background(Color.black.opacity(0.08))
                        //                                .clipShape(Circle())
                        //                        }
                        //                        .padding(.trailing).padding(.top, 50)
                        //
                        if(self.isVoted){
                            
                            Button(action:self.addToMyList) {
                                Image(self.favoriteViewModel.liked == true ? "heartred" : "heartwhite").resizable().frame(width: 50, height: 50).aspectRatio(contentMode: .fit)
                                
                                
                            }.buttonStyle(PlainButtonStyle())
                                .background(Color.clear).foregroundColor(.black)
                                .padding(.trailing).offset(y: (UIScreen.main.bounds.height )/2.7)
                                .animation( Animation.easeInOut(duration: 1) .delay(1))
                            
                            
                            
                        }
                        
                        
                        
                    }
                    .background(Color.black.opacity(0.06)).edgesIgnoringSafeArea(.top)
  
                        .onAppear() {
                            self.pulsate.toggle()
                    }
                }
                
                
                
            }
                // default frame...
                .frame(height: 460)
            //                            .clipShape(CustomShape(corner: .bottomLeft, radii: 30))
            //                            .background(Color.black.opacity(0.5).edgesIgnoringSafeArea(.top)
            Group {
                
                VStack(alignment: .leading,spacing: 15){
                    
                    
                    if(!self.isVoted){
                        
                        
                        VStack(alignment: .center, spacing: 0) {
                            HStack(spacing: 15){
                                Spacer()
                                Text(RATING_TEXT)
                                    //                                            .font(.system(size: 20, weight: .bold))
                                    .font(.custom(FONT, size: CGFloat(BUTTON_TITLE_FONT_SIZE)))
                                    
                                    .foregroundColor(APP_THEME_COLOR)
                                
                                
                                ForEach(1...5,id: \ .self){_ in
                                    
                                    Image(systemName: "star.fill")
                                        .foregroundColor(.yellow)
                                }
                                Spacer()
                                
                            }.padding(.bottom, 20)
                                            .overlay(
                                                  HStack {
                                                      Spacer()
                                                      VStack {
                                                          Button(action: {
                                                              // ACTION
                                                              self.presentationMode.wrappedValue.dismiss()
                                                          }, label: {
                                                              Image(systemName: "xmark.circle.fill")
                                                                  .font(.title)
                                                                  .foregroundColor(Color.white)
                                                                  .shadow(radius: 8)
                                                                  .opacity( 1 )
                                                                  .scaleEffect( 1.4, anchor: .center)
                                                                  .animation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true))
                                                          })
                                                              .padding(.trailing, 20)
                            //                                  .padding(.top, 10)
                                                          Spacer()
                                                      }
                                                  }
                                              )
                            
                            // Info
                            RatingDetailView()
                        }
                        
                        VStack(spacing: 6){
                            HStack(spacing : 6){
                                AttrButtonView(isPressed: self.$buttonPressed[0],  title:user.attrNames[0])
                                AttrButtonView(isPressed: self.$buttonPressed[1], title:user.attrNames[1])
                                AttrButtonView(isPressed: self.$buttonPressed[2], title:user.attrNames[2])
                                
                                
                            }.padding(.horizontal, 5)
                            HStack(spacing : 6){
                                AttrButtonView(isPressed: self.$buttonPressed[3], title:user.attrNames[3])
                                AttrButtonView(isPressed: self.$buttonPressed[4], title:user.attrNames[4])
                                Spacer()
                                
                            }.padding(.horizontal, 20)
                            
                            
                            Button(action:  {
                                self.persist()
                                withAnimation{
                                    self.isVoted.toggle()
                                    
                                }
                                
                            }) {
                                Text(VOTE_SUBMIT_BUTTON.uppercased())
                                    //                                             .font(.system(.subheadline, design: .rounded))
                                    .font(.custom(FONT, size: CGFloat(BUTTON_TITLE_FONT_SIZE)))
                                    
                                    .fontWeight(.heavy)
                                    .padding(.horizontal, 50)
                                    .padding(.vertical, 10).foregroundColor( Color("Color5"))
                                    .background(
                                        Capsule().stroke( Color("Color5"), lineWidth: 2)
                                )
                            }   // Disabling button by verifying all images...
                                .opacity(self.checkAttrSelected() ? 1 : 0.35)
                                .disabled(self.checkAttrSelected() ? false : true).padding(.top, 10)
                            Spacer()
                        }
                        
                    }else{
                        VStack(spacing: 6){
                            if !self.voteData.isEmpty {
                                Spacer()
                                VStack(spacing: 10){
                                    
                                    Text(self.user.username + USER_RESULT.uppercased()).font(.custom(FONT, size: CGFloat(BUTTON_TITLE_FONT_SIZE))).padding().foregroundColor(Color("Color2"))
                                    
                                    
//                                    self.fireworkController.addFireworks(around: ChartView as UIView)

                                    ChartView(data: self.$voteData, totalNum: CHART_Y_AXIS, categories: self.user.attrNames).frame(width: UIScreen.main.bounds.width, height: (UIScreen.main.bounds.height) / 2.4)
                                       
                                }                                .overlay(
                                                      HStack {
                                                          Spacer()
                                                          VStack {
                                                              Button(action: {
                                                                  // ACTION
                                                                  self.presentationMode.wrappedValue.dismiss()
                                                              }, label: {
                                                                  Image(systemName: "xmark.circle.fill")
                                                                      .font(.title)
                                                                      .foregroundColor(Color.white)
                                                                      .shadow(radius: 8)
                                                                      .opacity( 1 )
                                                                      .scaleEffect( 1.4, anchor: .center)
                                                                      .animation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true))
                                                              })
                                                                  .padding(.trailing, 20)
                                //                                  .padding(.top, 10)
                                                              Spacer()
                                                          }
                                                      }
                                                  )
                                
                                
                                Spacer()
                            } else {
                                LoadingView(isLoading: self.chartViewModel.isLoading, error: self.chartViewModel.error) {
                                    self.loadChartData()
                                }
                            }
                        }  .onAppear{
                            self.loadChartData()
                        }
                        .cornerRadius(20)
                        .offset(y: -50)
                        
                        
                        
                    }
                    
                    
                }
                .padding(.top, 35)
                .background(Color.white)
                .cornerRadius(20)
                .offset(y: -80)

                
            }
            
            
            
        })
            .edgesIgnoringSafeArea(.all)
            .background(Color.white.edgesIgnoringSafeArea(.all))
            .onAppear{
                self.favoriteViewModel.checkLiked(id: self.user.id)
                
        }
        
    }
    
}


//struct ButtonView : View{
//    var body: some View{
//
//    }
//}


