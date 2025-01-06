//
//  SectionTmpView.swift
//  UTH-4DB
//
//  Created by 이요섭 on 7/26/24.
//

import SwiftUI
import CoreBluetooth

struct SectionTmpView: View {
    @ObservedObject var bluetoothManager = BluetoothManager()
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
//    @State var Section1Tmp: Int = 0
//    @State var Section2Tmp: Int = 0
//    @State var Section3Tmp: Int = 0
//    @State var Section4Tmp: Int = 0
    
    @State var CHT1_Value: Int
    @State var CHT2_Value: Int
    @State var CHT3_Value: Int
    @State var CHT4_Value: Int
    
    var body: some View {
        ZStack(alignment: .leading) {
            Color.bgWhite.ignoresSafeArea()
                        
            VStack(spacing: 8) {
                    Text("구역별 온도 설정하기")
                        .font(Font.custom("Pretendard", size: 20).weight(.bold))
                        .foregroundColor(.blackDark)
                        .padding()
                    
//                    Spacer()
                    
                    VStack {
                        HStack {
                            VStack(spacing:2) {
                                Text("구역 1")
                                    .font(Font.custom("Pretendard", size: 16).weight(.bold))
                                    .foregroundColor(.blackDark)
                                    .padding(.top)
                                
                                Picker("구역 1", selection: $CHT1_Value) {
                                    ForEach(0..<81) { tmp in
                                        Text("\(tmp)℃").tag(tmp)
                                    }
                                }
                                .pickerStyle(.wheel)
                                .frame(height:80)
                                .foregroundColor(.blackDark)
                                .background(.whiteLight)
                                .cornerRadius(16)
                                .padding()
                                .onChange(of: CHT1_Value) { _ in
                                    sendTmp1Data()
                                }
                            }
                            .background(.whiteLight)
                            .cornerRadius(24)
                            //.padding()
                            
                            VStack(spacing:2) {
                                Text("구역 2")
                                    .font(Font.custom("Pretendard", size: 16).weight(.bold))
                                    .foregroundColor(.blackDark)
                                    .padding(.top)
                                
                                Picker("구역 2", selection: $CHT2_Value) {
                                    ForEach(0..<81) { tmp in
                                        Text("\(tmp)℃").tag(tmp)
                                    }
                                }
                                .pickerStyle(.wheel)
                                .frame(height:80)
                                .foregroundColor(.blackDark)
                                .background(.whiteLight)
                                .cornerRadius(16)
                                .padding()
                                .onChange(of: CHT2_Value) { _ in
                                    sendTmp2Data()
                                }
                            }
                            .background(.whiteLight)
                            .cornerRadius(24)
                            //.padding()
                        }
                        
                        HStack {
                            VStack(spacing:2) {
                                Text("구역 3")
                                    .font(Font.custom("Pretendard", size: 16).weight(.bold))
                                    .foregroundColor(.blackDark)
                                    .padding(.top)
                                
                                Picker("구역 3", selection: $CHT3_Value) {
                                    ForEach(0..<81) { tmp in
                                        Text("\(tmp)℃").tag(tmp)
                                    }
                                }
                                .pickerStyle(.wheel)
                                .frame(height:80)
                                .foregroundColor(.blackDark)
                                .background(.whiteLight)
                                .cornerRadius(16)
                                .padding()
                                .onChange(of: CHT3_Value) { _ in
                                    sendTmp3Data()
                                }
                            }
                            .background(.whiteLight)
                            .cornerRadius(24)
                            //.padding()
                            
                            VStack(spacing:2) {
                                Text("구역 4")
                                    .font(Font.custom("Pretendard", size: 16).weight(.bold))
                                    .foregroundColor(.blackDark)
                                    .padding(.top)
                                
                                Picker("구역 4", selection: $CHT4_Value) {
                                    ForEach(0..<81) { tmp in
                                        Text("\(tmp)℃").tag(tmp)
                                    }
                                }
                                .pickerStyle(.wheel)
                                .frame(height:80)
                                .foregroundColor(.blackDark)
                                .background(.whiteLight)
                                .cornerRadius(16)
                                .padding()
                                .onChange(of: CHT4_Value) { _ in
                                    sendTmp4Data()
                                }
                            }
                            .background(.whiteLight)
                            .cornerRadius(24)
                            //.padding()
                        }
                    }
                    .padding()
                    
//                    Spacer()
                    
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
    
    func sendTmp1Data() {
        if !bluetoothManager.bluetoothIsReady {
            print("기기가 연결되지 않음")
            alertMessage = "블루투스가 준비되지 않았습니다."
            showingAlert = true
            return
        }
        
        _ = UInt8(Int(15)) // 예시로 모든 채널을 켜는 모드
        let V_L = UInt8(Int(0)) // 최소 온도
        let V_H = UInt8(Int(80)) // 최대 온도
        let IF = UInt8(Int(5)) // 온도 편차
        let LY = UInt8(Int(10)) // 출력 지연
        let Ht = UInt8(Int(50)) // 과승 온도
        let ES = UInt8(Int(0)) // 보정 온도
        let PF = UInt8(Int(6)) // 자동 OFF 시간
        // let CHT: [UInt8] = [UInt8(Int(Section1Tmp)), UInt8(Int(Section2Tmp)), UInt8(Int(Section3Tmp)), UInt8(Int(Section4Tmp))]
        let CHT1 = UInt8(Int(CHT1_Value))
        let CHT2 = UInt8(Int(CHT2_Value))
        let CHT3 = UInt8(Int(CHT3_Value))
        let CHT4 = UInt8(Int(CHT4_Value))
        let IN = UInt8(Int(30)) // 주기 시간
        let Hb = UInt8(Int(10)) // 초기 투입 시간
        let FL = UInt8(Int(20)) // 기타
        let rN = UInt8(Int(40)) // 기타
        // let CHI: [UInt8] = [UInt8(Int(0)), UInt8(Int(0)), UInt8(Int(0)), UInt8(Int(0))] // 채널별 강도
        let CHI1 = UInt8(Int(bluetoothManager.CHI1_Value))
        let CHI2 = UInt8(Int(bluetoothManager.CHI2_Value))
        let CHI3 = UInt8(Int(bluetoothManager.CHI3_Value))
        let CHI4 = UInt8(Int(bluetoothManager.CHI4_Value))
        let LT = UInt8(Int(3))
        
        let CHECKSUM: UInt8 = 175 &+ 4 &+ V_L &+ V_H &+ IF &+ LY &+ Ht &+ ES &+ PF &+ CHT1 &+ CHT2 &+ CHT3 &+ CHT4 &+ IN &+ Hb &+ FL &+ rN &+ CHI1 &+ CHI2 &+ CHI3 &+ CHI4 + LT
        
        let packet: [UInt8] = [175, 4, V_L, V_H, IF, LY, Ht, ES, PF, CHT1,CHT2,CHT3,CHT4,IN, Hb,FL, rN, CHI1, CHI2, CHI3, CHI4, LT, CHECKSUM, 13, 10]
        
        print(packet)
        bluetoothManager.sendBytesToDevice(packet)
    }
    
    func sendTmp2Data() {
        if !bluetoothManager.bluetoothIsReady {
            print("기기가 연결되지 않음")
            alertMessage = "블루투스가 준비되지 않았습니다."
            showingAlert = true
            return
        }
        
        _ = UInt8(Int(15)) // 예시로 모든 채널을 켜는 모드
        let V_L = UInt8(Int(0)) // 최소 온도
        let V_H = UInt8(Int(80)) // 최대 온도
        let IF = UInt8(Int(5)) // 온도 편차
        let LY = UInt8(Int(10)) // 출력 지연
        let Ht = UInt8(Int(50)) // 과승 온도
        let ES = UInt8(Int(0)) // 보정 온도
        let PF = UInt8(Int(6)) // 자동 OFF 시간
        let CHT1 = UInt8(Int(CHT1_Value))
        let CHT2 = UInt8(Int(CHT2_Value))
        let CHT3 = UInt8(Int(CHT3_Value))
        let CHT4 = UInt8(Int(CHT4_Value))
        let IN = UInt8(Int(30)) // 주기 시간
        let Hb = UInt8(Int(10)) // 초기 투입 시간
        let FL = UInt8(Int(20)) // 기타
        let rN = UInt8(Int(40)) // 기타
        // let CHI: [UInt8] = [UInt8(Int(0)), UInt8(Int(0)), UInt8(Int(0)), UInt8(Int(0))] // 채널별 강도
        let CHI1 = UInt8(Int(bluetoothManager.CHI1_Value))
        let CHI2 = UInt8(Int(bluetoothManager.CHI2_Value))
        let CHI3 = UInt8(Int(bluetoothManager.CHI3_Value))
        let CHI4 = UInt8(Int(bluetoothManager.CHI4_Value))
        let LT = UInt8(Int(3))
        
        let CHECKSUM: UInt8 = 175 &+ 4 &+ V_L &+ V_H &+ IF &+ LY &+ Ht &+ ES &+ PF &+ CHT1 &+ CHT2 &+ CHT3 &+ CHT4 &+ IN &+ Hb &+ FL &+ rN &+ CHI1 &+ CHI2 &+ CHI3 &+ CHI4 + LT
        
        let packet: [UInt8] = [175, 4, V_L, V_H, IF, LY, Ht, ES, PF, CHT1,CHT2,CHT3,CHT4,IN, Hb,FL, rN, CHI1, CHI2, CHI3, CHI4, LT, CHECKSUM, 13, 10]
        
        print(packet)
        bluetoothManager.sendBytesToDevice(packet)
    }
    
    func sendTmp3Data() {
        if !bluetoothManager.bluetoothIsReady {
            print("기기가 연결되지 않음")
            alertMessage = "블루투스가 준비되지 않았습니다."
            showingAlert = true
            return
        }
        
        _ = UInt8(Int(15)) // 예시로 모든 채널을 켜는 모드
        let V_L = UInt8(Int(0)) // 최소 온도
        let V_H = UInt8(Int(80)) // 최대 온도
        let IF = UInt8(Int(5)) // 온도 편차
        let LY = UInt8(Int(10)) // 출력 지연
        let Ht = UInt8(Int(50)) // 과승 온도
        let ES = UInt8(Int(0)) // 보정 온도
        let PF = UInt8(Int(6)) // 자동 OFF 시간
        let CHT1 = UInt8(Int(CHT1_Value))
        let CHT2 = UInt8(Int(CHT2_Value))
        let CHT3 = UInt8(Int(CHT3_Value))
        let CHT4 = UInt8(Int(CHT4_Value))
        let IN = UInt8(Int(30)) // 주기 시간
        let Hb = UInt8(Int(10)) // 초기 투입 시간
        let FL = UInt8(Int(20)) // 기타
        let rN = UInt8(Int(40)) // 기타
        // let CHI: [UInt8] = [UInt8(Int(0)), UInt8(Int(0)), UInt8(Int(0)), UInt8(Int(0))] // 채널별 강도
        let CHI1 = UInt8(Int(bluetoothManager.CHI1_Value))
        let CHI2 = UInt8(Int(bluetoothManager.CHI2_Value))
        let CHI3 = UInt8(Int(bluetoothManager.CHI3_Value))
        let CHI4 = UInt8(Int(bluetoothManager.CHI4_Value))
        let LT = UInt8(Int(3))
        
        let CHECKSUM: UInt8 = 175 &+ 4 &+ V_L &+ V_H &+ IF &+ LY &+ Ht &+ ES &+ PF &+ CHT1 &+ CHT2 &+ CHT3 &+ CHT4 &+ IN &+ Hb &+ FL &+ rN &+ CHI1 &+ CHI2 &+ CHI3 &+ CHI4 + LT
        
        let packet: [UInt8] = [175, 4, V_L, V_H, IF, LY, Ht, ES, PF, CHT1,CHT2,CHT3,CHT4,IN, Hb,FL, rN, CHI1, CHI2, CHI3, CHI4, LT, CHECKSUM, 13, 10]
        
        print(packet)
        bluetoothManager.sendBytesToDevice(packet)
    }
    
    func sendTmp4Data() {
        if !bluetoothManager.bluetoothIsReady {
            print("기기가 연결되지 않음")
            alertMessage = "블루투스가 준비되지 않았습니다."
            showingAlert = true
            return
        }
        
        _ = UInt8(Int(15)) // 예시로 모든 채널을 켜는 모드
        let V_L = UInt8(Int(0)) // 최소 온도
        let V_H = UInt8(Int(80)) // 최대 온도
        let IF = UInt8(Int(5)) // 온도 편차
        let LY = UInt8(Int(10)) // 출력 지연
        let Ht = UInt8(Int(50)) // 과승 온도
        let ES = UInt8(Int(0)) // 보정 온도
        let PF = UInt8(Int(6)) // 자동 OFF 시간
        let CHT1 = UInt8(Int(CHT1_Value))
        let CHT2 = UInt8(Int(CHT2_Value))
        let CHT3 = UInt8(Int(CHT3_Value))
        let CHT4 = UInt8(Int(CHT4_Value))
        let IN = UInt8(Int(30)) // 주기 시간
        let Hb = UInt8(Int(10)) // 초기 투입 시간
        let FL = UInt8(Int(20)) // 기타
        let rN = UInt8(Int(40)) // 기타
        // let CHI: [UInt8] = [UInt8(Int(0)), UInt8(Int(0)), UInt8(Int(0)), UInt8(Int(0))] // 채널별 강도
        let CHI1 = UInt8(Int(bluetoothManager.CHI1_Value))
        let CHI2 = UInt8(Int(bluetoothManager.CHI2_Value))
        let CHI3 = UInt8(Int(bluetoothManager.CHI3_Value))
        let CHI4 = UInt8(Int(bluetoothManager.CHI4_Value))
        let LT = UInt8(Int(3))
        
        let CHECKSUM: UInt8 = 175 &+ 4 &+ V_L &+ V_H &+ IF &+ LY &+ Ht &+ ES &+ PF &+ CHT1 &+ CHT2 &+ CHT3 &+ CHT4 &+ IN &+ Hb &+ FL &+ rN &+ CHI1 &+ CHI2 &+ CHI3 &+ CHI4 + LT
        
        let packet: [UInt8] = [175, 4, V_L, V_H, IF, LY, Ht, ES, PF, CHT1,CHT2,CHT3,CHT4,IN, Hb,FL, rN, CHI1, CHI2, CHI3, CHI4, LT, CHECKSUM, 13, 10]
        
        print(packet)
        bluetoothManager.sendBytesToDevice(packet)
    }
}
