//
//  UserTableView.swift
//  UsersList
//
//  Created by user164501 on 2/7/20.
//  Copyright © 2020 EdisonZ. All rights reserved.
//

import UIKit

class UserTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    private let cellIdentifier = "UserTableViewCell"
    private var users: [User] = []

    override func viewDidLoad() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        let nib = UINib(nibName: cellIdentifier, bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: cellIdentifier)
        
        //Fetch data
        self.activityIndicator.startAnimating()
        RequestManager.sharedInstance.fetcUsers() {success, results in
            if (success) {
                self.users = results
                self.tableView.reloadData()
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? UserTableViewCell else {
            print("UserTableViewController.tableView(cellforRowAt): Failed to dequeue cell.")
            return UITableViewCell(frame: CGRect.zero)
        }
        let user = users[indexPath.item]
        cell.name.text = user.name
        cell.phone.text = user.phone
        cell.mail.text = user.email
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        users.count
    }

}
