//
//  UserAPI.swift
//  Pregnansi
//
//  Created by Abhijit Kalamkar on 9/25/15.
//  Copyright © 2015 Dovetail Care. All rights reserved.
//

import Foundation

func updateUser(json: JSON) {
    let app = Utils.sharedInstance()
    app.user = User.init(user: json["users"][0])
    NSNotificationCenter.defaultCenter().postNotificationName(Config.USER_UPDATED, object: app.user)
    Utils.setStoredCredentials(app.user?.uuid, auth: app.user?.auth)
}

class UserCreate: ApiResponseTask {
    
    init(name: String, email: String, token: String) {
        super.init(url: Config.USER_URL)
        request.HTTPMethod = "POST"
        let body = "\(User.PARAM_NAME)=\(name)&\(User.PARAM_EMAIL)=\(email)"
            + "&\(User.PARAM_TYPE)=APPLE&\(User.PARAM_TOKEN)=\(token)"
        request.HTTPBody = body.dataUsingEncoding(NSUTF8StringEncoding)
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    }
    
    override func onSuccess(json: JSON) {
        updateUser(json)
    }
}


class UserUpdate: ApiResponseTask {
    
    convenience init(feature: String?) {
        self.init(name: nil, email: nil, type: nil, token: nil, feature: feature)
    }
    
    init(name: String?, email: String?, type: String?, token: String?, feature: String?) {
        super.init(url: Config.USER_URL)
        request.HTTPMethod = "PUT"
        var body = ""
        if (name != nil) {
            body = "\(User.PARAM_NAME)=\(name!)&"
        }
        if (email != nil) {
            body += "\(User.PARAM_EMAIL)=\(email!)&"
        }
        if (token != nil) {
            body += "\(User.PARAM_TYPE)=APPLE&\(User.PARAM_TOKEN)=\(token!)&"
        }
        if (feature != nil) {
            body += "\(User.PARAM_FEATURE)=\(feature!)"
        }
        request.HTTPBody = body.dataUsingEncoding(NSUTF8StringEncoding)
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    }
    
    override func onSuccess(json: JSON) {
        updateUser(json)
    }
}

class UserGet: ApiResponseTask {
    init() {
        super.init(url: Config.USER_URL)
    }
    
    override func onSuccess(json: JSON) {
        updateUser(json)
    }
}