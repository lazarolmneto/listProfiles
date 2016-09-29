//
//  ProfileCellTableViewCell.swift
//  ListProfiles
//
//  Created by Lazaro Neto on 29/09/16.
//  Copyright © 2016 Lazaro. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SDWebImage

class ProfileCellTableViewCell: UITableViewCell {

    @IBOutlet weak var imageProfile     : UIImageView!
    @IBOutlet weak var labelFirstName   : UILabel!
    @IBOutlet weak var labelAge         : UILabel!
    @IBOutlet weak var labelCity        : UILabel!
    
    var imageDownloaded  : UIImage?
    
    var profile : Profile?{
        didSet{
            fillElements()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func fillElements(){
        if let firstName = profile?.firstName{
            labelFirstName.text = firstName
        }
        
        if let age = profile?.age{
            labelAge.text = "\(age)"
        }
        
        if let city = profile?.city{
            labelCity.text = city
        }
        
        imageProfile.image = UIImage()
        
//        if let imageDownloaded = imageDownloaded{
//            imageProfile.image = imageDownloaded
//?        }else{
            if let imageUrl = profile?.imageUrl{
                //TODO - Create a service to load the image
                print(imageUrl)
//                imageProfile.sd_setImageWithURL(NSURL(string: imageUrl)!)
                imageProfile.af_setImageWithURL(NSURL(string: imageUrl)!)
                imageProfile.layer.cornerRadius = imageProfile.frame.size.width / 2
                imageProfile.clipsToBounds = true
            }
//        }
    }

}
