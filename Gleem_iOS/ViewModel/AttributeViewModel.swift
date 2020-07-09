//
//  AttributeViewModel.swift
//  Gleem_Dating
//
//  Created by Dustin yang on 7/3/20.
//  Copyright © 2020 Dustin yang. All rights reserved.
//

import SwiftUI

class  AttributeViewModel: ObservableObject {
    @Published var isSucess = false
    @Published var error: NSError?
    @Published  var buttonAttributes : [String] = []
    @Published var isLoading = true
    
    func loadAttributes(sex: String) {
        self.buttonAttributes.removeAll()
        Ref.FIRESTORE_COLLECTION_ATTRIBUTE.getDocuments { (snapshot, error) in
            
            guard let snap = snapshot else {
                print("Error fetching data")
                self.error = (error as! NSError)
                return
            }
            for i in snap.documents {
                if(i.documentID == sex){
                    self.buttonAttributes.append(i.get("attr1") as! String)
                    self.buttonAttributes.append(i.get("attr2") as! String)
                    self.buttonAttributes.append(i.get("attr3") as! String)
                    self.buttonAttributes.append(i.get("attr4") as! String)
                    self.buttonAttributes.append(i.get("attr5") as! String)
                    self.buttonAttributes.append(i.get("attr6") as! String)
                    self.buttonAttributes.append(i.get("attr7") as! String)
                    self.buttonAttributes.append(i.get("attr8") as! String)
                    
                    
                    self.isLoading = false
                    break
                }
                
                
            }
        }
    }
}
