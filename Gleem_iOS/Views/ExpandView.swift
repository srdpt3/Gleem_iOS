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
    
    var user : User
    @Binding var show : Bool
    @Binding var isVoted: Bool
    //    @State var voted: Bool = false
    @State var voteData:[Double] = []
    //    @State var voteData = [Int.random(in: 0 ..< 100),Int.random(in: 0 ..< 100),Int.random(in: 0 ..< 100),Int.random(in: 0 ..< 100),Int.random(in: 0 ..< 100)]
    
    @State var buttonPressed = [false,false,false,false,false]
    let  buttonTitle = ["개같이 생김","잘생김","섹시함","스마트함","머리스타일 잘어울림"]
    var selectedButton = [String]()
    
    @ObservedObject private var voteViewModel = VoteViewModel()
    @ObservedObject private var chartViewModel = ChartViewModel()
    @ObservedObject  private var favoriteViewModel = FavoriteViewModel()
    
    //    @State var buttonSelected: Bool = false
    
    
    func persist() {
        //                                     self.topRatedState.loadMovies(with: .topRated)
        self.voteViewModel.persist(id: user.id, buttonPressed: self.buttonPressed, buttonTitle:self.buttonTitle)
        self.loadChartData()
    }
    
    func loadChartData(){
        self.chartViewModel.loadChartData(userId: user.id) { (vote) in
            
            self.voteData.removeAll()
            
            
            self.voteData.append((Double(vote.attr1) / Double(vote.numVote) * 100).roundToDecimal(0))
            self.voteData.append((Double(vote.attr2) / Double(vote.numVote) * 100).roundToDecimal(0))
            self.voteData.append((Double(vote.attr3) / Double(vote.numVote) * 100).roundToDecimal(0))
            self.voteData.append((Double(vote.attr4) / Double(vote.numVote) * 100).roundToDecimal(0))
            self.voteData.append((Double(vote.attr5) / Double(vote.numVote) * 100).roundToDecimal(0))
            //            self.totalNum = vote.numVote
            
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
        for (index, button) in buttonPressed.enumerated() {
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
                
                if reader.frame(in: .global).minY > -480 {
                    ZStack(alignment: .topTrailing) {
                        AnimatedImage(url: URL(string: self.user.profileImageUrl))
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            // moving View Up....
                            .offset(y: -reader.frame(in: .global).minY)
                            // going to add parallax effect....
                            .frame(width: UIScreen.main.bounds.width, height:  reader.frame(in: .global).minY > 0 ? reader.frame(in: .global).minY + 480 : 480)
                        
                        
                        Button(action: {
                            
                            withAnimation{
                                self.show.toggle()
                            }
                            
                        }) {
                            
                            Image(systemName: "xmark")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.black.opacity(0.08))
                                .clipShape(Circle())
                        }
                        .padding(.trailing).padding(.top, 50)
                        
                        if(self.isVoted){
                            
                            Button(action:self.addToMyList) {
                                
                                Image(self.favoriteViewModel.liked == true ? "heartred" : "heartwhite").resizable().frame(width: 50, height: 50).aspectRatio(contentMode: .fit)
                                //                        .renderingMode(.original)
                                //                        .padding()
                                
                                
                            }.buttonStyle(PlainButtonStyle())
                                .background(Color.clear).foregroundColor(.black)
                                .padding(.trailing).offset(y: (UIScreen.main.bounds.height )/2.7)
                                .animation( Animation.easeInOut(duration: 1) .delay(1))
                            
                            
                            
                        }
                        
                        
                        
                    }
//                    .clipShape(CustomShape(corner: .bottomLeft, radii: 30))
                    .background(Color.black.opacity(0.06)).edgesIgnoringSafeArea(.top)
                    
                }
                
                
                
            }
                // default frame...
                .frame(height: 460)
            //                            .clipShape(CustomShape(corner: .bottomLeft, radii: 30))
            //                            .background(Color.black.opacity(0.5).edgesIgnoringSafeArea(.top)
            VStack(alignment: .leading,spacing: 15){
                
                
                if(!self.isVoted){
                    
                    
                    HStack(spacing: 15){
                        Spacer()
                        Text("인기 상승")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(Color("Color2"))
                        
                        
                        ForEach(1...5,id: \ .self){_ in
                            
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                        }
                        Spacer()
                        
                    }.padding(.bottom, 20)
                    
                    VStack(spacing: 6){
                        HStack(spacing : 6){
                            AttrButtonView(isPressed: self.$buttonPressed[0],  title:buttonTitle[0])
                            //                        Spacer()
                            AttrButtonView(isPressed: self.$buttonPressed[1], title:buttonTitle[1])
                            AttrButtonView(isPressed: self.$buttonPressed[2], title:buttonTitle[2])
                            
                            
                        }.padding(.horizontal, 5)
                        HStack(spacing : 6){
                            AttrButtonView(isPressed: self.$buttonPressed[3], title:buttonTitle[3])
                            //                        Spacer()
                            AttrButtonView(isPressed: self.$buttonPressed[4], title:buttonTitle[4])
                            Spacer()
                            
                        }.padding(.horizontal, 20)
                        
                        
                        Button(action:  {
                            self.persist()
                            withAnimation{
                                //                                    self.voted.toggle()
                                self.isVoted.toggle()
                                
                            }
                            
                        }) {
                            Text("첫인상반영하고 결과보기".uppercased())
                                .font(.system(.subheadline, design: .rounded))
                                .fontWeight(.heavy)
                                .padding(.horizontal, 50)
                                .padding(.vertical, 10).foregroundColor( Color("Color5"))
                                .background(
                                    Capsule().stroke( Color("Color5"), lineWidth: 2)
                            )
                            //                                                            .animation(
                            //                                                              Animation.easeInOut(duration: 1)
                            //                                                                  .delay(1)
                            //                                                          )
                        }   // Disabling button by verifying all images...
                            .opacity(self.checkAttrSelected() ? 1 : 0.35)
                            .disabled(self.checkAttrSelected() ? false : true).padding(.top, 10)
                        Spacer()
                    } 
                    
                }else{
                    VStack(spacing: 6){
                        if !self.voteData.isEmpty {
                            
                            ChartView(data: self.$voteData, totalNum: CHART_Y_AXIS, categories: self.buttonTitle).frame(width: UIScreen.main.bounds.width - 10, height: (UIScreen.main.bounds.height) / 1.9)
                            
                            
                        } else {
                            LoadingView(isLoading: self.chartViewModel.isLoading, error: self.chartViewModel.error) {
                                self.loadChartData()
                            }
                        }
                    }  .onAppear{
                        self.loadChartData()
                        
                    }           //                Spacer()
                        .cornerRadius(20)
                        .offset(y: -35)
                    
                    
                    
                }
                
                
            }
            .padding(.top, 35)
                //            .padding(.horizontal)
                .background(Color.white)
                .cornerRadius(20)
                .offset(y: -20)
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


