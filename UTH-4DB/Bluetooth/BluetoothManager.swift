//
//  BluetoothManager.swift
//  UTH-4DB
//
//  Created by 이요섭 on 7/17/24.
//

import SwiftUI
import CoreBluetooth

/// 블루투스와 관련된 일을 전담하는 글로벌 시리얼 핸들러입니다.
var serial : BluetoothManager!

// 블루투스를 연결하는 과정에서의 시리얼과 뷰의 소통을 위해 필요한 프로토콜입니다.
protocol BluetoothSerialDelegate : AnyObject {
    func serialDidDiscoverPeripheral(peripheral : CBPeripheral, RSSI : NSNumber?)
    func serialDidConnectPeripheral(peripheral : CBPeripheral)
    func serialDidReceiveMessage(message : UInt16)
}

// 프로토콜에 포함되어 있는 일부 함수를 옵셔널로 설정합니다.
extension BluetoothSerialDelegate {
    func serialDidDiscoverPeripheral(peripheral : CBPeripheral, RSSI : NSNumber?) {}
    func serialDidConnectPeripheral(peripheral : CBPeripheral) {}
    func serialDidReceiveMessage(message : String) {}
}

class BluetoothManager: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    @Published var discoveredDevices: [CBPeripheral] = []
        
    // @Published var discoveredDevices: [String: CBPeripheral] = [:]
    // @Published var devices = [CBPeripheral: String]()
    @Published var devices: [CBPeripheral] = []
    @Published var isConnected: Bool = false
    var onConnect: (() -> Void)?
    @Published var connectedDeviceIdentifier: String = ""
    @Published var connectedDeviceName: String = "UTH-4DB"
    
    @Published var modeNum: Int = 0
    
    @Published var mode1_V_L_Value: Int = 0
    @Published var mode1_V_H_Value: Int = 0
    @Published var mode1_IF_Value: Int = 0
    @Published var mode1_LY_Value: Int = 0
    @Published var mode1_Ht_Value: Int = 0
    @Published var mode1_ES_Value: Int = 0
    @Published var mode1_PF_Value: Int = 0
    @Published var mode1_CHT1_Value: Int = 0
    @Published var mode1_CHT2_Value: Int = 0
    @Published var mode1_CHT3_Value: Int = 0
    @Published var mode1_CHT4_Value: Int = 0
    @Published var mode1_IN_Value:Int = 0
    @Published var mode1_Hb_Value:Int = 0
    @Published var mode1_FL_Value:Int = 0
    @Published var mode1_rN_Value:Int = 0
    @Published var mode1_CHI1_Value:Int = 0
    @Published var mode1_CHI2_Value:Int = 0
    @Published var mode1_CHI3_Value:Int = 0
    @Published var mode1_CHI4_Value:Int = 0
    @Published var mode1_LT_Value:Int = 0
    @Published var sensor1: Int = 0
    @Published var sensor2: Int = 0
    @Published var sensor3: Int = 0
    @Published var sensor4: Int = 0
    
    @Published var openErr: Int = 0
    @Published var shortErr: Int = 0
    @Published var overheatErr: Int = 0
    
    
    @Published var V_L_Value: Int = 0
    @Published var V_H_Value: Int = 0
    @Published var IF_Value: Int = 0
    @Published var LY_Value: Int = 0
    @Published var Ht_Value: Int = 0
    @Published var ES_Value: Int = 0
    @Published var PF_Value: Int = 0
    @Published var CHT1_Value: Int = 0
    @Published var CHT2_Value: Int = 0
    @Published var CHT3_Value: Int = 0
    @Published var CHT4_Value: Int = 0
    @Published var IN_Value:Int = 0
    @Published var Hb_Value:Int = 0
    @Published var FL_Value:Int = 0
    @Published var rN_Value:Int = 0
    @Published var CHI1_Value:Int = 0
    @Published var CHI2_Value:Int = 0
    @Published var CHI3_Value:Int = 0
    @Published var CHI4_Value:Int = 0
    @Published var LT_Value:Int = 0
    
    @Published var mon_ontime:Int = 0
    @Published var mon_offtime:Int = 0
    @Published var tues_ontime:Int = 0
    @Published var tues_offtime:Int = 0
    @Published var wed_ontime:Int = 0
    @Published var wed_offtime:Int = 0
    @Published var thurs_ontime:Int = 0
    @Published var thurs_offtime:Int = 0
    @Published var fri_ontime:Int = 0
    @Published var fri_offtime:Int = 0
    @Published var sat_ontime:Int = 0
    @Published var sat_offtime:Int = 0
    @Published var sun_ontime:Int = 0
    @Published var sun_offtime:Int = 0
    
    @Published var dayValue: UInt8 = 0 {
        didSet {
            self.dayBitSet = BitSet(value: dayValue)
        }
    }
    
    @Published var powerOnOff: UInt8 = 0 {
        didSet {
            self.bitSet = BitSet(value: powerOnOff)
        }
    }
    
    @Published var sectionValue: UInt8 = 0 {
        didSet {
            self.bitSet = BitSet(value: sectionValue)
        }
    }
    
    var bitSet = BitSet()
    var dayBitSet = BitSet()
    
    @Published var powerOn: Bool = false
    @Published var emergencyOn: Bool = false
    var peripheralList: [String: [String : String]] = [:]
    var lastFourCharactersDict: [UUID: String] = [:]
    
    // BluetoothSerialDelegate 프로토콜에 등록된 메서드를 수행하는 delegate입니다.
    var delegate : BluetoothSerialDelegate?
    
    /// centralManager은 블루투스 주변기기를 검색하고 연결하는 역할을 수행합니다.
    var centralManager : CBCentralManager!
    var peripheral: CBPeripheral!
    var characteristic: CBCharacteristic!
    
    /// pendingPeripheral은 현재 연결을 시도하고 있는 블루투스 주변기기를 의미합니다.
    var pendingPeripheral : CBPeripheral?
    
    /// connectedPeripheral은 연결에 성공된 기기를 의미합니다. 기기와 통신을 시작하게되면 이 객체를 이용하게됩니다.
    var connectedPeripheral : CBPeripheral?
    
    /// 데이터를 주변기기에 보내기 위한 characteristic을 저장하는 변수입니다.
    weak var writeCharacteristic: CBCharacteristic?
    
    /// 데이터를 주변기기에 보내는 type을 설정합니다. withResponse는 데이터를 보내면 이에 대한 답장이 오는 경우입니다. withoutResponse는 반대로 데이터를 보내도 답장이 오지 않는 경우입니다.
    private var writeType: CBCharacteristicWriteType = .withoutResponse
    
    /// serviceUUID는 Peripheral이 가지고 있는 서비스의 UUID를 뜻합니다. 거의 모든 HM-10모듈이 기본적으로 갖고있는 FFE0으로 설정하였습니다. 하나의 기기는 여러개의 serviceUUID를 가질 수도 있습니다.
    var serviceUUID = CBUUID(string: "85D1488F-DB99-4DB0-8BC4-FD605A970185")
    
    /// characteristicUUID는 serviceUUID에 포함되어있습니다. 이를 이용하여 데이터를 송수신합니다. FFE0 서비스가 갖고있는 FFE1로 설정하였습니다. 하나의 service는 여러개의 characteristicUUID를 가질 수 있습니다.
    var characteristicUUID = CBUUID(string : "EEB1")
    
    /// 블루투스 기기와 성공적으로 연결되었고, 통신이 가능한 상태라면 true를 반환합니다.
    var bluetoothIsReady:  Bool  {
        get {
            return centralManager.state == .poweredOn &&
            connectedPeripheral?.name != nil &&
            writeCharacteristic != nil
        }
    }
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
        loadPeripheralList()
    }
    
    func startScan() {
        guard centralManager.state == .poweredOn else { return }
        
        // CBCentralManager의 메서드인 scanForPeripherals를 호출하여 연결가능한 기기들을 검색합니다. 이 떄 withService 파라미터에 nil을 입력하면 모든 종류의 기기가 검색되고, 지금과 같이 serviceUUID를 입력하면 특정 serviceUUID를 가진 기기만을 검색합니다.
        // withService의 파라미터를 nil로 설정하면 검색 가능한 모든 기기를 검색합니다.
        // 새로운 주변기기가 연결될 때마다 centralManager(_:didDiscover:advertisementData:rssi:)를 호출합니다.
        centralManager.scanForPeripherals(withServices: nil, options: nil)
        
        // 이미 연결된 기기들을 peripherals 변수에 반환받는 과정입니다.
        let peripherals = centralManager.retrieveConnectedPeripherals(withServices: [serviceUUID])
        for peripheral in peripherals {
            // 연결된 기기들에 대한 처리를 코드로 작성합니다.
            delegate?.serialDidDiscoverPeripheral(peripheral: peripheral, RSSI: nil)
        }
    }

    
    /// 기기 검색을 중단합니다.
    func stopScan() {
        centralManager.stopScan()
    }
    
    
    func connectToDevice(_ device: CBPeripheral) {
        centralManager.connect(device, options: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.isConnected = true
            self.onConnect?()
        }
    }
    
    
    // peripheral disconnecting
    func disconnectDevice() {
        guard let peripheral = connectedPeripheral else {
            print("No device is connected.")
            return
        }
        centralManager.cancelPeripheralConnection(peripheral)
    }
        
    
    
    /// 데이터 Array를 Byte형식으로 주변기기에 전송합니다.
    func sendBytesToDevice(_ bytes: [UInt8]) {
        guard bluetoothIsReady else { return }
        
        let data = Data(bytes: UnsafePointer<UInt8>(bytes), count: bytes.count)
        connectedPeripheral!.writeValue(data, for: writeCharacteristic!, type: writeType)
    }
    
    /// 데이터를 주변기기에 전송합니다.
    func sendDataToDevice(_ data: Data) {
        guard bluetoothIsReady else { return }
        
        connectedPeripheral!.writeValue(data, for: writeCharacteristic!, type: writeType)
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            let options = [CBCentralManagerScanOptionAllowDuplicatesKey: false]
            centralManager.scanForPeripherals(withServices: nil, options: options)
        } else {
            // 적절한 오류 처리
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        if peripheralList.keys.contains(peripheral.identifier.uuidString) {
            print("Target Device with UUID found")
        }
        
        if let manufacturerData = advertisementData[CBAdvertisementDataManufacturerDataKey] as? Data {
            let targetManufacturerData = Data([0x94, 0xC9])
                                    
            let hexString = manufacturerData.map { String(format: "%02x", $0) }.joined()
            print("Manufacturer Data (Hex): \(hexString)")
            
            let slicedHexString = String(hexString.dropFirst(8).prefix(4)).uppercased()
            lastFourCharactersDict[peripheral.identifier] = slicedHexString
                                    
            if #available(iOS 16.0, *) {
                if manufacturerData.contains(targetManufacturerData) {
                    
                    if let localNameData = advertisementData[CBAdvertisementDataLocalNameKey] as? String {
                    let targetLocalNameData = "UTH-4DB"
            
                        if localNameData == targetLocalNameData {
                            if !discoveredDevices.contains(peripheral) {
                                discoveredDevices.append(peripheral)
                            }
                        }
                    }
                }
            } else {
                // Fallback on earlier versions iOS 15.0
                let targetDataCount = targetManufacturerData.count
                let manufacturerDataCount = manufacturerData.count
                var found = false
                
                if manufacturerDataCount >= targetDataCount {
                    for i in 0...(manufacturerDataCount - targetDataCount) {
                        let range = i..<(i + targetDataCount)
                        if manufacturerData[range] == targetManufacturerData {
                            found = true
                            break
                        }
                    }
                }
                
                if found {
                    if !discoveredDevices.contains(peripheral) {
                        discoveredDevices.append(peripheral)
                    }
                }
            }
        }
    }
    
    /// 특정 peripheral의 마지막 4자리 Manufacturer Data 반환
    func getLastFourCharacters(for device: CBPeripheral) -> String? {
        return lastFourCharactersDict[device.identifier]
//        return lastFourCharactersDict
    }
    
    func loadDeviceName(_ peripheral: CBPeripheral) -> String {
        let connectedName = peripheral.identifier.uuidString
        return UserDefaults.standard.string(forKey: connectedName) ?? peripheral.name ?? "Unknown Device"
    }
    
    func loadPeripheralList() {
        let userDefaults = UserDefaults.standard
        if let storedPeripherals = userDefaults.dictionary(forKey: "PeripheralList") as? [String: [String:String]] {
            peripheralList = storedPeripherals
        }
    }
        
    func findName(for uuidString: String) -> String? {
        return peripheralList[uuidString]?["name"]
    }
    
    

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        // 연결 성공 처리
        print("연결 성공: \(peripheral.name ?? "")")
        peripheral.delegate = self
        pendingPeripheral = nil
        connectedPeripheral = peripheral
        connectedDeviceName = peripheral.name ?? "Unknown Device"
        connectedDeviceIdentifier = peripheral.identifier.uuidString
        isConnected = true
        
        peripheral.discoverServices(nil)
        delegate?.serialDidConnectPeripheral(peripheral: peripheral)
        DispatchQueue.main.async {
            self.isConnected = true
        }
    }
    
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Device disconnected.")
        isConnected = false
        if peripheral == connectedPeripheral {
            connectedPeripheral = nil
        }
    }
    
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        // 연결 실패 처리
        print("연결 실패: \(peripheral.name ?? ""), 오류: \(error?.localizedDescription ?? "알 수 없는 오류")")
    }
    
    // service 검색에 성공 시 호출되는 메서드입니다.
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        for service in peripheral.services! {
            // 검색된 모든 service에 대해서 characteristic을 검색합니다. 파라미터를 nil로 설정하면 해당 service의 모든 characteristic을 검색합니다.
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    
    // characteristic 검색에 성공 시 호출되는 메서드입니다.
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else {
                return
            }
            
            for characteristic in characteristics {
                if characteristic.properties.contains(.read) {
                    peripheral.readValue(for: characteristic)
                }
                
                if characteristic.properties.contains(.write) {
                    self.characteristic = characteristic
                    sendCurrentStatusRequest() // characteristic이 설정된 후 현재 상태를 요청합니다.
                }
                
                if characteristic.properties.contains(.notify) {
                    peripheral.setNotifyValue(true, for: characteristic)
                }
                
                if characteristic.uuid == characteristicUUID {
                    // 데이터를 보내기 위한 characteristic을 저장.
                    writeCharacteristic = characteristic
                    // 데이터를 보내는 타입을 설정합니다. 이는 주변기기가 어떤 type으로 설정되어 있는지에 따라 변경.
                    writeType = characteristic.properties.contains(.write) ? .withResponse : .withoutResponse
                    // 주변 기기와 연결 완료 시 동작하는 코드를 여기에 작성합니다.
                    delegate?.serialDidConnectPeripheral(peripheral: peripheral)
                }
            }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
            if error != nil {
                print("Failed to subscribe to characteristic notifications: \(String(describing: error))")
                return
            }
            if characteristic.isNotifying {
                print("Successfully subscribed to characteristic notifications.")
            } else {
                print("Stopped subscribing to characteristic notifications.")
            }
        }
    
    
    func sendCurrentStatusRequest() {
        guard let characteristic = self.characteristic else {
            print("Characteristic is not set.")
            return
        }
        
            let stx: UInt8 = 0x00
            let mode: UInt8 = 0x00
            let day: UInt8 = 0x00
            let onTime: [UInt8] = [0x00, 0x00]
            let offTime: [UInt8] = [0x00, 0x00]
            let onTime2: [UInt8] = [0x00, 0x00]
            let offTime2: [UInt8] = [0x00, 0x00]

            let checksum: UInt8 = stx &+ mode &+ day &+ onTime[0] &+ onTime[1] &+ offTime[0] &+ offTime[1] &+ onTime2[0] &+ onTime2[1] &+ offTime2[0] &+ offTime2[1]
            let packet: [UInt8] = [stx, mode, day, onTime[0], onTime[1], offTime[0], offTime[1], onTime2[0], onTime2[1], offTime2[0], offTime2[1], checksum, 0x0D, 0x0A]

            let data = Data(packet)
            connectedPeripheral?.writeValue(data, for: characteristic, type: .withResponse)
        }
    
    // peripheral으로부터 데이터를 전송받으면 호출되는 메서드.
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
        // 전송받은 데이터가 존재하는지 확인.
        if let data = characteristic.value {
            let response = [UInt8](data)
            
            if response[0] == 0xDF {
                let mode = response[1]
                let day = response[2]
                let hour = response[3]
                let minute = response[4]
                let mon_ontime1:UInt8 = response[5]
                let mon_ontime2:UInt8 = response[6]
                let mon_ontime: UInt16 = (UInt16(mon_ontime1) << 8) | UInt16(mon_ontime2)
                
                let tues_ontime1 = response[7]
                let tues_ontime2 = response[8]
                let tues_ontime: UInt16 = (UInt16(tues_ontime1) << 8) | UInt16(tues_ontime2)
                
                let wed_ontime1 = response[9]
                let wed_ontime2 = response[10]
                let wed_ontime: UInt16 = (UInt16(wed_ontime1) << 8) | UInt16(wed_ontime2)
                
                let thurs_ontime1 = response[11]
                let thurs_ontime2 = response[12]
                let thurs_ontime: UInt16 = (UInt16(thurs_ontime1) << 8) | UInt16(thurs_ontime2)
                
                let fri_ontime1 = response[13]
                let fri_ontime2 = response[14]
                let fri_ontime: UInt16 = (UInt16(fri_ontime1) << 8) | UInt16(fri_ontime2)
                
                let sat_ontime1 = response[15]
                let sat_ontime2 = response[16]
                let sat_ontime: UInt16 = (UInt16(sat_ontime1) << 8) | UInt16(sat_ontime2)
                
                let sun_ontime1 = response[17]
                let sun_ontime2 = response[18]
                let sun_ontime: UInt16 = (UInt16(sun_ontime1) << 8) | UInt16(sun_ontime2)
                
                let mon_offtime1 = response[19]
                let mon_offtime2 = response[20]
                let mon_offtime: UInt16 = (UInt16(mon_offtime1) << 8) | UInt16(mon_offtime2)
                
                let tues_offtime1 = response[21]
                let tues_offtime2 = response[22]
                let tues_offtime: UInt16 = (UInt16(tues_offtime1) << 8) | UInt16(tues_offtime2)
                
                let wed_offtime1 = response[23]
                let wed_offtime2 = response[24]
                let wed_offtime: UInt16 = (UInt16(wed_offtime1) << 8) | UInt16(wed_offtime2)
                
                let thurs_offtime1 = response[25]
                let thurs_offtime2 = response[26]
                let thurs_offtime: UInt16 = (UInt16(thurs_offtime1) << 8) | UInt16(thurs_offtime2)
                
                let fri_offtime1 = response[27]
                let fri_offtime2 = response[28]
                let fri_offtime: UInt16 = (UInt16(fri_offtime1) << 8) | UInt16(fri_offtime2)
                
                let sat_offtime1 = response[29]
                let sat_offtime2 = response[30]
                let sat_offtime: UInt16 = (UInt16(sat_offtime1) << 8) | UInt16(sat_offtime2)
                
                let sun_offtime1 = response[31]
                let sun_offtime2 = response[32]
                let sun_offtime: UInt16 = (UInt16(sun_offtime1) << 8) | UInt16(sun_offtime2)
                
                let checksum = response[33]
                
                var calculatedChecksum: UInt8 = 0xDF
                for i in 1..<33 {
                    calculatedChecksum = calculatedChecksum &+ response[i]
                }
                
                if calculatedChecksum == checksum {
                    DispatchQueue.main.async {
                        print(mon_ontime)
                        
                        if Int(mode) == 1 {
                            if mon_ontime > 1440 {
                                self.mon_ontime = 0
                            } else {
                                self.mon_ontime = Int(mon_ontime)
                            }
                            
                            if tues_ontime > 1440 {
                                self.tues_ontime = 0
                            } else {
                                self.tues_ontime = Int(tues_ontime)
                            }
                            
                            if wed_ontime > 1440 {
                                self.wed_ontime = 0
                            } else {
                                self.wed_ontime = Int(wed_ontime)
                            }
                            
                            if thurs_ontime > 1440 {
                                self.thurs_ontime = 0
                            } else {
                                self.thurs_ontime = Int(thurs_ontime)
                            }
                            
                            if fri_ontime > 1440 {
                                self.fri_ontime = 0
                            } else {
                                self.fri_ontime = Int(fri_ontime)
                            }
                            
                            if sat_ontime > 1440 {
                                self.sat_ontime = 0
                            } else {
                                self.sat_ontime = Int(sat_ontime)
                            }
                            
                            if sun_ontime > 1440 {
                                self.sun_ontime = 0
                            } else {
                                self.sun_ontime = Int(sun_ontime)
                            }
                                                                                    
                            if mon_offtime > 1440 {
                                self.mon_offtime = 0
                            } else {
                                self.mon_offtime = Int(mon_offtime)
                            }
                            
                            if tues_offtime > 1440 {
                                self.tues_offtime = 0
                            } else {
                                self.tues_offtime = Int(tues_offtime)
                            }
                            
                            if wed_offtime > 1440 {
                                self.wed_offtime = 0
                            } else {
                                self.wed_offtime = Int(wed_offtime)
                            }
                            
                            if thurs_offtime > 1440 {
                                self.thurs_offtime = 0
                            } else {
                                self.thurs_offtime = Int(thurs_offtime)
                            }
                            
                            if fri_offtime > 1440 {
                                self.fri_offtime = 0
                            } else {
                                self.fri_offtime = Int(fri_offtime)
                            }
                            
                            if sat_offtime > 1440 {
                                self.sat_offtime = 0
                            } else {
                                self.sat_offtime = Int(sat_offtime)
                            }
                            
                            if sun_offtime > 1440 {
                                self.sun_offtime = 0
                            } else {
                                self.sun_offtime = Int(sun_offtime)
                            }
                            
                        }
                    }
                }
                                
            } else if response[0] == 0xBF {
                let mode = response[1]
                let V_L = response[2]
                let V_H = response[3]
                let IF = response[4]
                let LY = response[5]
                let Ht = response[6]
                let ES = response[7]
                let PF = response[8]
                let CHT1 = response[9]
                let CHT2 = response[10]
                let CHT3 = response[11]
                let CHT4 = response[12]
                // let CHT = [response[9], response[10], response[11], response[12]]
                let IN = response[13]
                let Hb = response[14]
                let FL = response[15]
                let rN = response[16]
                // let CHI = [response[17], response[18], response[19], response[20]]
                let CHI1 = response[17]
                let CHI2 = response[18]
                let CHI3 = response[19]
                let CHI4 = response[20]
                let LT = response[21]
                
                let checksum = response[22]
                
                var calculatedChecksum: UInt8 = 0xBF
                for i in 1..<22 {
                    calculatedChecksum = calculatedChecksum &+ response[i]
                }
                
                if calculatedChecksum == checksum {
                    
                    DispatchQueue.main.async {
                        print("Mode: \(mode)")
                        print("V_L: \(V_L)")
                        print("V_H: \(V_H)")
                        print("IF: \(IF)")
                        print("LY: \(LY)")
                        print("Ht: \(Ht)")
                        print("ES: \(ES)")
                        print("PF: \(PF)")
                        print("CHT1: \(CHT1)")
                        print("CHT2: \(CHT2)")
                        print("CHT3: \(CHT3)")
                        print("CHT4: \(CHT4)")
                        print("IN: \(IN)")
                        print("Hb: \(Hb)")
                        print("FL: \(FL)")
                        print("rN: \(rN)")
                        print("CHI1: \(CHI1)")
                        print("CHI2: \(CHI2)")
                        print("CHI3: \(CHI3)")
                        print("CHI4: \(CHI4)")
                        print("LT: \(LT)")
                        
                        if Int(mode) == 1 {
                            
                            self.powerOnOff = V_L
                            self.mode1_V_H_Value = Int(V_H)
                            // self.mode1_IF_Value = Int(IF)
                            self.openErr = Int((IF & 0x01))
                            self.shortErr = Int((IF & 0x02))
                            self.overheatErr = Int((IF & 0x04))
                            print(self.openErr)
                            print(self.shortErr)
                            print(self.overheatErr)
                            
                            // self.mode1_LY_Value = Int(LY)
                            self.sensor1 = Int((LY & 0x01))
                            self.sensor2 = Int((LY & 0x02))
                            self.sensor3 = Int((LY & 0x04))
                            self.sensor4 = Int((LY & 0x08))
                            print(self.sensor1)
                            print(self.sensor2)
                            print(self.sensor3)
                            print(self.sensor4)
                            
                            self.mode1_Ht_Value = Int(Ht)
                            self.mode1_ES_Value = Int(ES)
                            self.mode1_PF_Value = Int(PF)
                            self.mode1_CHT1_Value = Int(CHT1)
                            self.mode1_CHT2_Value = Int(CHT2)
                            self.mode1_CHT3_Value = Int(CHT3)
                            self.mode1_CHT4_Value = Int(CHT4)
                            self.mode1_IN_Value = Int(IN)
                            self.mode1_Hb_Value = Int(Hb)
                            self.mode1_FL_Value = Int(FL)
                            self.mode1_rN_Value = Int(rN)
                            self.mode1_CHI1_Value = Int(CHI1)
                            self.mode1_CHI2_Value = Int(CHI2)
                            self.mode1_CHI3_Value = Int(CHI3)
                            self.mode1_CHI4_Value = Int(CHI4)
                            self.mode1_LT_Value = Int(LT)
                        }
                        
                        if Int(mode) == 5 {
                            self.V_L_Value = Int(V_L)
                            self.V_H_Value = Int(V_H)
                            self.IF_Value = Int(IF)
                            self.LY_Value = Int(LY)
                            self.Ht_Value = Int(Ht)
                            self.ES_Value = Int(ES)
                            self.PF_Value = Int(PF)
                            self.CHT1_Value = Int(CHT1)
                            self.CHT2_Value = Int(CHT2)
                            self.CHT3_Value = Int(CHT3)
                            self.CHT4_Value = Int(CHT4)
                            self.IN_Value = Int(IN)
                            self.Hb_Value = Int(Hb)
                            self.FL_Value = Int(FL)
                            self.rN_Value = Int(rN)
                            self.CHI1_Value = Int(CHI1)
                            self.CHI2_Value = Int(CHI2)
                            self.CHI3_Value = Int(CHI3)
                            self.CHI4_Value = Int(CHI4)
                            self.LT_Value = Int(LT)
                        }
                    }
                    
                } else {
                    print("Checksum mismatch")
                }
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        // writeType이 .withResponse일 때, 블루투스 기기로부터의 응답이 왔을 때 호출되는 메서드.
        // 필요한 로직을 작성.
        // 전송받은 데이터가 존재하는지 확인.
        if let data = characteristic.value {
            let response = [UInt8](data)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
        // 블루투스 기기의 신호 강도를 요청하는 peripheral.readRSSI()가 호출하는 메서드.
        // 신호 강도와 관련된 코드를 작성.
        // 필요한 로직을 작성.
    }
}

struct BitSet {
    private(set) var value: UInt8 {
        didSet {
            UserDefaults.standard.set(value, forKey: "selectedSections")
            print(value)
        }
    }
    
    init(value: UInt8 = 0) {
        self.value = value
        print(self.value)
    }
    
    mutating func set(section: Int) {
        value |= (1 << section)
    }

    mutating func clear(section: Int) {
        value &= ~(1 << section)
    }

    func isSet(section: Int) -> Bool {
        return (value & (1 << section)) != 0
    }
}

