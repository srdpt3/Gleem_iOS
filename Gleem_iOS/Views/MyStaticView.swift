
import SwiftUI
import SDWebImageSwiftUI

struct MyStaticView: View , Equatable {
    static func == (lhs: MyStaticView, rhs: MyStaticView) -> Bool {
        return true
    }
    
    //    var user : User
    @EnvironmentObject  var obs : observer
    
    @ObservedObject private var chartViewModel = ChartViewModel()
    //    @ObservedObject private var VoteViewModel = VoteViewModel()
    
    @State var vote : Vote?
    let radar_graph_ratio =  UIScreen.main.bounds.height < 896.0 ? 2.73 : 2.62
    let bar_graph_ratio =  UIScreen.main.bounds.height < 896.0 ? 4.0 : 3.95
    
    @State var totalNum : Int = 0
    @State var voteData:[Double] = [0,0,0,0,0]
    @State var numVoteData:[Int] = [0,0,0,0,0]
    
    @State var voteBarData:[Double] = [0,0,0,0,0]
    
    let numberIVoted = 30
    @State var buttonTitle : [String] = ["없음", "없음","없음", "없음", "없음"]
    @State var date : Double = 0
    
    @State var votePiclocation : String = ""
    //    @State var voteData = [Int.random(in: 0 ..< 100),Int.random(in: 0 ..< 100),Int.random(in: 0 ..< 100),Int.random(in: 0 ..< 100),Int.random(in: 0 ..< 100)]
    @State var selected = 0
    @State private var rotation = 0
    @State private var celsius: Double = 0
    @State var ymax : Int = 100
    @State var uploadMsg : String = NEW_UPLOAD2
    @State var noVotePic : Bool = false
    @State var uploadComplete : Bool = false
    @State private var animatingModal: Bool = false
    
    let haptics = UINotificationFeedbackGenerator()
    
    var colors = [[Color("Color"),Color("Color1")],
                  [Color("Color1"),Color("Color3")],
                  [Color("Color3"),Color("Color4")],
                  [Color("Color4"),Color("Color5")],
                  [Color("Color5"),Color("Color11")]]
    
    var empty_color = [Color("Color-2").opacity(0.2),Color("Color-2").opacity(0.2)]
    
    
    @State var index : Int = 0
    
    @State var showView = false
    @State var buttonPressed = [false,false,false,false,false]
    
    var selectedButton = [String]()
    
