//
//  Event.swift
//  Pregnansi
//
//  Created by Abhijit Kalamkar on 9/24/15.
//  Copyright © 2015 Dovetail Care. All rights reserved.
//

import Foundation

class Event {
    
    static let PARAM_TAGS: String = "tags";
    static let PARAM_TIME: String = "time";
    static let PARAM_DATA: String = "data";
    static let PARAM_START_TIME: String = "start_time";
    static let PARAM_END_TIME: String = "end_time";
    
    var tags: [String] = []
    var time: Int?
    var data: String?
    
    init(event: JSON) {
        self.time = event["time"].int
        self.data = event["data"].string
        for tag: JSON in event["tags"].array! {
            self.tags.append(tag.string!)
        }
    }
}