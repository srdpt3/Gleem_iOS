//
//  SigninButton.swift
//  FrontYard
//
//  Created by Dustin yang on 6/14/20.
//  Copyright © 2020 Dustin yang. All rights reserved.
//

import Foundation
import SwiftUI
struct SigninButton: View {
    var action: () -> Void
    var label: String
    var body: some View {
        Button(action: action) {
            HStack {
                Spacer()
                Text(label).fontWeight(.bold).foregroundColor(Color.white)   .padding(.vertical).font(.custom(FONT, size: 18))
                Spacer()
            }
            
        }.modifier(SigninButtonModifier2())
    }
}
