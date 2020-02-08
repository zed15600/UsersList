//
//  UserTableView.swift
//  UsersList
//
//  Created by user164501 on 2/7/20.
//  Copyright © 2020 EdisonZ. All rights reserved.
//

import UIKit

class UserTableViewController : UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    private let cellIdentifier = "UserTableViewCell"
    private let emptyCellIdentifier = "EmptySearchCell"
    private var users: [User] = []
    private var filteredUsers: [User] = []
    private let searchController = UISearchController(searchResultsController: nil)
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }

    override func viewDidLoad() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        var nib = UINib(nibName: cellIdentifier, bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: cellIdentifier)
        nib = UINib(nibName: emptyCellIdentifier, bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: emptyCellIdentifier)
        
        //Cehck for data in the db
        users = DatabaseManager.sharedInstance.select(from: .users)
        if (users.isEmpty) {
            //Fetch data
            self.activityIndicator.startAnimating()
            RequestManager.sharedInstance.fetchUsers() {success, results in
                if (success) {
                    self.users = results
                    for user in self.users {
                        DatabaseManager.sharedInstance.insert(into: .users, user)
                    }
                    self.tableView.reloadData()
                    self.activityIndicator.stopAnimating()
                }
            }
        }
        
        //Configure Search controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Buscar"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
}

//MARK: TableView
extension UserTableViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user: User
        if isFiltering {
            if (filteredUsers.count > 0) {
                user = filteredUsers[indexPath.row]
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: self.emptyCellIdentifier) else {
                    print("UserTableViewController.tableView(cellforRowAt): Failed to dequeue empty search cell.")
                    return UITableViewCell(frame: CGRect.zero)
                }
                return cell
            }
        } else {
            user = users[indexPath.row]
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier) as? UserTableViewCell else {
            print("UserTableViewController.tableView(cellforRowAt): Failed to dequeue user cell.")
            return UITableViewCell(frame: CGRect.zero)
        }
        cell.user = user
        cell.configure()
        cell.delegate = self
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredUsers.count > 0 ? filteredUsers.count : 1
        }
        return users.count
    }
}

//MARK: CellDelegate
extension UserTableViewController : UserCellDelegate {
    func showDetails(for user: User?) {
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserPostsViewController") as! UserPostsViewController
        controller.user = user
        navigationController!.pushViewController(controller, animated: true)
    }
}

//MARK: SearchController
extension UserTableViewController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
    func filterContentForSearchText(_ searchText: String) {
        filteredUsers = users.filter { (user: User) -> Bool in
            user.name.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
    }
}
