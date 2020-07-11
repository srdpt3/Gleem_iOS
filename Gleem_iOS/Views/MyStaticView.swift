//
//  MyStaticView.swift
//  Gleem_Dating
//
//  Created by Dustin yang on 7/3/20.
//  Copyright © 2020 Dustin yang. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct MyStaticView: View {
    //    var user : User
    
    @State var totalNum : Int = 0
    @State var voteData:[Double] = []
    @State var voteNum:[Int] = []
    let numberIVoted = 10
    //    @State var voteData = [Int.random(in: 0 ..< 100),Int.random(in: 0 ..< 100),Int.random(in: 0 ..< 100),Int.random(in: 0 ..< 100),Int.random(in: 0 ..< 100)]
    @State var selected = 0
    var colors = [[Color("Color"),Color("Color1")],
                  [Color("Color1"),Color("Color3")],
                  [Color("Color3"),Color("Color4")],
                  [Color("Color4"),Color("Color5")],
                  [Color("Color5"),Color("Color11")]]
    
    
    
    @State var showUploadView = false
    @State var buttonPressed = [false,false,false,false,false]
    let  buttonTitle = ["개같이 생김","잘생김","섹시함","스마트함","머리스타일 잘어울림"]
    var selectedButton = [String]()
    
    @ObservedObject var chartViewModel = ChartViewModel()
    func loadChartData(){
        self.chartViewModel.loadChartData(userId: User.currentUser()!.id) { (vote) in
            
            self.voteData.removeAll()
            self.voteNum.removeAll()
            
            if(vote.numVote == 0){
                self.voteData = [10,10,10,10,10]
            }else{
                self.voteData.append((Double(vote.attr1) / Double(vote.numVote) * 100).roundToDecimal(0))
                self.voteData.append((Double(vote.attr2) / Double(vote.numVote) * 100).roundToDecimal(0))
                self.voteData.append((Double(vote.attr3) / Double(vote.numVote) * 100).roundToDecimal(0))
                self.voteData.append((Double(vote.attr4) / Double(vote.numVote) * 100).roundToDecimal(0))
                self.voteData.append((Double(vote.attr5) / Double(vote.numVote) * 100).roundToDecimal(0))
            }
            
            
            
            self.voteNum.append(vote.attr1)
            self.voteNum.append(vote.attr2)
            self.voteNum.append(vote.attr3)
            self.voteNum.append(vote.attr4)
            self.voteNum.append(vote.attr5)
            
            
            self.totalNum = 100
            print(self.voteData)
            print( self.totalNum)
            
        }
    }
    
    var body: some View {
        ZStack{
            ScrollView(.vertical, showsIndicators: false) {
                if !self.voteData.isEmpty {
                    
                    VStack{
                        VStack(alignment: .leading, spacing: 15) {
                            Spacer()
                            
                            HStack{
                                
                                AnimatedImage(url: URL(string: User.currentUser()!.profileImageUrl)!).resizable().frame(width: 70, height: 70).cornerRadius(35).padding(.trailing, 10).onTapGesture {
                                    self.showUploadView.toggle()
                                }
                                
                                Text("2020/07/02 4:14AM 에 참여하였습니다.")
                                    .font(.system(size: 12))
                                    .fontWeight(.bold)
                                    .foregroundColor(.gray)
                                Spacer()
                                
                            }
                           .padding(.horizontal, 5)
                        }
                        .background(Color.black.opacity(0.06).edgesIgnoringSafeArea(.top))
                        .cornerRadius(10)
                        .padding(.horizontal, 5)
                        //                            .frame(height:  UIScreen.main.bounds.height/3)
                        //
                        
                        HStack(spacing: 5){
                            HStack{
                                
                                Text("테스트")
                                    .font(.system(size: 18))
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                                
                                
                            }
                            .padding().padding(.top, -20)
                            
                            ForEach(Array(self.voteData.enumerated()), id: \.offset) { index, work in
                                
                                VStack{
                                    
                                    VStack{
                                        
                                        Spacer(minLength: 0)
                                        //
                                        //
                                        //                                            Text(String(self.voteNum[index]))
                                        //                                                .foregroundColor(Color("Color"))
                                        //                                                .font(.system(size: 12))
                                        //                                                                        .fontWeight(.bold)
                                        //                                                .padding(.bottom,5).padding(.horizontal, 5)
                                        
                                        RoundedShape()
                                            .fill(LinearGradient(gradient: .init(colors:  self.colors[index]), startPoint: .top, endPoint: .bottom))
                                            // max height = 200
                                            .frame(height:  self.getHeight(value: CGFloat(work))).animation(.linear)
                                    }
                                    .frame(height: UIScreen.main.bounds.width / 2.55).padding(.bottom, 10).padding(.horizontal, 2)
                                    //                                    .onTapGesture {
                                    //                                        self.selected = work.id
                                    //
                                    ////                                        withAnimation(.easeOut){
                                    ////
                                    ////                                            self.selected = work.id
                                    ////                                        }
                                    //                                    }
                                    Spacer()
                                    Text(self.buttonTitle[index])
                                        .font(.caption)
                                        .foregroundColor(.black).lineLimit(2)
                                }
                            }
                        }.padding(.horizontal,5)
//                            .background(Color.black.opacity(0.06).edgesIgnoringSafeArea(.bottom))
                        
                        
                        HStack{
                            Text("나의 그래프")
                                .font(.system(size: 18))
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                            
                            Spacer(minLength: 0)
                        }
                        .padding()
                        VStack{
                            if !self.voteData.isEmpty {
                                ChartView(data: self.$voteData, totalNum: self.totalNum, categories: self.buttonTitle).frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/2.3)  .padding(.top, -20).background(Color.clear).padding(.bottom, 30)
                                
                                
                                
                                
                            }
                            else {
                                LoadingView(isLoading: self.chartViewModel.isLoading, error: self.chartViewModel.error) {
                                    self.loadChartData()
                                }
                            }
                        }
                        
                        VStack(spacing: 32){
                            
                            
                            
                            HStack{
                                VStack(spacing: 15){
                                    Text("나의 투표 포인트")
                                        .font(.system(size: 18))
                                        .fontWeight(.bold)
                                        .foregroundColor(.black)
                                    
                                    Spacer(minLength: 0)
                                    ZStack{
                                        
                                        Circle()
                                            .trim(from: 0, to: 1)
                                            .stroke(Color("myvote").opacity(0.05), lineWidth: 10)
                                            .frame(width: (UIScreen.main.bounds.width - 150) / 2, height: (UIScreen.main.bounds.width - 150) / 2)
                                        
                                        Circle()
                                            .trim(from: 0, to: (CGFloat(self.numberIVoted % 20) / 100))
                                            .stroke(Color("myvote"), style: StrokeStyle(lineWidth: 10, lineCap: .round))
                                            .frame(width: (UIScreen.main.bounds.width - 150) / 2, height: (UIScreen.main.bounds.width - 150) / 2)
                                            .animation(.spring())
                                        
                                        Text(String(describing: CGFloat(self.numberIVoted % 20)) + "%")
                                            .font(.system(size: 22))
                                            .fontWeight(.bold)
                                            .foregroundColor(Color("myvote"))
                                            .rotationEffect(.init(degrees: 90))
                                        
                                    }
                                    .rotationEffect(.init(degrees: -90))
                                    .animation(.spring())
                                    
                                }
                                Spacer(minLength: 0)
                                VStack(spacing: 15){
                                    Text("내 인기율")
                                        .font(.system(size: 18))
                                        .fontWeight(.bold)
                                        .foregroundColor(.black)
                                    
                                    Spacer(minLength: 0)
                                    ZStack{
                                        
                                        Circle()
                                            .trim(from: 0, to: 1)
                                            .stroke(Color("receivedVote").opacity(0.05), lineWidth: 10)
                                            .frame(width: (UIScreen.main.bounds.width - 150) / 2, height: (UIScreen.main.bounds.width - 150) / 2)
                                        
                                        Circle()
                                            .trim(from: 0, to: (CGFloat(self.totalNum % 100) / 100))
                                            .stroke(Color("receivedVote"), style: StrokeStyle(lineWidth: 10, lineCap: .round))
                                            .frame(width: (UIScreen.main.bounds.width - 150) / 2, height: (UIScreen.main.bounds.width - 150) / 2)
                                            .animation(.spring())
                                        Text(String(describing: CGFloat(self.totalNum % 100)) + "%")
                                            .font(.system(size: 22))
                                            .fontWeight(.bold)
                                            .foregroundColor(Color("receivedVote"))
                                            .rotationEffect(.init(degrees: 90))
                                        
                                    }
                                    .rotationEffect(.init(degrees: -90))
                                    .animation(.spring())
                                    
                                }
                                
                            }
                            
                        }
                        .padding()
                        .background(Color.white.opacity(0.06))
                        .cornerRadius(15)
                        .shadow(color: Color.white.opacity(0.2), radius: 10, x: 0, y: 0)
                        
                    }
                }
                
                
            }
            .background(Color.white.edgesIgnoringSafeArea(.top))
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .padding(.bottom, UIApplication.shared.windows.first?.safeAreaInsets.bottom == 0 ? 5 : 0).onAppear{
                
                print(UIScreen.main.bounds.width)
                print(UIScreen.main.bounds.height)
                self.loadChartData()
            }
                
            .sheet(isPresented: self.$showUploadView) {
                UploadView()
                
                
                
            }
            
            
            
        }
        
        
    }
    //    func getType(val: String)->String{
    //
    //        switch val {
    //        case "Water": return "L"
    //        case "Sleep": return "Hrs"
    //        case "Running": return "Km"
    //        case "Cycling": return "Km"
    //        case "Steps": return "stp"
    //        default: return "Kcal"
    //        }
    //    }
    //
    // converting Number to decimal...
    
    func getDec(val: CGFloat)->String{
        
        let format = NumberFormatter()
        format.numberStyle = .decimal
        
        return format.string(from: NSNumber.init(value: Float(val)))!
    }
    
    // calculating percent...
    
    func getPercent(current : CGFloat,Goal : CGFloat)->String{
        
        let per = (current / Goal) * 10
        
        return String(format: "%.1f", per)
    }
    
    // calculating Hrs For Height...
    
    func getHeight(value : CGFloat)->CGFloat{
        
        // the value in minutes....
        // 24 hrs in min = 1440
        
        let hrs = CGFloat(value ) * 1.5
        
        return hrs
    }
    
    // getting hrs...
    
    func getPercentage(value: CGFloat)->String{
        
        let hrs = value / 60
        
        return String(format: "%.1f", hrs)
    }
}

struct RoundedShape : Shape {
    
    func path(in rect: CGRect) -> Path {
        
        
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topLeft,.topRight], cornerRadii: CGSize(width: 5, height: 5))
        
        return Path(path.cgPath)
    }
}


extension Color {
    public init(hex: Int) {
        self.init(UIColor(hex: hex))
    }
}



extension UIColor {
    convenience init(hex: Int) {
        let components = (
            R: CGFloat((hex >> 16) & 0xff) / 255,
            G: CGFloat((hex >> 08) & 0xff) / 255,
            B: CGFloat((hex >> 00) & 0xff) / 255
        )
        self.init(red: components.R, green: components.G, blue: components.B, alpha: 1)
    }
}
