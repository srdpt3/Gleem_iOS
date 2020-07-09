//
//  BottomView.swift
//  Gleem_Dating
//
//  Created by Dustin yang on 6/28/20.
//  Copyright © 2020 Dustin yang. All rights reserved.
//

import SwiftUI

struct BottomView : View {
    
    @EnvironmentObject var obs : observer
    @State var show = false
    @State var isVoted = false
    
    
    @State var x : CGFloat = 0
    @State var count : CGFloat = 0
    @State var screen = UIScreen.main.bounds.width - 30
    @State var op : CGFloat = 0
    @State var selectedCard: User?
    @State var bottomDragState: CGSize = .zero
    var heightBanner = (UIScreen.main.bounds.height * 0.65)
    @State var showFull = false
    
    
    var body : some View{
        
        ZStack {
            
            HStack(spacing: 20){
                Button(action: {
                    // ACTION
                    
                    self.show.toggle()
                    
                    self.selectedCard = self.obs.users[0]
                    
                }) {
                    Text("일단 첫인상".uppercased())
                        .font(.system(.subheadline, design: .rounded))
                        .fontWeight(.heavy)
                        .padding(.horizontal, 50)
                        .padding(.vertical, 10).foregroundColor(Color("Color2"))
                        .background(
                            Capsule().stroke(Color("Color2"), lineWidth: 2)
                    ).animation(
                        Animation.easeInOut(duration: 2)
                            .delay(1)
                    )
                    
                }.opacity((self.obs.last > 0 || self.obs.last == -1 ) ? 1 : 0).padding(.top, 20)
                
                if(self.isVoted ) {
                    Button(action: {
                        self.isVoted.toggle()
                        if self.obs.last == -1{
                            //intial user...
                            self.obs.update(id: self.obs.users[self.obs.users.count - 1], value: 500, degree: 0)
                            //                            self.obs.updateDB(id: self.obs.users[self.obs.users.count - 1], status: "liked")
                        }
                        else{
                            if(self.obs.last  > 0){
                                // if last user index is 4 means current user index will be 4-1 = 3
                                //                                self.obs.updateDB(id: self.obs.users[self.obs.last - 1], status: "voted")
                                self.obs.update(id: self.obs.users[self.obs.last - 1], value: 500, degree: 0)
                                
                            }
                        }
                        
                        
                    }) {
                        Image(systemName: "arrow.right").resizable().frame(width: 20, height: 20).padding(.all, 8)
                    }.foregroundColor(.black)
                        .background(Color.clear)
                        .shadow(radius: 45)
                        .clipShape(Circle()).animation(
                            Animation.easeInOut(duration: 2)
                                .delay(1)
                    )
              }
                
                
            }
            .padding(.bottom, 45)
            .sheet(isPresented: $show) {
                ExpandView(user: self.obs.users[self.obs.last == -1 ? self.obs.users.count - 1 : self.obs.last - 1], show: self.$show, isVoted:self.$isVoted)
                    //shrinking the view in background...
                    .scaleEffect(self.show ? 1 : 0)
                    .frame(width: self.show ? nil : 0, height: self.show ? nil : 0)
            }
            
        }
    }
}



struct CustomShape : Shape {
    
    var corner : UIRectCorner
    var radii : CGFloat
    
    func path(in rect: CGRect) -> Path {
        
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corner, cornerRadii: CGSize(width: radii, height: radii))
        
        return Path(path.cgPath)
    }
}

