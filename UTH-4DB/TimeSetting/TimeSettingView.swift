//
//  TimeSettingView.swift
//  UTH-4DB
//
//  Created by 이요섭 on 9/4/24.
//

import SwiftUI
import CoreBluetooth

struct TimeSettingView: View {
    @ObservedObject var bluetoothManager = BluetoothManager()
    @Environment(\.presentationMode) var presentationMode
    // 요일 배열
    let daysOfWeek = ["월요일", "화요일", "수요일", "목요일", "금요일", "토요일", "일요일"]
    
    // 각 요일에 해당하는 선택된 켜지는 시간과 분을 저장하는 배열
    @State var selectedOnHours = Array(repeating: 0, count: 7)
    @State var selectedOnMinutes = Array(repeating: 0, count: 7)
    
    // 각 요일에 해당하는 선택된 꺼지는 시간과 분을 저장하는 배열
    @State var selectedOffHours = Array(repeating: 0, count: 7)
    @State var selectedOffMinutes = Array(repeating: 0, count: 7)
    
    // 모달 표시 여부 및 선택한 요일 인덱스
    @State private var isShowingModal = false
    @State private var selectedDayIndex = 0
    
    var body: some View {
        let mon_ontime_hour = bluetoothManager.mon_ontime / 60
        let mon_ontime_min = bluetoothManager.mon_ontime % 60
        
        let tues_ontime_hour = bluetoothManager.tues_ontime / 60
        let tues_ontime_min = bluetoothManager.tues_ontime % 60
        
        let wed_ontime_hour = bluetoothManager.wed_ontime / 60
        let wed_ontime_min = bluetoothManager.wed_ontime % 60
        
        let thurs_ontime_hour = bluetoothManager.thurs_ontime / 60
        let thurs_ontime_min = bluetoothManager.thurs_ontime % 60
        
        let fri_ontime_hour = bluetoothManager.fri_ontime / 60
        let fri_ontime_min = bluetoothManager.fri_ontime % 60
        
        let sat_ontime_hour = bluetoothManager.sat_ontime / 60
        let sat_ontime_min = bluetoothManager.sat_ontime % 60
        
        let sun_ontime_hour = bluetoothManager.sun_ontime / 60
        let sun_ontime_min = bluetoothManager.sun_ontime % 60
        
        let mon_offtime_hour = bluetoothManager.mon_offtime / 60
        let mon_offtime_min = bluetoothManager.mon_offtime % 60
         
        let tues_offtime_hour = bluetoothManager.tues_offtime / 60
        let tues_offtime_min = bluetoothManager.tues_offtime % 60
        
        let wed_offtime_hour = bluetoothManager.wed_offtime / 60
        let wed_offtime_min = bluetoothManager.wed_offtime % 60
        
        let thurs_offtime_hour = bluetoothManager.thurs_offtime / 60
        let thurs_offtime_min = bluetoothManager.thurs_offtime % 60
        
        let fri_offtime_hour = bluetoothManager.fri_offtime / 60
        let fri_offtime_min = bluetoothManager.fri_offtime % 60
        
        let sat_offtime_hour = bluetoothManager.sat_offtime / 60
        let sat_offtime_min = bluetoothManager.sat_offtime % 60
        
        let sun_offtime_hour = bluetoothManager.sun_offtime / 60
        let sun_offtime_min = bluetoothManager.sun_offtime % 60
        
        let selectedOnHours1 = [mon_ontime_hour, tues_ontime_hour, wed_ontime_hour, thurs_ontime_hour, fri_ontime_hour, sat_ontime_hour, sun_ontime_hour]
        
        let selectedOnMinutes1 = [mon_ontime_min, tues_ontime_min, wed_ontime_min, thurs_ontime_min, fri_ontime_min, sat_ontime_min, sun_ontime_min]
        
        let selectedOffHours1 = [mon_offtime_hour, tues_offtime_hour, wed_offtime_hour, thurs_offtime_hour, fri_offtime_hour, sat_offtime_hour, sun_offtime_hour]
        
        let selectedOffMinutes1 = [mon_offtime_min, tues_offtime_min, wed_offtime_min, thurs_offtime_min, fri_offtime_min, sat_offtime_min, sun_offtime_min]
        
        
        ZStack {
            Color.bgWhite.ignoresSafeArea()
            ScrollView {
                VStack {
                    Text("사용 시간 설정하기")
                        .font(Font.custom("Pretendard", size: 20).weight(.bold))
                        .foregroundColor(.textBlack)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 20)
                    // 요일별로 시간 선택 영역을 생성
                    ForEach(0..<daysOfWeek.count, id: \.self) { index in
                        
                        VStack {
                            HStack {
                                Text(daysOfWeek[index])
                                    .font(Font.custom("Pretendard", size: 18).weight(.bold))
                                    .foregroundColor(.black)
                                    .padding()
                                
                                Spacer()
                                                                        
                                Image(systemName: "chevron.right")
                                    .font(Font.custom("Pretendard", size: 19).weight(.bold))
                                    .foregroundColor(.black)
                                    .padding()
                            }
                            .padding(.horizontal)
                                                    
                            // 선택된 켜지는 시간과 꺼지는 시간이 나타나는 부분
                            VStack() {
                                HStack (spacing: 4) {
                                    HStack  {
                                        Text("\(selectedOnHours[index])시 \(selectedOnMinutes[index])분")
                                            .frame(maxWidth:.infinity, minHeight: 50)
                                            .font(Font.custom("Pretendard", size: 18).weight(.bold))
                                            .foregroundColor(.textBlack)
                                            .background(.bgWhite)
                                            .cornerRadius(24)
                                            .padding(.leading)
                                        
                                        Text("켜짐")
                                            .font(Font.custom("Pretendard", size: 18).weight(.bold))
                                            .foregroundColor(.bgRed)
                                    }
                                    .frame(maxWidth:.infinity, minHeight: 65)
                                                                        
                                    
                                    HStack {
                                        Text("\(selectedOffHours[index])시 \(selectedOffMinutes[index])분")
                                            .frame(maxWidth:.infinity, minHeight: 50)
                                            .font(Font.custom("Pretendard", size: 18).weight(.bold))
                                            .foregroundColor(.textBlack)
                                            .background(.bgWhite)
                                            .cornerRadius(24)
                                        
                                        Text("꺼짐")
                                            .font(Font.custom("Pretendard", size: 18).weight(.bold))
                                            .foregroundColor(.gray)
                                            .padding(.trailing)
                                    }
                                    .frame(maxWidth:.infinity, minHeight: 65)
                                }
                                // .padding()
                            }
                        }
                        .background(.whiteLight)
                        .frame(maxWidth: .infinity)
                        .cornerRadius(24)
                        .padding(.horizontal)
                        .onTapGesture {
                            // 특정 요일을 클릭하면 모달을 띄우고 해당 요일 인덱스 설정
                            selectedDayIndex = index
                            isShowingModal.toggle()
                        }
                        .onAppear {
                            selectedOnHours = selectedOnHours1
                            selectedOnMinutes = selectedOnMinutes1
                            selectedOffHours = selectedOffHours1
                            selectedOffMinutes = selectedOffMinutes1
                            
                            requestDayData()
                        }
                    }
                    
                    // 데이터를 전송하는 버튼 추가
//                    Button("저장") {
//                        sendData()
//                    }
//                    .font(Font.custom("Pretendard", size: 18).weight(.bold))
//                    .foregroundColor(.textLight)
//                    .padding()
//                    .frame(maxWidth: .infinity)
//                    .background(.blackDark)
//                    // .padding(.top, 30)
//                    .cornerRadius(12)
//                    .padding()
//                    .padding(.top, 20)
                }
                .onAppear {
//                    loadSavedTimes()
                                                            
                    requestDayData()
                }
                .sheet(isPresented: $isShowingModal) {
                    // 선택된 요일의 켜지는 시간과 꺼지는 시간을 수정할 수 있는 모달
                    TimePickerModal(
                        selectedOnHour: $selectedOnHours[selectedDayIndex],
                        selectedOnMinute: $selectedOnMinutes[selectedDayIndex],
                        selectedOffHour: $selectedOffHours[selectedDayIndex],
                        selectedOffMinute: $selectedOffMinutes[selectedDayIndex],
                        
                        saveTimes: saveTimesForCurrentDay,
                        sendData : sendData
                    )
                }
            }
        }
    }
    
    func requestDayData() {
        if !bluetoothManager.bluetoothIsReady {
            print("시리얼이 준비되지 않음")
            return
        }
        
//        let CHECKSUM = 207 &+ 1
        
        let packet: [UInt8] = [207, 1, 0, 0, 0, 0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0,0,0, 208, 13, 10]
        
        bluetoothManager.sendBytesToDevice(packet)
    }
    
    // 시/분 -> 분으로 바꿔주는 함수
    func HourToMinutes(hour: Int, minute: Int) -> Int {
        return hour * 60 + minute
    }
    
    // 저장된 시간을 UserDefaults에서 불러오는 함수
    func loadSavedTimes() {
        for index in 0..<daysOfWeek.count {
            selectedOnHours[index] = UserDefaults.standard.integer(forKey: "onHour_\(index)")
            selectedOnMinutes[index] = UserDefaults.standard.integer(forKey: "onMinute_\(index)")
            selectedOffHours[index] = UserDefaults.standard.integer(forKey: "offHour_\(index)")
            selectedOffMinutes[index] = UserDefaults.standard.integer(forKey: "offMinute_\(index)")
        }
    }
        
    // 현재 선택한 요일의 시간을 저장하는 함수
    func saveTimesForCurrentDay() {
        UserDefaults.standard.set(selectedOnHours[selectedDayIndex], forKey: "onHour_\(selectedDayIndex)")
        UserDefaults.standard.set(selectedOnMinutes[selectedDayIndex], forKey: "onMinute_\(selectedDayIndex)")
        UserDefaults.standard.set(selectedOffHours[selectedDayIndex], forKey: "offHour_\(selectedDayIndex)")
        UserDefaults.standard.set(selectedOffMinutes[selectedDayIndex], forKey: "offMinute_\(selectedDayIndex)")
    }
    
    func sendData() {
        if !bluetoothManager.bluetoothIsReady {
            print("시리얼이 준비되지 않음")
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
        print(day)
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
        
        // Monday
        let monOnTime = HourToMinutes(hour: selectedOnHours[0], minute: selectedOnMinutes[0])
        print(monOnTime)
        let monOffTime = HourToMinutes(hour: selectedOffHours[0], minute: selectedOffMinutes[0])
        print(monOffTime)
        let monOnTimeResult: UInt16 = UInt16(monOnTime)
        let monOnTimeUpperByte = UInt8(monOnTimeResult >> 8)
        let monOnTimeLowerByte = UInt8(monOnTimeResult & 0x00FF)
        
        let monOffTimeResult: UInt16 = UInt16(monOffTime)
        let monOffTimeUpperByte = UInt8(monOffTimeResult >> 8)
        let monOffTimeLowerByte = UInt8(monOffTimeResult & 0x00FF)
        
        // Tuesday
        let tuesOnTime = HourToMinutes(hour: selectedOnHours[1], minute: selectedOnMinutes[1])
        print(tuesOnTime)
        let tuesOffTime = HourToMinutes(hour: selectedOffHours[1], minute: selectedOffMinutes[1])
        print(tuesOffTime)
        let tuesOnTimeResult: UInt16 = UInt16(tuesOnTime)
        let tuesOnTimeUpperByte = UInt8(tuesOnTimeResult >> 8)
        let tuesOnTimeLowerByte = UInt8(tuesOnTimeResult & 0x00FF)
        
        let tuesOffTimeResult: UInt16 = UInt16(tuesOffTime)
        let tuesOffTimeUpperByte = UInt8(tuesOffTimeResult >> 8)
        let tuesOffTimeLowerByte = UInt8(tuesOffTimeResult & 0x00FF)
        
        // Wednesday
        let wedOnTime = HourToMinutes(hour: selectedOnHours[2], minute: selectedOnMinutes[2])
        print(wedOnTime)
        let wedOffTime = HourToMinutes(hour: selectedOffHours[2], minute: selectedOffMinutes[2])
        print(wedOffTime)
        let wedOnTimeResult: UInt16 = UInt16(wedOnTime)
        let wedOnTimeUpperByte = UInt8(wedOnTimeResult >> 8)
        let wedOnTimeLowerByte = UInt8(wedOnTimeResult & 0x00FF)
        
        let wedOffTimeResult: UInt16 = UInt16(wedOffTime)
        let wedOffTimeUpperByte = UInt8(wedOffTimeResult >> 8)
        let wedOffTimeLowerByte = UInt8(wedOffTimeResult & 0x00FF)
    
        // Thursday
        let thurOnTime = HourToMinutes(hour: selectedOnHours[3], minute: selectedOnMinutes[3])
        print(thurOnTime)
        let thurOffTime = HourToMinutes(hour: selectedOffHours[3], minute: selectedOffMinutes[3])
        print(thurOffTime)
        let thurOnTimeResult: UInt16 = UInt16(thurOnTime)
        let thurOnTimeUpperByte = UInt8(thurOnTimeResult >> 8)
        let thurOnTimeLowerByte = UInt8(thurOnTimeResult & 0x00FF)
        
        let thurOffTimeResult: UInt16 = UInt16(thurOffTime)
        let thurOffTimeUpperByte = UInt8(thurOffTimeResult >> 8)
        let thurOffTimeLowerByte = UInt8(thurOffTimeResult & 0x00FF)
        
        // Friday
        let friOnTime = HourToMinutes(hour: selectedOnHours[4], minute: selectedOnMinutes[4])
        print(friOnTime)
        let friOffTime = HourToMinutes(hour: selectedOffHours[4], minute: selectedOffMinutes[4])
        print(friOffTime)
        let friOnTimeResult: UInt16 = UInt16(friOnTime)
        let friOnTimeUpperByte = UInt8(friOnTimeResult >> 8)
        let friOnTimeLowerByte = UInt8(friOnTimeResult & 0x00FF)
        
        let friOffTimeResult: UInt16 = UInt16(friOffTime)
        let friOffTimeUpperByte = UInt8(friOffTimeResult >> 8)
        let friOffTimeLowerByte = UInt8(friOffTimeResult & 0x00FF)
                
        // Saturday
        let satOnTime = HourToMinutes(hour: selectedOnHours[5], minute: selectedOnMinutes[5])
        print(satOnTime)
        let satOffTime = HourToMinutes(hour: selectedOffHours[5], minute: selectedOffMinutes[5])
        print(satOffTime)
        let satOnTimeResult: UInt16 = UInt16(satOnTime)
        let satOnTimeUpperByte = UInt8(satOnTimeResult >> 8)
        let satOnTimeLowerByte = UInt8(satOnTimeResult & 0x00FF)
        
        let satOffTimeResult: UInt16 = UInt16(satOffTime)
        let satOffTimeUpperByte = UInt8(satOffTimeResult >> 8)
        let satOffTimeLowerByte = UInt8(satOffTimeResult & 0x00FF)
        
        // Sunday
        let sunOnTime = HourToMinutes(hour: selectedOnHours[6], minute: selectedOnMinutes[6])
        print(sunOnTime)
        let sunOffTime = HourToMinutes(hour: selectedOffHours[6], minute: selectedOffMinutes[6])
        print(sunOffTime)
        let sunOnTimeResult: UInt16 = UInt16(sunOnTime)
        let sunOnTimeUpperByte = UInt8(sunOnTimeResult >> 8)
        let sunOnTimeLowerByte = UInt8(sunOnTimeResult & 0x00FF)
        
        let sunOffTimeResult: UInt16 = UInt16(sunOffTime)
        let sunOffTimeUpperByte = UInt8(sunOffTimeResult >> 8)
        let sunOffTimeLowerByte = UInt8(sunOffTimeResult & 0x00FF)
        
        let CHECKSUM = 207 &+ 0 &+ DAY &+ HH &+ MIN &+ monOnTimeUpperByte &+ monOnTimeLowerByte &+ tuesOnTimeUpperByte &+ tuesOnTimeLowerByte &+ wedOnTimeUpperByte &+ wedOnTimeLowerByte &+ thurOnTimeUpperByte &+ thurOnTimeLowerByte &+ friOnTimeUpperByte &+ friOnTimeLowerByte &+ satOnTimeUpperByte &+ satOnTimeLowerByte &+ sunOnTimeUpperByte &+ sunOnTimeLowerByte &+ monOffTimeUpperByte &+ monOffTimeLowerByte &+ tuesOffTimeUpperByte &+ tuesOffTimeLowerByte &+ wedOffTimeUpperByte &+ wedOffTimeLowerByte &+ thurOffTimeUpperByte &+ thurOffTimeLowerByte &+ friOffTimeUpperByte &+ friOffTimeLowerByte &+ satOffTimeUpperByte &+ satOffTimeLowerByte &+ sunOffTimeUpperByte &+ sunOffTimeLowerByte
        print(CHECKSUM)
        
        let packet: [UInt8] = [207, 0, DAY, HH, MIN, monOnTimeUpperByte, monOnTimeLowerByte, tuesOnTimeUpperByte, tuesOnTimeLowerByte, wedOnTimeUpperByte, wedOnTimeLowerByte, thurOnTimeUpperByte, thurOnTimeLowerByte, friOnTimeUpperByte, friOnTimeLowerByte, satOnTimeUpperByte, satOnTimeLowerByte, sunOnTimeUpperByte, sunOnTimeLowerByte, monOffTimeUpperByte, monOffTimeLowerByte, tuesOffTimeUpperByte, tuesOffTimeLowerByte, wedOffTimeUpperByte, wedOffTimeLowerByte, thurOffTimeUpperByte, thurOffTimeLowerByte, friOffTimeUpperByte, friOffTimeLowerByte, satOffTimeUpperByte, satOffTimeLowerByte, sunOffTimeUpperByte, sunOffTimeLowerByte, CHECKSUM, 13, 10]
        print(packet)
        
        bluetoothManager.sendBytesToDevice(packet)
//        presentationMode.wrappedValue.dismiss()
    }
}

