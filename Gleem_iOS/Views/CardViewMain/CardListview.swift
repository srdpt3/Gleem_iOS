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
    @EnvironmentObject var obs : observer

    @State var active = false
    @State var activeIndex = -1
    @State var activeView = CGSize.zero
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @State var isScrollable = false
       var body: some View {
        Text("")
//        GeometryReader { bounds in
//            ZStack {
//                Color.black.opacity(Double(self.activeView.height/500))
//                    .animation(.linear)
//                    .edgesIgnoringSafeArea(.all)
//
//                ScrollView {
//                    VStack(spacing: 30) {
//                        Text("투표 카드 - 5장 투표완료 후 새로운 카드를 받게됩니다")
//                            .font(.headline).bold()
//                            .frame(maxWidth: .infinity, alignment: .leading)
//                            .padding(.leading, 30)
//                            .padding(.top, 30)
//                            .blur(radius: self.active ? 20 : 0)
//
//                        ForEach(self.obs.users.indices, id: \.self) { index in
////                            Text(String(self.obs.users[index].username))
//                            GeometryReader { geometry in
//                                VotingCardView(
//                                    show: self.$obs.users[index].show,
//                                    user: self.obs.users[index],
//                                    active: self.$active,
//                                    index: index,
//                                    activeIndex: self.$activeIndex,
//                                    activeView: self.$activeView,
//                                    bounds: bounds,
//                                    isScrollable: self.$isScrollable
//                                )
//                                    .offset(y: self.obs.users[index].show ? -geometry.frame(in: .global).minY : 0)
//                                    .opacity(self.activeIndex != index && self.active ? 0 : 1)
//                                    .scaleEffect(self.activeIndex != index && self.active ? 0.5 : 1)
//                                    .offset(x: self.activeIndex != index && self.active ? bounds.size.width : 0)
//                            }
//                            .frame(height: self.horizontalSizeClass == .regular ? 80 : 280)
//                            .frame(maxWidth: self.obs.users[index].show ? 712 : getCardWidth(bounds: bounds))
//                            .zIndex(self.obs.users[index].show ? 1 : 0)
//                        }
//                    }
//                    .frame(width: bounds.size.width)
////                        .animation(.interactiveSpring())
////                    .animation(.interpolatingSpring(stiffness: 0.2, damping: 0.2))
//                    .animation(.spring(response: 0.5, dampingFraction: 1, blendDuration: 0))
//
////                    .animation(.interactiveSpring()(response: 0.5, dampingFraction: 0.6, blendDuration: 0))
//                }
//                .statusBar(hidden: self.active ? true : false)
//                .animation(.linear)
//                .disabled(self.active && !self.isScrollable ? true : false)
//            }
//        }
    }
}

func getCardWidth(bounds: GeometryProxy) -> CGFloat {
    if bounds.size.width > 712 {
        return 712
    }
    
    return bounds.size.width - 60
}

func getCardCornerRadius(bounds: GeometryProxy) -> CGFloat {
    if bounds.size.width < 712 && bounds.safeAreaInsets.top < 44 {
        return 0
    }
    
    return 30
}



