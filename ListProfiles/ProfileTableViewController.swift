//
//  ProfileTableViewController.swift
//  ListProfiles
//
//  Created by Lazaro Neto on 29/09/16.
//  Copyright © 2016 Lazaro. All rights reserved.
//

import UIKit

class ProfileTableViewController: UITableViewController {
    
    //Variables
    var profiles          = [Profile]()
    var searchingProfiles = [Profile]()
    let searchController  = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchBar.delegate               = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext                        = true
        tableView.tableHeaderView                         = searchController.searchBar
        
        createProfiles()
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active && searchController.searchBar.text != ""{
            return searchingProfiles.count
        }
        
        return profiles.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("profileCell", forIndexPath: indexPath) as! ProfileCellTableViewCell
        
        
        if searchController.active && searchController.searchBar.text != ""{
            cell.profile = searchingProfiles[indexPath.row]
        }else{
            cell.profile = profiles[indexPath.row]
        }
        
        return cell
    }
    
    func createProfiles(){
        for index in 0...10{
            let profile       = Profile()
            profile.age       = index
            profile.city      = "Curitiba"
            profile.firstName = "Lazaro neto \(index)"
            profile.imageUrl  = "http://adeem.de/affinitas/iStock_000022079835Medium_595.jpg"
            
            profiles.append(profile)
        }
    }
}

extension ProfileTableViewController : UISearchBarDelegate{

    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        searchingProfiles = profiles.filter({ (profile) -> Bool in
            if let firstName = profile.firstName, searchText = searchBar.text{
                return firstName.containsString(searchText)
            }
            return false
        })
        
        tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        
        
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.text = ""
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
    }
}
