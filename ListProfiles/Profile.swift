//
//  Profile.swift
//  ListProfiles
//
//  Created by Lazaro Neto on 29/09/16.
//  Copyright © 2016 Lazaro. All rights reserved.
//

import UIKit
import SwiftyJSON

class Profile: NSObject {

    var uuid            : String?
    var imageUrl        : String?
    var firstName       : String?
    var age             : Int?
    var city            : String?
    var postCode        : String?
    var job             : String?
    var smoke           : Bool?
    var wishChildren    : Bool?
    var totalImages     : Int?
    
    override init() {}
    
    init(from json: JSON) {
        uuid         = json["id"].stringValue
        imageUrl     = json["image_url"].stringValue
        firstName    = json["firstname"].stringValue
        age          = json["age"].intValue
        city         = json["city"].stringValue
        postCode     = json["postcode"].stringValue
        job          = json["job"].stringValue
        smoke        = json["smoke"].boolValue
        wishChildren = json["wish_for_children"].boolValue
        totalImages  = json["total_images"].intValue
    }
    
    func toDictonary()->[String : AnyObject]{
        var dict = [String : AnyObject]()
    
        dict["id"]                = uuid
        dict["image_url"]         = imageUrl
        dict["firstname"]         = firstName
        dict["age"]               = age
        dict["city"]              = city
        dict["job"]               = job
        dict["postcode"]          = postCode
        dict["smoke"]             = smoke
        dict["wish_for_children"] = wishChildren
        dict["total_images"]      = totalImages
        
        return dict
    }
    
    func toJSON()->JSON{
        return JSON(toDictonary())
    }
}
