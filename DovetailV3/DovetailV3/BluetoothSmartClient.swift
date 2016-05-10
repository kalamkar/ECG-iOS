//
//  BluetoothSmartClient.swift
//  DovetailV3
//
//  Created by Abhijit Kalamkar on 5/9/16.
//  Copyright © 2016 Dovetail Care. All rights reserved.
//

import Foundation
import CoreBluetooth

protocol BluetoothUpdatesDelegate: class {
    func didUpdateState(state: CBCentralManagerState)
    func didFindPeripheral(peripheral: CBPeripheral)
    func didConnectPeripheral(peripheral: CBPeripheral)
    func didDisconnectPeripheral(peripheral: CBPeripheral)
}

class BluetoothSmartClient : NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    private let DOVETAIL_SERVICE: CBUUID = CBUUID.init(string: "46A0")
    private let DOVETAIL_CHARACTERISTIC: CBUUID = CBUUID.init(string: "46A1")
    
    private var centralManager: CBCentralManager!
    
    private var delegate: BluetoothUpdatesDelegate?
    
    override init() {
        super.init()
        
        centralManager = CBCentralManager(delegate: self, queue: nil, options: nil)
        //            [ CBCentralManagerOptionRestoreIdentifierKey : "care.dovetail.pregnansi" ])
    }
    
    func setDelegate(delegate: BluetoothUpdatesDelegate) {
        self.delegate = delegate
    }
    
    func startScan() {
        print("Starting BLE Scan")
        centralManager.scanForPeripheralsWithServices(nil, options: nil)
    }
    
    func connect(peripheral: CBPeripheral) {
        print("Connecting to \(peripheral.name)...")
        peripheral.delegate = self
        centralManager.connectPeripheral(peripheral, options: nil)
        //            [ CBCentralManagerOptionRestoreIdentifierKey : "care.dovetail.pregnansi" ])
    }
    
    func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber) {

        print("Found \(peripheral.name)")
        if (peripheral.name != nil && peripheral.name!.hasPrefix("nRF5x"/*Config.BT_DEVICE_NAME_PREFIX*/)) {
            centralManager!.stopScan()
            delegate?.didFindPeripheral(peripheral)
        }
    }
    
    func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
        print("Connected to \(peripheral.name) while in \(Utils.getUIState().rawValue)")
        delegate?.didConnectPeripheral(peripheral)
        peripheral.delegate = self
        peripheral.discoverServices([DOVETAIL_SERVICE])
    }
    
    func peripheral(peripheral: CBPeripheral, didDiscoverServices error: NSError?) {
        print("didDiscoverServices \(error)")
        for service in peripheral.services! {
            peripheral.discoverCharacteristics([DOVETAIL_CHARACTERISTIC], forService: service)
        }
    }
    
    func peripheral(peripheral: CBPeripheral, didDiscoverCharacteristicsForService service: CBService, error: NSError?) {
        print("didDiscoverCharacteristicsForService \(error)")
        for charateristic in service.characteristics! {
            if (charateristic.properties.contains(.Notify)) {
                peripheral.setNotifyValue(true, forCharacteristic: charateristic)
            }
        }
    }
    
    func peripheral(peripheral: CBPeripheral, didUpdateValueForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
        let data: NSData = characteristic.value!
        let value: [UInt8] = Array(UnsafeBufferPointer(start: UnsafePointer<UInt8>(data.bytes), count: data.length))
        print("Got data \(value)")
    }
    
    func centralManager(central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: NSError?) {
        print("Disconnected from \(peripheral.name) while in \(Utils.getUIState().rawValue)")
        delegate?.didDisconnectPeripheral(peripheral)
    }
    
    func centralManagerDidUpdateState(central: CBCentralManager) {
        if (central.state == CBCentralManagerState.PoweredOn) {
            print("Bluetooth is ON")
            centralManager!.scanForPeripheralsWithServices(nil, options: nil)
        } else if (central.state == CBCentralManagerState.PoweredOff) {
            // TODO(abhi): Ask user to turn on bluetooth
            print("Bluetooth is OFF")
        } else {
            print("Invalid bluetooth state \(central.state)")
        }
    }
    
    func centralManager(central: CBCentralManager, willRestoreState dict: [String : AnyObject]) {
        print("centralManager willRestoreState")
    }
}