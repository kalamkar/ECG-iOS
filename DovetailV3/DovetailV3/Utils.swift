//
//  Utils.swift
//  DovetailV3
//
//  Created by Abhijit Kalamkar on 5/9/16.
//  Copyright © 2016 Dovetail Care. All rights reserved.
//

import Foundation
import UIKit

class Utils {
    
    static func sharedInstance() -> AppDelegate {
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }
    
    static func getRecordingTags() -> String? {
        let defaults = NSUserDefaults.standardUserDefaults()
        return defaults.stringForKey("RECORDING_TAGS")
    }
    
    static func setRecordingTags(tags: String?) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(tags, forKey: "RECORDING_TAGS")
    }

    static func getUIState() -> UIApplicationState {
        return UIApplication.sharedApplication().applicationState
    }
}