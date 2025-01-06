//
//  SectionStepView.swift
//  UTH-4DB
//
//  Created by 이요섭 on 7/28/24.
//

import SwiftUI
import CoreBluetooth

struct SectionStepView: View {
    @ObservedObject var bluetoothManager: BluetoothManager
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
//    @State private var Section1Step: Int = 0
//    @State private var Section2Step: Int = 0
//    @State private var Section3Step: Int = 0
//    @State private var Section4Step: Int = 0
    
    @State var CHI1_Value: Int
    @State var CHI2_Value: Int
    @State var CHI3_Value: Int
    @State var CHI4_Value: Int
    
    var body: some View {
        ZStack {
            Color.bgWhite.ignoresSafeArea()
            
            
                VStack(spacing: 8) {
                    Text("구역별 강도 선택")
                        .font(Font.custom("Pretendard", size: 20).weight(.bold))
                        .foregroundColor(.blackDark)
                        .padding()
                    
                    Spacer()
                    
                    VStack {
                        HStack {
                            VStack(spacing: 2) {
                                Text("구역 1")
                                    .font(Font.custom("Pretendard", size: 16).weight(.bold))
                                    .foregroundColor(.blackDark)
                                    .padding(.top)
                                
                                Picker("구역 1", selection: $CHI1_Value) {
                                    ForEach(1..<11) { step in
                                        Text("\(step)단계").tag(step)
                                    }
                                }
                                .pickerStyle(.wheel)
                                .frame(height: 80)
                                .foregroundColor(.blackDark)
                                .background(.whiteLight)
                                .cornerRadius(16)
                                .padding()
                                .onChange(of: CHI1_Value) { _ in
                                    sendStep1Data()
                                }
                            }
                            .background(.whiteLight)
                            .cornerRadius(24)
                            
                            VStack (spacing:2) {
                                Text("구역 2")
                                    .font(Font.custom("Pretendard", size: 16).weight(.bold))
                                    .foregroundColor(.blackDark)
                                    .padding(.top)
                                
                                Picker("구역 2", selection: $CHI2_Value) {
                                    ForEach(1..<11) { step in
                                        Text("\(step)단계").tag(step)
                                    }
                                }
                                .pickerStyle(.wheel)
                                .frame(height: 80)
                                .foregroundColor(.blackDark)
                                .background(.whiteLight)
                                .cornerRadius(16)
                                .padding()
                                .onChange(of: CHI2_Value) { _ in
                                    sendStep2Data()
                                }
                            }
                            .background(.whiteLight)
                            .cornerRadius(24)
                        }
                        
                        
                        HStack {
                            VStack(spacing:2) {
                                Text("구역 3")
                                    .font(Font.custom("Pretendard", size: 16).weight(.bold))
                                    .foregroundColor(.blackDark)
                                    .padding(.top)
                                
                                Picker("구역 3", selection: $CHI3_Value) {
                                    ForEach(1..<11) { step in
                                        Text("\(step)단계").tag(step)
                                    }
                                }
                                .pickerStyle(.wheel)
                                .frame(height: 80)
                                .foregroundColor(.blackDark)
                                .background(.whiteLight)
                                .cornerRadius(16)
                                .padding()
                                .onChange(of: CHI3_Value) { _ in
                                    sendStep3Data()
                                }
                            }
                            .background(.whiteLight)
                            .cornerRadius(24)
                            
                            
                            VStack(spacing:2) {
                                Text("구역 4")
                                    .font(Font.custom("Pretendard", size: 16).weight(.bold))
                                    .foregroundColor(.blackDark)
                                    .padding(.top)
                                
                                Picker("구역 4", selection: $CHI4_Value) {
                                    ForEach(1..<11) { step in
                                        Text("\(step)단계").tag(step)
                                    }
                                }
                                .pickerStyle(.wheel)
                                .frame(height: 80)
                                .foregroundColor(.blackDark)
                                .background(.whiteLight)
                                .cornerRadius(16)
                                .padding()
                                .onChange(of: CHI4_Value) { _ in
                                    sendStep4Data()
                                }
                            }
                            .background(.whiteLight)
                            .cornerRadius(24)
                        }
                    }
                    .padding()
                    
                    Spacer()
                    
                    Button("저장") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .font(Font.custom("Pretendard", size: 18).weight(.bold))
                    .foregroundColor(.textLight)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.blackDark)
                    .cornerRadius(12)
                    .padding()
                    .onTapGesture {
                        presentationMode.wrappedValue.dismiss()
                    }
                
            }
        }
        .onAppear {
            requestData()
        }
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
    
