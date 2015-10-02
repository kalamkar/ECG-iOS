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
    
    private let WEIGHT_SERVICE: CBUUID = CBUUID.init(string: "FFF0")
    private let WEIGHT_CHARACTERISTIC: CBUUID = CBUUID.init(string: "FFF4")
    
    private var centralManager: CBCentralManager?
    private var knownPeripheral: CBPeripheral?

    private var identifiers: [NSUUID] = []

    private var scanFoundCallback: ((CBPeripheral) -> Void)?
    
    private var lastStableWeightInGrams: Int = 0
    
    override init() {
        super.init()

        let scaleId: NSUUID? = Utils.getWeighingScale()
        if (scaleId != nil) {
            identifiers.append(scaleId!)
        }
        centralManager = CBCentralManager(delegate: self, queue: nil, options: nil)
//            [ CBCentralManagerOptionRestoreIdentifierKey : "care.dovetail.pregnansi" ])
    }
    
    func connect(peripheral: CBPeripheral) {
        print("Connecting to \(peripheral.name)...")
        peripheral.delegate = self
        centralManager?.connectPeripheral(peripheral, options: nil)
//            [ CBCentralManagerOptionRestoreIdentifierKey : "care.dovetail.pregnansi" ])
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
        print("Connected to \(peripheral.name) while in \(Utils.getUIState().rawValue)")
        lastStableWeightInGrams = 0
        peripheral.delegate = self
        peripheral.discoverServices([WEIGHT_SERVICE])
    }
    
    func peripheral(peripheral: CBPeripheral, didDiscoverServices error: NSError?) {
        print("didDiscoverServices \(error)")
        for service in peripheral.services! {
            peripheral.discoverCharacteristics([WEIGHT_CHARACTERISTIC], forService: service)
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

        // If weighing scale is stable and value is grams
        if ((value[0] & 0xFF) == 203 && (value[1] & 0xFF) == 0) {
            let weight: Int = (Int(value[2]) << 8 | Int(value[3])) * 100
            lastStableWeightInGrams = weight
        }
    }
    
    func centralManager(central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: NSError?) {
        print("Disconnected from \(peripheral.name) while in \(Utils.getUIState().rawValue)")
        if (lastStableWeightInGrams > 0) {
            // TODO(abhi): Add a card to notify user
            print("Weight on Date is \(lastStableWeightInGrams)")
        }
        connect(peripheral)
    }
    
    func centralManagerDidUpdateState(central: CBCentralManager) {
        print("centralManagerDidUpdateState")
        if (central.state == CBCentralManagerState.PoweredOn) {
            let knownPeripherals: [CBPeripheral]? = centralManager?.retrievePeripheralsWithIdentifiers(identifiers)
            if (knownPeripherals != nil && knownPeripherals!.count > 0) {
                connect(knownPeripherals![0])
                knownPeripheral = knownPeripherals![0]
            }
        } else if (central.state == CBCentralManagerState.PoweredOff) {
            // TODO(abhi): Ask user to turn on bluetooth
        } else {
            print("Invalid bluetooth state \(central.state)")
        }
    }
    
    func centralManager(central: CBCentralManager, willRestoreState dict: [String : AnyObject]) {
        print("centralManager willRestoreState")
    }
}