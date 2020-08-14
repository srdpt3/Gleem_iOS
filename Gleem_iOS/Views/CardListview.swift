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
                    
                    
                    if(!self.obs.users.isEmpty){
                        ForEach(self.obs.cardViews) { cardView in
                            cardView.zIndex(self.isTopCard(cardView: cardView) ? 1 : 0)
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
                                .animation(Animation.spring(response: 0.7, dampingFraction: 1.0, blendDuration: 1.0).repeatForever(autoreverses: true))
                                
                                if(self.obs.users.isEmpty){
                                    Text(NO_NEW_CARD)
                                                                  .font(.custom(FONT, size: CGFloat(15))).foregroundColor(APP_THEME_COLOR).multilineTextAlignment(.center).lineLimit(2).padding(.horizontal)
                                }
                          
                                Spacer()
                                //                                         LoadingView(isLoading: self.obs.isLoading, error: self.obs.error) {
                                //                                             self.obs.getNewCards()
                                //                                         }
                                
                            }.animation(.default).onAppear{
//                                self.obs.getNewCards()
                            }
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
                
                Spacer()
                if(!self.obs.users.isEmpty){
                    FooterView(isVoted: $isVoted, showVotingScreen: $showVotingScreen)
                        .opacity(dragState.isDragging ? 0.0 : 1.0)
                        .animation(.easeInOut).opacity(self.obs.isLoading == true ? 0 : 1)

                }
                
                Spacer()
                
                
            }.navigationBarHidden(true).navigationBarTitle("")
                .onAppear{
                
            }
            
            VStack{
                
                Spacer()
                
                RadioButtons(selected: self.$selectedFlag,show: self.$showFlag).offset(y: self.showFlag ? (UIApplication.shared.windows.last?.safeAreaInsets.bottom)! + 15 : UIScreen.main.bounds.height)
                    .onTapGesture {
                        self.showFlag.toggle()
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
            
            
        }.onAppear{
        }
        
        //        .alert(isPresented: $showAlert) {
        //            Alert(
        //                title: Text("테스트"),
        //                message: Text("Wishing a lovely and most precious of the times together for the amazing couple."),
        //                dismissButton: .default(Text("Happy Honeymoon!")))
        //
        //
        //
        //
        //        }
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

