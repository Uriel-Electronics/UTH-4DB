//
//  ScanView.swift
//  UTH-4DB
//
//  Created by 이요섭 on 7/17/24.
//

import SwiftUI
import CoreBluetooth

struct ScanView: View {
    @ObservedObject var bluetoothManager: BluetoothManager
    @Environment(\.presentationMode) var presentationMode
    
    // @Binding var navigateToSetting: Bool
    @Binding var navigateToLanding: Bool
    
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    @State private var isLoading: Bool = false
    
    var body: some View {
        ZStack {
            Color.bgWhite.ignoresSafeArea()
            VStack {
                if isLoading {
                    Text("기기 연결 중").font(Font.custom("Pretendard", size: 24).weight(.bold)).foregroundColor(.blackDark).padding(.top, 40)
                    
                    ProgressView("연결 중...")
                        .progressViewStyle(CircularProgressViewStyle(tint: .blackDark))
                } else {
                    Text("기기 찾기").font(Font.custom("Pretendard", size: 20).weight(.bold)).foregroundColor(.blackDark).padding(.top, 40)
                    Text("기기를 찾지 못할 경우,앱을 종료 후 블루투스 기능을 껏다 켜주세요.").font(Font.custom("Pretendard", size: 15).weight(.bold)).foregroundColor(.blackDark).padding(.vertical, 20)
                    
                    ScrollView {
                        VStack(spacing: 20) {
                            ForEach(bluetoothManager.discoveredDevices, id: \.identifier) { device in
                                Button(action: {
                                    self.isLoading = true
                                    self.bluetoothManager.connectToDevice(device)
                                                                       
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.4) {
                                        sendData()
                                        requestPowerData()
                                    }
                                }) {
//                                    Text(bluetoothManager.findName(for: device.identifier.uuidString) ?? "UTH-4DB")
//                                        .font(Font.custom("Pretendard", size: 20).weight(.bold))
//                                        .foregroundColor(.whiteLight)
//                                        .tracking(1)
//                                        .padding()
//                                        .frame(maxWidth: .infinity)
//                                        .background(.blackDark)
//                                        .cornerRadius(12)
                                    
                                    Text(bluetoothManager.getLastFourCharacters(for: device) ?? "UTH-4DB")
                                        .font(Font.custom("Pretendard", size: 20).weight(.bold))
                                        .foregroundColor(.whiteLight)
                                        .tracking(1)
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(.blackDark)
                                        .cornerRadius(12)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .onAppear {
                        bluetoothManager.loadPeripheralList()
                        bluetoothManager.onConnect = {
                            self.isLoading = false
                            self.navigateToLanding = true
                        }
                    }
//                    .sheet(isPresented:$navigateToSetting) {
//                        SettingView(bluetoothManager: bluetoothManager, navigateToLanding: $navigateToLanding)
//                    }
                }
            }
        }
    }
    
    func sendData () {
        if !bluetoothManager.bluetoothIsReady {
            print("기기가 연결되지 않음")
            alertMessage = "블루투스가 준비되지 않았습니다."
            showingAlert = true
            return
        }
        
        let date = Date()
        let dayform = DateFormatter()
        let hhform = DateFormatter()
        let minform = DateFormatter()
        
        dayform.dateFormat = "ccc"
        hhform.dateFormat = "HH"
        minform.dateFormat = "mm"
        
        let day = dayform.string(from: date)
        let hh = hhform.string(from: date)
        let minute = minform.string(from: date)
        
        let DAY: UInt8 = {
            switch day {
            case "월": return 1
            case "화": return 2
            case "수": return 3
            case "목": return 4
            case "금": return 5
            case "토": return 6
            case "일": return 7
            default: return 0 // 잘못된 요일 값 처리
            }
        }()
        let HH = UInt8(Int(hh)!)
        let MIN = UInt8(Int(minute)!)
        print(DAY)
        print(HH)
        print(MIN)
        
        let CHECKSUM = 207 &+ 4 &+ DAY &+ HH &+ MIN
        let packet: [UInt8] = [207, 4, DAY, HH, MIN, 0,0,0,0,0,0,0, 0,0,0,0,0,0,0, 0,0,0,0,0,0,0, 0,0,0,0,0,0,0 ,CHECKSUM, 13, 10]
        print(packet)
        
        bluetoothManager.sendBytesToDevice(packet)
        alertMessage = "기기 설정이 완료되었습니다"
        showingAlert = true
        
        presentationMode.wrappedValue.dismiss()
        navigateToLanding = true
    }
    
    func requestPowerData() {
        if !bluetoothManager.bluetoothIsReady {
            print("기기가 연결되지 않음")
            alertMessage = "블루투스가 준비되지 않았습니다."
            showingAlert = true
            return
        }
        
        let CHECKSUM: UInt8 = 175 &+ 1
        
        let packet: [UInt8] = [175, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, CHECKSUM, 13, 10]
        
        
        print(packet)
        bluetoothManager.sendBytesToDevice(packet)
        
        presentationMode.wrappedValue.dismiss()
        navigateToLanding = true
    }
    
    func requestData() {
        if !bluetoothManager.bluetoothIsReady {
            print("기기가 연결되지 않음")
            alertMessage = "블루투스가 준비되지 않았습니다."
            showingAlert = true
            return
        }
        
        let CHECKSUM: UInt8 = 175 &+ 5
        
        let packet: [UInt8] = [175, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0,0,0,0,0,0,0,0,0,0,0,0, CHECKSUM, 13, 10]
        
        print(packet)
        bluetoothManager.sendBytesToDevice(packet)
    }
}
