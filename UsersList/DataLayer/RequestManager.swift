//
//  RequestManager.swift
//  UsersList
//
//  Created by user164501 on 2/7/20.
//  Copyright © 2020 EdisonZ. All rights reserved.
//

import Foundation
import Alamofire

class RequestManager {
    private enum Url {
        static let base = "https://jsonplaceholder.typicode.com/%@"
        enum Target {
            static let users = "users"
            static let posts = "posts?userId=%@"
        }
    }
    static let sharedInstance = RequestManager()
    var manager: SessionManager!
    
    private init() {
        self.manager = Alamofire.SessionManager.default
        self.manager.session.configuration.timeoutIntervalForRequest = 10
    }
    
    func fetchUsers(handler: @escaping(_ success: Bool, _ results: [User]) -> Void) {
        let headers: HTTPHeaders = ["Accept": "application/json"]
        self.manager.request(
            String(format: Url.base, Url.Target.users),
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: headers).responseJSON { response -> Void in
                if (response.result.isFailure) {
                    handler(false,[])
                } else {
                    let decoder = JSONDecoder()
                    do {
                        let users = try decoder.decode([User].self, from: response.data!)
                        handler(true, users)
                    } catch let error {
                        print("RequestManager.fetchUsers(): \(error)")
                    }
                }
        }
    }
    
    func fetchPosts(for user: User, handler: @escaping(_ success: Bool) -> Void) {
        let headers: HTTPHeaders = ["Accept": "application/json"]
        let url = String(format: Url.base, Url.Target.posts)
        self.manager.request(
            String(format: url, "\(user.id)"),
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: headers).responseJSON { response -> Void in
                if (response.result.isFailure) {
                    handler(false)
                } else {
                    let decoder = JSONDecoder()
                    do {
                        let posts = try decoder.decode([Post].self, from: response.data!)
                        user.posts = posts
                        handler(true)
                    } catch let error {
                        print("RequestManager.fetchUsers(): \(error)")
                    }
                }
        }
    }
}
