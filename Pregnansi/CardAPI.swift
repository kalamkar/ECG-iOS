//
//  CardAPI.swift
//  
//
//  Created by Abhijit Kalamkar on 9/25/15.
//
//

import Foundation

class CardAdd: ApiResponseTask {

    init(tags: String, text: String, icon: String, image: String, priority: Int) {
        super.init(url: Config.CARD_URL)
        request.HTTPMethod = "POST"
        var body = ""
        if (!tags.isEmpty) {
            body = "\(Card.PARAM_TAGS)=\(tags)&"
        }
        if (!text.isEmpty) {
            body += "\(Card.PARAM_TEXT)=\(text)&"
        }
        if (!icon.isEmpty) {
            body += "\(Card.PARAM_ICON)=\(icon)&"
        }
        if (!image.isEmpty) {
            body += "\(Card.PARAM_IMAGE)=\(image)"
        }
        body += "\(Card.PARAM_PRIORITY)=\(priority)"
        request.HTTPBody = body.dataUsingEncoding(NSUTF8StringEncoding)
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    }
}

class CardUpdate: ApiResponseTask {

    init(id: String, tag: String) {
        super.init(url: Config.CARD_URL)
        request.HTTPMethod = "PUT"
        let body = "\(Card.PARAM_ID)=\(id)&\(Card.PARAM_TAG)=\(tag)"
        request.HTTPBody = body.dataUsingEncoding(NSUTF8StringEncoding)
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    }
}

class CardsGet: ApiResponseTask {

    init(tags: String, isPublic: Bool) {
        var url = "\(Config.CARD_URL)?\(Card.PARAM_TAGS)=\(tags)&"
        if (isPublic) {
            url += "\(Card.PARAM_PUBLIC)=true"
        }
        super.init(url: url)
    }
}
