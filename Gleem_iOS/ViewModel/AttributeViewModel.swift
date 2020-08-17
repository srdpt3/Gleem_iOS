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
    @Published  var buttonAttributes = [String]()
    @Published var isLoading = true
    
    func loadAttributes() {
        self.buttonAttributes.removeAll()
        Ref.FIRESTORE_COLLECTION_ATTRIBUTE.getDocuments { (snapshot, error) in
            self.buttonAttributes.removeAll()
            guard let snap = snapshot else {
                print("Error fetching data")
                self.error = (error as! NSError)
                return
            }
            for i in snap.documents {
                if(i.documentID == User.currentUser()!.sex){
                    self.buttonAttributes.append(i.get("attr1") as! String)
                    self.buttonAttributes.append(i.get("attr2") as! String)
                    self.buttonAttributes.append(i.get("attr3") as! String)
                    self.buttonAttributes.append(i.get("attr4") as! String)
                    self.buttonAttributes.append(i.get("attr5") as! String)
                    self.buttonAttributes.append(i.get("attr6") as! String)
                    self.buttonAttributes.append(i.get("attr7") as! String)
                    self.buttonAttributes.append(i.get("attr8") as! String)
                    self.buttonAttributes.append(i.get("attr9") as! String)
                    self.buttonAttributes.append(i.get("attr10") as! String)
                    self.buttonAttributes.append(i.get("attr11") as! String)
                    self.buttonAttributes.append(i.get("attr12") as! String)
                    self.buttonAttributes.append(i.get("attr13") as! String)
                    self.buttonAttributes.append(i.get("attr14") as! String)
                    self.buttonAttributes.append(i.get("attr15") as! String)
                    self.buttonAttributes.append(i.get("attr16") as! String)
                    self.buttonAttributes.append(i.get("attr17") as! String)

                    
                    self.isLoading = false
                    break
                }
                
                
            }
        }
    }
}
