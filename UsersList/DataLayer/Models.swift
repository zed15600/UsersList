//
//  Model.swift
//  UsersList
//
//  Created by user164501 on 2/7/20.
//  Copyright © 2020 EdisonZ. All rights reserved.
//

import Foundation

class User : Codable {
    let id: Int
    let name: String
    let email: String
    let phone: String
    var posts: [Post]?
    
    init(id: Int, name: String, email: String, phone: String) {
        self.id = id
        self.name = name
        self.email = email
        self.phone = phone
    }
}

struct Post : Codable {
    let id: Int
    let title: String
    let body: String
}
