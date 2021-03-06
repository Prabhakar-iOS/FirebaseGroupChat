//
//  User.swift
//  OneToOneChat
//
//  Created by Prabhakar G on 03/03/19.
//  Copyright © 2019 Prabhakar G. All rights reserved.
//

import Foundation
import Firebase

class User: NSObject {
    @objc var id: String?
    @objc var name: String!
    @objc var email: String!
    @objc var profileImageUrl: String!
}
