//
//  EventAPI.swift
//  Pregnansi
//
//  Created by Abhijit Kalamkar on 9/25/15.
//  Copyright © 2015 Dovetail Care. All rights reserved.
//

import Foundation


class EventAdd: ApiResponseTask {
    
    init(tags: String, time: Int, data: String?) {
        super.init(url: Config.EVENT_URL)
        request.HTTPMethod = "POST"
        var body = "\(Event.PARAM_TAGS)=\(tags)&\(Event.PARAM_TIME)=\(time)&"
        if (data != nil) {
            body += "\(Event.PARAM_DATA)=\(data)"
        }
        request.HTTPBody = body.dataUsingEncoding(NSUTF8StringEncoding)
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    }
}


class EventsGet: ApiResponseTask {

    init(tags: String, startTime: Int?, endTime: Int?) {
        var url = "\(Config.EVENT_URL)?\(Event.PARAM_TAGS)=\(tags)&"
        if (startTime != nil) {
            url += "\(Event.PARAM_START_TIME)=\(startTime)"
        }
        if (endTime != nil) {
            url += "\(Event.PARAM_END_TIME)=\(endTime)"
        }
        super.init(url: url)
    }
}
