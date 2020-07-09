//
//  ImagePicker.swift
//  Gleem_Dating
//
//  Created by Dustin yang on 6/29/20.
//  Copyright © 2020 Dustin yang. All rights reserved.
//
import SwiftUI

// Image Picker

import SwiftUI

struct ImagePicker : UIViewControllerRepresentable {
    
    func makeCoordinator() -> Coordinator {
        
        return ImagePicker.Coordinator(parent1: self)
    }
    
    @Binding var showPicker : Bool
    @Binding var imageData : Data
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
        
    }
    
    class Coordinator : NSObject,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
        
        var parent : ImagePicker
        
        init(parent1: ImagePicker) {
            
            parent = parent1
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            
            parent.showPicker.toggle()
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            let imgData = info[.originalImage] as! UIImage
            
            parent.imageData = imgData.jpegData(compressionQuality: 0.5)!
            
            parent.showPicker.toggle()
        }
    }
}
