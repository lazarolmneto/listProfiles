//
//  HeaderDetailCollectionReusableView.swift
//  ListProfiles
//
//  Created by Lazaro on 29/09/16.
//  Copyright © 2016 Lazaro. All rights reserved.
//

import UIKit

class HeaderDetailCollectionReusableView: UICollectionReusableView {
        
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var labelFirstName: UILabel!
    @IBOutlet weak var labelAge: UILabel!
    @IBOutlet weak var labelCity: UILabel!
    @IBOutlet weak var labelPostalCOde: UILabel!
    @IBOutlet weak var labelJob: UILabel!
    @IBOutlet weak var labelSmoke: UILabel!
    @IBOutlet weak var labelWishChildren: UILabel!
    @IBOutlet weak var imageBackGround: UIImageView!
    
    var profile : Profile?{
        didSet{
            fillElements()
        }
    }
    
    func fillElements(){
        if let firstname = profile?.firstName{
            labelFirstName.text = firstname
        }
        
        if let age = profile?.age{
            labelAge.text = "\(age)"
        }
        
        if let city = profile?.city{
            labelCity.text = city
        }
        
        if let postCode = profile?.postCode{
            labelPostalCOde.text = postCode
        }
        
        if let job = profile?.job{
            labelJob.text = job
        }
        
        if let smoke = profile?.smoke{
            labelSmoke.text = "No"
            if smoke{
                labelFirstName.text = "Yes"
            }
        }
        
        if let wishChildren = profile?.wishChildren{
            labelWishChildren.text = "No"
            if wishChildren{
                labelWishChildren.text = "Yes"
            }
        }
        
        if let imageURL = profile?.imageUrl{
            if let url = NSURL(string: imageURL){
                imageProfile.af_setImageWithURL(url)
                imageBackGround.af_setImageWithURL(url)
//                let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
//                let blurEffectView = UIVisualEffectView(effect: blurEffect)
//                blurEffectView.frame = imageBackGround.bounds
//                
//                blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight] // for supporting device rotation
//                imageBackGround.addSubview(blurEffectView)

            }
        }

        for sub in imageBackGround.subviews{
            sub.removeFromSuperview()
        }
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.ExtraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = imageBackGround.bounds
        
        blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight] // for supporting device rotation
        imageBackGround.addSubview(blurEffectView)
        
        imageProfile.layer.cornerRadius = imageProfile.frame.size.height / 2
        imageProfile.clipsToBounds      = true
    }
}
