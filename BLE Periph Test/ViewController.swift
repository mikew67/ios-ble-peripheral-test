//
//  ViewController.swift
//  BLE Periph Test
//
//  Created by Mike Wirth on 4/12/20.
//  Copyright © 2020 Mike Wirth. All rights reserved.
//

import UIKit
import CoreBluetooth

private var periphMgr: CBPeripheralManager!

class ViewController: UIViewController, CBPeripheralManagerDelegate {

    @IBOutlet weak var messageLabel: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        super.viewDidLoad()
        periphMgr = CBPeripheralManager(delegate: self, queue: nil)
        }
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        
        switch peripheral.state {
            case .unknown:
                print("Bluetooth Device is UNKNOWN")
            case .unsupported:
                print("Bluetooth Device is UNSUPPORTED")
            case .unauthorized:
                print("Bluetooth Device is UNAUTHORIZED")
            case .resetting:
                print("Bluetooth Device is RESETTING")
            case .poweredOff:
                print("Bluetooth Device is POWERED OFF")
            case .poweredOn:
                print("Bluetooth Device is POWERED ON")
            @unknown default:
                print("Unknown State")

        }
        addServices()
    }
    
    // private let value = "AD34E"
    // var service = CBUUID(string: "C019")     // TCN Coalition Service UUID
    var service = CBUUID(string: "1810")     // Blood Pressure Service UUID

    
    func addServices() {
        print("Service UUID = \(service.uuidString)")
        let valueData = "Creating iOS app as BLE Peripheral".data(using: .utf8)
        
        // 1. Create instances of CBMutableCharacteristic
        let myChar1 = CBMutableCharacteristic(
            type: CBUUID(nsuuid: UUID()),
            properties: [.notify, .write, .read],
            value: nil,
            permissions: [.readable, .writeable])
        
        let myChar2  = CBMutableCharacteristic(
                   type: CBUUID(nsuuid: UUID()),
                   properties: [.read],
                   value: valueData,
                   permissions: [.readable])
        
        // 2. Create instance of CBMutableService
        service = CBUUID(nsuuid: UUID())
        // print("TY:\(type(of:(service.debugDescription)))\n")
        print("Service Desc:\(service.description  )\n")
        print("Service Debug Desc:\(service.debugDescription)\n")
        let myService = CBMutableService(type: service, primary: true)
        
        // 3. Add characteristics to the service
        myService.characteristics = [myChar1, myChar2]
        
        // 4. Add service to peripheralManager
        periphMgr.add(myService)


        
        // 5. Start advertising
        startAdvertising()
    }
    
    func startAdvertising() {
        // Verify that the peripheral manager object is powered on
        periphMgr.state == CBManagerState.poweredOn
        messageLabel.text = "Advertising Data"
        periphMgr.startAdvertising([
            CBAdvertisementDataLocalNameKey: "BLETestPeriph",
            CBAdvertisementDataServiceUUIDsKey: [service]])
        print("Started Advertising")
    }
}

