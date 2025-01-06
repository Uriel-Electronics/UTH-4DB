//
//  PeripheralSettingView.swift
//  UTH-4DB
//
//  Created by 이요섭 on 9/3/24.
//

import SwiftUI
import CoreBluetooth

struct PeripheralSettingView: View {
    @ObservedObject var bluetoothManager = BluetoothManager()
    @Binding var navigateToLanding: Bool
    @Environment(\.presentationMode) var presentationMode
    @State var deviceName: String = "" // 현재 기기 이름을 저장할 상태 변수
    @State private var showAlert = false // 오류 메시지 표시를 위한 상태 변수
    @State private var isLoading = false
    
    var body: some View {
        ZStack {
            Color.bgWhite.ignoresSafeArea()
            
            if isLoading {
                VStack {
                    Text("연결 해제 중").font(Font.custom("Pretendard", size: 24).weight(.bold)).foregroundColor(.textBlack).padding(.top, 40)
                    
                    ProgressView("연결 해제 중...")
                        .progressViewStyle(CircularProgressViewStyle(tint: .textBlack))
                        .foregroundColor(.textBlack)
                        .padding(.vertical, 20)
                }
            } else {
            ScrollView {
                VStack {
                    VStack {
                        
                        Text("기기 설정")
                            .font(Font.custom("Pretendard", size: 20).weight(.bold))
                            .foregroundColor(.textBlack)
                            .padding(.vertical, 40)
                        
                        VStack(spacing: 20) {
                            HStack(spacing: 50) {
                                VStack (alignment: .leading) {
                                    
                                    Text("기기 이름 변경")
                                        .font(Font.custom("Pretendard", size: 16).weight(.bold))
                                        .foregroundColor(.textBlack)
                                        .padding(.bottom, 20)
                                    
                                    HStack(spacing: 10) {
                                        TextField(loadDeviceName(uuidString: bluetoothManager.connectedDeviceIdentifier) ?? "UTH-4DB", text: $deviceName)
                                            .padding()
                                            .frame(maxWidth: .infinity)
                                            .background(.bgWhite)
                                            .foregroundColor(.textBlack)
                                            .cornerRadius(12)
                                            
                                        
                                            Button("확인") {
                                                saveDeviceName(for: bluetoothManager.connectedDeviceIdentifier, name: deviceName)
                                                changeDeviceName()
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                                                    disconnectDevice()
                                                }
                                            }
                                            .font(Font.custom("Pretendard", size: 15).weight(.bold))
                                            .foregroundColor(.textLight)
                                            
                                            .padding()
                                            .frame(width: 100)
                                            .background(.blackDark)
                                            .cornerRadius(12)
                                            // .disabled(deviceName.count > 9)
                                    }
                                }
                            }
                        }
                        .padding(20)
                        .frame(maxWidth: .infinity)
                        .background(Color.whiteLight)
                        .cornerRadius(24)
                        .padding()
                        .padding(.top, -20)
                        .alert(isPresented: $showAlert) {
                            Alert(title: Text("오류"), message: Text("유효하지 않은 이름입니다. 9자 이내로 입력하세요."), dismissButton: .default(Text("확인")))
                        }
                        
                        // 기기 연결 해제 버튼
                        
                        
                            Button("기기 연결 해제") {
                                // 연결 해제 로직 처리
                                isLoading = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                    disconnectDevice()
                                    isLoading = false
                                }
                            }
                            .font(Font.custom("Pretendard", size: 18).weight(.bold))
                            .foregroundColor(.red)
                            // .tracking(1)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .cornerRadius(24)
                            .padding()
                        }
                    }
                }
            }
        }
    }
    
    func changeDeviceName() {
        if deviceName.count <= 9 {
            // 실제 블루투스 기기 이름을 변경하는 코드 필요
            let nameData = Array(deviceName.utf8)
            var nameBytes = [UInt8](repeating: 0, count: 19)
            for (index, byte) in nameData.enumerated() {
                nameBytes[index] = byte
            }
            print(nameBytes)
            
            var checksum: UInt16 = 175
            checksum = checksum &+ UInt16(2)
            for byte in nameBytes {
                checksum = checksum &+ UInt16(byte)
            }
            
            let CHECKSUM = UInt8(checksum % 256)
            print(CHECKSUM)
            
            let packet: [UInt8] = [175, 2] + nameBytes + [CHECKSUM, 13, 10]
            print(packet)
            bluetoothManager.sendBytesToDevice(packet)
            print("기기 이름이 변경되었습니다: \(deviceName)")
            
            // 이름 변경 후 재연결필요...
            
            navigateToLanding = false
            presentationMode.wrappedValue.dismiss()
        } else {
            showAlert = true
        }
    }
    
    func saveDeviceName(for peripheral:String, name: String) {
        let connectedName = bluetoothManager.connectedDeviceIdentifier
        
        //UserDefaults.standard.set(name, forKey: connectedName)
        var peripheralDict = UserDefaults.standard.dictionary(forKey: "PeripheralList") as? [String: [String: String]] ?? [:]
        peripheralDict[connectedName] = ["name": name]
        
        UserDefaults.standard.set(peripheralDict, forKey: "PeripheralList")
        print(connectedName)
    }

    func loadDeviceName(uuidString: String) -> String? {
        // let connectedName = bluetoothManager.connectedDeviceIdentifier
        // UserDefaults.standard.string(forKey: connectedName)
        if let peripheralDict = UserDefaults.standard.dictionary(forKey: "PeripheralList") as? [String: [String: String]] {
            return peripheralDict[uuidString]?["name"]
        }
        return nil
    }
           
    func disconnectDevice () {
        if !bluetoothManager.bluetoothIsReady {
            print("블루투스가 연결되지 않았습니다.")
            return
        }
        bluetoothManager.disconnectDevice()
        navigateToLanding = false
        presentationMode.wrappedValue.dismiss()
    }
}

