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
    @EnvironmentObject  var obs : observer
    
    @State var totalNum : Int = 0
    @State var voteData:[Double] = []
    @State var voteNum:[Int] = []
    let numberIVoted = 30
    @State var buttonTitle : [String] = ["없음", "없음","없음", "없음", "없음"]
    @State var date : Double = 0
    @State var noVotePic : Bool = false
    @State var votePiclocation : String = ""
    //    @State var voteData = [Int.random(in: 0 ..< 100),Int.random(in: 0 ..< 100),Int.random(in: 0 ..< 100),Int.random(in: 0 ..< 100),Int.random(in: 0 ..< 100)]
    @State var selected = 0
    @State private var rotation = 0
    @State private var celsius: Double = 0
    @State var ymax : Int = 100
    @State var uploadMsg : String = NEW_UPLOAD2
    let haptics = UINotificationFeedbackGenerator()
    
    var colors = [[Color("Color"),Color("Color1")],
                  [Color("Color1"),Color("Color3")],
                  [Color("Color3"),Color("Color4")],
                  [Color("Color4"),Color("Color5")],
                  [Color("Color5"),Color("Color11")]]
    
    var empty_color = [Color("Color-2").opacity(0.2),Color("Color-2").opacity(0.2)]
    
    @State var showUploadView = false
    @State var buttonPressed = [false,false,false,false,false]
    
    var selectedButton = [String]()
    
    @ObservedObject var chartViewModel = ChartViewModel()
    func loadChartData(){
        self.chartViewModel.loadChartData(userId: User.currentUser()!.id) { (vote) in
            
            if vote.attrNames.count == 0 {
                self.noVotePic = true
                self.voteData = [0,0,0,0,0]
                self.totalNum = 0
                self.obs.updateVoteImage = false
                self.uploadMsg = NEW_UPLOAD2
                return
            }else{
                
                self.uploadMsg = NEW_UPLOAD
                
                self.obs.updateVoteImage = true
                self.voteData.removeAll()
                self.voteNum.removeAll()
                self.buttonTitle.removeAll()
                if(vote.numVote == 0){
                    self.voteData = [0,0,0,0,0]
                    self.totalNum = 0
                }else{
                    let attr1 = (Double(vote.attr1) / Double(vote.numVote) * 100).roundToDecimal(0)
                    let attr2 = (Double(vote.attr2) / Double(vote.numVote) * 100).roundToDecimal(0)
                    let attr3 = (Double(vote.attr3) / Double(vote.numVote) * 100).roundToDecimal(0)
                    let attr4 = (Double(vote.attr4) / Double(vote.numVote) * 100).roundToDecimal(0)
                    let attr5 = (Double(vote.attr5) / Double(vote.numVote) * 100).roundToDecimal(0)
                    
                    
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
                    }
                    
                    
                    self.voteData = [attr1, attr2, attr3, attr4, attr5]
                    //
                    //                    self.voteData.append((Double(vote.attr1) / Double(vote.numVote) * 100).roundToDecimal(0))
                    //                    self.voteData.append((Double(vote.attr2) / Double(vote.numVote) * 100).roundToDecimal(0))
                    //                    self.voteData.append((Double(vote.attr3) / Double(vote.numVote) * 100).roundToDecimal(0))
                    //                    self.voteData.append((Double(vote.attr4) / Double(vote.numVote) * 100).roundToDecimal(0))
                    //                    self.voteData.append((Double(vote.attr5) / Double(vote.numVote) * 100).roundToDecimal(0))
                }
                
                self.voteNum.append(vote.attr1)
                self.voteNum.append(vote.attr2)
                self.voteNum.append(vote.attr3)
                self.voteNum.append(vote.attr4)
                self.voteNum.append(vote.attr5)
                
                self.totalNum = vote.numVote
                //                self.totalNum = 100
                //                print(self.voteData)
                //                print( self.totalNum)
                self.date = vote.createdDate
                self.buttonTitle = vote.attrNames
                self.votePiclocation = vote.imageLocation
            }
            
            
            
        }
    }
    
    var body: some View {
        ZStack{
            ScrollView(.vertical, showsIndicators: false) {
                
                if !self.voteData.isEmpty && !self.noVotePic {
                    
                    VStack{
                        VStack(alignment: .leading, spacing: 15) {
                            Spacer()
                            
                            HStack(alignment: .top){
                                Spacer()
                                ZStack{
                                    AnimatedImage(url: URL(string: self.votePiclocation)!).resizable().frame(width: 80, height: 80).cornerRadius(40).padding(.trailing, 10)
                                        
                                        .onTapGesture {
                                            self.haptics.notificationOccurred(.success)
                                            
                                            self.showUploadView.toggle()
                                    }
                                    Circle().stroke(APP_THEME_COLOR, lineWidth: 5).frame(width: 85, height: 85).cornerRadius(40).padding(.trailing, 10)
                                    
                                    
                                }
                                
                                VStack(alignment: .leading, spacing: 10){
                                    
                                    Text(timeAgoSinceDate(Date(timeIntervalSince1970: self.date ), currentDate: Date(), numericDates: true) + "에 참여하였습니다.").font(Font.custom(FONT, size: 13)).multilineTextAlignment(.leading).lineLimit(2)
                                        .foregroundColor(.gray)
                                    Text(self.uploadMsg).font(Font.custom(FONT, size: 12)).multilineTextAlignment(.leading).lineLimit(2)
                                        .foregroundColor(.gray)
                                    if(self.totalNum == 0){
                                        Text(NO_DATA).font(Font.custom(FONT, size: 12)).multilineTextAlignment(.leading).lineLimit(2)
                                            .foregroundColor(.gray)
                                    }else{
                                        Spacer(minLength: 0)
                                    }
                                    
                                }.padding(.top, 15)
                                
                                Spacer()
                                
                            }
                            .padding(.horizontal, 5)
                        }
                        .background(Color.white.edgesIgnoringSafeArea(.top))
                        .cornerRadius(10)
                        .padding(.horizontal, 5)
                        //                            .frame(height:  UIScreen.main.bounds.height/3)
                        //
                        
                        HStack(spacing: 5){
                            
                            
                            ZStack{
                                VStack{
                                    
                                    ZStack{
                                        //                                        LoadingView2(filename: "heart")
                                        LottieView(filename: "heart")
                                            .frame(width: 80, height: 100)
                                    }
                                    
                                }
                                
                                
                                
                            }
                            .padding().padding(.top, -20)
                            
                            
                            
                            
                            ForEach(Array(self.voteData.enumerated()), id: \.offset) { index, work in
                                
                                VStack{
                                    
                                    
                                    if(work == 0){
                                        VStack{
                                            
                                            Spacer(minLength: 0)
                                            
                                            
                                            RoundedShape()
                                                .fill(LinearGradient(gradient: .init(colors:  self.empty_color), startPoint: .top, endPoint: .bottom))
                                                // max height = 200
                                                .frame(height:  150 ).animation(.linear)
                                        }
                                        .frame(height: UIScreen.main.bounds.width / 2.55).padding(.bottom, 10).padding(.horizontal, 2)
                                    }else{
                                        VStack{
                                            
                                            Spacer(minLength: 0)
                                            
                                            
                                            RoundedShape()
                                                .fill(LinearGradient(gradient: .init(colors:  self.colors[index]), startPoint: .top, endPoint: .bottom))
                                                // max height = 200
                                                .frame(height:  self.getHeight(value: CGFloat(work))).animation(.linear)
                                        }
                                        .frame(height: UIScreen.main.bounds.width / 2.55).padding(.bottom, 10).padding(.horizontal, 2)
                                    }
                                    
                                    Spacer()
                                    Text(self.buttonTitle[index]).fontWeight(.heavy).font(Font.custom(FONT, size: 12)).foregroundColor(.gray).multilineTextAlignment(.leading).lineLimit(2)
                                    
                                }
                            }
                        }.padding(.horizontal,5)
                        
                        
                        HStack{
                            
                            Text(MY_STAT_RADAR).fontWeight(.heavy).font(Font.custom(FONT, size: 20)).foregroundColor(APP_THEME_COLOR)
                            Spacer(minLength: 0)
                        }
                        .padding()
                        VStack{
                            
                            if !self.voteData.isEmpty {
                                ZStack{
                                    
                                    //                                    LottieView(filename: "fireworks")
                                    ChartView(data: self.$voteData, totalNum: self.$ymax, categories: self.buttonTitle).frame(width: UIScreen.main.bounds.width , height: UIScreen.main.bounds.height/2.4)  .padding(.top, -20).background(Color.clear).padding(.bottom, 30)
                                        .rotationEffect(.degrees(Double(celsius)))
                                    
                                    
                                    LottieView(filename: "radar-motion").frame(width: 300  , height: 300).padding(.bottom, 30)
                                    
                                }
                                
                                
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
                                    Text("나의 투표 포인트").fontWeight(.heavy).font(Font.custom(FONT, size: 20)).foregroundColor(APP_THEME_COLOR)
                                    
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
                                    Text("내 인기율").fontWeight(.heavy).font(Font.custom(FONT, size: 20)).foregroundColor(APP_THEME_COLOR)
                                    
                                    Spacer(minLength: 0)
                                    ZStack{
                                        
                                        Circle()
                                            .trim(from: 0, to: 1)
                                            .stroke(Color("receivedVote").opacity(0.05), lineWidth: 10)
                                            .frame(width: (UIScreen.main.bounds.width - 140) / 2, height: (UIScreen.main.bounds.width - 140) / 2)
                                        
                                        Circle()
                                            .trim(from: 0, to: (CGFloat(self.totalNum % 100) / 100))
                                            .stroke(Color("receivedVote"), style: StrokeStyle(lineWidth: 10, lineCap: .round))
                                            .frame(width: (UIScreen.main.bounds.width - 140) / 2, height: (UIScreen.main.bounds.width - 140) / 2)
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
                        .padding()                        .padding(.horizontal, 10)
                        .background(Color.white.opacity(0.06))
                        .cornerRadius(15)
                        .shadow(color: Color.white.opacity(0.2), radius: 10, x: 0, y: 0)
                        
                    }
                }else{
                    VStack(alignment: .leading, spacing: 15) {
                        Spacer()
                        
                        HStack(alignment: .top){
                            Spacer()
                            
                            AnimatedImage(url: URL(string: User.currentUser()!.profileImageUrl)).resizable().frame(width: 80, height: 80).cornerRadius(40).padding(.trailing, 10).onTapGesture {
                                self.showUploadView.toggle()
                            }
                            VStack(alignment: .leading, spacing: 15){
                                
                                Text(self.uploadMsg).font(Font.custom(FONT, size: 14.5)).multilineTextAlignment(.leading).lineLimit(2)
                                    .foregroundColor(Color("sleep"))
                                Spacer(minLength: 0)
                                
                            }.padding(.top, 15)
                            
                            Spacer()
                            
                        }
                        .padding(.horizontal, 5)
                    }
                    .background(Color.white.edgesIgnoringSafeArea(.top))
                    .cornerRadius(10)
                    .padding(.horizontal, 5)
                    
                    HStack(spacing: 5){
                        
                        
                        ZStack{
                            VStack{
                                
                                ZStack{
                                    //                                        LoadingView2(filename: "heart")
                                    LottieView(filename: "heart")
                                        .frame(width: 80, height: 100)
                                }
                                
                            }
                            
                            
                            
                        }
                        .padding().padding(.top, -20)
                        
                        
                        
                        
                        ForEach(Array(self.voteData.enumerated()), id: \.offset) { index, work in
                            
                            VStack{
                                
                                
                                if(work == 0){
                                    VStack{
                                        
                                        Spacer(minLength: 0)
                                        
                                        
                                        RoundedShape()
                                            .fill(LinearGradient(gradient: .init(colors:  self.empty_color), startPoint: .top, endPoint: .bottom))
                                            // max height = 200
                                            .frame(height:  150 ).animation(.linear)
                                    }
                                    .frame(height: UIScreen.main.bounds.width / 2.55).padding(.bottom, 10).padding(.horizontal, 2)
                                }else{
                                    VStack{
                                        
                                        Spacer(minLength: 0)
                                        
                                        
                                        RoundedShape()
                                            .fill(LinearGradient(gradient: .init(colors:  self.colors[index]), startPoint: .top, endPoint: .bottom))
                                            // max height = 200
                                            .frame(height:  self.getHeight(value: CGFloat(work))).animation(.linear)
                                    }
                                    .frame(height: UIScreen.main.bounds.width / 2.55).padding(.bottom, 10).padding(.horizontal, 2)
                                }
                                
                                Spacer()
                                Text(self.buttonTitle[index]).fontWeight(.heavy).font(Font.custom(FONT, size: 12)).foregroundColor(.gray).multilineTextAlignment(.leading).lineLimit(2)
                                
                            }
                        }
                    }.padding(.horizontal,5)
                    
                    
                    HStack{
                        
                        Text(MY_STAT_RADAR).fontWeight(.heavy).font(Font.custom(FONT, size: 20)).foregroundColor(APP_THEME_COLOR)
                        Spacer(minLength: 0)
                    }
                    .padding()
                    VStack{
                        
                        if !self.voteData.isEmpty {
                            ZStack{
                                
                                //                                    LottieView(filename: "fireworks")
                                ChartView(data: self.$voteData, totalNum: self.$ymax, categories: self.buttonTitle).frame(width: UIScreen.main.bounds.width , height: UIScreen.main.bounds.height/2.4)  .padding(.top, -20).background(Color.clear).padding(.bottom, 30)
                                    .rotationEffect(.degrees(Double(celsius)))
                                
                                
                                LottieView(filename: "radar-motion").frame(width: 300  , height: 300).padding(.bottom, 30)
                                
                            }
                            
                            
                        }
                        else {
                            LoadingView(isLoading: self.chartViewModel.isLoading, error: self.chartViewModel.error) {
                                self.loadChartData()
                            }
                        }
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
