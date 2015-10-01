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
            print("Connecting to \(peripheral?.name)")
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
    }
    
    func centralManager(central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: NSError?) {
        print("Disconnected from \(peripheral.name)")
        connect()
    }
    
    func centralManagerDidUpdateState(central: CBCentralManager) {
        switch (central.state) {
        case CBCentralManagerState.PoweredOff:
            print("PoweredOff")
            
        case CBCentralManagerState.Unauthorized:
            // Indicate to user that the iOS device does not support BLE.
            print("BLE not supported")
            break
            
        case CBCentralManagerState.Unknown:
            // Wait for another event
            print("Unknown")
            break
            
        case CBCentralManagerState.PoweredOn:
            print("PoweredOn")
            connect()
            break
            
        case CBCentralManagerState.Resetting:
            print("Resetting")
            break
            
        case CBCentralManagerState.Unsupported:
            break
        }
    }
}