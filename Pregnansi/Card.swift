//
//  Card.swift
//  Pregnansi
//
//  Created by Abhijit Kalamkar on 9/24/15.
//  Copyright © 2015 Dovetail Care. All rights reserved.
//

import Foundation

class Card {

    static let TITLE_PATTERN: String = "^[^\\.\\?\\!]+[\\.\\?\\!]+"

    static let PARAM_ID: String = "card_id"
    static let PARAM_TAGS: String = "tags"
    static let PARAM_TAG: String = "tag"
    static let PARAM_TEXT: String = "text"
    static let PARAM_IMAGE: String = "image"
    static let PARAM_ICON: String = "icon"
    static let PARAM_PRIORITY: String = "priority"
    static let PARAM_PUBLIC: String = "public"

    var id:         String?
    var priority:   Int?
    var expireTime: Int?  // expire_time in JSON
    
    var text:   String?
    var icon:   String?
    var image:  String?
    var url:    String?
    
    var options:    [String]?
    var tags:       [String] = []
    
    enum Type: String {
        case SIZE       = "size"
        case TIP        = "tip"
        case POLL       = "poll"
        case SYMPTOM    = "symptom"
        case VOTE       = "vote"
        case CARE       = "care"
        case TODO       = "todo"
        case MILESTONE  = "milestone"
        case INSIGHT    = "insight"
        case UNKNOWN    = "basic"
    }
    
    enum Action: String {
        case DUE_DATE               = "due_date"
        case CONNECT_SCALE          = "connect_scale"
        case CONNECT_HEALTH_DATA    = "connect_health_data"
        case TO_DO                  = "to_do"
        case NONE                   = "none"
    }
    
    init(card: JSON) {
        self.id = card["id"].string
        self.priority = card["priority"].int
        self.expireTime = card["expire_time"].int
        
        self.text = card["text"].string
        self.icon = card["icon"].string
        self.image = card["image"].string
        self.url = card["url"].string
        
        if (card["options"].array != nil) {
            self.options = []
            for option: JSON in card["options"].array! {
                self.options?.append(option.string!)
            }
        }
        for tag: JSON in card["tags"].array! {
            self.tags.append(tag.string!)
        }
    }
    
    func getTitle() -> String? {
        do {
            let regex = try NSRegularExpression(pattern: Card.TITLE_PATTERN, options: [])
            let match = regex.firstMatchInString(self.text!, options: [], range: NSMakeRange(0, (self.text?.characters.count)!))
            if (match != nil) {
                return self.text!.substringWithRange(self.text!.rangeFromNSRange(match!.range)!)
            }
        } catch {
        }
        return nil
    }
    
    func getText() -> String? {
        if (self.text == nil) {
            return nil
        }
        let title: String? = getTitle()
        return title == nil ? text : text!.stringByReplacingOccurrencesOfString(title!, withString: "").stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    }
    
    func getType() -> Type {
        for tag: String in self.tags {
            let type = Type(rawValue: tag.lowercaseString)
            if (type != nil) {
                return type!
            }
        }
        return Type.UNKNOWN;
    }

    func getAction() -> Action {
        for tag: String in self.tags {
            if (tag.lowercaseString.hasPrefix("action:")) {
                let action = Action(rawValue: tag.stringByReplacingOccurrencesOfString("action:", withString: ""));
                if (action != nil) {
                    return action!
                }
            }
        }
        if (self.getType() == Type.CARE) {
            return Action.TO_DO;
        }
        return Action.NONE;
    }
    
    func getQuestionId() -> String? {
        for tag: String in self.tags {
            if (tag.lowercaseString.hasPrefix("qid:")) {
                return tag.stringByReplacingOccurrencesOfString("qid:", withString: "")
            }
        }
        return nil
    }
}

extension String {
    func rangeFromNSRange(nsRange : NSRange) -> Range<String.Index>? {
        let from16 = utf16.startIndex.advancedBy(nsRange.location, limit: utf16.endIndex)
        let to16 = from16.advancedBy(nsRange.length, limit: utf16.endIndex)
        if let from = String.Index(from16, within: self),
            let to = String.Index(to16, within: self) {
                return from ..< to
        }
        return nil
    }
}
