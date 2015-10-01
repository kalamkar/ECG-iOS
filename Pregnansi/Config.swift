//
//  Config.swift
//  Pregnansi
//
//  Created by Abhijit Kalamkar on 9/24/15.
//  Copyright © 2015 Dovetail Care. All rights reserved.
//

import Foundation

class Config {
    
//    static let uuid = "8979a2ab-e0c3-4ecc-ab72-9f5565757d7c"
//    static let auth = "5023d995-e069-4c8f-b3af-98e9253def98"
    static let uuid = "f45c20b0-0a70-4be5-9081-fd34d9527a5f"
    static let auth = "ae4f27b4-49c8-4f5a-89df-2b7cd81e8c4b"

    
    static let API_URL:String = "http://api.pregnansi.com"
    static let USER_URL:String = API_URL + "/user"
    static let RECOVERY_URL:String = USER_URL + "/recover"
    static let PHOTO_UPLOAD_URL:String = USER_URL + "/photo"
    static let CARD_URL:String = USER_URL + "/card"
    static let APPOINTMENT_URL:String = API_URL + "/appointment"
    static let EVENT_URL :String = API_URL + "/event"
    static let EVENT_CHART_URL :String = API_URL + "/event/chart"
    static let GROUP_URL:String = API_URL + "/group"
    static let MESSAGE_URL :String = API_URL + "/message"
    static let SEARCH_URL:String = API_URL + "/search"
    static let POLL_URL:String = API_URL + "/poll/"

    static let USER_PHOTO_URL:String = PHOTO_UPLOAD_URL + "?uuid="
    static let GROUP_PHOTO_URL:String = GROUP_URL + "/photo?group_uuid="
    
    static let HELP_URL:String = "http://www.pregnansi.com/help/app"

    static let GCM_SENDER_ID:String = "772594394845"
    
    static let WEIGHT_SCALE_NAME:String = "Samico Scales";

    static let BACKGROUND_IMAGES: [String] = [
        "https://storage.googleapis.com/dovetail-images/baby1.png",
        "https://storage.googleapis.com/dovetail-images/baby2.png",
        "https://storage.googleapis.com/dovetail-images/baby3.png",
        "https://storage.googleapis.com/dovetail-images/Generic/baby-200760_640.jpg",
        "https://storage.googleapis.com/dovetail-images/Generic/baby-84627_640.jpg",
        "https://storage.googleapis.com/dovetail-images/Generic/brothers-457234_640.jpg",
        "https://storage.googleapis.com/dovetail-images/Generic/cat-649164_640.jpg",
        "https://storage.googleapis.com/dovetail-images/Generic/children-817365_640.jpg",
        "https://storage.googleapis.com/dovetail-images/Generic/flowers-164754_640.jpg",
        "https://storage.googleapis.com/dovetail-images/Generic/friends-640096_640.jpg",
        "https://storage.googleapis.com/dovetail-images/Generic/hands-634866_640.jpg",
        "https://storage.googleapis.com/dovetail-images/Generic/pregnancy-806989_640.jpg",
        "https://storage.googleapis.com/dovetail-images/Generic/summerfield-336672_640.jpg",
        "https://storage.googleapis.com/dovetail-images/Generic/twins-775506_640.jpg"]
    
    static let TODO_ICON:String = "https://storage.googleapis.com/dovetail-images/ic_todo.png"
    static let WEIGHT_ICON:String = "https://storage.googleapis.com/dovetail-images/weight.png"
    
    
    static let CENTER_DECOR: [String]       = [ "back_b1", "back_b4", "back_t_br1", "back_t_br2", "back_tl_br1", "back_tr_b1"]
    static let BOTTOM_DECOR: [String]       = [ "back_b1", "back_b2", "back_b3", "back_b4", "back_b5", "back_t_br1",
                                                "back_t_br2", "back_tl_br1", "back_tr_b1" ]
    static let BOTTOM_RIGHT_DECOR: [String] = [ "back_br1", "back_br2", "back_br3", "back_br4", "back_br5", "back_br6",
                                                "back_br7", "back_br8", "back_br9", "back_br10" ]
    static let BOTTOM_LEFT_DECOR: [String]  = [ "back_bl1", "back_bl2" ]
    static let TOP_RIGHT_DECOR: [String]    = [ "back_tr1", "back_tr2", "back_tr3", "back_tr4", "back_tr5" ]
    
    static let ACTION_TEXT_ICONS: [Card.Action: [String]] =
        [   Card.Action.TO_DO :                 ["Add To Do",           "ic_todo.png"],
            Card.Action.DUE_DATE :              ["Due Date",            "ic_date.png"],
            Card.Action.CONNECT_HEALTH_DATA :   ["Connect Health Kit",  "ic_heart.png"],
            Card.Action.CONNECT_SCALE :         ["Connect Scale",       "ic_action_pair.png"]]
    
    static let USER_UPDATED: String = "USER_UPDATED_NOTIFICATION"
}