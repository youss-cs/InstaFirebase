//
//  UserSearchController.swift
//  InstaFirebase
//
//  Created by YouSS on 12/11/18.
//  Copyright © 2018 YouSS. All rights reserved.
//

import UIKit

class UserSearchController: UITableViewController,  UISearchResultsUpdating {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        definesPresentationContext = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UserSearchCell.self, forCellReuseIdentifier: kCELLID)
        
        setupSearchBar()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kCELLID, for: indexPath) as! UserSearchCell
        return cell
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        print(text)
    }
    
    fileprivate func setupSearchBar() {
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Type something here to search"
        navigationItem.searchController = search
    }
}
