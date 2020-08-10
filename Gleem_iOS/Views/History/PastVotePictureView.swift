//
//  PastVotePictureView.swift
//  Gleem_iOS
//
//  Created by Dustin yang on 8/9/20.
//  Copyright © 2020 Dustin yang. All rights reserved.
//

import SwiftUI

struct PastVotePictureView: View {
    var card: Recipe
    var hapticImpact = UIImpactFeedbackGenerator(style: .heavy)
    @State private var showModal: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // CARD IMAGE
            Image(card.image)
                .resizable()
                .scaledToFit()
                .overlay(
                    HStack {
                        Spacer()
                        VStack {
                            Image(systemName: "bookmark")
                                .font(Font.title.weight(.light))
                                .foregroundColor(Color.white)
                                .imageScale(.small)
                                .shadow(color: Color("ColorBlackTransparentLight"), radius: 2, x: 0, y: 0)
                                .padding(.trailing, 20)
                                .padding(.top, 22)
                            Spacer()
                        }
                    }
            )
            
            VStack(alignment: .leading, spacing: 12) {
                // TITLE
                Text(card.title)
                    .font(.system(.title, design: .serif))
                    .fontWeight(.bold)
                    .foregroundColor(Color("ColorGreenMedium"))
                    .lineLimit(1)
                
                // HEADLINE
                Text(card.headline)
                    .font(.system(.body, design: .serif))
                    .foregroundColor(Color.gray)
                    .italic()
                
                // RATING
                //            RatingDetailView(recipe: recipe)
                //
                //            // COOKING
                //            RecipeCookingView(recipe: recipe)
            }
            .padding()
            .padding(.bottom, 12)
        }
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color("ColorBlackTransparentLight"), radius: 8, x: 0, y: 0)
        //        .onTapGesture {
        //          self.hapticImpact.impactOccurred()
        //          self.showModal = true
        //        }
        //        .sheet(isPresented: self.$showModal) {
        ////          RecipeDetailView(recipe: self.recipe)
        //        }
    }
}
//
//    struct PastVotePictureView_Previews: PreviewProvider {
//      static var previews: some View {
//        PastVotePictureView(card
//          .previewLayout(.sizeThatFits)
//      }
//    }
