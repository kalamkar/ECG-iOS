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
    func didUpdateData(data: [UInt8])
    func didDisconnectPeripheral(peripheral: CBPeripheral)
}

class BluetoothSmartClient : NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    private let DOVETAIL_SERVICE: CBUUID = CBUUID.init(string: "4048") // 4048 46A0
    private let DOVETAIL_CHARACTERISTIC: CBUUID = CBUUID.init(string: "4048")  // 4048 46A0
    
    private var centralManager: CBCentralManager!
    private var peripheral: CBPeripheral?
    
    var delegate: BluetoothUpdatesDelegate?
    
    override init() {
        super.init()
        
        centralManager = CBCentralManager(delegate: self, queue: nil, options: nil)
        //            [ CBCentralManagerOptionRestoreIdentifierKey : "care.dovetail.pregnansi" ])
    }
    
    func isBluetoothOn() -> Bool {
        return centralManager.state == CBCentralManagerState.PoweredOn;
    }
    
    func startScan() {
        centralManager.scanForPeripheralsWithServices(nil, options: nil)
    }
    
    func connect(peripheral: CBPeripheral) {
        self.peripheral = peripheral
        print("Connecting to \(self.peripheral!.name)...")
        self.peripheral!.delegate = self
        centralManager.connectPeripheral(peripheral, options: nil)
        //            [ CBCentralManagerOptionRestoreIdentifierKey : "care.dovetail.pregnansi" ])
    }
    
    func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber) {
        if (peripheral.name != nil && peripheral.name!.hasPrefix(Config.BT_DEVICE_NAME_PREFIX)) {
            centralManager!.stopScan()
            delegate?.didFindPeripheral(peripheral)
        }
    }
    
    func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
        print("Connected to \(peripheral.name)")
        delegate?.didConnectPeripheral(peripheral)
        peripheral.delegate = self
        peripheral.discoverServices([CBUUID(string: Config.DOVETAIL_SERVICE)])
    }
    
    func peripheral(peripheral: CBPeripheral, didDiscoverServices error: NSError?) {
        for service in peripheral.services! {
            peripheral.discoverCharacteristics([CBUUID(string: Config.ECG_CHARACTERISTIC)], forService: service)
        }
    }
    
    func peripheral(peripheral: CBPeripheral, didDiscoverCharacteristicsForService service: CBService, error: NSError?) {
        for charateristic in service.characteristics! {
            if (charateristic.properties.contains(.Notify)) {
                peripheral.setNotifyValue(true, forCharacteristic: charateristic)
            }
        }
    }
    
    func peripheral(peripheral: CBPeripheral, didUpdateValueForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
        let data: NSData = characteristic.value!
        let value: [UInt8] = Array(UnsafeBufferPointer(start: UnsafePointer<UInt8>(data.bytes), count: data.length))
        delegate?.didUpdateData(value)
    }
    
    func centralManager(central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: NSError?) {
        print("Disconnected from \(peripheral.name)")
        delegate?.didDisconnectPeripheral(peripheral)
    }
    
    func centralManagerDidUpdateState(central: CBCentralManager) {
        if (delegate != nil) {
            delegate?.didUpdateState(central.state)
        }
    }
    
    func centralManager(central: CBCentralManager, willRestoreState dict: [String : AnyObject]) {
        print("centralManager willRestoreState")
    }
}