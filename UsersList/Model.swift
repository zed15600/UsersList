//
//  Model.swift
//  UsersList
//
//  Created by user164501 on 2/7/20.
//  Copyright © 2020 EdisonZ. All rights reserved.
//

import Foundation

struct User : Codable {
    let id: Int
    let name: String
    let email: String
    let phone: String
    var posts: [Post]?
}

struct Post : Codable {
    let id: Int
    let title: String
    let body: String
}
