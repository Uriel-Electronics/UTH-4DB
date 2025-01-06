//
//  LandingView.swift
//  UTH-4DB
//
//  Created by 이요섭 on 7/17/24.
//

import SwiftUI
import CoreBluetooth

struct LandingView: View {
    @ObservedObject var bluetoothManager = BluetoothManager()
    @Binding var navigateToLanding: Bool
    @State private var currentDate = Date()
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var isLoading: Bool = false
    @State var powerOnOff: UInt8
    
    @State var mode1_CHT1_Value:Int
    @State var mode1_CHT2_Value:Int
    @State var mode1_CHT3_Value:Int
    @State var mode1_CHT4_Value:Int
    
    var body: some View {
        NavigationStack {
            ZStack {
                if !navigateToLanding {
                    MainView()
                }
                else {                 
                    if bluetoothManager.powerOnOff == 0x00 {
                        Color.bgWhite.ignoresSafeArea()
                        
                        ScrollView {
                            VStack() {
                                HStack {
                                    Image(systemName: "gearshape.fill")
                                        .font(Font.custom("Pretendard", size: 20).weight(.bold))
                                        .foregroundColor(.textBlack)
                                        .opacity(0)
                                    
                                    Spacer()
                                    
                                    Text("Uriel")
                                        .font(Font.custom("Pretendard", size: 20).weight(.bold))
                                        .foregroundColor(.textBlack)
                                        .multilineTextAlignment(.center)
                                    
                                    Spacer()
                                    
                                    NavigationLink (destination: PeripheralSettingView(bluetoothManager: bluetoothManager, navigateToLanding: $navigateToLanding)) {
                                        Image(systemName: "gearshape.fill")
                                            .font(Font.custom("Pretendard", size: 20).weight(.bold))
                                            .foregroundColor(.textBlack)
                                    }
                                }
                                .padding()
                                .padding(.top, 10)
                                .padding(.bottom, 15)
                                
                                VStack {
                                    VStack(spacing: 0) {
                                        HStack {
                                            Image(systemName: "gearshape.fill")
                                                .font(Font.custom("Pretendard", size: 20).weight(.bold))
                                                .foregroundColor(.textBlack)
                                                .opacity(0)
                                            
                                            Spacer()
                                            
                                            Text("기기 전원")
                                                .font(Font.custom("Pretendard", size: 15).weight(.bold))
                                                .foregroundColor(Color(red: 0.13, green: 0.14, blue: 0.15).opacity(0.4))
                                                .opacity(0.8)
                                            
                                            Spacer()
                                            
                                            Image(systemName: "gearshape.fill")
                                                .font(Font.custom("Pretendard", size: 20).weight(.bold))
                                                .foregroundColor(.textBlack)
                                                .opacity(0)
                                        }
                                        
                                        HStack {
                                            Image(systemName: "gearshape.fill")
                                                .font(Font.custom("Pretendard", size: 20).weight(.bold))
                                                .foregroundColor(.textBlack)
                                                .opacity(0)
                                            
                                            Spacer()
                                            
                                            
                                            Text("꺼짐")
                                                .font(Font.custom("Pretendard", size: 20).weight(.bold))
                                                .foregroundColor(Color(red: 0.13, green: 0.14, blue: 0.15).opacity(0.4))
                                            
                                            Spacer()
                                            
                                            Image(systemName: "gearshape.fill")
                                                .font(Font.custom("Pretendard", size: 20).weight(.bold))
                                                .foregroundColor(.textBlack)
                                                .opacity(0)
                                        }
                                    }
                                }
                                .padding(.vertical, 15)
                                
                                VStack () {
                                    Button (action: {
                                        sendOnData()
                                    }) {
                                        HStack(alignment: .center, spacing: 0) {
                                            HStack(alignment: .center, spacing: 7.14286) {
                                                Image("fi:power")
                                                .frame(width: 20, height: 20)
                                            }
                                            .padding(28.57143)
                                            .background(.bgWhite)
                                            .cornerRadius(22)
                                        }
                                        .padding(.leading, 10)
                                        .padding(.trailing, 10)
                                        .padding(.top, 70.5)
                                        .padding(.bottom, 9.5)
                                        .background(Color(red: 0.13, green: 0.14, blue: 0.15).opacity(0.4))
                                        .cornerRadius(32)
                                    }
                                }
                                .padding(.top, 30)
                                .padding(.bottom, 15)
                                
                                VStack {
                                    HStack(spacing: 2) {
                                      VStack(alignment: .leading, spacing: 0) {
                                        Text("1 구역 ")
                                          .font(Font.custom("Pretendard", size: 13).weight(.semibold))
                                          .lineSpacing(23)
                                          .foregroundColor(Color(red: 0.13, green: 0.14, blue: 0.15).opacity(0.40))
                                        Text(" --℃")
                                          .font(Font.custom("Pretendard", size: 13).weight(.bold))
                                          .lineSpacing(23)
                                          .foregroundColor(Color(red: 0.13, green: 0.14, blue: 0.15).opacity(0.40))
                                      }
                                      .padding(EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16))
                                      .frame(maxWidth: .infinity)
                                      .cornerRadius(24)
                                      Rectangle()
                                        .foregroundColor(.clear)
                                        .frame(width: 1, height: 28)
                                        .background(Color(red: 0.13, green: 0.14, blue: 0.15).opacity(0.40))
                                        .cornerRadius(2)
                                        .opacity(0.50)
                                      VStack(alignment: .leading, spacing: 0) {
                                        Text("2 구역")
                                          .font(Font.custom("Pretendard", size: 13).weight(.semibold))
                                          .lineSpacing(23)
                                          .foregroundColor(Color(red: 0.13, green: 0.14, blue: 0.15).opacity(0.40))
                                        Text("--℃")
                                          .font(Font.custom("Pretendard", size: 13).weight(.bold))
                                          .lineSpacing(23)
                                          .foregroundColor(Color(red: 0.13, green: 0.14, blue: 0.15).opacity(0.40))
                                      }
                                      .padding(EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16))
                                      .frame(maxWidth: .infinity)
                                      .cornerRadius(24)
                                      Rectangle()
                                        .foregroundColor(.clear)
                                        .frame(width: 1, height: 28)
                                        .background(Color(red: 0.13, green: 0.14, blue: 0.15).opacity(0.40))
                                        .cornerRadius(2)
                                        .opacity(0.50)
                                      VStack(alignment: .leading, spacing: 0) {
                                        Text("3 구역")
                                          .font(Font.custom("Pretendard", size: 13).weight(.semibold))
                                          .lineSpacing(23)
                                          .foregroundColor(Color(red: 0.13, green: 0.14, blue: 0.15).opacity(0.40))
                                        Text("--℃")
                                          .font(Font.custom("Pretendard", size: 13).weight(.bold))
                                          .lineSpacing(23)
                                          .foregroundColor(Color(red: 0.13, green: 0.14, blue: 0.15).opacity(0.40))
                                      }
                                      .padding(EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16))
                                      .frame(maxWidth: .infinity)
                                      .cornerRadius(24)
                                      Rectangle()
                                        .foregroundColor(.clear)
                                        .frame(width: 1, height: 28)
                                        .background(Color(red: 0.13, green: 0.14, blue: 0.15).opacity(0.40))
                                        .cornerRadius(2)
                                        .opacity(0.50)
                                      VStack(alignment: .leading, spacing: 0) {
                                        Text("4 구역")
                                          .font(Font.custom("Pretendard", size: 13).weight(.semibold))
                                          .lineSpacing(23)
                                          .foregroundColor(Color(red: 0.13, green: 0.14, blue: 0.15).opacity(0.40))
                                        Text("--℃")
                                          .font(Font.custom("Pretendard", size: 13).weight(.bold))
                                          .lineSpacing(23)
                                          .foregroundColor(Color(red: 0.13, green: 0.14, blue: 0.15).opacity(0.40))
                                      }
                                      .padding(EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16))
                                      .frame(maxWidth: .infinity)
                                      .cornerRadius(24)
                                    }
                                    .frame(maxWidth: .infinity, minHeight: 70)
                                    .padding()
                                }
                                
                                
                                VStack(spacing: 16) {
                                    HStack {
                                        NavigationLink(destination: SectionTmpView(bluetoothManager:bluetoothManager, CHT1_Value: bluetoothManager.CHT1_Value, CHT2_Value: bluetoothManager.CHT2_Value, CHT3_Value: bluetoothManager.CHT3_Value, CHT4_Value: bluetoothManager.CHT4_Value)) {
                                            VStack() {
                                                HStack(alignment:.top, spacing: 12) {
                                                    Image("clockBlack")
                                                        .frame(width: 20, height: 20)
                                                        .opacity(0.4)
                                                    Text("사용 시간\n설정하기")
                                                        .font(Font.custom("Pretendard", size: 16).weight(.bold))
                                                        .foregroundColor(Color(red: 0.13, green: 0.14, blue: 0.15).opacity(0.40))
                                                }
                                                .padding(0)
                                                .frame(maxWidth: .infinity)
                                            }
                                            .frame(maxWidth: .infinity, minHeight: 86)
                                            .background(.whiteLight)
                                            .cornerRadius(24)
                                        }
                                        
                                        NavigationLink(destination: SectionSettingView(bluetoothManager: bluetoothManager)) {
                                            VStack() {
                                                HStack(alignment:.top, spacing: 12) {
                                                    Image("calculatorBlack")
                                                        .frame(width: 20, height: 20)
                                                        .opacity(0.4)
                                                    Text("사용 구역\n 설정하기")
                                                        .font(Font.custom("Pretendard", size: 16).weight(.bold))
                                                        .foregroundColor(Color(red: 0.13, green: 0.14, blue: 0.15).opacity(0.40))
                                                }
                                                .padding(0)
                                                .frame(maxWidth: .infinity)
                                            }
                                            .frame(maxWidth: .infinity, minHeight: 86)
                                            .background(.whiteLight)
                                            .cornerRadius(24)
                                            
                                        }
                                    }
                                    
                                    HStack {
                                        NavigationLink(destination: SectionTmpView(bluetoothManager:bluetoothManager, CHT1_Value: bluetoothManager.CHT1_Value, CHT2_Value: bluetoothManager.CHT2_Value, CHT3_Value: bluetoothManager.CHT3_Value, CHT4_Value: bluetoothManager.CHT4_Value)) {
                                            VStack() {
                                                HStack(alignment: .top, spacing: 12) {
                                                    Image("temperatureBlack")
                                                        .frame(width: 20, height: 20)
                                                        .opacity(0.4)
                                                    Text("구역별 온도\n설정하기")
                                                        .font(Font.custom("Pretendard", size: 16).weight(.bold))
                                                        .foregroundColor(Color(red: 0.13, green: 0.14, blue: 0.15).opacity(0.40))
                                                }
                                                .padding(0)
                                                .frame(maxWidth: .infinity)
                                            }
                                            .frame(maxWidth: .infinity, minHeight: 86)
                                            .background(.whiteLight)
                                            .cornerRadius(24)
                                        }
                                                                                
                                        NavigationLink(destination: SectionStepView(bluetoothManager: bluetoothManager, CHI1_Value: bluetoothManager.CHI1_Value, CHI2_Value: bluetoothManager.CHI2_Value, CHI3_Value: bluetoothManager.CHI3_Value, CHI4_Value: bluetoothManager.CHI4_Value)) {
                                            VStack() {
                                                HStack(alignment: .top, spacing: 12) {
                                                    Image("dashboardBlack")
                                                        .frame(width: 20, height: 20)
                                                        .opacity(0.4)
                                                    Text("구역별 단계\n설정하기")
                                                        .font(Font.custom("Pretendard", size: 16).weight(.bold))
                                                        .foregroundColor(Color(red: 0.13, green: 0.14, blue: 0.15).opacity(0.40))
                                                }
                                                .padding(0)
                                                .frame(maxWidth: .infinity)
                                            }
                                            .frame(maxWidth: .infinity, minHeight: 86)
                                            .background(.whiteLight)
                                            .cornerRadius(24)
                                            }
                                        }
                                    
                                        // 사용 구역 설정하기
//                                        NavigationLink(destination: SectionSettingView(bluetoothManager: bluetoothManager)) {
//                                            VStack() {
//                                                HStack(alignment:.top, spacing: 12) {
//                                                    Image("calculatorBlack")
//                                                        .frame(width: 20, height: 20)
//                                                        .opacity(0.4)
//                                                    
//                                                    Text("사용 구역 설정하기")
//                                                        .font(Font.custom("Pretendard", size: 16).weight(.bold))
//                                                        .lineSpacing(23)
//                                                        .foregroundColor(Color(red: 0.13, green: 0.14, blue: 0.15).opacity(0.40))
//
//                                                }
//                                                .padding(.leading)
//                                                .frame(maxWidth: .infinity, alignment: .leading)
//                                            }
//                                            .frame(maxWidth: .infinity, minHeight: 64, maxHeight: 64)
//                                            .background(.whiteLight)
//                                            .cornerRadius(24)
//                                        }
                                    }
                                    .padding()   
                                    .disabled(true)
                            }
                        }
                    } else {
                        
                        ScrollView {
                            VStack() {
                                HStack {
                                    Image(systemName: "gearshape.fill")
                                        .font(Font.custom("Pretendard", size: 20).weight(.bold))
                                        .foregroundColor(.whiteLight)
                                        .opacity(0)
                                    
                                    Spacer()
                                    
                                    Text("Uriel")
                                        .font(Font.custom("Pretendard", size: 20).weight(.bold))
                                        .foregroundColor(.whiteLight)
                                        .multilineTextAlignment(.center)
                                    
                                    Spacer()
                                    
                                    NavigationLink (destination: PeripheralSettingView(bluetoothManager: bluetoothManager, navigateToLanding: $navigateToLanding)) {
                                        Image(systemName: "gearshape.fill")
                                            .font(Font.custom("Pretendard", size: 20).weight(.bold))
                                            .foregroundColor(.whiteLight)
                                    }
                                }
                                .padding()
                                .padding(.top, 10)
                                .padding(.bottom, 15)
                                
                                VStack {
                                    VStack(spacing: 0) {
                                        HStack {
                                            Image(systemName: "gearshape.fill")
                                                .font(Font.custom("Pretendard", size: 20).weight(.bold))
                                                .foregroundColor(.whiteLight)
                                                .opacity(0)
                                            
                                            Spacer()
                                            
                                            Text("기기 전원")
                                                .font(Font.custom("Pretendard", size: 15).weight(.bold))
                                                .foregroundColor(.whiteLight)
                                                
                                            
                                            Spacer()
                                            
                                            Image(systemName: "gearshape.fill")
                                                .font(Font.custom("Pretendard", size: 20).weight(.bold))
                                                .foregroundColor(.textBlack)
                                                .opacity(0)
                                        }
                                        
                                        HStack {
                                            Image(systemName: "gearshape.fill")
                                                .font(Font.custom("Pretendard", size: 20).weight(.bold))
                                                .foregroundColor(.textBlack)
                                                .opacity(0)
                                            
                                            Spacer()
                                            
                                            
                                            Text("켜짐")
                                                .font(Font.custom("Pretendard", size: 20).weight(.bold))
                                                .foregroundColor(.whiteLight)
                                                                                        
                                            Spacer()
                                            
                                            Image(systemName: "gearshape.fill")
                                                .font(Font.custom("Pretendard", size: 20).weight(.bold))
                                                .foregroundColor(.textBlack)
                                                .opacity(0)
                                        }
                                    }
                                }
                                .padding(.vertical, 15)
                                                                
                                VStack () {
                                    Button (action: {
                                        sendOffData()
                                    }) {
                                        HStack(alignment: .center, spacing: 0) {
                                            HStack(alignment: .center, spacing: 7.14286) {
                                                Image("fi:power:red")
                                                .frame(width: 20, height: 20)
                                            }
                                            .padding(28.57143)
                                            .background(.bgWhite)
                                            .cornerRadius(22)
                                        }
                                        .padding(.leading, 10)
                                        .padding(.trailing, 10)
                                        .padding(.top, 9.5)
                                        .padding(.bottom, 70.5)
                                        .background(.bgRed)
                                        .cornerRadius(32)
                                    }
                                }
                                .padding(.top, 30)
                                .padding(.bottom, 15)
                                
                                VStack {
                                    HStack(spacing: 2) {
                                      VStack(alignment: .leading, spacing: 0) {
                                        Text("1 구역 ")
                                          .font(Font.custom("Pretendard", size: 12).weight(.semibold))
                                          .lineSpacing(23)
                                          .foregroundColor(Color(red: 0.98, green: 0.99, blue: 1))
                                          Text(" \(bluetoothManager.mode1_CHT1_Value)℃")
                                          .font(Font.custom("Pretendard", size: 13).weight(.bold))
                                          .lineSpacing(23)
                                          .foregroundColor(Color(red: 0.98, green: 0.99, blue: 1))
                                      }
                                      .padding(EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16))
                                      .frame(maxWidth: .infinity)
                                      .cornerRadius(24)
                                      Rectangle()
                                        .foregroundColor(.clear)
                                        .frame(width: 1, height: 28)
                                        .background(Color(red: 0.98, green: 0.99, blue: 1))
                                        .cornerRadius(2)
                                        .opacity(0.50)
                                      VStack(alignment: .leading, spacing: 0) {
                                        Text("2 구역")
                                          .font(Font.custom("Pretendard", size: 12).weight(.semibold))
                                          .lineSpacing(23)
                                          .foregroundColor(Color(red: 0.98, green: 0.99, blue: 1))
                                          Text(" \(bluetoothManager.mode1_CHT2_Value)℃")
                                          .font(Font.custom("Pretendard", size: 13).weight(.bold))
                                          .lineSpacing(23)
                                          .foregroundColor(Color(red: 0.98, green: 0.99, blue: 1))
                                      }
                                      .padding(EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16))
                                      .frame(maxWidth: .infinity)
                                      .cornerRadius(24)
                                      Rectangle()
                                        .foregroundColor(.clear)
                                        .frame(width: 1, height: 28)
                                        .background(Color(red: 0.98, green: 0.99, blue: 1))
                                        .cornerRadius(2)
                                        .opacity(0.50)
                                      VStack(alignment: .leading, spacing: 0) {
                                        Text("3 구역")
                                          .font(Font.custom("Pretendard", size: 12).weight(.semibold))
                                          .lineSpacing(23)
                                          .foregroundColor(Color(red: 0.98, green: 0.99, blue: 1))
                                          Text(" \(bluetoothManager.mode1_CHT3_Value)℃")
                                          .font(Font.custom("Pretendard", size: 13).weight(.bold))
                                          .lineSpacing(23)
                                          .foregroundColor(Color(red: 0.98, green: 0.99, blue: 1))
                                      }
                                      .padding(EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16))
                                      .frame(maxWidth: .infinity)
                                      .cornerRadius(24)
                                      Rectangle()
                                        .foregroundColor(.clear)
                                        .frame(width: 1, height: 28)
                                        .background(Color(red: 0.98, green: 0.99, blue: 1))
                                        .cornerRadius(2)
                                        .opacity(0.50)
                                      VStack(alignment: .leading, spacing: 0) {
                                        Text("4 구역")
                                          .font(Font.custom("Pretendard", size: 12).weight(.semibold))
                                          .lineSpacing(23)
                                          .foregroundColor(Color(red: 0.98, green: 0.99, blue: 1))
                                          Text(" \(bluetoothManager.mode1_CHT4_Value)℃")
                                          .font(Font.custom("Pretendard", size: 13).weight(.bold))
                                          .lineSpacing(23)
                                          .foregroundColor(Color(red: 0.98, green: 0.99, blue: 1))
                                      }
                                      .padding(EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16))
                                      .frame(maxWidth: .infinity)
                                      .cornerRadius(24)
                                    }
                                    .frame(maxWidth: .infinity, minHeight: 70)
                                    .padding()
                                }
                                
                                
                                VStack (spacing: 16) {
                                    HStack {
                                        NavigationLink(destination: TimeSettingView(bluetoothManager:bluetoothManager)) {
                                            VStack() {
                                                HStack(alignment:.top, spacing: 12) {
                                                    Image("clockRed")
                                                        .frame(width: 20, height: 20)
                                                        .opacity(0.4)
                                                    
                                                    
                                                    Text("사용 시간\n설정하기")
                                                        .font(Font.custom("Pretendard", size: 16).weight(.bold))
                                                        .foregroundColor(.textBlack)
                                                }
                                                .padding(0)
                                                .frame(maxWidth: .infinity)
                                            }
                                            .frame(maxWidth: .infinity, minHeight: 86)
                                            .background(.whiteLight)
                                            .cornerRadius(24)
                                        }
                                        
                                        
                                        NavigationLink(destination: SectionSettingView(bluetoothManager: bluetoothManager)) {
                                            VStack() {
                                                HStack(alignment:.top, spacing: 12) {
                                                    Image("calculatorRed")
                                                        .frame(width: 20, height: 20)
                                                        .opacity(0.4)
                                                    
                                                    Text("사용 구역\n 설정하기")
                                                        .font(Font.custom("Pretendard", size: 16).weight(.bold))
                                                        .foregroundColor(.textBlack)
                                                }
                                                .padding(0)
                                                .frame(maxWidth: .infinity)
                                            }
                                            .frame(maxWidth: .infinity, minHeight: 86)
                                            .background(.whiteLight)
                                            .cornerRadius(24)
                                            
                                        }
                                    }
                                    
                                    HStack {
                                        NavigationLink(destination: SectionTmpView(bluetoothManager:bluetoothManager, CHT1_Value: bluetoothManager.CHT1_Value, CHT2_Value: bluetoothManager.CHT2_Value, CHT3_Value: bluetoothManager.CHT3_Value, CHT4_Value: bluetoothManager.CHT4_Value)) {
                                            VStack() {
                                                HStack(alignment: .top, spacing: 12) {
                                                    Image("temperatureRed")
                                                        .frame(width: 20, height: 20)
                                                        .opacity(0.4)
                                                    Text("구역별 온도\n설정하기")
                                                        .font(Font.custom("Pretendard", size: 16).weight(.bold))
                                                        .foregroundColor(.textBlack)
                                                }
                                                .padding(0)
                                                .frame(maxWidth: .infinity)
                                            }
                                            .frame(maxWidth: .infinity, minHeight: 86)
                                            .background(.whiteLight)
                                            .cornerRadius(24)
                                            .onAppear {
                                                requestData()
                                            }
                                        }
                                        
                                        
                                        NavigationLink(destination: SectionStepView(bluetoothManager: bluetoothManager, CHI1_Value: bluetoothManager.CHI1_Value, CHI2_Value: bluetoothManager.CHI2_Value, CHI3_Value: bluetoothManager.CHI3_Value, CHI4_Value: bluetoothManager.CHI4_Value)) {
                                            VStack() {
                                                HStack(alignment: .top, spacing: 12) {
                                                    Image("dashboardRed")
                                                        .frame(width: 20, height: 20)
                                                        .opacity(0.4)
                                                    Text("구역별 단계\n설정하기")
                                                        .font(Font.custom("Pretendard", size: 16).weight(.bold))
                                                        .foregroundColor(.textBlack)
                                                }
                                                .padding(0)
                                                .frame(maxWidth:.infinity)
                                            }
                                            .frame(maxWidth: .infinity, minHeight: 86)
                                            .background(.whiteLight)
                                            .cornerRadius(24)
                                        }
                                    }
                                    
                                    // 사용 구역 설정하기
//                                    NavigationLink(destination: SectionSettingView(bluetoothManager: bluetoothManager)) {
//                                        VStack() {
//                                            HStack(alignment: .top, spacing: 12) {
//                                                Image("calculatorRed")
//                                                    .frame(width: 20, height: 20)
//                                                    .opacity(0.4)
//                                                Text("사용 구역 설정하기")
//                                                    .font(Font.custom("Pretendard", size: 16).weight(.bold))
//                                                    .lineSpacing(23)
//                                                    .foregroundColor(.textBlack)
//                                            }
//                                            .padding(.leading)
//                                            .frame(maxWidth: .infinity, alignment: .leading)
//                                        }
//                                        .frame(maxWidth: .infinity, minHeight: 64, maxHeight: 64)
//                                        .background(.whiteLight)
//                                        .cornerRadius(24)
//                                    }
                                }
                                .padding()
                            }
                        }
                        .background(
                            LinearGradient(
                                stops: [
                                Gradient.Stop(color: Color(red: 1, green: 0.45, blue: 0.33).opacity(0.5), location: 0.00),
                                Gradient.Stop(color: Color(red: 1, green: 0.18, blue: 0).opacity(0.5), location: 1.00),
                                ],
                                startPoint: UnitPoint(x: 0.5, y: 0),
                                endPoint: UnitPoint(x: 0.5, y: 1)
                            )
                        )
                    }
                }
            }
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
    
    func requestMode1Data() {
        if !bluetoothManager.bluetoothIsReady {
            print("기기가 연결되지 않음")
            alertMessage = "블루투스가 준비되지 않았습니다."
            showingAlert = true
            return
        }
        
        let CHECKSUM: UInt8 = 175 &+ 1
        
        let packet: [UInt8] = [175, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,0,0, CHECKSUM, 13, 10]
        
        print(packet)
        bluetoothManager.sendBytesToDevice(packet)
    }
    
    func sendOnData() {
        if !bluetoothManager.bluetoothIsReady {
            print("시리얼이 준비되지 않음")
            return
        }
                
        let CHECKSUM: UInt8 = 175 &+ 15 // 0xAF
        
        let packet: [UInt8] = [175, 0, 15, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, CHECKSUM, 13, 10]
        bluetoothManager.sendBytesToDevice(packet)
    }
    
    func sendOffData() {
        if !bluetoothManager.bluetoothIsReady {
            print("시리얼이 준비되지 않음")
            return
        }
                
        let CHECKSUM: UInt8 = 175 &+ 0 // 0xAF
        
        let packet: [UInt8] = [175, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, CHECKSUM, 13, 10]
        bluetoothManager.sendBytesToDevice(packet)
    }
}



