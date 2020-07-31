//
//  PaymentView.swift
//  Gleem_iOS
//
//  Created by Dustin yang on 7/27/20.
//  Copyright © 2020 Dustin yang. All rights reserved.
//

import SwiftUI

struct PaymentView: View {
    
    @State private var degrees: Double = 0
    @State private var flipped: Bool = false
    
    @State private var name: String = ""
    @State private var expires: String = ""
    @State private var cvv: String = ""
    
    var body: some View {
        VStack {
            CreditCard {
                
                VStack {
                    Group {
                        if self.flipped {
                            CreditCardBack(cvv: self.cvv)
                        } else {
                            CreditCardFront(name: self.name, expires: self.expires)
                        }
                    }
                }.rotation3DEffect(
                    .degrees(self.degrees),
                    axis: (x: 0.0, y: 1.0, z: 0.0)
                )
                
            }
            .onTapGesture {
                withAnimation {
                    self.degrees += 180
                    self.flipped.toggle()
                }
            }
            
            TextField("Name", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding([.top,.leading,.trailing])
            
            TextField("Expiration", text: $expires)
               
                .padding([.leading,.trailing]).textFieldStyle(RoundedBorderTextFieldStyle())
            
            
//            TextField("CVV", text: $cvv)
            TextField("CVV", text: $cvv, onEditingChanged: { (editingChanged) in
                                withAnimation {
                                    self.degrees += 180
                                    self.flipped.toggle()
                                }
            }) .padding([.leading,.trailing]) .textFieldStyle(RoundedBorderTextFieldStyle())
//            {
//                <#code#>
//            }
//            TextField("CVV", text: $cvv) { (editingChanged) in

//            }
//            onCommit: {}
//                .textFieldStyle(RoundedBorderTextFieldStyle())
//
//
        }
    }
}

struct PaymentView_Previews: PreviewProvider {
    static var previews: some View {
        PaymentView()
    }
}
