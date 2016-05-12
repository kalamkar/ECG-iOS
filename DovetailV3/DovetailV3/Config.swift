//
//  Config.swift
//  DovetailV3
//
//  Created by Abhijit Kalamkar on 5/9/16.
//  Copyright © 2016 Dovetail Care. All rights reserved.
//

import Foundation

class Config {
    static let API_URL:String = "https://dovetail-data-1.appspot.com"
    static let RECORDING_URL:String = API_URL + "/recording"
    
    static let BT_DEVICE_NAME_PREFIX:[String] = ["Dovetail", "nRF5x"]
    
    static let DOVETAIL_SERVICE:String = "404846A0-608A-11E5-AB45-0002A5D5C51B"
    static let ECG_CHARACTERISTIC:String = "404846A1-608A-11E5-AB45-0002A5D5C51B"
    
    static let SAMPLE_INTERVAL_MS: Int = 5
    static let SAMPLES_PER_BROADCAST: Int = 20 // Hardcoded in FW
    
//    static int AUDIO_PLAYBACK_RATE = 4000 // 4kHz
//    static int AUDIO_BYTES_PER_SAMPLE = AUDIO_PLAYBACK_RATE / (1000 / SAMPLE_INTERVAL_MS)
    
    static let GRAPH_LENGTH: Int = 1000			// 5 seconds at 200Hz
    static let BREATH_GRAPH_LENGTH: Int = 6000		// 30 seconds at 200Hz
    
    static let SHORT_GRAPH_MIN: Int = 0 	//  64 for V2,  64 for V1
    static let SHORT_GRAPH_MAX: Int = 275 	// 192 for V2, 255 for V1
    
//    static int LONG_GRAPH_MIN = 0		// 100 for V2, 100 for V1
//    static int LONG_GRAPH_MAX = 255	// 192 for V2, 255 for V1
    
    static let GRAPH_UPDATE_MILLIS: Int = 500
    static let GRAPH_UPDATE_INTERVAL: Int = GRAPH_UPDATE_MILLIS / (SAMPLE_INTERVAL_MS * SAMPLES_PER_BROADCAST)
    
    // Detect features every 5 chunk updates (and not every update), 500ms interval
    static let FEATURE_DETECT_INTERVAL: Int = GRAPH_UPDATE_MILLIS / (SAMPLE_INTERVAL_MS * SAMPLES_PER_BROADCAST)
    
//    static int BPM_UPDATE_MILLIS = 3000
//    static int MIN_BPM_SAMPLES = 5
//    static int MAX_BPM_SAMPLES = 10
//    
//    static int ECG_AMPLITUDE_ADJUST = 100
    
    // static SimpleDateFormat EVENT_TIME_FORMAT = new SimpleDateFormat("hh:mm:ssaa, MMM dd yyyy", Locale.US)
    
    static let POSITION_TAGS:String = "top,right,bottom,left,top_far,right_far,bottom_far,left_far"
}