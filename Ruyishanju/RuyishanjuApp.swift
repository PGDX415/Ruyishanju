//
//  RuyishanjuApp.swift
//  Ruyishanju
//
//  App 入口 — 启动页 → 主界面
//

import SwiftUI

@main
struct RuyishanjuApp: App {
    @State private var showKiosk = false
    @State private var showSplash = true
    @State private var dataStore = AppDataStore()

    init() {
        // 横向 ScrollView 中的按钮需要立即响应 tap，不让 UIScrollView 延迟判断
        UIScrollView.appearance().delaysContentTouches = false
    }

    var body: some Scene {
        WindowGroup {
            ZStack {
                ContentView(showKiosk: $showKiosk)
                    .environment(\.dataStore, dataStore)

                if showSplash {
                    SplashView {
                        showSplash = false
                    }
                    .transition(.opacity)
                }
            }
            .animation(.easeInOut(duration: 0.6), value: showSplash)
        }
    }
}
