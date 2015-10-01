//
//  User.swift
//  Pregnansi
//
//  Created by Abhijit Kalamkar on 9/24/15.
//  Copyright © 2015 Dovetail Care. All rights reserved.
//

import Foundation

class User {
    static let PARAM_TYPE: String    = "type"
    static let PARAM_TOKEN: String   = "token"
    static let PARAM_NAME: String    = "name"
    static let PARAM_EMAIL: String   = "email"
    static let PARAM_FEATURE: String = "feature";

    var name: String?
    var uuid: String?
    var auth: String?
    var email: String?
    
    var updateTime: Int?  // update_time in Json response
    var createTime: Int?  // create_time in Json response

    var features: [String: String] = [String: String]()
    var cards:[Card] = []
    
    init(user: JSON) {
        self.name = user["name"].string
        self.uuid = user["uuid"].string
        self.auth = user["auth"].string
        self.email = user["email"].string
        
        self.updateTime = user["update_time"].int
        self.createTime = user["create_time"].int
        
        if (user["features"].array != nil) {
            for feature: JSON in user["features"].array! {
                let tokens = feature.string!.characters.split{$0 == "="}.map{String($0)}
                self.features[tokens[0]] = tokens[1]
            }
        }
        if (user["cards"].array != nil) {
            for card: JSON in user["cards"].array! {
                self.cards.append(Card.init(card: card))
            }
            self.cards.sortInPlace({ $0.priority < $1.priority })
        }
    }
}