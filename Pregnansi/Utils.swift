//
//  Utils.swift
//  Pregnansi
//
//  Created by Abhijit Kalamkar on 9/24/15.
//  Copyright © 2015 Dovetail Care. All rights reserved.
//

import Foundation
import UIKit

class Utils {
    static func makeAuthHeader(uuid: String, auth: String) -> String {
        return "UUID-TOKEN uuid=\"\(uuid)\", token=\"\(auth)\"";
    }
    
    
    static func sharedInstance() -> AppDelegate {
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }
    
    static func getStoredCredentials() -> [String]? {
        let defaults = NSUserDefaults.standardUserDefaults()
        let uuid: String? = defaults.stringForKey("UUID")
        let auth: String? = defaults.stringForKey("AUTH")
        if (uuid != nil && auth != nil) {
            return [uuid!, auth!]
        }
        return nil
    }
    
    static func setStoredCredentials(uuid: String?, auth: String?) {
        if (uuid == nil || auth == nil) {
            print("Nil UUID or AUTH cannot be stored")
            return
        }
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(uuid, forKey: "UUID")
        defaults.setObject(auth, forKey: "AUTH")
    }

    static func getWeighingScale() -> NSUUID? {
        let defaults = NSUserDefaults.standardUserDefaults()
        let address: String? = defaults.stringForKey("WEIGHING_SCALE")
        return address != nil ? NSUUID(UUIDString: address!) : nil
    }

    static func setWeighingScale(identifier: NSUUID) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(identifier.UUIDString, forKey: "WEIGHING_SCALE")
    }
}