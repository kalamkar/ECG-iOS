//
//  SamicoScaleClient.swift
//  Pregnansi
//
//  Created by Abhijit Kalamkar on 9/29/15.
//  Copyright © 2015 Dovetail Care. All rights reserved.
//

import Foundation
import CoreBluetooth

class SamicoScaleClient : NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    private var centralManager: CBCentralManager?
    private var identifiers: [NSUUID] = []
    private var peripheral: CBPeripheral?
    
    private var scanFoundCallback: ((CBPeripheral) -> Void)?
    
    private var lastStableWeightInGrams: Int = 0
    
    override init() {
        super.init()

        let scaleId: NSUUID? = Utils.getWeighingScale()
        if (scaleId != nil) {
            identifiers.append(scaleId!)
        }
        centralManager = CBCentralManager(delegate: self, queue: nil)
        let knownPeripherals: [CBPeripheral]? = centralManager?.retrievePeripheralsWithIdentifiers(identifiers)
        if (knownPeripherals != nil && knownPeripherals!.count > 0) {
            peripheral = knownPeripherals![0]
        }
    }
    
    func connect() {
        if (peripheral != nil && centralManager?.state == CBCentralManagerState.PoweredOn) {
            peripheral!.delegate = self
            print("Connecting to \(peripheral?.name)...")
            centralManager?.connectPeripheral(peripheral!, options: [
                CBConnectPeripheralOptionNotifyOnConnectionKey: true,
                CBConnectPeripheralOptionNotifyOnDisconnectionKey: true,
                CBConnectPeripheralOptionNotifyOnNotificationKey: true
            ])
        }
    }
    
    func scanScales(callback: (CBPeripheral) -> Void) {
        print("Starting BLE Scan")
        centralManager!.scanForPeripheralsWithServices(nil, options: nil)
        scanFoundCallback = callback
    }

    func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber) {
        
        if (peripheral.name == Config.WEIGHT_SCALE_NAME) {
            centralManager!.stopScan()
            Utils.setWeighingScale(peripheral.identifier)
            print("Found \(peripheral.name)")
            if (scanFoundCallback != nil) {
                scanFoundCallback!(peripheral)
            }
        }
    }
    
    func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
        print("Connected to \(peripheral.name)")
        lastStableWeightInGrams = 0
        peripheral.discoverServices(nil)
    }
    
    func peripheral(peripheral: CBPeripheral, didDiscoverServices error: NSError?) {
        for service in peripheral.services! {
            print("Found service \(service.UUID.UUIDString)")
            peripheral.discoverCharacteristics(nil, forService: service)
        }
    }
    
    func peripheral(peripheral: CBPeripheral, didDiscoverCharacteristicsForService service: CBService, error: NSError?) {
        for charateristic in service.characteristics! {
            print("Found characteristic \(charateristic.UUID.UUIDString)")
            charateristic.properties
            if (charateristic.properties.contains(.Notify)) {
                print("Enabling notification for \(charateristic.UUID.UUIDString)")
                peripheral.setNotifyValue(true, forCharacteristic: charateristic)
            }
        }
    }
    
    func peripheral(peripheral: CBPeripheral, didUpdateValueForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
        let data: NSData = characteristic.value!
        let value: [UInt8] = Array(UnsafeBufferPointer(start: UnsafePointer<UInt8>(data.bytes), count: data.length))
//        print("Got notified \(value)")

        // If weighing scale is stable and value is grams
        if ((value[0] & 0xFF) == 203 && (value[1] & 0xFF) == 0) {
            let weight: Int = (Int(value[2]) << 8 | Int(value[3])) * 100
            lastStableWeightInGrams = weight
//            print("New weight data: \(weight), \(value[0] & 0xFF), \(value[1] & 0xFF)")
        }
    }
    
    func centralManager(central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: NSError?) {
        print("Disconnected from \(peripheral.name)")
        if (lastStableWeightInGrams > 0) {
            // TODO(abhi): Add a card to notify user
            print("Weight on Date is \(lastStableWeightInGrams)")
        }
        connect()
    }
    
    func centralManagerDidUpdateState(central: CBCentralManager) {
        if (central.state == CBCentralManagerState.PoweredOn) {
            connect()
        } else if (central.state == CBCentralManagerState.PoweredOff) {
            // TODO(abhi): Ask user to turn on bluetooth
        } else {
            print("Invalid bluetooth state \(central.state)")
        }
    }
}