    func sendStep1Data() {
        if !bluetoothManager.bluetoothIsReady {
            print("기기가 연결되지 않음")
            alertMessage = "블루투스가 준비되지 않았습니다."
            showingAlert = true
            return
        }
        
        _ = UInt8(Int(15))
        let V_L = UInt8(Int(0)) // 최소 온도
        let V_H = UInt8(Int(80)) // 최대 온도
        let IF = UInt8(Int(5)) // 온도 편차
        let LY = UInt8(Int(10)) // 출력 지연
        let Ht = UInt8(Int(50)) // 과승 온도
        let ES = UInt8(Int(0)) // 보정 온도
        let PF = UInt8(Int(6)) // 자동 OFF 시간
        let CHT1 = UInt8(Int(bluetoothManager.CHT1_Value))
        let CHT2 = UInt8(Int(bluetoothManager.CHT2_Value))
        let CHT3 = UInt8(Int(bluetoothManager.CHT3_Value))
        let CHT4 = UInt8(Int(bluetoothManager.CHT4_Value))
        let IN = UInt8(Int(30)) // 주기 시간
        let Hb = UInt8(Int(10)) // 초기 투입 시간
        let FL = UInt8(Int(20)) // 기타
        let rN = UInt8(Int(40)) // 기타
        let CHI1 = UInt8(Int(CHI1_Value))
        let CHI2 = UInt8(Int(CHI2_Value))
        let CHI3 = UInt8(Int(CHI3_Value))
        let CHI4 = UInt8(Int(CHI4_Value))
        let LT = UInt8(Int(3))
        
        let CHECKSUM: UInt8 = 175 &+ 4 &+ V_L &+ V_H &+ IF &+ LY &+ Ht &+ ES &+ PF &+ CHT1 &+ CHT2 &+ CHT3 &+ CHT4 &+ IN &+ Hb &+ FL &+ rN &+ CHI1 &+ CHI2 &+ CHI3 &+ CHI4 &+ LT
        
        let packet: [UInt8] = [175, 4, V_L, V_H, IF, LY, Ht, ES, PF, CHT1,CHT2,CHT3,CHT4,IN, Hb, FL, rN, CHI1, CHI2, CHI3, CHI4, LT, CHECKSUM, 13, 10]
        
        print(packet)
        bluetoothManager.sendBytesToDevice(packet)
    }
    
    func sendStep2Data() {
        if !bluetoothManager.bluetoothIsReady {
            print("기기가 연결되지 않음")
            alertMessage = "블루투스가 준비되지 않았습니다."
            showingAlert = true
            return
        }
        
        _ = UInt8(Int(15))
        let V_L = UInt8(Int(0)) // 최소 온도
        let V_H = UInt8(Int(60)) // 최대 온도
        let IF = UInt8(Int(5)) // 온도 편차
        let LY = UInt8(Int(10)) // 출력 지연
        let Ht = UInt8(Int(50)) // 과승 온도
        let ES = UInt8(Int(0)) // 보정 온도
        let PF = UInt8(Int(6)) // 자동 OFF 시간
        let CHT1 = UInt8(Int(bluetoothManager.CHT1_Value))
        let CHT2 = UInt8(Int(bluetoothManager.CHT2_Value))
        let CHT3 = UInt8(Int(bluetoothManager.CHT3_Value))
        let CHT4 = UInt8(Int(bluetoothManager.CHT4_Value))
        let IN = UInt8(Int(30)) // 주기 시간
        let Hb = UInt8(Int(10)) // 초기 투입 시간
        let FL = UInt8(Int(20)) // 기타
        let rN = UInt8(Int(40)) // 기타
        let CHI1 = UInt8(Int(CHI1_Value))
        let CHI2 = UInt8(Int(CHI2_Value))
        let CHI3 = UInt8(Int(CHI3_Value))
        let CHI4 = UInt8(Int(CHI4_Value))
        let LT = UInt8(Int(3))
        
        let CHECKSUM: UInt8 = 175 &+ 4 &+ V_L &+ V_H &+ IF &+ LY &+ Ht &+ ES &+ PF &+ CHT1 &+ CHT2 &+ CHT3 &+ CHT4 &+ IN &+ Hb &+ FL &+ rN &+ CHI1 &+ CHI2 &+ CHI3 &+ CHI4 &+ LT
        
        let packet: [UInt8] = [175, 4, V_L, V_H, IF, LY, Ht, ES, PF, CHT1,CHT2,CHT3,CHT4,IN, Hb,FL, rN, CHI1, CHI2, CHI3, CHI4, LT, CHECKSUM, 13, 10]
        
        print(packet)
        bluetoothManager.sendBytesToDevice(packet)
    }
    
