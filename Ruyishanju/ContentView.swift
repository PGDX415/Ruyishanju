//
//  ContentView.swift
//  Ruyishanju
//
//  主视图 — 纯 SwiftUI TabView
//

import SwiftUI

struct ContentView: View {
    @Binding var showKiosk: Bool
    @State private var selectedTab: AppTab = .home

    enum AppTab: String, CaseIterable {
        case home = "首页"
        case unitTypes = "户型"
        case gallery = "图库"
        case overview = "总览"
        case more = "更多"

        var icon: String {
            switch self {
            case .home: return "house.fill"
            case .unitTypes: return "square.grid.2x2.fill"
            case .gallery: return "photo.on.rectangle.angled"
            case .overview: return "map.fill"
            case .more: return "ellipsis.circle.fill"
            }
        }
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            Tab(AppTab.home.rawValue, systemImage: AppTab.home.icon, value: AppTab.home) {
                HomeView(showKiosk: $showKiosk, switchTab: { selectedTab = $0 })
            }
            Tab(AppTab.unitTypes.rawValue, systemImage: AppTab.unitTypes.icon, value: AppTab.unitTypes) {
                UnitTypeListView()
            }
            Tab(AppTab.gallery.rawValue, systemImage: AppTab.gallery.icon, value: AppTab.gallery) {
                GalleryView()
            }
            Tab(AppTab.overview.rawValue, systemImage: AppTab.overview.icon, value: AppTab.overview) {
                OverviewView(switchTab: { selectedTab = $0 })
            }
            Tab(AppTab.more.rawValue, systemImage: AppTab.more.icon, value: AppTab.more) {
                MoreView(showKiosk: $showKiosk)
            }
        }
        .tint(AppTheme.primary)
        .fullScreenCover(isPresented: $showKiosk) {
            KioskView()
        }
    }
}

#Preview {
    ContentView(showKiosk: .constant(false))
}

