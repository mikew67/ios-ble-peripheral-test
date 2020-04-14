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
    
    // var service = CBUUID(string: "AD34")     // Random 16-bit Service UUID
    var service1 = CBUUID(string: "C019")     // TCN Coalition Service UUID
    //var service2 = CBUUID(string: "1810")     // Blood Pressure Service UUID
    var service2 = CBUUID(string: "F5A1287E-227D-4C9E-AD2C-11D0FD6ED640")       // Random 128-bit Service UUID

    
    func addServices() {

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
        print("Service1 UUID = \(service1.uuidString)")
        print("Service1 Desc = \(service1.description)")
        print("Service2 UUID = \(service2.uuidString)")
        print("Service2 Desc = \(service2.description)\n")

        let myService1 = CBMutableService(type: service1, primary: true)
        let myService2 = CBMutableService(type: service2, primary: false)

        // 3. Add characteristics to the service
        myService1.characteristics = [myChar1, myChar2]
        
        // 4. Add service to peripheralManager
        periphMgr.add(myService1)
        periphMgr.add(myService2)


        
        // 5. Start advertising
        startAdvertising()
    }
    
    func startAdvertising() {
        // Verify that the peripheral manager object is powered on
        // periphMgr.state == CBManagerState.poweredOn
        messageLabel.text = "Advertising Data"
        periphMgr.startAdvertising([
            CBAdvertisementDataLocalNameKey: "B",
            CBAdvertisementDataServiceUUIDsKey: [service1, service2]
        ])
        print("Started Advertising")
    }
}