    init(){
        //        self.loadChartData()
        if(Reachabilty.HasConnection()){
            self.chartViewModel.loadSomeoneVoted()
            
        }
    }
    
    
    func loadChartData(){
        
        self.chartViewModel.loadChartData(userId: User.currentUser()!.id) { (vote) in
            self.vote = vote
            if vote.attrNames.count == 0 {
                self.noVotePic = true
                self.voteData = [0,0,0,0,0]
                self.numVoteData = [0,0,0,0,0]
                
                self.voteBarData = [0,0,0,0,0]
                
                
                self.totalNum = 0
                self.obs.updateVoteImage = false
                self.uploadMsg = NEW_UPLOAD2
                return
            }else{
                
                self.uploadMsg = NEW_UPLOAD
                self.noVotePic = false
                self.obs.updateVoteImage = true
                self.voteData.removeAll()
                self.voteBarData.removeAll()
                self.buttonTitle.removeAll()
                if(vote.numVote == 0){
                    self.voteData = [0,0,0,0,0]
                    self.numVoteData = [0,0,0,0,0]
                    
                    self.voteBarData = [0,0,0,0,0]
                    
                    self.totalNum = 0
                }else{
                    let attr1 = (Double(vote.attr1) / Double(vote.numVote) * 100).roundToDecimal(0)
                    let attr2 = (Double(vote.attr2) / Double(vote.numVote) * 100).roundToDecimal(0)
                    let attr3 = (Double(vote.attr3) / Double(vote.numVote) * 100).roundToDecimal(0)
                    let attr4 = (Double(vote.attr4) / Double(vote.numVote) * 100).roundToDecimal(0)
                    let attr5 = (Double(vote.attr5) / Double(vote.numVote) * 100).roundToDecimal(0)
                    
                    self.voteData = [attr1, attr2, attr3, attr4, attr5]
                    self.numVoteData = [Int(vote.attr1), Int(vote.attr2) ,Int(vote.attr3), Int(vote.attr4), Int(vote.attr5)]
                    
                    let maxNum =  100 - (self.voteData.max()!)
                    print(maxNum)
                    self.voteBarData = [attr1 > 0.0 ? attr1 + maxNum : attr1 ,
                                        attr2 > 0.0 ? attr2 + maxNum : attr2 ,
                                        attr3 > 0.0 ? attr3 + maxNum : attr3 ,
                                        attr4 > 0.0 ? attr4 + maxNum : attr4 ,
                                        attr5 > 0.0 ? attr5 + maxNum : attr5]
                    
                    
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
                    
                    //                                        if(self.voteData.max()! < 98.0 ){
                    //                                            self.ymax = Int(self.voteData.max()!) + 2
                    //
                    //                                        }else{
                    //                                                                 self.ymax = Int(self.voteData.max()!)
                    //                                        }
                    
                }
                
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
        VStack{
            if self.obs.updateVoteImage && self.votePiclocation != "" {
                VStack(alignment: .leading, spacing: 5) {
                    HStack(alignment: .top, spacing: 10){
                        
                        ZStack(alignment: .bottomTrailing){
                            
                            
                            
                            AnimatedImage(url: URL(string: self.votePiclocation)!).resizable().frame(width: 80, height: 80).cornerRadius(40)
                                .background(Color("Color-2"))
                                
                                .onTapGesture {
                                    self.haptics.notificationOccurred(.success)
                                    self.uploadComplete = false
                                    
                                    self.showView.toggle()
                                    self.index = 0
                                    
                            }
                            .cornerRadius(50)
                            .shadow(color: Color.black.opacity(0.3), radius: 2, x: 2, y: 2)
                            //                                    Circle().stroke(APP_THEME_COLOR, lineWidth: 5).frame(width: 110, height: 110).cornerRadius(55).padding(.trailing, 10)
                            //                                    Spacer()
                            Image(systemName: "plus")
                                .resizable()
                                .frame(width: 10, height: 10)
                                .padding(6)
                                .background(Color("background2"))
                                .clipShape(Circle()).foregroundColor(Color.white)
                                .offset(x: 5)
                        }.padding(.trailing, 4)
                        
                        
                        
                        VStack(alignment: .leading, spacing: 5){
                            
                            Text(timeAgoSinceDate(Date(timeIntervalSince1970: self.date ), currentDate: Date(), numericDates: true) + "에 참여하였습니다.").font(Font.custom(FONT, size: 13)).multilineTextAlignment(.leading).lineLimit(2)
                                .foregroundColor(Color("Color11"))
                            Text(self.uploadMsg).font(Font.custom(FONT, size: 13)).multilineTextAlignment(.leading).lineLimit(2)
                                .foregroundColor(.gray)
                            if(self.totalNum == 0){
                                Text(NO_DATA).font(Font.custom(FONT, size: 12)).multilineTextAlignment(.leading).lineLimit(2)
                                    .foregroundColor(.gray)
                            }else{
                                Spacer(minLength: 0)
                            }
                            Spacer()
                        }.padding(.top, 15)
                        
                        Spacer()
                        Button(action: {
                            // ACTION
                            //        playSound(sound: "sound-click", type: "mp3")
                            self.haptics.notificationOccurred(.success)
                            self.showView.toggle()
                            self.index  = 1
                        }) {
                            Image("time-machine").resizable()
                                .frame(width: 30, height: 30)
                                .font(.system(size: 24, weight: .regular))
                        }.onTapGesture {
                        }.accentColor(APP_THEME_COLOR).buttonStyle(PlainButtonStyle()).padding(.trailing,10)
                    }
                    .padding(.leading, 10)
                    Spacer()
                    
                    
                }
                .background(Color.white.edgesIgnoringSafeArea(.top))
                .cornerRadius(10)
                .padding(.horizontal, 5)
                .frame(height: UIScreen.main.bounds.height / 8)
                .alert(isPresented: $uploadComplete) {
                    Alert(
                        title: Text(COMPLETE),
                        message: Text(UPLOAD_COMPLETE),
                        dismissButton: .default(Text(CONFIRM)))
                    
                    
                    
                }
                
                
                
                
                
            }
            else{
                
                VStack(alignment: .leading, spacing: 15) {
                    
                    HStack(alignment: .top){
                        ZStack(alignment: .bottomTrailing){
                            
                            ZStack{
                                LottieView(filename: "profile").frame(width: 80, height: 80)
                                    .clipShape(Circle()).zIndex(1)
                                    .onTapGesture {
                                        print("Tapped")
                                        self.showView.toggle()
                                        self.index  = 0
                                }
                                
                            }
                            Image(systemName: "plus")
                                .resizable()
                                .frame(width: 10, height: 10)
                                .padding(6)
                                .background(Color("background2"))
                                .clipShape(Circle()).foregroundColor(Color.white)
                                .offset(x: 5)
                        }.padding(.trailing, 4)
                        
                        
                        
                        if(!self.obs.updateVoteImage){
                            VStack(alignment: .leading, spacing: 15){
                                if(Reachabilty.HasConnection()){
                                    Text(self.uploadMsg).font(Font.custom(FONT, size: 14.5)).multilineTextAlignment(.leading).lineLimit(2)
                                        .foregroundColor(Color("sleep"))
                                    
                                }else{
                                    Text(NO_CONNECTION).font(Font.custom(FONT, size: 14.5)).multilineTextAlignment(.leading).lineLimit(2)
                                        .foregroundColor(Color("sleep"))
                                }
                                
                                Spacer(minLength: 0)
                                
                            }.padding(.top, 15)
                        }
                        
                        
                        
                        
                        Spacer()
                        
                    }
                    .padding(.leading, 10)
                    Spacer()
                }
                .background(Color.white.edgesIgnoringSafeArea(.top))
                .cornerRadius(10)
                .padding(.horizontal, 5)
                .frame(height: UIScreen.main.bounds.height / 8)
                
                
                
                
            }
            //            // GET  a List of users who voted me
            VStack{
                
                
                if !self.chartViewModel.someOneVoted.isEmpty {
                    VStack(alignment: .leading){
                        
                        Text(RECENT_VOTE).fontWeight(.heavy).font(Font.custom(FONT, size: 17)).foregroundColor(Color("Color11"))
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5).padding(.bottom, 5)
                        //                                    Spacer(minLength: 0)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack() {
                                
                                ForEach(self.chartViewModel.someOneVoted, id: \.activityId){ user in
                                    
                                    SomeoneVotedView(user: user)
                                        .animation(Animation.easeIn(duration: 1.5))
                                }
                                
                            }
                            .padding(.leading, 15)
                            
                            
                        }
                    }.padding(.top, -5)
                    
                    
                    
                }else{
                    VStack(alignment: .leading){
                        
                        Text(RECENT_VOTE).fontWeight(.heavy).font(Font.custom(FONT, size: 15)).foregroundColor(Color("Color11"))
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5).padding(.bottom, 5)
                        //                                    Spacer(minLength: 0)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack() {
                                Image("Gleem_3D").resizable().aspectRatio(contentMode: .fill).frame(width: 60, height: 60).cornerRadius(60 / 2).padding(.leading, -15)
                            }.padding(.leading, 15)
                            
                            
                        }
                    }
                    LoadingView(isLoading: self.chartViewModel.isLoading, error: self.chartViewModel.error) {
                        self.chartViewModel.loadSomeoneVoted()
                    }
                    
                }
                
                
            } .padding(.top,3).padding(.horizontal)
            Divider().padding(.horizontal, 15)
            
            ScrollView(.vertical, showsIndicators: true) {
                
                if self.obs.updateVoteImage && self.votePiclocation != "" {
                    //                    HStack{
                    ////
                    ////                        Text(MY_STAT_RADAR).fontWeight(.heavy).font(Font.custom(FONT, size: 15)).foregroundColor(Color("Color11"))
                    ////                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                    //
                    ////                        Spacer(minLength: 0)
                    //                    } .padding(.horizontal).padding(.top,5)
                    
                    
                    VStack(spacing: 5){
                        
                        if !self.voteData.isEmpty {
                            
                            ChartView_BAR(data: self.$voteData, numVote: self.$numVoteData, totalNum: self.$ymax, categories: self.buttonTitle).frame(width: UIScreen.main.bounds.width   , height: UIScreen.main.bounds.height/CGFloat(bar_graph_ratio))
                                .offset(y : -15)
                            
                            //                                    LottieView(filename: "fireworks")
                            ChartView(data: self.$voteData, totalNum: self.$ymax, categories: self.buttonTitle).frame(width: UIScreen.main.bounds.width - 5 , height: UIScreen.main.bounds.height/CGFloat(radar_graph_ratio)).background(Color.clear)
                                .offset(y: UIScreen.main.bounds.height < 896.0 ? -20 : -15)
                            
                            //                                    LottieView(filename: "radar-motion").frame(width: 300  , height: 300)
                            //                                        .padding(.bottom, 50)
                            
                            
                            
                            
                        }
                        //                            else {
                        //                                LoadingView(isLoading: self.chartViewModel.isLoading, error: self.chartViewModel.error) {
                        //                                    if(Reachabilty.HasConnection()){
                        //                                        self.loadChartData()
                        //
                        //                                    }
                        //
                        //
                        //                                }
                        //                            }
                    }
                    
                    //                    VStack(spacing: 32){
                    //
                    //
                    //                        HStack{
                    //                            VStack(spacing: 15){
                    //                                Text("나의 투표 포인트").fontWeight(.heavy).font(Font.custom(FONT, size: 20)).foregroundColor(APP_THEME_COLOR)
                    //
                    //                                Spacer(minLength: 0)
                    //                                ZStack{
                    //
                    //                                    Circle()
                    //                                        .trim(from: 0, to: 1)
                    //                                        .stroke(Color("myvote").opacity(0.05), lineWidth: 10)
                    //                                        .frame(width: (UIScreen.main.bounds.width - 150) / 2, height: (UIScreen.main.bounds.width - 150) / 2)
                    //
                    //                                    Circle()
                    //                                        .trim(from: 0, to: (CGFloat(self.numberIVoted % 20) / 100))
                    //                                        .stroke(Color("myvote"), style: StrokeStyle(lineWidth: 10, lineCap: .round))
                    //                                        .frame(width: (UIScreen.main.bounds.width - 150) / 2, height: (UIScreen.main.bounds.width - 150) / 2)
                    //                                        .animation(.spring())
                    //
                    //                                    Text(String(describing: CGFloat(self.numberIVoted % 20)) + "%")
                    //                                        .font(.system(size: 22))
                    //                                        .fontWeight(.bold)
                    //                                        .foregroundColor(Color("myvote"))
                    //                                        .rotationEffect(.init(degrees: 90))
                    //
                    //                                }
                    //                                .rotationEffect(.init(degrees: -90))
                    //                                .animation(.spring())
                    //
                    //                            }
                    //                            Spacer(minLength: 0)
                    //                            VStack(spacing: 15){
                    //                                Text("내 인기율").fontWeight(.heavy).font(Font.custom(FONT, size: 20)).foregroundColor(APP_THEME_COLOR)
                    //
                    //                                Spacer(minLength: 0)
                    //                                ZStack{
                    //
                    //                                    Circle()
                    //                                        .trim(from: 0, to: 1)
                    //                                        .stroke(Color("receivedVote").opacity(0.05), lineWidth: 10)
                    //                                        .frame(width: (UIScreen.main.bounds.width - 140) / 2, height: (UIScreen.main.bounds.width - 140) / 2)
                    //
                    //                                    Circle()
                    //                                        .trim(from: 0, to: (CGFloat(self.totalNum % 100) / 100))
                    //                                        .stroke(Color("receivedVote"), style: StrokeStyle(lineWidth: 10, lineCap: .round))
                    //                                        .frame(width: (UIScreen.main.bounds.width - 140) / 2, height: (UIScreen.main.bounds.width - 140) / 2)
                    //                                        .animation(.spring())
                    //                                    Text(String(describing: CGFloat(self.totalNum % 100)) + "%")
                    //                                        .font(.system(size: 22))
                    //                                        .fontWeight(.bold)
                    //                                        .foregroundColor(Color("receivedVote"))
                    //                                        .rotationEffect(.init(degrees: 90))
                    //
                    //                                }
                    //                                .rotationEffect(.init(degrees: -90))
                    //                                .animation(.spring())
                    //
                    //                            }
                    //
                    //                        }
                    //
                    //                    }
                    //                    .padding()                        .padding(.horizontal, 10)
                    //                    .background(Color.white.opacity(0.06))
                    //                    .cornerRadius(15)
                    //                    .shadow(color: Color.white.opacity(0.2), radius: 10, x: 0, y: 0)
                    
                }
                else{
                    
                    //                    HStack{
                    //
                    //                        Text(MY_STAT_RADAR).fontWeight(.heavy).font(Font.custom(FONT, size: 18)).foregroundColor(APP_THEME_COLOR)
                    //                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                    //
                    //                        //                            Text(" - " + VOTENUM_SOFAR +  String(self.totalNum)).fontWeight(.heavy).font(Font.custom(FONT, size: 17)).foregroundColor(APP_THEME_COLOR)
                    //                        //                                .shadow(color: Color.black.opacity(0.3), radius: 5, x: 5, y: 5)
                    //                        //                                .shadow(color: Color.white.opacity(0.5), radius: 5, x: -8, y: -8)
                    //                        Spacer(minLength: 0)
                    //                    } .padding(.horizontal).padding(.vertical,10)
                    //                        ChartView_BAR(data: self.$voteData, totalNum: self.$ymax, categories: self.buttonTitle).frame(width: UIScreen.main.bounds.width , height: UIScreen.main.bounds.height/3.4).background(Color.clear).padding(.bottom, 10)
                    //
                    //                    HStack(alignment: .top,spacing: 5){
                    //                        ForEach(Array(self.voteBarData.enumerated()), id: \.offset) { index, work in
                    //                            VStack{
                    //                                if(work == 0){
                    //                                    VStack{
                    //
                    //                                        Spacer(minLength: 0)
                    //
                    //
                    //                                        RoundedShape()
                    //                                            .fill(LinearGradient(gradient: .init(colors:  self.empty_color), startPoint: .top, endPoint: .bottom))
                    //                                            // max height = 200
                    //                                            .frame(height:  100 ).animation(.linear)
                    //                                        //                                                .shadow(color: Color.black.opacity(0.3), radius: 2, x: 2, y: 2)
                    //                                        //                                                .shadow(color: Color.white.opacity(0.5), radius: 5, x: -8, y: -8)
                    //                                    }
                    //                                    .frame(height: UIScreen.main.bounds.width / 3.5).padding(.bottom, 5).padding(.horizontal, 2)
                    //
                    //                                }
                    //
                    //                                Text(self.buttonTitle[index]).fontWeight(.heavy).font(Font.custom(FONT, size: 12)).foregroundColor(.gray).multilineTextAlignment(.leading).lineLimit(1)
                    //                                Spacer()
                    //                            }
                    //                        }
                    //                        Spacer()
                    //                    }.padding(.horizontal,5)
                    ChartView_BAR(data: self.$voteData, numVote: self.$numVoteData, totalNum: self.$ymax, categories: self.buttonTitle).frame(width: UIScreen.main.bounds.width   , height: UIScreen.main.bounds.height/3.9)
                        .offset(y : -15)
                    
                    //                                    LottieView(filename: "fireworks")
                    ChartView(data: self.$voteData, totalNum: self.$ymax, categories: self.buttonTitle).frame(width: UIScreen.main.bounds.width - 5 , height: UIScreen.main.bounds.height/CGFloat(radar_graph_ratio)).background(Color.clear)
                        .offset(y: 5) .padding(.top, -10)
                    
                    
                    
                    
                }
                
                
                
                
                
                VStack{
                    
                    BannerAdView(bannerId: BANNER_UNIT_ID).frame(height: 200)
                    
                    //
                }
                
                
            }
            .background(Color.white.edgesIgnoringSafeArea(.top))
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .padding(.bottom, UIApplication.shared.windows.first?.safeAreaInsets.bottom == 0 ? 5 : 0)  .onAppear{
                
                print(UIScreen.main.bounds.width)
                print(UIScreen.main.bounds.height)
                if(Reachabilty.HasConnection()){
                    self.loadChartData()
                    
                }
            }
                
                
            .sheet(isPresented: self.$showView) {
                if(self.index == 0) {
                    UploadView(vote: self.vote!, noVotePic: self.$noVotePic,uploadComplete: self.$uploadComplete).environmentObject(self.obs)
                    
                }else{
                    HistoryView()
                }
                
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
        
        let hrs = CGFloat(value ) * 1.0
        
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


struct SomeoneVotedView: View {
    var user: Activity
    var height: CGFloat = 60
    var body: some View {
        VStack {
            
            
            if(user.userAvatar == ""){
                Image("Gleem_3D").resizable().aspectRatio(contentMode: .fit).frame(width: height, height: height).cornerRadius(height / 2).padding(.leading, -15)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
            }else{
                AnimatedImage(url: URL(string:user.userAvatar)).resizable().aspectRatio(contentMode: .fill).frame(width: height, height: height).cornerRadius(height / 2).padding(.leading, -15)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5).animation(.spring())
                
            }
            
            
        }
        
    }
}
