//
//  SettingView.swift
//  UTH-4DB
//
//  Created by 이요섭 on 7/17/24.
//

import SwiftUI
import CoreBluetooth

struct SettingView: View {
    @ObservedObject var bluetoothManager: BluetoothManager
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var navigateToLanding: Bool
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var isTimeLoading = false
    @State private var isModeLoading = false
    
    var body: some View {
        ZStack {
            Color.bgWhite.ignoresSafeArea()
            
            VStack (spacing:20) {
                if isModeLoading {
                    ProgressView("로딩 중...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                } else {
                    VStack {
                        Text("모드 선택하기")
                            .font(Font.custom("Pretendard", size: 20).weight(.bold))
                            .lineSpacing(8)
                            .foregroundColor(.textLight)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                        
                        Button(action: {
                            isModeLoading = true
                            sendData()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                                requestPowerData()
                            }
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
//                                requestData()
//                            }
                            isModeLoading = false
                        }) {
                            HStack {
                                Text("모드 선택하기")
                                    .font(Font.custom("Pretendard", size: 22).weight(.bold))
                            }
                            .padding(EdgeInsets(top: 20, leading: 40, bottom: 20, trailing: 40))
                            .foregroundColor(.blackDark)
                            .frame(maxWidth: . infinity)
                            .background(Color.white)
                            .cornerRadius(12)
                            .padding(.bottom)
                        }
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity)
                    .background(Color(red: 0.22, green: 0.23, blue: 0.25))
                    .cornerRadius(24)
                    .padding()
                    .padding(.top, -20)
                }
                
                if isTimeLoading {
                    ProgressView("로딩 중...")
                        .progressViewStyle(CircularProgressViewStyle(tint: .textLight))
                        .padding()
                } else {
                    VStack {
                        Text("기기의 시간과 위치정보를 재설정")
                            .font(Font.custom("Pretendard", size: 20).weight(.bold))
                            .lineSpacing(8)
                            .foregroundColor(.textLight)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                        
                        Button (action: {
                            sendTimeData()
                            isTimeLoading = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                                disconnectDevice()
                                isTimeLoading = false
                            }
                        }){
                            HStack {
                                Text("시간 재설정하기")
                                    .font(Font.custom("Pretendard", size: 22).weight(.bold))
                            }
                            .padding(EdgeInsets(top: 20, leading: 40, bottom: 20, trailing: 40))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .cornerRadius(12)
                            .padding(.bottom)
                        }
                        //.padding()
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity)
                    .background(Color(red: 0.22, green: 0.23, blue: 0.25))
                    .cornerRadius(24)
                    .padding()
                    .padding(.top, -20)
                }
            }
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("알림"), message: Text(alertMessage), dismissButton: .default(Text("확인")))
        }
    }
    
    func disconnectDevice () {
        if !bluetoothManager.bluetoothIsReady {
            print("블루투스가 연결되지 않았습니다.")
            return
        }
        bluetoothManager.disconnectDevice()
    }
    
    func sendData () {
        if !bluetoothManager.bluetoothIsReady {
            print("기기가 연결되지 않음")
            alertMessage = "블루투스가 준비되지 않았습니다."
            showingAlert = true
            return
        }
        
        alertMessage = "기기 설정이 완료되었습니다"
        showingAlert = true
        
        presentationMode.wrappedValue.dismiss()
        navigateToLanding = true
    }
    
    
    func sendTimeData () {
        if !bluetoothManager.bluetoothIsReady {
            print("기기가 연결되지 않음")
            alertMessage = "블루투스가 준비되지 않았습니다."
            showingAlert = true
            return
        }
        
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