struct TimePickerModal: View {
    @Binding var selectedOnHour: Int
    @Binding var selectedOnMinute: Int
    @Binding var selectedOffHour: Int
    @Binding var selectedOffMinute: Int
    var saveTimes: () -> Void
    var sendData: () -> Void // 추가
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Text("시간 선택")
                .font(.headline)
                .padding()

            // 켜지는 시간 Picker
            VStack {
                Text("켜지는 시간")
                    .font(.subheadline)
                    .padding(.bottom, 5)
                
                HStack {
                    Picker(selection: $selectedOnHour, label: Text("시")) {
                        ForEach(0..<24) { hour in
                            Text("\(hour)시")
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(maxWidth: .infinity)

                    Picker(selection: $selectedOnMinute, label: Text("분")) {
                        ForEach(0..<60) { minute in
                            Text("\(minute)분")
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(maxWidth: .infinity)
                }
                .padding()
            }

            // 꺼지는 시간 Picker
            VStack {
                Text("꺼지는 시간")
                    .font(.subheadline)
                    .padding(.bottom, 5)
                
                HStack {
                    Picker(selection: $selectedOffHour, label: Text("시")) {
                        ForEach(0..<24) { hour in
                            Text("\(hour)시")
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(maxWidth: .infinity)

                    Picker(selection: $selectedOffMinute, label: Text("분")) {
                        ForEach(0..<60) { minute in
                            Text("\(minute)분")
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(maxWidth: .infinity)
                }
                .padding()
            }
            
            Button("확인") {
                saveTimes()
                sendData()
                presentationMode.wrappedValue.dismiss()
            }
            .font(Font.custom("Pretendard", size: 18).weight(.bold))
            .foregroundColor(.textLight)
            .padding()
            .frame(maxWidth: .infinity)
            .background(.blackDark)
            // .padding(.top, 30)
            .cornerRadius(12)
            .padding()
            .padding(.top, 20)
            .onTapGesture {
                saveTimes()
                sendData()
                presentationMode.wrappedValue.dismiss()
            }

            // 완료 버튼
//            Button(action: {
//                // 완료 버튼을 눌렀을 때 모달 닫기
//                saveTimes()
//                presentationMode.wrappedValue.dismiss()
//            }) {
//                Text("완료")
//                    .font(.title2)
//                    .padding()
//                    .background(Color.blue)
//                    .foregroundColor(.white)
//                    .cornerRadius(10)
//            }
        }
        .onAppear {
            
        }
    }
    
}
