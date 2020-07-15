//
//  FlagApi.swift
//  Gleem_iOS
//
//  Created by Dustin yang on 7/14/20.
//  Copyright © 2020 Dustin yang. All rights reserved.
//

import SwiftUI

class FlagApi{
    
    func reportCard(flag: Flag){
        
        let firestoreFlagDocId = Ref.FIRESTORE_COLLECTION_FLAG_USERID(userId: flag.id).collection("flagged").document().documentID
        
        guard let dict = try? flag.toDictionary() else {return}
        Ref.FIRESTORE_COLLECTION_FLAG_USERID(userId:flag.id).collection("flagged").document(firestoreFlagDocId).setData(dict) { (error) in
            if error == nil {
                print("persist sucessfully to my favorite list")
                return
            }
            
        }
    }
    
}
