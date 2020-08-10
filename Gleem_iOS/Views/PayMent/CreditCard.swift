//
//  CreditCard.swift
//  Gleem_iOS
//
//  Created by Dustin yang on 7/27/20.
//  Copyright © 2020 Dustin yang. All rights reserved.
//

import SwiftUI

struct CreditCard<Content>: View where Content: View {
    
    var content: () -> Content
    
    var body: some View {
        content()
    }
}


struct CreditCardFront: View {
    
    let name: String
    let number : String

    let expires: String
    enum CardType {
        case visa
        case masterCard
        case unknown

//        ...
//
//        var segmentGroupings: [Int] {...}
//        var cvvLength: Int {...}
//
//
//        func isValid(_ accountNumber: String) -> Bool {...}
//        func isPrefixValid(_ accountNumber: String) -> Bool {...}
    }
    
    
    func getCardType() -> CardType{
        if number.hasPrefix("6011") || number.hasPrefix("65") {
            return CardType.masterCard
        }
        else if number.hasPrefix("622") {
            // If the number has a prefix in the range 622126-622925, it's Discover
            let prefixLength = 6;
            if (number.count >= prefixLength) {
                let prefixIndex = number.index(number.startIndex, offsetBy: prefixLength)
                let sixDigitPrefixString = number.substring(to: prefixIndex)
                let sixDigitPrefixInt = Int(sixDigitPrefixString)!
                if sixDigitPrefixInt >= 622126 && sixDigitPrefixInt <= 622925 {
                    return CardType.masterCard;
                }
            }
//            return .unknown
        }
        
        return .unknown
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            
            HStack(alignment: .top) {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(Color.white)
            
                Spacer()
                
                Text(self.getCardType() == CardType.masterCard ? "MASTER" : "")
                    .foregroundColor(Color.white)
                    .font(.system(size: 15))
                    .fontWeight(.bold)
            
            }
            
            Spacer()
            
            Text(number)
                .foregroundColor(Color.white)
                .font(.system(size: 32))
            
            Spacer()
            
            HStack {
                
                VStack(alignment: .leading) {
                    Text("CARD HOLDER")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(Color.gray)
                    
                    Text(name)
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                    
                }
                
                Spacer()
                
                VStack {
                    Text("EXPIRES")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(Color.gray)
                    Text(expires)
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                }
                
            }
            
            
            
        }.frame(width: 300, height: 200)
        .padding()
        .background(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.5481430292, green: 0, blue: 0.4720868468, alpha: 1)), Color.blue]), startPoint: .topLeading, endPoint: .bottomTrailing))
        .cornerRadius(10)
    }
}


struct CreditCardBack: View {
    
    let cvv:String
    
    var body: some View {
        VStack {
           
            Rectangle()
                .frame(maxWidth: .infinity, maxHeight: 20)
                .padding([.top])
            
            Spacer()
            
            HStack {
                
                Text(cvv).foregroundColor(Color.black)
                    .rotation3DEffect(
                        .degrees(180),
                        axis: (x: 0.0, y: 1.0, z: 0.0))
                    .padding(5)
                    .frame(width: 100, height: 20)
                    .background(Color.white)
                
                
                Spacer()
            }.padding()
            
        }.frame(width: 300, height: 200)
        .background(LinearGradient(gradient: Gradient(colors: [Color.yellow, Color.blue]), startPoint: /*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/, endPoint: /*@START_MENU_TOKEN@*/.trailing/*@END_MENU_TOKEN@*/))
        .cornerRadius(10)
    }
}


//struct CreditCard_Previews: PreviewProvider {
//    static var previews: some View {
//        CreditCard<CreditCardFront>(content: { CreditCardFront(name: "Mohammad Azam", expires: "02/06") })
//    }
//}
