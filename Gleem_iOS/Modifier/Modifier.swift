//
//  Modifier.swift
//  Gleem_Dating
//
//  Created by Dustin yang on 7/1/20.
//  Copyright © 2020 Dustin yang. All rights reserved.
//

import SwiftUI

struct TextFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content.padding()
            .border(COLOR_LIGHT_GRAY, width: 1)
            .padding([.top, .leading, .trailing])
    }
}

struct SigninButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content.padding().background(LinearGradient(gradient: .init(colors: [Color("Color2"),Color("Color1-2")]), startPoint: .leading, endPoint: .trailing)).cornerRadius(5).shadow(radius: 10, x: 0, y: 10).padding()
        
    }
}

