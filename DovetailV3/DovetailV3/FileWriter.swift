//
//  FileWriter.swift
//  DovetailV3
//
//  Created by Abhijit Kalamkar on 5/11/16.
//  Copyright © 2016 Dovetail Care. All rights reserved.
//

import Foundation

class FileWriter {
    
    private let filename: String
    private var data: NSMutableData = NSMutableData()
    
    init(tags: String) {
        filename = FileWriter.createArrayPath(tags)
    }
    
    func update(chunk: NSData) {
        data.appendData(chunk)
    }
    
    func close() {
        data.writeToFile(filename, atomically: true)
        Utils.addToUploadQueue(filename)
    }

    static func createArrayPath (tags: String) -> String {
        let formatter: NSDateFormatter = NSDateFormatter.init()
        formatter.dateFormat = "MMM-dd-kk-mm-ss"
        let tempDirPath: NSString = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        let date: NSString = formatter.stringFromDate(NSDate.init())
        let path: NSString = tempDirPath.stringByAppendingPathComponent("Dovetail-\(date)_\(tags)")
        return path.stringByAppendingPathExtension("raw")!
    }
}