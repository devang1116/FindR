//
//  ChatUser.swift
//  FindR
//
//  Created by Devang Papinwar on 11/16/21.
//

import FirebaseFirestoreSwift

struct ChatUser: Identifiable
{
    var id: String { uid }
    
    let uid, email, profileImageUrl, type: String
    
    init(data: [String: Any])
    {
        self.type = data["type"] as? String ?? ""
        self.uid = data["uid"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
        self.profileImageUrl = data["profileImageUrl"] as? String ?? ""
    }
}

