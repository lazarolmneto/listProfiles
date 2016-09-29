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

class ProfileCellTableViewCell: UITableViewCell {

    @IBOutlet weak var imageProfile     : UIImageView!
    @IBOutlet weak var labelFirstName   : UILabel!
    @IBOutlet weak var labelAge         : UILabel!
    @IBOutlet weak var labelCity        : UILabel!
    
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
        
        if let imageUrl = profile?.imageUrl{
            //TODO - Create a service to load the image
            print(imageUrl)
            Manager.sharedInstance.request(.GET, imageUrl).responseImage(completionHandler: { (response) in
                debugPrint(response)
                
                print(response.request)
                print(response.response)
                debugPrint(response.result)
                
                if let image = response.result.value {
                    print("image downloaded: \(image)")
                    self.imageProfile.image              = image
                    self.imageProfile.layer.cornerRadius = self.imageProfile.frame.size.width / 2
                    self.imageProfile.clipsToBounds      = true
                }
            })
        }
    }

}
