//
//  FavoriteView.swift
//  Gleem_Dating
//
//  Created by Dustin yang on 7/6/20.
//  Copyright © 2020 Dustin yang. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct FavoriteView: View {
    
    var body: some View {
        FavoriteHome()
    }
}


struct FavoriteHome : View {
    @ObservedObject private var favoriteViewModel = FavoriteViewModel()
    init() {
        self.favoriteViewModel.loadFavoriteUsers()
    }
    
    
    var body: some View{
        //        NavigationView {
        
        VStack(spacing: 10){
            
            //            GeometryReader{geo in
            //            HStack(spacing: 10){
            //                if !self.favoriteViewModel.favoriteUsers.isEmpty {
            //                    MainSubViewFavorite2(title: "Favorite Votes", users: self.favoriteViewModel.favoriteUsers)
            //
            //                } else {
            //                    Spacer()
            //
            //                    LoadingView(isLoading: self.favoriteViewModel.isLoading, error: self.favoriteViewModel.error) {
            //                        self.favoriteViewModel.loadFavoriteUsers()
            //                    }
            //                    Spacer()
            //
            //                }
            //            }.padding(.top, -10)
            
            
            //            }
            
            GeometryReader{geo in
                VStack{
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(sectionData) { item in
                                GeometryReader { geometry in
                                    SectionView2(section: item)
                                        .rotation3DEffect(Angle(degrees:
                                            Double(geometry.frame(in: .global).minX - 60) / -getAngleMultiplier(bounds: geo)
                                        ), axis: (x: 0, y: 20, z: 0))
                                }
                                .frame(width: geo.size.height / 4.5 , height: geo.size.height / 4.5)
                            }
                        }.padding()
                       
                        //                    .padding(.bottom, 30)
                    }.background(Color.black)
                    VStack(spacing: 10){
                        if !self.favoriteViewModel.favoriteUsers.isEmpty {
                            MainSubViewFavorite(title: "Favorite Votes", users: self.favoriteViewModel.favoriteUsers)
                                .frame( height: geo.size.height / 1.5 )
                        } else {
                            Spacer()
                            
                            LoadingView(isLoading: self.favoriteViewModel.isLoading, error: self.favoriteViewModel.error) {
                                self.favoriteViewModel.loadFavoriteUsers()
                            }
                            Spacer()
                            
                        }
                    }
                }
                
                
                
                
                
                
            }
            
            //                GeometryReader{_ in
            
        }
        .navigationBarHidden(true)
        .navigationBarTitle("")
        //                font(.caption).padding(.horizontal, 16)            .padding(.bottom, 45)
        //        .navigationBarTitle(Text("모든카드"), displayMode: .inline)
        //        .padding(.horizontal, 16)
        
        //        .padding(.bottom, 45)
        
        //
        //        .onAppear(){
        //            self.favoriteViewModel.loadFavoriteUsers()
        //        }
        
        
    }
}
func getAngleMultiplier(bounds: GeometryProxy) -> Double {
    if bounds.size.width > 500 {
        return 80
    } else {
        return 20
    }
}

struct MainSubViewFavorite: View{
    let title: String
    let users: [User]
    @State var show : Bool  = false
    @State var showExpandView : Bool = false
    @State var isVoted : Bool  = true
    //    var user : User?
    @State var selectedUser : User?
    
    var body : some View{
        
        
        ScrollView(.vertical, showsIndicators: false) {
            
            HStack{
                Text("나의 Gleem").fontWeight(.heavy).font(.headline)
                    .foregroundColor(Color("Color2"))
                Spacer()
                
            }
            .padding(.horizontal)
            
            
            VStack(spacing: 20){
                ForEach(0..<users.chunked(3).count){index in
                    
                    HStack(spacing: 8){
                        ForEach(self.users.chunked(3)[index]){i in
                            
                            NavigationLink(destination: ExpandView(user: i, show: self.$show, isVoted: self.$isVoted)) {
                                FavoriteCard(user: i)
                                //                                    .onTapGesture {
                                //                                    self.show.toggle()
                                //                                    self.selectedUser = i
                                //                                }
                                //                                .animation(.default).opacity(self.show ? 0 : 1)
                                //                                    }
                            }
                            
                            
                            
                        }
                    }
                    
                }
            }
            
            
        }
        
        
    }
}

struct MainSubViewFavorite2: View{
    let title: String
    let users: [User]
    @State var show : Bool  = false
    
    @State var showExpandView : Bool = false
    @State var isVoted : Bool  = true
    //    var user : User?
    @State var selectedUser : User?
    
    var body : some View{
        
        VStack(alignment: .leading) {
            HStack{
                
                Text("나에게 끌림").fontWeight(.heavy).font(.headline)
                    .foregroundColor(Color("Color2"))
                //                Spacer()
                
                
            }.padding(.leading, 12)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    HStack(spacing : 12){
                        ForEach(self.users) { i in
                            
                            FavoriteCard2(user: i).onTapGesture {
                                self.show.toggle()
                                self.selectedUser = i
                            }.blur(radius: 5)
                                .padding(.leading, i.id == self.users.first!.id ? 12 : 0)
                                .padding(.trailing, i.id == self.users.last!.id ? 12 : 0)
                        }
                    }
                    
                    
                    
                    
                }
            }
            //            .alert(isPresented: self.$showBlockAlert) {
            //                    Alert(title: Text("Error"), message: Text(BLOCKUSER),  dismissButton: .default(Text("OK"), action: {
            //                        //                self.showLoader.toggle()
            //                        //                self.showAlert.toggle()
            //
            //                    }))
            //            }
        }
        
        
        
    }
    
    
}




