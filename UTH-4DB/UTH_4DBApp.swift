//
//  UTH_4DBApp.swift
//  UTH-4DB
//
//  Created by 이요섭 on 7/17/24.
//

import SwiftUI

@main
struct UTH_4DBApp: App {
    var timerManager = TimeManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(timerManager)
        }
    }
}
