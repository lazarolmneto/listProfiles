//
//  ProfileTableViewController.swift
//  ListProfiles
//
//  Created by Lazaro Neto on 29/09/16.
//  Copyright © 2016 Lazaro. All rights reserved.
//

import UIKit
import MBProgressHUD
import Alamofire
import AlamofireImage
import SwiftyJSON

class ProfileTableViewController: UITableViewController {
    
    //Variables
    var profiles          = [Profile]()
    var searchingProfiles = [Profile]()
    let searchController  = UISearchController(searchResultsController: nil)
    
    var emptyView : EmptyView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchBar.delegate               = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext                        = true
        tableView.tableHeaderView                         = searchController.searchBar
        
        createProfiles()
        tableView.tableFooterView = UIView(frame: CGRectZero)
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
        cell.imageProfile.image = UIImage()
        if searchController.active && searchController.searchBar.text != ""{
            cell.profile = searchingProfiles[indexPath.row]
        }else{
            cell.profile = profiles[indexPath.row]
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("ShowDetailSegue", sender: self)
    }
    
    func createProfiles(){
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        Manager.sharedInstance.request(.GET, "http://adeem.de/affinitas/profiles.php?action=list").responseJSON { (response) in
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            if let statusCode = response.response?.statusCode{
                switch statusCode{
                case 200...204:
                    print(response.result.value)
                    if let value = response.result.value{
                        let json = JSON(value)
                        if json["success"].boolValue{
                            self.parteJsonTolist(json)
                        }else{
                            self.addEmptyView()
                        }
                    }
                default:
                    print(response)
                    self.addEmptyView()
                }
            }
        }
    }
    
    func parteJsonTolist(jsonList : JSON){
        if let arrayDict = jsonList["data"].arrayObject{
            for dict in arrayDict{
                let jsonDict = JSON(dict)
                profiles.append(Profile(from: jsonDict))
            }
        }
        
        tableView.reloadData()
    }
    
    func retryGetList(){
        emptyView?.removeFromSuperview()
        createProfiles()
    }
    
    func addEmptyView(){
        if let emptyView = NSBundle.mainBundle().loadNibNamed("EmptyView", owner: EmptyView(), options: nil).first as? EmptyView{
            self.emptyView                       = emptyView
            emptyView.frame                      = tableView.frame
            emptyView.btRetry.layer.cornerRadius = emptyView.btRetry.frame.size.height / 2
//            emptyView.btRetry.clipsToBounds      = true
            emptyView.btRetry.addTarget(self, action: #selector(retryGetList), forControlEvents: .TouchUpInside)
            tableView.addSubview(emptyView)
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
