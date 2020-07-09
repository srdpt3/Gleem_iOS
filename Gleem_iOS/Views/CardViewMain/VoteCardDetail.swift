//
//  VoteCardDetail.swift
//  Gleem_iOS
//
//  Created by Dustin yang on 7/8/20.
//  Copyright © 2020 Dustin yang. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct VoteCardDetail: View {
    var user: User
    @Binding var show: Bool
    @Binding var active: Bool
    @Binding var activeIndex: Int
    @Binding var isScrollable: Bool
    var bounds: GeometryProxy
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                VStack {
//                    HStack(alignment: .top) {
//                        VStack(alignment: .leading, spacing: 8.0) {
//                            Text(user.username)
//                                .font(.system(size: 24, weight: .bold))
//                                .foregroundColor(.white)
//                            Text(user.age)
//                                .foregroundColor(Color.white.opacity(0.7))
//                        }
//                        Spacer()
////                        ZStack {
////                            VStack {
////                                Image(systemName: "xmark")
////                                    .font(.system(size: 16, weight: .medium))
////                                    .foregroundColor(.white)
////                            }
////                            .frame(width: 36, height: 36)
////                            .background(Color.black)
////                            .clipShape(Circle())
////                            .onTapGesture {
////                                self.show = false
////                                self.active = false
////                                self.activeIndex = -1
////                                self.isScrollable = false
////                            }
////                        }
//                    }
//                    Spacer()
                    WebImage(url: URL(string:user.profileImageUrl)!)
                        .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: bounds.size.width )
                                .frame(height: 460)
                }
                .padding(show ? 30 : 20)
                .padding(.top, show ? 30 : 0)
                            .frame(width: show ? screen.width : screen.width - 60, height: show ? 460 : 280)
//                    .frame(width: show ? .infinity : bounds.size.width - 60)
                    .frame(height: show ? 460 : 300)
                    .background(Color("background2"))
                    .clipShape(RoundedRectangle(cornerRadius: getCardCornerRadius(bounds: bounds), style: .continuous))
                    .shadow(color: Color("background2").opacity(0.3), radius: 20, x: 0, y: 20)
                
                VStack(alignment: .leading, spacing: 30.0) {
                    Text("asdfasdfasdfasdfasdfS.")
                    
                    Text("asdfasdfasdf")
                        .font(.title).bold()
                                Text("aThirdly, create a separate view, called ImageOverlay, which contains the desired text with appropriate styling. Wrap the text view in a ZStack to create a nice sticker impression with rounded corners, opacity and background color.")
                }
                .padding(30)
            }
        }
        .edgesIgnoringSafeArea(.all).navigationBarTitle("").navigationBarHidden(true)
    }
}
//
//struct VoteCardDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        VoteCardDetail()
//    }
//}
