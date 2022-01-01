//
//  ChatMessage.swift
//  FindR
//
//  Created by Devang Papinwar on 11/19/21.
//

import Foundation
import FirebaseFirestoreSwift

struct ChatMessage : Identifiable
{
    var id : String { documentId }
    var documentId :String
    let fromId , toId , text : String
    
    init(documentId : String , data : [String : Any])
    {
        self.documentId = documentId
        self.fromId = data["fromId"] as? String ?? ""
        self.toId = data["toId"] as? String ?? ""
        self.text = data["text"] as? String ?? ""
    }
}
