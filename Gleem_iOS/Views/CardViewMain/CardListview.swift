//
//  CardListview.swift
//  Gleem_iOS
//
//  Created by Dustin yang on 7/8/20.
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
    @State var show = false
    
    //
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
    
    private func moveCards() {
        self.obs.cardViews.removeFirst()
        self.isVoted = false
        print("lastCardIndex \(obs.index) asdfas \(self.obs.totalCount)")
        
        if(self.obs.index >  self.obs.users.count){
            print("reload")
            
            self.obs.reload()
            self.obs.index = 2
        }else{
            
            let u = self.obs.users[self.obs.index % self.obs.users.count]
            let newCardView = MainCardView(user: u)
            self.obs.cardViews.append(newCardView)
            self.obs.index += 1
            self.obs.last += 1
            
            
        }
        
        
        
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
        
        VStack{
            HeaderView(showGuideView: $showGuide, showInfoView: $showInfo)
                .opacity(dragState.isDragging ? 0.0 : 1.0)
                .animation(.default)
            
            Spacer()
            ZStack{
                ForEach(self.obs.cardViews) { cardView in
                    cardView.zIndex(self.isTopCard(cardView: cardView) ? 1 : 0)
                        .overlay(
                            ZStack {
                                // X-MARK SYMBOL
                                //                              Image(systemName: "x.circle")
                                //                                .modifier(SymbolModifier())
                                //                                .opacity(self.dragState.translation.width < -self.dragAreaThreshold && self.isTopCard(cardView: cardView) ? 1.0 : 0.0)
                                //
                                // HEART SYMBOL
                                Image(systemName: "heart.circle")
                                    .modifier(SymbolModifier())
                                    .opacity(self.dragState.translation.width > self.dragAreaThreshold && self.isTopCard(cardView: cardView) ? 1.0 : 0.0)
                            }
                    )
                        .offset(x: self.isTopCard(cardView: cardView) ?  self.dragState.translation.width : 0, y: self.isTopCard(cardView: cardView) ?  self.dragState.translation.height : 0)
                        .scaleEffect(self.dragState.isDragging && self.isTopCard(cardView: cardView) ? 0.85 : 1.0)
                        .rotationEffect(Angle(degrees: self.isTopCard(cardView: cardView) ? Double(self.dragState.translation.width / 12) : 0))
                        .animation(.interpolatingSpring(stiffness: 120, damping: 120))
                        .gesture(LongPressGesture(minimumDuration: 0.01)
                            .sequenced(before: DragGesture())
                            .updating(self.$dragState, body: { (value, state, transaction) in
                                switch value {
                                case .first(true):
                                    state = .pressing
                                case .second(true, let drag):
                                    state = .dragging(translation: drag?.translation ?? .zero)
                                default:
                                    break
                                }
                            })
                            .onChanged({ (value) in
                                guard case .second(true, let drag?) = value else {
                                    return
                                }
                                
                                if drag.translation.width < -self.dragAreaThreshold {
                                    self.cardRemovalTransition = .leadingBottom
                                }
                                
                                if drag.translation.width > self.dragAreaThreshold {
                                    self.cardRemovalTransition = .trailingBottom
                                }
                            })
                            .onEnded({ (value) in
                                guard case .second(true, let drag?) = value else {
                                    return
                                }
                                if drag.translation.width > self.dragAreaThreshold {
                                    //                                if drag.translation.width < -self.dragAreaThreshold || drag.translation.width > self.dragAreaThreshold {
                                    //                                playSound(sound: "sound-rise", type: "mp3")
                                    //                                self.moveCards()
                                    if(self.isVoted){
                                        self.moveCards()
                                    }
                                }
                            })
                    )
                }
            }.padding(.horizontal)
            
            Spacer()
            FooterView(showBookingAlert: $showVotingScreen)
                .opacity(dragState.isDragging ? 0.0 : 1.0)
                .animation(.default)
            Spacer()
            
        }.sheet(isPresented: $showVotingScreen) {
            ExpandView(user: self.obs.users[self.obs.last], show: self.$showVotingScreen, isVoted:self.$isVoted)
            //shrinking the view in background...
            //                .scaleEffect(self.show ? 1 : 0)
            //                .frame(width: self.show ? nil : 0, height: self.show ? nil : 0)
        }
            
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("테스트"),
                message: Text("Wishing a lovely and most precious of the times together for the amazing couple."),
                dismissButton: .default(Text("Happy Honeymoon!")))
            
            
            
            
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
