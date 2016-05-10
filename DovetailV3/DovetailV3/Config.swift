//
//  Config.swift
//  DovetailV3
//
//  Created by Abhijit Kalamkar on 5/9/16.
//  Copyright © 2016 Dovetail Care. All rights reserved.
//

import Foundation

class Config {
    static let API_URL:String = "http://dovetail-data-1.appspot.com";
    static let RECORDING_URL:String = API_URL + "/recording";
    
    static let BT_DEVICE_NAME_PREFIX:String = "Dovetail";
//    static long DATA_UUID = 0x404846A1;
//    static int SAMPLE_INTERVAL_MS = 5;
//    static int SAMPLES_PER_BROADCAST = 20; // Hardcoded in FW
    
//    static int AUDIO_PLAYBACK_RATE = 4000; // 4kHz
//    static int AUDIO_BYTES_PER_SAMPLE = AUDIO_PLAYBACK_RATE / (1000 / SAMPLE_INTERVAL_MS);
//    
//    static int GRAPH_LENGTH = 1000;			// 5 seconds at 200Hz
//    static int BREATH_GRAPH_LENGTH = 6000;		// 30 seconds at 200Hz
//    
//    static int SHORT_GRAPH_MIN = 0; 	//  64 for V2,  64 for V1
//    static int SHORT_GRAPH_MAX = 275; 	// 192 for V2, 255 for V1
//    
//    static int LONG_GRAPH_MIN = 0;		// 100 for V2, 100 for V1
//    static int LONG_GRAPH_MAX = 255;	// 192 for V2, 255 for V1
//    
//    static int GRAPH_UPDATE_MILLIS = 500;
    
    // Detect features every 5 chunk updates (and not every update), 500ms interval
//    static int FEATURE_DETECT_INTERVAL = GRAPH_UPDATE_MILLIS / (SAMPLE_INTERVAL_MS * SAMPLES_PER_BROADCAST);
    
//    static int BPM_UPDATE_MILLIS = 3000;
//    static int MIN_BPM_SAMPLES = 5;
//    static int MAX_BPM_SAMPLES = 10;
//    
//    static int ECG_AMPLITUDE_ADJUST = 100;
    
    // static SimpleDateFormat EVENT_TIME_FORMAT = new SimpleDateFormat("hh:mm:ssaa, MMM dd yyyy", Locale.US)
    
    static let POSITION_TAGS:String = "top,right,bottom,left,top_far,right_far,bottom_far,left_far"
}