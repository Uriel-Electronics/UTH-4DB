//
//  SectionSettingView.swift
//  UTH-4DB
//
//  Created by 이요섭 on 7/26/24.
//

import SwiftUI
import CoreBluetooth

struct SectionSettingView: View {
    @ObservedObject var bluetoothManager = BluetoothManager()
    @Environment(\.presentationMode) var presentationMode
    
    let sectionNames = ["구역 1", "구역 2", "구역 3", "구역 4"]
    
    var body: some View {
        ZStack {
            Color.bgWhite.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 8) {
                    Text("사용 구역 설정하기")
                        .font(Font.custom("Pretendard", size: 20).weight(.bold))
                        .foregroundColor(.blackDark)
                        .padding()
                    
                    ForEach(sectionNames.indices, id: \.self) { index in
                        VStack(spacing: 6) {
                            HStack(spacing: 50) {
                                VStack(alignment: .leading) {
                                    
                                    Toggle(isOn: Binding(
                                        get: { self.bluetoothManager.bitSet.isSet(section: index)},
                                        set: { isOn in
                                            if isOn {
                                                self.bluetoothManager.bitSet.set(section: index)
                                            } else {
                                                self.bluetoothManager.bitSet.clear(section: index)
                                            }
                                            self.bluetoothManager.sectionValue = self.bluetoothManager.bitSet.value
                                        }
                                    )) {
                                        Text(self.sectionNames[index])
                                            .font(Font.custom("Pretendard", size: 20).weight(.bold))
                                            .foregroundColor(.textLight)
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
                    .background(.blackDark)
                    .cornerRadius(12)
                    .padding()
                    
                    Button(action: {
                        updateBluetoothDevice()
                    }) {
                        HStack {
                            Text("구역 설정하기")
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
    
    func updateSectionName() {
        let selectedSections = sectionNames.indices.filter { self.bluetoothManager.bitSet.isSet(section: $0)}
        let selectedSectionNames = selectedSections.map {self.sectionNames[$0]}
        print("Selected Sections: \(selectedSectionNames.joined(separator: ", "))")
    }
    
    func updateBluetoothDevice() {
        if !bluetoothManager.bluetoothIsReady {
            print("시리얼이 준비되지 않음")
            return
        }
        
        let sectionsData = bluetoothManager.bitSet.value
        self.bluetoothManager.powerOnOff = sectionsData
        let CHECKSUM: UInt8 = 175 &+ sectionsData // 0xAF
        print(CHECKSUM)
        
        let packet: [UInt8] = [175, 0, sectionsData, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, CHECKSUM, 13, 10]
        print(packet)
        
        bluetoothManager.sendBytesToDevice(packet)
        presentationMode.wrappedValue.dismiss()
    }
}
