//
//  DatabaseManager.swift
//  UsersList
//
//  Created by user164501 on 2/8/20.
//  Copyright © 2020 EdisonZ. All rights reserved.
//

import Foundation
import SQLite

class DatabaseManager {
    static let sharedInstance = DatabaseManager()
    private let path: String
    private let db: Connection?
    //tables
    private let users = Table("users")
    private let posts = Table("posts")
    //table fields
    let id = Expression<Int64>("id")
    let name = Expression<String?>("name")
    let email = Expression<String>("email")
    let phone = Expression<String?>("phone")
    let userId = Expression<Int64>("user_id")
    let title = Expression<String?>("title")
    let body = Expression<String?>("body")
    enum Tables {
        case users
        case posts
    }
    
    init() {
        do {
            path = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("UsersList.sqlite").relativePath
        } catch let error {
            print("DatabaseManager.init()-> Unable to create file: \(error)")
            path = ""
        }
        do {
            db = try Connection(path)
        } catch let error {
            print("DatabaseManager.init()-> Unable to create database: \(error)")
            db = nil
        }
        setup()
    }
    
    func setup() {
        do {
            try db?.run(users.create { t in
                t.column(id, primaryKey: true)
                t.column(name)
                t.column(phone)
                t.column(email, unique: true)
            })
            try db?.run(posts.create { t in
                t.column(id, primaryKey: true)
                t.column(userId)
                t.column(title)
                t.column(body)
            })
        } catch let error {
            print("DatabaseManager.setup()-> Unable to create tables: \(error)")
        }
    }
    
    func insert<T>(into: Tables, _ register: T) {
        guard let user = register as? User else {
            print("DatabaseManager.insert()-> The provided object is not an user")
            return
        }
        switch into {
        case .users:
            let insert = users.insert(id <- Int64(user.id), name <- user.name, email <- user.email, phone <- user.phone)
            do {
                try db?.run(insert)
            } catch let error {
                print("DatabaseManager.insert()-> Unable to insert user: \(error)")
            }
        case .posts:
            for post in user.posts ?? [] {
                let insert = posts.insert(id <- Int64(post.id), userId <- Int64(user.id), title <- post.title, body <- post.body)
                do {
                    try db?.run(insert)
                } catch let error {
                    print("DatabaseManager.insert()-> Unable to insert post: \(error)")
                }
            }
        }
    }
    
    func select<T>(from: Tables) -> [T] {
        switch from {
        case .users:
            do {
                guard let results = try db?.prepare(users) else {
                    print("DatabaseManager.select(from)-> Unable to unwrap results.")
                    return []
                }
                var users: [User] = []
                for user in results {
                    users.append(User(id: Int(user[id]), name: user[name] ?? "", email: user[email], phone: user[phone] ?? ""))
                }
                return users as! [T]
            } catch let error {
                print("DatabaseManager.select(from)-> Error fetching data from the database: \(error)")
            }
        case .posts:
            fatalError("DatabaseManager.select(from)-> Case not yet implemented.")
        }
        return []
    }
    
    func select<T>(from: Tables, associatedWith user: User) -> [T] {
        switch from {
        case .users:
            fatalError("DatabaseManager.select(from)-> Case not yet implemented.")
        case .posts:
            do {
                let filteredPosts = posts.filter(userId == Int64(user.id))
                guard let results = try db?.prepare(filteredPosts) else {
                    print("DatabaseManager.select(from, associatedWith)-> Unable to unwrap results.")
                    return []
                }
                var posts: [Post] = []
                for post in results {
                    posts.append(Post(id: Int(post[id]), title: post[title] ?? "", body: post[body] ?? ""))
                }
                return posts as! [T]
            } catch let error {
                print("DatabaseManager.select(from, associatedWith)-> Error fetching data from the database: \(error)")
            }
        }
        return []
    }
}
