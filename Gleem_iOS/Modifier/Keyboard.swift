//
//  Keyboard.swift
//  Gleem_Dating
//
//  Created by Dustin yang on 7/1/20.
//  Copyright © 2020 Dustin yang. All rights reserved.
//

import SwiftUI



struct Keyboard: ViewModifier {
    @State var keyboardYOffset: CGFloat = 0
    //    let keyboardWillAppearPublisher = NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
    //    let keyboardWillHidePublisher = NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
    
    //    init(_ offset: Binding<CGFloat>) {
    //        _keyboardYOffset = offset
    //    }
    
    func body(content: Content) -> some View {
        content.padding(.bottom, keyboardYOffset).onAppear {
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification,  object: nil, queue: .main) { (notification) in
                let value = notification.userInfo? [UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
                let height = value.height
                self.keyboardYOffset = height
            }
            
            
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification,  object: nil, queue: .main) { (notification) in
                
                self.keyboardYOffset = 0
            }
        }
    }
}

extension View {
    func KeyboardResponsive() -> ModifiedContent<Self,Keyboard>{
        return modifier(Keyboard())
    }
}
