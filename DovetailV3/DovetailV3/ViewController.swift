//
//  ViewController.swift
//  DovetailV3
//
//  Created by Abhijit Kalamkar on 5/9/16.
//  Copyright © 2016 Dovetail Care. All rights reserved.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController, BluetoothUpdatesDelegate, UITextFieldDelegate {

    @IBOutlet var status: UILabel!
    @IBOutlet var spinner: UIActivityIndicatorView!
    @IBOutlet var chart: ChartView!
    @IBOutlet var tags: UITextField!
    @IBOutlet var record: UIButton!
    @IBOutlet var recordStatus: UILabel!
    
    private var app: AppDelegate!
    
    private var writer: FileWriter? = nil
    private var recordTimer: NSTimer? = nil
    private var recordStartTime: NSDate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        app = Utils.sharedInstance()
        app.bleClient.delegate = self
        tags.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if (app.bleClient.isBluetoothOn()) {
            app.bleClient.startScan()
            spinner.startAnimating()
            status.text = "Searching"
        }
    }
    
    @IBAction func didClickRecord(sender: UIButton) {
        if (writer != nil) {
            writer!.close()
            writer = nil
            self.record.setTitle("Record", forState: UIControlState.Normal)
            recordTimer?.invalidate()
            recordTimer = nil
            self.recordStatus.text = ""
        } else {
            writer = FileWriter.init(tags: self.tags.text!)
            self.record.setTitle("Stop", forState: UIControlState.Normal)
            recordTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(ViewController.updateRecordTime), userInfo: nil, repeats: true)
            recordStartTime = NSDate()
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func updateRecordTime() {
        let seconds:Int = abs(Int((recordStartTime?.timeIntervalSinceNow)!))
        dispatch_async(dispatch_get_main_queue()) {
            self.recordStatus.text = "\(seconds)"
        }
    }
    
    func didUpdateState(state: CBCentralManagerState) {
        if (state == CBCentralManagerState.PoweredOn) {
            app.bleClient.startScan()
            dispatch_async(dispatch_get_main_queue()) {
                self.spinner.startAnimating()
                self.status.text = "Searching"
            }
        } else if (state == CBCentralManagerState.PoweredOff) {
            let alert = UIAlertController(title: "Bluetooth OFF", message: "Please turn on Bluetooth to connect to monitor.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            dispatch_async(dispatch_get_main_queue()) {
                self.status.text = "Bluetooth OFF"
            }
        } else {
            print("Invalid bluetooth state \(state)")
        }
    }
    
    func didFindPeripheral(peripheral: CBPeripheral) {
        app.bleClient.connect(peripheral)
        dispatch_async(dispatch_get_main_queue()) {
            self.spinner.hidden = true
            self.status.text = "Connecting"
        }
    }
    
    func didConnectPeripheral(peripheral: CBPeripheral) {
        dispatch_async(dispatch_get_main_queue()) {
            self.status.text = "Connected"
        }
    }
    
    func didUpdateData(data: NSData) {
        if (writer != nil) {
            writer!.update(data)
        }
        chart.update(data)
    }
    
    func didDisconnectPeripheral(peripheral: CBPeripheral) {
        if (writer != nil) {
            writer!.close()
            self.record.titleLabel?.text = "Record"
        }
        app.bleClient.startScan()
        dispatch_async(dispatch_get_main_queue()) {
            self.spinner.hidden = false
            self.status.text = "Searching"
        }
    }
}