struct FavoriteCard2: View {
    let user: User
    
    var body: some View {
        VStack {
            AnimatedImage(url: URL(string:self.user.profileImageUrl))
                .resizable().frame(width :  (UIScreen.main.bounds.width ) / 3, height:  (UIScreen.main.bounds.height ) / 8).cornerRadius(20).aspectRatio(contentMode: .fit)
            
            HStack {
                
                Text(user.username).font(.footnote).lineLimit(1)
            }
            
            
            
            
        } .padding(.all, 8)
            .frame(width: (UIScreen.main.bounds.width - 25) / 3.1)
            .background(Color("Color-2"))
            .cornerRadius(15)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 8, y: 8)
            .shadow(color: Color.white.opacity(0.5), radius: 5, x: -8, y: -8)
        
        
        
    }
    
}



struct FavoriteCard: View {
    let user: User
    //    @Namespace var namespace
    
    var body: some View {
        VStack {
            
            ZStack(alignment: Alignment(horizontal: .trailing, vertical: .top)) {
                AnimatedImage(url: URL(string:self.user.profileImageUrl))
                    .resizable().frame(width: (UIScreen.main.bounds.width - 35) / 3, height: (UIScreen.main.bounds.height ) / 5.2).cornerRadius(15)
                HStack {
                    
                    Text(user.username).font(.footnote).lineLimit(1)
                }
                
                
                
                Button(action: {
                    
                }){
                    Image(systemName: "heart.fill")
                        .foregroundColor(.red)
                        .padding(.all,5)
                        .background(Color.white)
                        .clipShape(Circle())
                }   .padding(.all,5)
                
                
            }
            //            .matchedGeometryEffect(id: "image", in: self.namespace)
            
            
            //
            //            AnimatedImage(url: URL(string:self.user.profileImageUrl))
            //                .resizable().frame(width: (UIScreen.main.bounds.width - 35) / 3, height: (UIScreen.main.bounds.height ) / 5.2).cornerRadius(15)
            //            HStack {
            //
            //                Text(user.username).font(.footnote).lineLimit(1)
            //            }
            //
            
            
            
        } .padding(.all, 8)
            .frame(width: (UIScreen.main.bounds.width - 25) / 3)
            .background(Color("Color-2"))
            .cornerRadius(15)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 8, y: 8)
            .shadow(color: Color.white.opacity(0.5), radius: 5, x: -8, y: -8)
        
        
        
    }
    
}

//struct MovieUpComingView_Previews: PreviewProvider {
//    static var previews: some View {
//        MovieUpComingView()
//    }
//}
//



struct SectionView2: View {
    var section: Section2
    var width: CGFloat = 160
    var height: CGFloat = 160
    
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                Text(section.title)
                    .font(.system(size: 24, weight: .bold))
                    .frame(width: 100, alignment: .leading)
                    .foregroundColor(.white)
                Spacer()
                Image(section.logo)
            }
            
            Text(section.text.uppercased())
                .frame(maxWidth: .infinity, alignment: .leading)
            Image(section.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 160)
        }
        .padding(.top, 20)
        .padding(.horizontal, 20)
        .frame(width: width, height: height)
        .background(Color("Color2"))
        .cornerRadius(30)
        .shadow(color: Color("Color2").opacity(0.3), radius: 20, x: 0, y: 20)
    }
}

struct Section2: Identifiable {
    var id = UUID()
    var title: String
    var text: String
    var logo: String
    var image: String
}

let sectionData = [
    Section2(title: "Prototype designs in SwiftUI", text: "18 Sections", logo: "Logo1", image: "Background1"),
    Section2(title: "Build a SwiftUI app", text: "20 Sections", logo: "Logo1", image:"Background1"),
    Section2(title: "Prototype designs in SwiftUI", text: "18 Sections", logo: "Logo1", image: "Background1"),
    Section2(title: "Build a SwiftUI app", text: "20 Sections", logo: "Logo1", image:"Background1"),
    Section2(title: "Prototype designs in SwiftUI", text: "18 Sections", logo: "Logo1", image: "Background1"),
    Section2(title: "Build a SwiftUI app", text: "20 Sections", logo: "Logo1", image:"Background1"),
    Section2(title: "Prototype designs in SwiftUI", text: "18 Sections", logo: "Logo1", image: "Background1"),
    Section2(title: "Build a SwiftUI app", text: "20 Sections", logo: "Logo1", image:"Background1"),
    Section2(title: "SwiftUI Advanced", text: "20 Sections", logo: "Logo1", image: "Background1")
]




extension Array{
    func chunked(_ size: Int)->[[Element]]{
        stride(from: 0, to: count, by: size).map{
            Array(self[$0 ..< Swift.min($0+size, count)])
        }
    }
}


