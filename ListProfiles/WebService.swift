//
//  WebService.swift
//  ListProfiles
//
//  Created by Lazaro on 30/09/16.
//  Copyright © 2016 Lazaro. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

let sharedWebservice = WebService()

//Typealias with the values of result of the webService.
typealias resultResponse = (value: AnyObject?, success: Bool, error : NSError?) -> Void

class WebService: NSObject {
    
    func getProfiles(result : resultResponse) {
        let url = "http://adeem.de/affinitas/profiles.php?action=list"
        
        Manager.sharedInstance.request(.GET, url).responseJSON { (response) in
            if let statusCode = response.response?.statusCode{
                //Verify with status is success
                //if success return the list of profiles
                //if not, return a error
                switch statusCode{
                case 200...204:
                    print(response.result.value)
                    if let value = response.result.value{
                        let json = JSON(value)
                        if json["success"].boolValue{
                            let profiles = json["data"].arrayValue.map { Profile(withJSON: $0) }
                            result(value: profiles, success: true, error: nil)
                        }else{
                            let error = NSError(domain: "", code: 1, userInfo: ["detail" : "Could not complete de operation"])
                            result(value: nil, success: false, error: error)
                        }
                    }
                default:
                    print(response)
                    let error = NSError(domain: "", code: 1, userInfo: ["detail" : "Could not complete de operation"])
                    result(value: nil, success: false, error: error)
                }
            }else{
                let error = NSError(domain: "Client", code: 1, userInfo: ["detail" : "Unable to connect, please verify the status of your internet connection"])
                result(value: nil, success: false, error: error)
            }
        }
    }
    
    func getDetailsFromProfile(uuid : String, result : resultResponse){
        
        let url = "http://adeem.de/affinitas/profiles.php?action=detail&id=\(uuid)"
        Manager.sharedInstance.request(.GET, url).responseJSON(completionHandler: { (response) in
           if let statusCode = response.response?.statusCode{
                //Verify status from service
                //if success return the list of profiles
                //if not, return a error
                switch statusCode{
                case 200...204:
                    if let value = response.result.value{
                        let json = JSON(value)
                        if json["success"].boolValue{
                            if let dict = json["data"].dictionaryObject{
                                let jsonProfile = JSON(dict)
                                let profile = Profile(withJSON: jsonProfile)
                                result(value: profile, success: true, error: nil)
                            }
                        }else{
                            let error = NSError(domain: "", code: 1, userInfo: ["detail" : "Could not complete de operation"])
                            result(value: nil, success: false, error: error)
                        }
                    }
                default:
                    print(response)
                    let error = NSError(domain: "", code: 1, userInfo: ["detail" : "Could not complete de operation"])
                    result(value: nil, success: false, error: error)
                }
            }else{
                let error = NSError(domain: "Client", code: 1, userInfo: ["detail" : "Unable to connect, please verify the status of your internet connection"])
                result(value: nil, success: false, error: error)
            }
        })
        
    }
    
}
