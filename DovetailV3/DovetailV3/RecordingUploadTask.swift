//
//  RecordingUploadTask.swift
//  DovetailV3
//
//  Created by Abhijit Kalamkar on 5/11/16.
//  Copyright © 2016 Dovetail Care. All rights reserved.
//

import Foundation

class RecordingUploadTask {
    
    private let BOUNDARY: String =  "*****"
    
    private let tags: String
    private let filename: String
    private let data: NSData?
    
    init(filename: String) {
        self.filename = filename
        self.data = NSData(contentsOfFile: filename)
        let tokens: [String] = filename.characters.split("/").map(String.init)
        var tags = tokens.last!.stringByReplacingOccurrencesOfString("_", withString: ",")
        tags = tags.stringByReplacingOccurrencesOfString("Dovetail-", withString: "")
        self.tags = tags.stringByReplacingOccurrencesOfString(".raw", withString: "")
    }
    
    func run() {
        if (data == nil) {
            print("File data is nil for \(filename), removing it.")
            removeFileFromQueue()
            return
        }
        
        let request = NSMutableURLRequest(URL: NSURL(string: Config.RECORDING_URL)!)
        request.HTTPMethod = "POST"
        
        let params = [ "tags"  : tags ]
        
        request.setValue("multipart/form-data; boundary=\(BOUNDARY)", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = createBodyWithParameters(params, data: self.data!)

        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil {
                print("\(error?.localizedDescription)")
                return
            }
            
            let responseCode = (response as! NSHTTPURLResponse).statusCode
            if (responseCode == 200) {
                self.removeFileFromQueue()
            }
        }
        task.resume()
    }
    
    private func createBodyWithParameters(parameters: [String: String], data: NSData) -> NSData {
        let body = NSMutableData()
        
        for (key, value) in parameters {
            body.appendString("--\(BOUNDARY)\r\n")
            body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.appendString("\(value)\r\n")
        }
        
        let contentType = "application/binary"
        body.appendString("--\(BOUNDARY)\r\n")
        body.appendString("Content-Disposition: form-data; name=\"file\"; filename=\"filename\"\r\n")
        body.appendString("Content-Type: \(contentType)\r\n\r\n")
        body.appendData(data)
        body.appendString("\r\n")
        
        body.appendString("--\(BOUNDARY)--\r\n")
        return body
    }
    
    private func removeFileFromQueue() {
        var queue = Utils.getUploadQueue()
        queue.removeAtIndex(queue.indexOf(self.filename)!)
        Utils.setUploadQueue(queue)
        Utils.uploadRecordings()
    }
}

extension NSMutableData {
    func appendString(string: String) {
        appendData(string.dataUsingEncoding(NSUTF8StringEncoding)!)
    }
}