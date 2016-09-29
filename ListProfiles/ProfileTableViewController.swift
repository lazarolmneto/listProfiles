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
        profileSelected = profiles[indexPath.row]
        performSegueWithIdentifier("ShowDetailSegue", sender: self)
    }
    
    func createProfiles(){
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        view.userInteractionEnabled = false
        Manager.sharedInstance.request(.GET, "http://adeem.de/affinitas/profiles.php?action=list").responseJSON { (response) in
            self.view.userInteractionEnabled = true
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
            }else{
                self.addEmptyView()
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
        
//        tableView.reloadData()
        animateTable()
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
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
