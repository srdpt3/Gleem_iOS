//
//  AttrButtonView.swift
//  Gleem_Dating
//
//  Created by Dustin yang on 6/30/20.
//  Copyright © 2020 Dustin yang. All rights reserved.
//

import SwiftUI

struct AttrButtonView: View {
    @Binding  var isPressed: Bool
//    @Binding var buttonSelected:Bool
    var title : String
    var body: some View {
        Button(title, action: {
            self.isPressed.toggle()
//            self.buttonSelected.toggle()
        }).buttonStyle(NeumorphicButtonStyle(bgColor: Color("Color-3"), isPressed:  $isPressed))
    }
}

//struct AttrButtonView_Previews: PreviewProvider {
//    static var previews: some View {
//        AttrButtonView(title :
//        "TEST")
//    }
//}


struct NeumorphicButtonStyle: ButtonStyle {
    var bgColor: Color
    @Binding var isPressed: Bool

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(15).padding(.horizontal, 5)
            .background(
                ZStack {
//                    RoundedRectangle(cornerRadius: 10, style: .continuous)
//                        .shadow(color: .white, radius: configuration.isPressed ? 8: 15, x: configuration.isPressed ? -5: -15, y: configuration.isPressed ? -5: -15)
//                        .shadow(color: .clear, radius: configuration.isPressed ? 8: 15, x: configuration.isPressed ? 5: 15, y: configuration.isPressed ? 5: 15)
//                        .blendMode(.overlay)
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(self.isPressed ? Color("Color2") : bgColor)
                }
        )
             .scaleEffect(self.isPressed ? 0.9: 1)
            .foregroundColor(self.isPressed ? Color.white : Color.black)
            .animation(.spring())
    }
}
