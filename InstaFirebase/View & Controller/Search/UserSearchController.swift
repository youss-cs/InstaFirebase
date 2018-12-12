//
//  UserSearchController.swift
//  InstaFirebase
//
//  Created by YouSS on 12/11/18.
//  Copyright © 2018 YouSS. All rights reserved.
//

import UIKit

class UserSearchController: UITableViewController,  UISearchResultsUpdating {
    
    var users = [User]()
    var filtredUsers = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        definesPresentationContext = true
        
        setupTableView()
        setupSearchBar()
        
        UserService.instance.fetchUsers { (users) in
            if let loggedUserId = AuthService.instance.currentUser()?.id {
                self.users = users.filter{$0.id != loggedUserId}
            }
            self.filtredUsers = users
            self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filtredUsers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kCELLID, for: indexPath) as! UserSearchCell
        cell.user = filtredUsers[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = filtredUsers[indexPath.row]
        let userProfile = UserProfileController(collectionViewLayout: UICollectionViewFlowLayout())
        userProfile.user = user
        navigationController?.pushViewController(userProfile, animated: true)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        filtredUsers = text.isEmpty ? users : filtredUsers.filter({$0.username.contains(text)})
        tableView.reloadData()
    }
    
    fileprivate func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.register(UserSearchCell.self, forCellReuseIdentifier: kCELLID)
    }
    
    fileprivate func setupSearchBar() {
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Type something here to search"
        navigationItem.searchController = search
    }
}