    func sendStep3Data() {
        if !bluetoothManager.bluetoothIsReady {
            print("기기가 연결되지 않음")
            alertMessage = "블루투스가 준비되지 않았습니다."
            showingAlert = true
            return
        }
        
        _ = UInt8(Int(15))
        let V_L = UInt8(Int(0)) // 최소 온도
        let V_H = UInt8(Int(60)) // 최대 온도
        let IF = UInt8(Int(5)) // 온도 편차
        let LY = UInt8(Int(10)) // 출력 지연
        let Ht = UInt8(Int(50)) // 과승 온도
        let ES = UInt8(Int(0)) // 보정 온도
        let PF = UInt8(Int(6)) // 자동 OFF 시간
        let CHT1 = UInt8(Int(bluetoothManager.CHT1_Value))
        let CHT2 = UInt8(Int(bluetoothManager.CHT2_Value))
        let CHT3 = UInt8(Int(bluetoothManager.CHT3_Value))
        let CHT4 = UInt8(Int(bluetoothManager.CHT4_Value))
        let IN = UInt8(Int(30)) // 주기 시간
        let Hb = UInt8(Int(10)) // 초기 투입 시간
        let FL = UInt8(Int(20)) // 기타
        let rN = UInt8(Int(40)) // 기타
        let CHI1 = UInt8(Int(CHI1_Value))
        let CHI2 = UInt8(Int(CHI2_Value))
        let CHI3 = UInt8(Int(CHI3_Value))
        let CHI4 = UInt8(Int(CHI4_Value))
        let LT = UInt8(Int(3))
        
        let CHECKSUM: UInt8 = 175 &+ 4 &+ V_L &+ V_H &+ IF &+ LY &+ Ht &+ ES &+ PF &+ CHT1 &+ CHT2 &+ CHT3 &+ CHT4 &+ IN &+ Hb &+ FL &+ rN &+ CHI1 &+ CHI2 &+ CHI3 &+ CHI4 &+ LT
        
        let packet: [UInt8] = [175, 4, V_L, V_H, IF, LY, Ht, ES, PF, CHT1,CHT2,CHT3,CHT4,IN, Hb,FL, rN, CHI1, CHI2, CHI3, CHI4, LT, CHECKSUM, 13, 10]
        
        print(packet)
        bluetoothManager.sendBytesToDevice(packet)
    }
    
    func sendStep4Data() {
        if !bluetoothManager.bluetoothIsReady {
            print("기기가 연결되지 않음")
            alertMessage = "블루투스가 준비되지 않았습니다."
            showingAlert = true
            return
        }
        
        _ = UInt8(Int(15))
        let V_L = UInt8(Int(0)) // 최소 온도
        let V_H = UInt8(Int(60)) // 최대 온도
        let IF = UInt8(Int(5)) // 온도 편차
        let LY = UInt8(Int(10)) // 출력 지연
        let Ht = UInt8(Int(50)) // 과승 온도
        let ES = UInt8(Int(0)) // 보정 온도
        let PF = UInt8(Int(6)) // 자동 OFF 시간
        let CHT1 = UInt8(Int(bluetoothManager.CHT1_Value))
        let CHT2 = UInt8(Int(bluetoothManager.CHT2_Value))
        let CHT3 = UInt8(Int(bluetoothManager.CHT3_Value))
        let CHT4 = UInt8(Int(bluetoothManager.CHT4_Value))
        let IN = UInt8(Int(30)) // 주기 시간
        let Hb = UInt8(Int(10)) // 초기 투입 시간
        let FL = UInt8(Int(20)) // 기타
        let rN = UInt8(Int(40)) // 기타
        let CHI1 = UInt8(Int(CHI1_Value))
        let CHI2 = UInt8(Int(CHI2_Value))
        let CHI3 = UInt8(Int(CHI3_Value))
        let CHI4 = UInt8(Int(CHI4_Value))
        let LT = UInt8(Int(3))
        
        let CHECKSUM: UInt8 = 175 &+ 4 &+ V_L &+ V_H &+ IF &+ LY &+ Ht &+ ES &+ PF &+ CHT1 &+ CHT2 &+ CHT3 &+ CHT4 &+ IN &+ Hb &+ FL &+ rN &+ CHI1 &+ CHI2 &+ CHI3 &+ CHI4 &+ LT
        
        let packet: [UInt8] = [175, 4, V_L, V_H, IF, LY, Ht, ES, PF, CHT1,CHT2,CHT3,CHT4,IN, Hb,FL, rN, CHI1, CHI2, CHI3, CHI4, LT, CHECKSUM, 13, 10]
        
        print(packet)
        bluetoothManager.sendBytesToDevice(packet)
    }
}
