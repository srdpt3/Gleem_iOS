//
//  CardListview.swift
//  Gleem_iOS
//
//  Created by Dustin yang on 7/14/20.
//  Copyright © 2020 Dustin yang. All rights reserved.
//
import SwiftUI
import SDWebImageSwiftUI
struct CardListview: View {
    @EnvironmentObject  var obs : observer
    @State var showAlert: Bool = false
    @State var showGuide: Bool = false
    @State var showInfo: Bool = false
    @GestureState private var dragState = DragState.inactive
    private var dragAreaThreshold: CGFloat = 65.0
    @State private var lastCardIndex: Int = 1
    @State private var cardRemovalTransition = AnyTransition.trailingBottom
    @State var showVotingScreen = false
    @State var isVoted = false
    //    @State var show = false
    @State var showProfile : Bool = false
    @State var viewState = CGSize.zero
    @State private var pulsate: Bool = false
    
    @State var reloading : Bool = false
    @State var selectedFlag = ""
    @State var showFlag = false
    @State var flagMessage = false
    @State var uploadComplete : Bool = false
    @State private var animatingModal: Bool = false
    let haptics = UINotificationFeedbackGenerator()
    
    //    @State var cardViews: [MainCardView] = {
    //        var views = [MainCardView]()
    //        for index in 0..<2 {
    //            views.append(MainCardView(user: obs.users[0]))
    //        }
    //        //      for index in 0..<2 {
    //        //      }
    //        return views
    //    }()
    
    // MARK: TOP CARD
    private func isTopCard(cardView: MainCardView) -> Bool {
        guard let index = self.obs.cardViews.firstIndex(where: { $0.id == cardView.id }) else {
            return false
        }
        return index == 0
    }
    
    
    enum DragState {
        case inactive
        case pressing
        case dragging(translation: CGSize)
        
        var translation: CGSize {
            switch self {
            case .inactive, .pressing:
                return .zero
            case .dragging(let translation):
                return translation
            }
        }
        
        var isDragging: Bool {
            switch self {
            case .dragging:
                return true
            case .pressing, .inactive:
                return false
            }
        }
        
