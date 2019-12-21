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
    var documentId: String!
    var userId: String!
    var isDone: Bool!
    
    init(username: String, text: String, timestamp: Timestamp, documentId: String, userId: String, isDone: Bool) {
        self.username = username
        self.text = text
        self.timestamp = timestamp
        self.documentId = documentId
        self.userId = userId
        self.isDone = isDone
    }
    
    class func parseData(snapshot: QuerySnapshot?) -> [Target] {
        var targets = [Target]()
        
        guard let snap = snapshot else { return targets }
        for document in snap.documents {
            let data = document.data()
            
            let username = data[USERNAME] as? String ?? ""
            let text = data[TEXT] as? String ?? ""
            let timestamp = data[TIMESTAMP] as? Timestamp ?? Timestamp.init(date: Date())
            let documentId = document.documentID
            let userId = data[USER_ID] as? String ?? ""
            let isDone = data[IS_DONE] as? Bool ?? false
            
            let newTarget = Target(username: username, text: text, timestamp: timestamp, documentId: documentId, userId: userId, isDone: isDone)
            targets.append(newTarget)
        }
        
        return targets
    }
}
