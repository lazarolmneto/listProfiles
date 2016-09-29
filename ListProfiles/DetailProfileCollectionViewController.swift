//
//  DetailProfileCollectionViewController.swift
//  ListProfiles
//
//  Created by Lazaro on 29/09/16.
//  Copyright © 2016 Lazaro. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
import SwiftyJSON

private let reuseIdentifier = "imageCell"

class DetailProfileCollectionViewController: UICollectionViewController {

    var profile = Profile()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let flow = collectionView!.collectionViewLayout as! UICollectionViewFlowLayout
        flow.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        let width = UIScreen.mainScreen().bounds.size.width - 6
        flow.itemSize = CGSizeMake(width/3, width/3)
        flow.minimumInteritemSpacing = 3
        flow.minimumLineSpacing = 3
        loadDetails()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let totalImages = profile.totalImages{
            return totalImages
        }
        
        return 0
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! ImageProfileCollectionViewCell

        if let imageURL = profile.imageUrl{
            if let url = NSURL(string: imageURL){
                cell.imageProfile.af_setImageWithURL(url)
            }
        }
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "HeaderCollectionDetail", forIndexPath: indexPath) as! HeaderDetailCollectionReusableView
            
            header.profile = profile
            return header
        default:
            assert(false, "Unexpected element kind")
        }
    }
    
    func loadDetails(){
        if let uuid = profile.uuid{
            view.userInteractionEnabled = false
            MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            let url = "http://adeem.de/affinitas/profiles.php?action=detail&id=\(uuid)"
            Manager.sharedInstance.request(.GET, url).responseJSON(completionHandler: { (response) in
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                self.view.userInteractionEnabled = true
            
                if let statusCode = response.response?.statusCode{
                    switch statusCode{
                    case 200...204:
                        if let value = response.result.value{
                            let json = JSON(value)
                            if json["success"].boolValue{
                                self.pardeJsonProfile(json)
                            }else{
//                                self.addEmptyView()
                            }
                        }
                    default:
                        print(response)
//                        self.addEmptyView()
                    }
                }
            })
        }
    }
    
    func pardeJsonProfile(json : JSON){
        if let dict = json["data"].dictionaryObject{
            let jsonProfile = JSON(dict)
            self.profile = Profile(from: jsonProfile)
            collectionView?.reloadData()
        }
    }
}
