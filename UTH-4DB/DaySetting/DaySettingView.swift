//
//  DaySettingView.swift
//  UTH-4DB
//
//  Created by 이요섭 on 9/3/24.
//

import SwiftUI
import CoreBluetooth

struct DaySettingView: View {
    @ObservedObject var bluetoothManager: BluetoothManager
    @Environment(\.presentationMode) var presentationMode
    
    // @State private var days = BitSet()
    @State private var showingAlert = false
    @State private var pendingIndex: Int?
    @State private var pendingValue: Bool = false
    @State private var alertMessage = ""
    
    let dayNames = ["월", "화", "수", "목", "금", "토", "일"]
    
    var body: some View {
        ZStack {
            Color.bgWhite.ignoresSafeArea()
            
            VStack {
                Text("요일 선택")
                    .font(Font.custom("Pretendard", size: 20).weight(.bold))
                    .foregroundColor(.textBlack)
                //    .padding()
                
                ScrollView {
                    ForEach(dayNames.indices, id: \.self) { index in
                    VStack (spacing: 4) {
                        HStack (spacing: 50){
                            VStack (alignment: .leading) {
                                
                                    Toggle(isOn: Binding(
                                        get: { self.bluetoothManager.dayBitSet.isSet(section: index) },
                                        set: { isOn in
                                            if isOn {
                                                self.bluetoothManager.dayBitSet.set(section: index)
                                                self.showingAlert = true
                                            } else {
                                                self.bluetoothManager.dayBitSet.clear(section: index)
                                            }
                                            self.bluetoothManager.dayValue = self.bluetoothManager.dayBitSet.value
                                        }
                                    )) {
                                        Text(self.dayNames[index])
                                            .font(Font.custom("Pretendard", size: 20).weight(.bold))
                                            .foregroundColor(.textBlack)
                                            .tracking(1)
                                            .padding()
                                            .cornerRadius(12)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    .frame(maxWidth: .infinity)
                    .background(Color.whiteLight)
                    .cornerRadius(12)
                    .padding()
                    
                    // .padding(.top, -15)
                    
                    Button(action: {
                        updateBluetoothDevice()
                    }) {
                        HStack {
                            Text("요일 설정하기")
                                .font(Font.custom("Pretendard", size: 18).weight(.bold))
                        }
                        .padding(EdgeInsets(top: 20, leading: 40, bottom: 20, trailing: 40))
                        .foregroundColor(.textLight)
                        .frame(maxWidth: .infinity)
                        .background(.blackDark)
                        .cornerRadius(12)
                        .padding(.bottom)
                    }
                    .padding()
                }
            }

        }
    }
    
    func updateDaysName() {
        let selectedDays = dayNames.indices.filter { self.bluetoothManager.dayBitSet.isSet(section: $0) }
        let selectedDayNames = selectedDays.map { self.dayNames[$0] }
        print("Selected days: \(selectedDayNames.joined(separator: ", "))")
    }
    
    
    func updateBluetoothDevice() {
//        print(String(format: "Selected days in binary: %08b", days.value))
//        print(String(format: "Selected days in hex: %02X", days.value))
//        print(days.value)
        
        if !bluetoothManager.bluetoothIsReady {
            print("시리얼이 준비되지 않음")
            return
        }
        
        // let daysData = days.value
        let daysData = bluetoothManager.bitSet.value
        
        
        let CHECKSUM: UInt8 = 207 &+ 8 &+ daysData
        print(CHECKSUM)
        
        let packet: [UInt8] = [207, 8, daysData, 0, 0, 0, 0, 0, 0, 0, 0, CHECKSUM, 13, 10]
        print(packet)
        
        sendData()
        bluetoothManager.sendBytesToDevice(packet)
        alertMessage = "요일 설정이 완료되었습니다."
        showingAlert = true
        
        presentationMode.wrappedValue.dismiss()
    }
    
    func sendData() {
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
        
//        let CHECKSUM = 175 &+ YY &+ MM &+ DD &+ DAY &+ HH &+ MIN &+ SS &+ upperLAT &+ lowerLAT &+ upperLNG &+ lowerLNG &+ 5 &+ 70
//        print(DAY)
//        print(CHECKSUM)
//        
//        let packet: [UInt8] = [175, YY, MM, DD, DAY, HH, MIN, SS, upperLAT, lowerLAT, upperLNG, lowerLNG, 5, 70, CHECKSUM, 13, 10]
//        print(packet)
//        bluetoothManager.sendBytesToDevice(packet)
    }
}
