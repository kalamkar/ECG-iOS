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
        defaults.synchronize()
    }
    
    static func addToUploadQueue(filename: String) {
        var queue: [String] = getUploadQueue()
        queue.append(filename)
        setUploadQueue(queue)
        uploadRecordings()
    }

    static func setUploadQueue(queue: [String]) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(queue, forKey: "UPLOAD_QUEUE")
        defaults.synchronize()
    }

    static func getUploadQueue() -> [String] {
        let defaults = NSUserDefaults.standardUserDefaults()
        let object = defaults.objectForKey("UPLOAD_QUEUE")
        return object != nil ? object as! [String] : []
    }
    
    static func uploadRecordings() {
        var queue: [String] = getUploadQueue()
        if (queue.count > 0) {
            RecordingUploadTask(filename: queue[0]).run();
        }
    }

    static func getUIState() -> UIApplicationState {
        return UIApplication.sharedApplication().applicationState
    }
}