struct VotingCardView: View {
    @Binding var show: Bool
    var user: User
    @Binding var active: Bool
    var index: Int
    @Binding var activeIndex: Int
    @Binding var activeView: CGSize
    var bounds: GeometryProxy
    @Binding var isScrollable: Bool
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 30.0) {
                Text("asdfasdfasdfasdfS.")
                
                Text("sfasdfasdf this casfasdfa")
                    .font(.title).bold()
                
                Text("TThirdly, create a separate view, called ImageOverlay, which contains the desired text with appropriate styling. Wrap the text view in a ZStack to create a nice sticker impression with rounded corners, opacity and background color..")
                
                Text("aThirdly, create a separate view, called ImageOverlay, which contains the desired text with appropriate styling. Wrap the text view in a ZStack to create a nice sticker impression with rounded corners, opacity and background color.")
            }
            .animation(nil)
            .padding(30)
            .frame(maxWidth: show ? .infinity : screen.width - 60, maxHeight: show ? .infinity : 280, alignment: .top)
            .offset(y: show ? 460 : 0)
            .background(Color("background1"))
            .clipShape(RoundedRectangle(cornerRadius: show ? getCardCornerRadius(bounds: bounds) : 30, style: .continuous))
            .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 20)
            .opacity(show ? 1 : 0)
            
            VStack {
//                HStack(alignment: .top) {
//                    VStack(alignment: .leading, spacing: 8.0) {
//                        Text(user.username)
//                            .font(.system(size: 24, weight: .bold))
//                            .foregroundColor(.white)
//                        Text(user.age)
//                            .foregroundColor(Color.white.opacity(0.7))
//                    }
//                    Spacer()
////                    ZStack {
////                        Image(uiImage: course.logo)
////                            .opacity(show ? 0 : 1)
////
////                        VStack {
////                            Image(systemName: "xmark")
////                                .font(.system(size: 16, weight: .medium))
////                                .foregroundColor(.white)
////                        }
////                        .frame(width: 36, height: 36)
////                        .background(Color.black)
////                        .clipShape(Circle())
////                        .opacity(show ? 1 : 0)
////                        .offset(x: 2, y: -2)
////                    }
//                }
//                Spacer()
                WebImage(url: URL(string: user.profileImageUrl)!)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity)
                    .frame(height: 300, alignment: .top)
            }
            .padding(show ? 30 : 20)
            .padding(.top, show ? 30 : 0)
            .frame(width: show ? screen.width : screen.width - 60, height: show ? 460 : 300)
//            .frame(maxWidth: show ? .infinity : screen.width - 60, maxHeight: show ? 460 : 300)
                .background(Color("background2"))
            .clipShape(RoundedRectangle(cornerRadius: show ? getCardCornerRadius(bounds: bounds) : 30, style: .continuous))
                .shadow(color: Color("background2").opacity(0.3), radius: 20, x: 0, y: 20)
            .gesture(
                show ?
                DragGesture().onChanged { value in
                    guard value.translation.height < 300 else { return }
                    guard value.translation.height > 0 else { return }
                    
                    self.activeView = value.translation
                }
                .onEnded { value in
                    if self.activeView.height > 50 {
                        self.show = false
                        self.active = false
                        self.activeIndex = -1
                        self.isScrollable = false
                    }
                    self.activeView = .zero
                }
                : nil
            )
            .onTapGesture {
                self.show.toggle()
                self.active.toggle()
                if self.show {
                    self.activeIndex = self.index
                } else {
                    self.activeIndex = -1
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                    self.isScrollable = true
                }
            }
            
            if isScrollable {
//                ExpandView(user: self.user, show: $show, isVoted: <#T##Binding<Bool>#>)
////                ExpandView(user: self.obs.users[self.obs.last == -1 ? self.obs.users.count - 1 : self.obs.last - 1], show: self.$show, isVoted:self.$isVoted)
////                                  //shrinking the view in background...
////                                  .scaleEffect(self.show ? 1 : 0)
////                                  .frame(width: self.show ? nil : 0, height: self.show ? nil : 0)
////
                
                VoteCardDetail(user: self.user, show: $show, active: $active, activeIndex: $activeIndex, isScrollable: $isScrollable, bounds: bounds)
                    .background(Color("background1"))
                    .clipShape(RoundedRectangle(cornerRadius: show ? getCardCornerRadius(bounds: bounds) : 30, style: .continuous))
                    .animation(nil)
                    .transition(.identity)
            }
        }
        .frame(height: show ? bounds.size.height + bounds.safeAreaInsets.top + bounds.safeAreaInsets.bottom : 280)
        .scaleEffect(1 - self.activeView.height / 1000)
        .rotation3DEffect(Angle(degrees: Double(self.activeView.height / 10)), axis: (x: 0, y: 10.0, z: 0))
        .hueRotation(Angle(degrees: Double(self.activeView.height)))
//        .animation(.interpolatingSpring(stiffness: 0.2, damping: 0.2))

        .animation(.spring(response: 0.5, dampingFraction: 1, blendDuration: 0))
        .gesture(
            show ?
            DragGesture().onChanged { value in
                guard value.translation.height < 300 else { return }
                guard value.translation.height > 50 else { return }
                
                self.activeView = value.translation
            }
            .onEnded { value in
                if self.activeView.height > 50 {
                    self.show = false
                    self.active = false
                    self.activeIndex = -1
                    self.isScrollable = false
                }
                self.activeView = .zero
            }
            : nil
        )
        .disabled(active && !isScrollable ? true : false)
        .edgesIgnoringSafeArea(.all)
    }
}
