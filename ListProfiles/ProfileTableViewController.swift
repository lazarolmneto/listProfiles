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
    
    var emptyView       : EmptyView?
    var profileSelected : Profile?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Attribute the delegate(self) to the searchController/
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
        //Verify with the search bar is active
        if searchController.active && searchController.searchBar.text != ""{
            return searchingProfiles.count
        }
        
        return profiles.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("profileCell", forIndexPath: indexPath) as! ProfileCellTableViewCell
        cell.imageProfile.image = UIImage()
      
        //Verify with the search bar is active
        if searchController.active && searchController.searchBar.text != ""{
            cell.profile = searchingProfiles[indexPath.row]
        }else{
            cell.profile = profiles[indexPath.row]
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        profileSelected = profiles[indexPath.row]
        performSegueWithIdentifier("ShowDetailSegue", sender: self)
    }
    
    
    //Call service and fill the array with new profiles.
    func createProfiles(){
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        view.userInteractionEnabled = false
        
        sharedWebservice.getProfiles { (value, success, error) in
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            self.view.userInteractionEnabled = true
            if success{
                if let value = value as? [Profile]{
                    self.profiles = value
                    self.animateTable()
                }
            }else{
                if let dictUser = error?.userInfo, let detail = dictUser["detail"] as? String{
                    self.addEmptyView(detail)
                }
            }
        }
    }
    
    func parteJsonTolist(jsonList : JSON){
        
        self.profiles = jsonList["data"].arrayValue.map { Profile(withJSON: $0) }
        
        //Call animation of tableView
        animateTable()
    }
    
    func retryGetList(){
        //Try get the profiles again, display a activity indicator indicating the "progress"
        emptyView?.activityIndicator.hidden = false
        emptyView?.activityIndicator.startAnimating()
        emptyView?.btRetry.setTitle("", forState: .Normal)
        emptyView?.btRetry.enabled = false
        
        sharedWebservice.getProfiles { (value, success, error) in
            self.emptyView?.activityIndicator.stopAnimating()
            self.emptyView?.activityIndicator.hidden = true
            self.emptyView?.btRetry.enabled          = true
            if success{
                if let value = value as? [Profile]{
                    self.emptyView?.removeFromSuperview()
                    self.profiles = value
                    self.animateTable()
                }
            }else{
                if let dictUser = error?.userInfo, let detail = dictUser["detail"] as? String{
                    self.addEmptyView(detail)
                }
            }
        }
    }
    
    //Function to add a Error View, with the possibility that the user try load data again
    func addEmptyView(messageError : String){
        emptyView?.removeFromSuperview()
        
        if let emptyView = NSBundle.mainBundle().loadNibNamed("EmptyView", owner: EmptyView(), options: nil).first as? EmptyView{
            self.emptyView                       = emptyView
            emptyView.frame                      = tableView.frame
            emptyView.btRetry.layer.cornerRadius = emptyView.btRetry.frame.size.height / 2
            emptyView.labelDescError.text        = messageError
            emptyView.activityIndicator.hidden   = true
            emptyView.btRetry.addTarget(self, action: #selector(retryGetList), forControlEvents: .TouchUpInside)
            
            tableView.addSubview(emptyView)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //Sending the selected profile to DetailView
        if segue.identifier == "ShowDetailSegue"{
            if let detailColletion = segue.destinationViewController as? DetailProfileCollectionViewController{
                if let profileSelected = profileSelected{
                    detailColletion.profile = profileSelected
                }
            }
        }
    }
    
    func animateTable() {
        self.tableView.reloadData()
        
        let cells = tableView.visibleCells;
        let tableHeight: CGFloat = tableView.bounds.size.height
        
        for i in cells {
            let cell: UITableViewCell = i as UITableViewCell
            cell.transform = CGAffineTransformMakeTranslation(0, tableHeight)
        }
        
        var index = 0
        
        for a in cells {
            let cell: UITableViewCell = a as UITableViewCell
            
            UIView.animateWithDuration(1.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseIn, animations: {
                cell.transform = CGAffineTransformMakeTranslation(0, 0);
                }, completion: nil)
            
            index += 1
        }
    }
}

extension ProfileTableViewController : UISearchBarDelegate{

    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        //Searching for profiles ignoring case
        
        searchingProfiles = profiles.filter({ (profile) -> Bool in
            if let firstName = profile.firstName, searchText = searchBar.text{
                return firstName.lowercaseString.containsString(searchText.lowercaseString)
            }
            return false
        })
        
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.text = ""
        tableView.reloadData()
    }
}
