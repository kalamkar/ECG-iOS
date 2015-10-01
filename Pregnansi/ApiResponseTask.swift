//
//  ApiResponseTask.swift
//  Pregnansi
//
//  Created by Abhijit Kalamkar on 9/25/15.
//  Copyright © 2015 Dovetail Care. All rights reserved.
//

import Foundation

class ApiResponseTask {
    
    let request: NSMutableURLRequest

    init(url: String) {
        request = NSMutableURLRequest(URL: NSURL(string: url)!)
//        let app: AppDelegate = Utils.sharedInstance()
//        if (app.user != nil && app.user?.uuid != nil && app.user?.auth != nil) {
//            let uuid = (app.user?.uuid!)!
//            let auth = (app.user?.auth!)!
            request.addValue(Utils.makeAuthHeader(Config.uuid, auth: Config.auth), forHTTPHeaderField: "Authorization")
//        }
    }
    
    func execute() {
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(self.request) {
            data, response, error -> Void in

            if (error != nil) {
                print(error!.localizedDescription)
                self.onError(error!.localizedDescription)
                return
            } else if (data == nil) {
                self.onError("Null response from \(self.request.URL!)")
                return
            }
            let json: JSON = JSON(data: data!)
            if (json == nil) {
                self.onError("Null response from \(self.request.URL!)")
                return
            } else if (json["code"].string != "OK") {
                if (json["message"].string != nil) {
                    self.onError(json["message"].string!)
                } else {
                    self.onError("Error parsing response from \(self.request.URL!)")
                }
                return
            }
            self.onSuccess(json)
        }
        
        task.resume()
    }
    
    func onSuccess(json: JSON) {}
    
    func onError(errorMesssage: String) {
        print(errorMesssage)
    }
}