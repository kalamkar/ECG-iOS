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
    
    var app: AppDelegate!
    
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
    
    func didUpdateState(state: CBCentralManagerState) {
        if (state == CBCentralManagerState.PoweredOn) {
            app.bleClient.startScan()
            spinner.startAnimating()
        } else if (state == CBCentralManagerState.PoweredOff) {
            // TODO(abhi): Ask user to turn on bluetooth
            print("Bluetooth is OFF")
        } else {
            print("Invalid bluetooth state \(state)")
        }
    }
    
    func didFindPeripheral(peripheral: CBPeripheral) {
        self.spinner.stopAnimating()
        app.bleClient.connect(peripheral)
    }
    
    func didConnectPeripheral(peripheral: CBPeripheral) {
        
    }
    
    func didDisconnectPeripheral(peripheral: CBPeripheral) {
        app.bleClient.startScan()
        spinner.startAnimating()
    }
}

