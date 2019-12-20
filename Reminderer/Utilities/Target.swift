//
//  Target.swift
//  Reminderer
//
//  Created by Can Balkaya on 9/22/19.
//  Copyright © 2019 Can Balkaya. All rights reserved.
//

import Foundation
import Firebase

class Target {
    var username: String!
    var text: String!
    var timestamp: Timestamp!
    var number: Int!
    var documentId: String!
    var userId: String!
    
    init(username: String, text: String, timestamp: Timestamp, number: Int, documentId: String, userId: String) {
        self.username = username
        self.text = text
        self.timestamp = timestamp
        self.number = number
        self.documentId = documentId
        self.userId = userId
    }
    
    class func parseData(snapshot: QuerySnapshot?) -> [Target] {
        var targets = [Target]()
        
        guard let snap = snapshot else { return targets }
        for document in snap.documents {
            let data = document.data()
            
            let username = data[USERNAME] as? String ?? ""
            let text = data[TEXT] as? String ?? ""
            let timestamp = data[TIMESTAMP] as? Timestamp ?? Timestamp.init(date: Date())
            let number = data[NUMBER] as? Int ?? 0
            let documentId = document.documentID
            let userId = data[USER_ID] as? String ?? ""
            
            let newTarget = Target(username: username, text: text, timestamp: timestamp, number: number, documentId: documentId, userId: userId)
            targets.append(newTarget)
        }
        
        return targets
    }
}
