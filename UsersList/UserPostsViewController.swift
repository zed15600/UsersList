//
//  UserPostsViewController.swift
//  UsersList
//
//  Created by user164501 on 2/8/20.
//  Copyright © 2020 EdisonZ. All rights reserved.
//

import UIKit

class UserPostsViewController: UIViewController {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var mail: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var user: User?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        if let user = user {
            name.text = user.name
            phone.text = user.phone
            mail.text = user.email
            
            //check for posts in the db
            user.posts = DatabaseManager.sharedInstance.select(from: .posts, associatedWith: user)
            if (user.posts?.isEmpty ?? true) {
                //fetch posts
                activityIndicator.startAnimating()
                RequestManager.sharedInstance.fetchPosts(for: user) {success in
                    if (success) {
                        DatabaseManager.sharedInstance.insert(into: .posts, user)
                        self.tableView.reloadData()
                        self.activityIndicator.stopAnimating()
                    }
                }
            }
        }
    }
}

extension UserPostsViewController :  UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        user?.posts?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell") as? PostTableViewCell else {
            print("UserPostsTableViewController.tableView(cellforRowAt): Failed to dequeue post cell.")
            return UITableViewCell(frame: CGRect.zero)
        }
        cell.post = user?.posts![indexPath.row]
        cell.configure()
        return cell
    }
}
