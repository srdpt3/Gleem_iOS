//
//  FavoriteViewModel.swift
//  Gleem_Dating
//
//  Created by Dustin yang on 7/6/20.
//  Copyright © 2020 Dustin yang. All rights reserved.
//

import SwiftUI

class FavoriteViewModel: ObservableObject {
    @Published var isSucess = false
    @Published var liked : Bool = false

    @Published var favoriteUsers : [User] = []
    @Published var error: NSError?
    @Published var isLoading = false
    
    var splitted: [[User]] = []
    
    func addToMyList(user: User) {
        
        guard let dict = try? user.toDictionary() else {return}
        
        Ref.FIRESTORE_COLLECTION_LIKED_USERID(userId: user.id).setData(dict) { (error) in
            if error == nil {
                print("persist sucessfully to my favorite list")
                
                
                guard let dict2 = try? User.currentUser().toDictionary() else {return}
                
                Ref.FIRESTORE_COLLECTION_SOMEOME_LIKED_USERID(userId: user.id).setData(dict2) { (error) in
                    if error == nil {
                        print("persist sucessfully to my someone_liekd")
                        self.isSucess = true
                        self.liked = true
                    }
                }
            }
        }
        
    }
    
    
    func checkLiked(id: String) {
        
        Ref.FIRESTORE_COLLECTION_LIKED_USERID(userId: id).getDocument { (document, error) in
            if let doc = document, doc.exists {
                self.liked = true
            } else {
                self.liked  = false
            }
        }
    }
    
    
    func removeFromList(id : String){
        Ref.FIRESTORE_COLLECTION_LIKED_USERID(userId: id).getDocument { (document, error) in
            if let doc = document, doc.exists {
                doc.reference.delete()
                print("Removed sucessfully from liked : \(id) ")
                
            }
            
            
        }
        
        Ref.FIRESTORE_COLLECTION_SOMEOME_LIKED_USERID(userId: id).getDocument { (document, error) in
            if let doc = document, doc.exists {
                doc.reference.delete()
                print("Removed sucessfully from someone_liked : \(id) ")
                
            }
        }
    }
    
    
    
    func loadFavoriteUsers() {
        isLoading = true
        favoriteUsers.removeAll()
        Ref.FIRESTORE_GET_LIKED_USERID_COLLECTION(userId: User.currentUser()!.id).getDocuments { (snapshot, error) in
            if(error != nil){
                print((error?.localizedDescription)!)
                self.error = (error?.localizedDescription as! NSError)
            }
         
            for document in snapshot!.documents {
                let dict = document.data()
                guard let decoderPost = try? User.init(fromDictionary: dict) else {return}
                
                self.favoriteUsers.append(decoderPost)
            }
            self.isLoading = false

        }
        
//        self.splitted = self.favoriteUsers.chunked(3)


    }
}

