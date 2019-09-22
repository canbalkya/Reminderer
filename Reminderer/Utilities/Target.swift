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
    private(set) var text: String!
    private(set) var image: UIImageView!
    private(set) var status: Bool!
    private(set) var documentId: String!
    
    init(text: String, image: UIImageView, status: Bool, documentId: String) {
        self.text = text
        self.image = image
        self.status = status
        self.documentId = documentId
    }
    
    class func parseData(snapshot: QuerySnapshot?) -> [Target] {
        var targets = [Target]()
        
        guard let snap = snapshot else { return targets }
        for document in snap.documents {
            let data = document.data()
            
            let text = data[TEXT] as? String ?? ""
            let image = data[IMAGE] as? UIImageView ?? #imageLiteral(resourceName: "Off")
            let status = data[STATUS] as? Bool ?? false
            let documentId = document.documentID
            
            let newTarget = Target(text: text, image: image as! UIImageView, status: status, documentId: documentId)
            targets.append(newTarget)
        }
        
        return targets
    }
}