        var isPressing: Bool {
            switch self {
            case .pressing, .dragging:
                return true
            case .inactive:
                return false
            }
        }
    }
    var body: some View{
        ZStack{
            VStack{
                
                //                Text(String(User.currentUser()!.username))
                HeaderView(showProfile: self.$showProfile, showInfoView: self.$showInfo)
                    .opacity(dragState.isDragging ? 0.0 : 1.0)
                    .animation(.default)
                
                //                Spacer()
                ZStack{
                    if(Reachabilty.HasConnection()){
                        
                        if(!self.obs.isVoteLoading){
                            if(!self.obs.cardViews.isEmpty){
                                ForEach(self.obs.cardViews) { cardView in
                                    cardView.zIndex(self.isTopCard(cardView: cardView) ? 1 : 0).onTapGesture {
                                        //                                self.showVotingScreen.toggle()
                                        if(self.obs.updateVoteImage){
                                            
                                            self.haptics.notificationOccurred(.success)
                                            
                                            //                self.fireworkController.addFirework(sparks: 10)
                                            withAnimation{
                                                self.showVotingScreen.toggle()
                                            }
                                        }
                                        
                                        
                                    }
                                        //                                .overlay(
                                        //                                    ZStack {
                                        //                                        // X-MARK SYMBOL
                                        //                                        //                              Image(systemName: "x.circle")
                                        //                                        //                                .modifier(SymbolModifier())
                                        //                                        //                                .opacity(self.dragState.translation.width < -self.dragAreaThreshold && self.isTopCard(cardView: cardView) ? 1.0 : 0.0)
                                        //                                        //
                                        //                                        // HEART SYMBOL
                                        //
                                        //                                        if(self.isVoted){
                                        //                                            Image(systemName: "heart.circle")
                                        //                                                .modifier(SymbolModifier())
                                        //                                                .opacity(self.dragState.translation.width > self.dragAreaThreshold && self.isTopCard(cardView: cardView) ? 1.0 : 0.0)
                                        //                                        }else{
                                        //                                            Text("사진 첫인상 투표를 \n먼저해주세요 ㅠㅠ").foregroundColor(Color.white)
                                        //                                                .font(.custom(FONT, size: CGFloat(25)))
                                        //                                                .opacity(self.dragState.translation.width > self.dragAreaThreshold && self.isTopCard(cardView: cardView) ? 1.0 : 0.0)
                                        //                                        }
                                        //
                                        //                                    }
                                        //                            )
                                        .offset(x: self.isTopCard(cardView: cardView) ?  self.dragState.translation.width : 0, y: self.isTopCard(cardView: cardView) ?  self.dragState.translation.height : 0)
                                        .scaleEffect(self.dragState.isDragging && self.isTopCard(cardView: cardView) ? 0.85 : 1.0)
                                        .rotationEffect(Angle(degrees: self.isTopCard(cardView: cardView) ? Double(self.dragState.translation.width / 12) : 0))
                                        .animation(Animation.spring(response: 0.7, dampingFraction: 1.0, blendDuration: 1.0))
                                    //                                .animation(.interpolatingSpring(stiffness: 150, damping: 130))
                                    //                              .animation(Animation.spring(response: 0.6, dampingFraction: 1.0, blendDuration: 1.0))
                                    //                                .animation(.easeInOut(duration: 3))
                                    
                                    //                                .gesture(LongPressGesture(minimumDuration: 0.01)
                                    //                                    .sequenced(before: DragGesture())
                                    //                                    .updating(self.$dragState, body: { (value, state, transaction) in
                                    //                                        switch value {
                                    //                                        case .first(true):
                                    //                                            state = .pressing
                                    //                                        case .second(true, let drag):
                                    //                                            state = .dragging(translation: drag?.translation ?? .zero)
                                    //                                        default:
                                    //                                            break
                                    //                                        }
                                    //                                    })
                                    //                                    .onChanged({ (value) in
                                    //                                        guard case .second(true, let drag?) = value else {
                                    //                                            return
                                    //                                        }
                                    //
                                    //                                        if drag.translation.width < -self.dragAreaThreshold {
                                    //                                            self.cardRemovalTransition = .leadingBottom
                                    //                                        }
                                    //
                                    //                                        if drag.translation.width > self.dragAreaThreshold {
                                    //                                            self.cardRemovalTransition = .trailingBottom
                                    //                                        }
                                    //                                    })
                                    //                                    .onEnded({ (value) in
                                    //                                        guard case .second(true, let drag?) = value else {
                                    //                                            return
                                    //                                        }
                                    //                                        if drag.translation.width > self.dragAreaThreshold {
                                    //                                            //                                if drag.translation.width < -self.dragAreaThreshold || drag.translation.width > self.dragAreaThreshold {
                                    //                                            //                                playSound(sound: "sound-rise", type: "mp3")
                                    //                                            //                                self.moveCards()
                                    //                                            if(self.isVoted){
                                    //                                                self.obs.moveCards()
                                    //                                                self.isVoted = false
                                    //
                                    //
                                    //                                            }
                                    //                                        }
                                    //                                    })
                                    //                            )
                                }
                                .overlay(
                                    HStack {
                                        Spacer()
                                        VStack {
                                            Button(action: {
                                                // ACTION
                                                //                                            self.presentationMode.wrappedValue.dismiss()
                                                self.showFlag.toggle()
                                                
                                            }, label: {
                                                Image(systemName: "flag.circle.fill")
                                                    .font(.title)
                                                    .foregroundColor(Color.white)
                                                    .shadow(radius: 5)
                                                    //                                            .opacity(self.pulsate ? 1 : 0.6)
                                                    .scaleEffect(1.2, anchor: .center)
                                                //                                            .animation(Animation.easeOut(duration: 1.5).repeatForever(autoreverses: true))
                                            })
                                                .padding(.trailing, 10)
                                                .padding(.top, 24)
                                            
                                            Spacer()
                                        }
                                    }
                                )
                            }else{
                                
                                if(!self.obs.isReloading){
                                    VStack{
                                        Spacer()
                                        
                                        
                                        Image("Gleem_3D").resizable().scaledToFit().frame(width: UIScreen.main.bounds.width / 3 , height: UIScreen.main.bounds.height / 3)
                                            .scaleEffect(self.reloading ? 1.1 : 1, anchor: .center).onAppear{
                                                self.reloading.toggle()
                                        }
                                        .animation(Animation.spring(response: 0.7, dampingFraction: 1.0, blendDuration: 1.0).repeatForever(autoreverses: true)).onTapGesture {
                                            self.obs.getNewCards()
                                        }
                                        
                                        //                                    Button(action: {
                                        //
                                        //                                    }) {
                                        //
                                        //                                        Image("refresh").resizable().frame(width: 50, height: 50)
                                        //                                    }.buttonStyle(PlainButtonStyle())
                                        //
                                        //                                if(self.obs.users.isEmpty){
                                        //                                    Text(NO_NEW_CARD)
                                        //                                        .font(.custom(FONT, size: CGFloat(15))).foregroundColor(APP_THEME_COLOR).multilineTextAlignment(.center).lineLimit(2).padding(.horizontal)
                                        //                                }
                                        
                                        Spacer()
                                        //                                         LoadingView(isLoading: self.obs.isLoading, error: self.obs.error) {
                                        //                                             self.obs.getNewCards()
                                        //                                         }
                                        
                                    }.animation(.default).onAppear{
                                        //                                self.obs.getNewCards()
                                    }
                                }
                                
                                
                                
                                
                            }
                        }else{
                            VStack{
                                Spacer()
                                
                                Button(action: {
                                                        
                                                    }) {
                                                        
                                                        Image("refresh").resizable().frame(width: 50, height: 50)
                                                    }.buttonStyle(PlainButtonStyle())
                                Spacer()
                            }
                    
                            
                        }
                        
                        
                        
                        
                    }
                    else{
                        VStack{
                            Spacer()
                            
                            
                            Image("Gleem_3D").resizable().scaledToFit().frame(width: UIScreen.main.bounds.width / 3 , height: UIScreen.main.bounds.height / 3)
                                .scaleEffect(self.reloading ? 1.1 : 1, anchor: .center).onAppear{
                                    self.reloading.toggle()
                            }
                            .animation(Animation.spring(response: 0.7, dampingFraction: 1.0, blendDuration: 1.0).repeatForever(autoreverses: true))
                            Text(NO_CONNECTION).font(.custom(FONT, size: CGFloat(16))).foregroundColor(APP_THEME_COLOR).multilineTextAlignment(.center).lineLimit(2).padding(.horizontal)
                            
                            Spacer()
                            
                            
                        }.animation(.default).onAppear{
                            //                                self.obs.getNewCards()
                        }
                    }
                    
                    //                    else{
                    ////                        VStack {
                    ////                            Spacer()
                    ////                            EmptyView()
                    //                            LoadingView(isLoading: self.obs.isLoading, error: self.obs.error) {
                    //                                self.obs.getNewCards()
                    //                            }
                    ////                            .animation(Animation.spring(response: 0.6, dampingFraction: 1.0, blendDuration: 1.0))
                    //
                    ////                        Spacer()
                    ////                    }
                    //
                    //                }
                    
                    //                    ZStack{
                    //
                    //                        Spacer()
                    //
                    //                        RadioButtons(selected: self.$selectedFlag,show: self.$showFlag)
                    //                            .offset(y: self.showFlag ? (UIApplication.shared.windows.last?.safeAreaInsets.bottom)! + 15 : UIScreen.main.bounds.height)
                    //
                    //                        }.edgesIgnoringSafeArea(.all).zIndex(1)
                    //                    .background(Color(UIColor.label.withAlphaComponent(self.showFlag ? 0.2 : 0))
                    
                }.padding(.horizontal)
                    .sheet(isPresented: self.$showVotingScreen) {
                        ExpandView(user: self.obs.users[self.obs.last], updateVoteImage: self.obs.updateVoteImage, show: self.$showVotingScreen, isVoted:self.$isVoted)
                            .environmentObject(self.obs)
                        
                        //                        .animation(.spring(response: 0.5, dampingFraction: 0.7, blendDuration: 0))
                        
                        //                        shrinking the view in background...
                        //                    .scaleEffect(self.show ? 1 : 0)
                        //                    .frame(width: self.show ? nil : 0, height: self.show ? nil : 0)
                }
                Spacer()
                if(!self.obs.cardViews.isEmpty){
                    if(Reachabilty.HasConnection()){
                        FooterView(isVoted: $isVoted, showVotingScreen: $showVotingScreen, uploadComplete: self.$uploadComplete)
                            .opacity(dragState.isDragging ? 0.0 : 1.0)
                            //                        .animation(.easeInOut)
                            .animation(Animation.spring(response: 0.7, dampingFraction: 1.0, blendDuration: 1.0)).opacity(self.obs.isLoading == true ? 0 : 1)
                    }
                    
                    
                }
                
                Spacer()
                
                
            }.navigationBarHidden(true).navigationBarTitle("")
                .onAppear{
                    
            }
            
            VStack{
                
                Spacer()
                
                RadioButtons(selected: self.$selectedFlag,show: self.$showFlag, flagMessage: self.$flagMessage).offset(y: self.showFlag ? (UIApplication.shared.windows.last?.safeAreaInsets.bottom)! + 15 : UIScreen.main.bounds.height)
                    .onTapGesture {
                        withAnimation{
                            self.showFlag.toggle()
                            
                        }
                } .animation(Animation.spring(response: 0.6, dampingFraction: 1.0, blendDuration: 1.0))
                    .alert(isPresented: $flagMessage) {
                        Alert(
                            title: Text(BLOCKUSER),
                            message: Text(BLOCKMSG),
                            dismissButton: .default(Text(CONFIRM)))
                        
                        
                        
                        
                }
                
            }.background(Color(UIColor.label.withAlphaComponent(self.showFlag ? 0.2 : 0)).edgesIgnoringSafeArea(.all))
            
            if self.showProfile{
                MenuView()
                    .background(Color.black.opacity(0.65))
                    .offset(y: self.showProfile ? 0 : screen.height)
                    .offset(y: self.viewState.height)
                    .animation(.spring(response: 1, dampingFraction: 0.7, blendDuration: 0))
                    .onTapGesture {
                        self.showProfile.toggle()
                }
                .gesture(
                    DragGesture().onChanged { value in
                        self.viewState = value.translation
                    }
                    .onEnded { value in
                        if self.viewState.height > 50 {
                            self.showProfile = false
                        }
                        self.viewState = .zero
                    }
                ).edgesIgnoringSafeArea(.all)
                
            }
            if self.uploadComplete {
                ZStack {
                    
                    Color("ColorTransparentBlack").edgesIgnoringSafeArea(.all)
                    
                    // MODAL
                    VStack(spacing: 0) {
                        // TITLE
                        
                        
                        Text("사진 등록 완료")
                            .font(Font.custom(FONT, size: 18))
                            .fontWeight(.heavy)
                            .padding()
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .background(APP_THEME_COLOR)
                            .foregroundColor(Color.white)
                        
                        Spacer()
                        
                        VStack(spacing: 16) {
                            
                            HStack{
                                Text("\(User.currentUser()!.username) 님도 투표를 시작해보세요")
                                    .font(Font.custom(FONT, size: 14))
                                    .lineLimit(2)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Color.gray)
                                    .layoutPriority(1)
                                
                                Button(action: {
                                }) {
                                    
                                    Image("Gleem_3D").resizable().frame(width: 35, height: 35)
                                }.buttonStyle(PlainButtonStyle())
                            }
                            
                            
                            HStack{
                                Spacer()
                                Button(action: {
                                    
                                    withAnimation(){
                                        self.uploadComplete = false
                                        self.animatingModal = false
                                        
                                    }
                                    
                                    
                                }) {
                                    Text(CONFIRM.uppercased())
                                        .font(Font.custom(FONT, size: 15))
                                        .fontWeight(.semibold)
                                        .accentColor(APP_THEME_COLOR)
                                        .padding(.horizontal, 55)
                                        .padding(.vertical, 15)
                                        .frame(minWidth: 100)
                                        .background(
                                            Capsule()
                                                .strokeBorder(lineWidth: 1.75)
                                                .foregroundColor(APP_THEME_COLOR)
                                    )
                                }
                                Spacer()
                            }
                        }
                        
                        
                        Spacer()
                        
                    }
                    .frame(minWidth: 260, idealWidth: 260, maxWidth: 300, minHeight: 140, idealHeight: 160, maxHeight: 200, alignment: .center)
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(color: Color("ColorTransparentBlack"), radius: 6, x: 0, y: 8)
                    .opacity(self.$animatingModal.wrappedValue ? 1 : 0)
                    .offset(y: self.$animatingModal.wrappedValue ? 0 : -100)
                    .animation(Animation.spring(response: 0.6, dampingFraction: 1.0, blendDuration: 1.0))
                    .onAppear(perform: {
                        self.animatingModal = true
                    })
                        .padding(.vertical, 5)
                }
                
                
                
            }
            
        }.onAppear{
            
        }
        
        
    }
    
    
}



extension AnyTransition {
    static var trailingBottom: AnyTransition {
        AnyTransition.asymmetric(
            insertion: .identity,
            removal: AnyTransition.move(edge: .trailing).combined(with: .move(edge: .bottom)))
    }
    
    static var leadingBottom: AnyTransition {
        AnyTransition.asymmetric(
            insertion: .identity,
            removal: AnyTransition.move(edge: .leading).combined(with: .move(edge: .bottom)))
    }
}
