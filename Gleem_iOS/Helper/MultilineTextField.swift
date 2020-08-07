//
//  MultilineTextField.swift
//  Gleem_iOS
//
//  Created by Dustin yang on 8/6/20.
//  Copyright © 2020 Dustin yang. All rights reserved.
//

import SwiftUI




struct MultilineTextField: UIViewRepresentable {

    
//    typealias UIViewType = UIView
//    var filename: String
    
    func makeCoordinator() -> MultilineTextField.Coordinator {
        return MultilineTextField.Coordinator(parent1: self)
    }
    
    @EnvironmentObject var obj : observed
    func makeUIView(context: UIViewRepresentableContext<MultilineTextField>) -> UITextView {
           let view = UITextView()
        //        view.font = .Font.custom(FONT, size: 14)
                view.text = "간단한 인사 메세지"
                view.textColor = UIColor.black.withAlphaComponent(0.35)
                return view
        
    }
    
    func updateUIView(_ uiView: UITextView, context: UIViewRepresentableContext<MultilineTextField>) {

    }
    
    class Coordinator : NSObject, UITextViewDelegate{
        var parent : MultilineTextField
        init(parent1: MultilineTextField){
            parent = parent1
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            textView.text = ""
            textView.textColor = .gray
        }
        
        func textViewDidChange(_ textView: UITextView) {
            self.parent.obj.size = textView.contentSize.height
        }
    }
}


class observed : ObservableObject{
    @Published var size : CGFloat = 0
}
