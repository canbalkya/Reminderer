//
//  Target.swift
//  Reminderer
//
//  Created by Can Balkaya on 9/22/19.
//  Copyright © 2019 Can Balkaya. All rights reserved.
//

import UIKit
import Firebase

class Target {
    private(set) var username: String!
    private(set) var text: String!
    private(set) var timestamp: Timestamp!
    private(set) var status: Bool!
    private(set) var documentId: String!
    private(set) var userId: String!
    
    init(username: String, text: String, timestamp: Timestamp, status: Bool, documentId: String, userId: String) {
        self.username = username
        self.text = text
        self.timestamp = timestamp
        self.status = status
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
            let status = data[STATUS] as? Bool ?? false
            let documentId = document.documentID
            let userId = data[USER_ID] as? String ?? ""
            
            let newTarget = Target(username: username, text: text, timestamp: timestamp, status: status, documentId: documentId, userId: userId)
            targets.append(newTarget)
        }
        
        return targets
    }
}
