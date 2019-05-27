//
//  Message.swift
//  OneToOneChat
//
//  Created by Prabhakar G on 17/03/19.
//  Copyright © 2019 Prabhakar G. All rights reserved.
//

import Foundation
import Firebase

class Message: NSObject {
    @objc var toId: String?
    @objc var timeStamp: NSNumber?
    @objc var fromId: String?
    @objc var text: String?
    
    func chatPartnerId() -> String? {
        return fromId == Auth.auth().currentUser?.uid ? toId : fromId
    }
}
