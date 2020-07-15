//
//  CardListViewUIkit.swift
//  Gleem_iOS
//
//  Created by Dustin yang on 7/14/20.
//  Copyright © 2020 Dustin yang. All rights reserved.
//

import SwiftUI

struct CardListViewUIkit: UIViewControllerRepresentable {

let someView = CardListview()
    func makeUIViewController(context: Context) -> CardListview {
        makeViewController(context: context) //instantiate vc etc.
    }

    func updateUIViewController(_ uiViewController: YourViewController, context: Context) {
        if isCallingFunc {
            uiViewController.doSomething()
            isCallingFunc = false
        }
    }
}
//
//struct CardListViewUIkit: UIViewRepresentable {
//
//
// // add this instance
//    let someView = CardListview() // changed your CaptureView to SomeView to make it compile
//
//
//
//    func makeUIView(context: Context) -> CardListview {
//        return someView
//    }
//
//    func moveCard() {
//         someView.moveCards()
//     }
//     func updateUIView(_ uiView: CardListview, context: Context) {
//
//    }
//
//
//
//
//}
