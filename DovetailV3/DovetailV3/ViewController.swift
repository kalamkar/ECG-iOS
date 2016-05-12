//
//  ViewController.swift
//  DovetailV3
//
//  Created by Abhijit Kalamkar on 5/9/16.
//  Copyright © 2016 Dovetail Care. All rights reserved.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController, BluetoothUpdatesDelegate {

    @IBOutlet var spinner: UIActivityIndicatorView!
    @IBOutlet var chart: ChartView!
    @IBOutlet var tags: UITextField!
    @IBOutlet var record: UIButton!
    
    private var app: AppDelegate!
    private var writer: FileWriter? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        app = Utils.sharedInstance()
        app.bleClient.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if (app.bleClient.isBluetoothOn()) {
            app.bleClient.startScan()
            spinner.startAnimating()
        }
    }
    
    @IBAction func didClickRecord(sender: UIButton) {
        if (writer != nil) {
            writer!.close()
            writer = nil
            self.record.setTitle("Record", forState: UIControlState.Normal)
        } else {
            writer = FileWriter.init(tags: self.tags.text!)
            self.record.setTitle("Stop", forState: UIControlState.Normal)
        }
    }
    
    func didUpdateState(state: CBCentralManagerState) {
        if (state == CBCentralManagerState.PoweredOn) {
            app.bleClient.startScan()
            spinner.startAnimating()
        } else if (state == CBCentralManagerState.PoweredOff) {
            let alert = UIAlertController(title: "Bluetooth OFF", message: "Please turn on Bluetooth to connect to monitor.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            print("Invalid bluetooth state \(state)")
        }
    }
    
    func didFindPeripheral(peripheral: CBPeripheral) {
        spinner.hidden = true
        app.bleClient.connect(peripheral)
    }
    
    func didConnectPeripheral(peripheral: CBPeripheral) {
        
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
        spinner.hidden = false
    }
}

