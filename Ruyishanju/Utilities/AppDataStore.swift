//
//  AppDataStore.swift
//  Ruyishanju
//
//  数据中心 — 统一管理 JSON 数据和全局状态
//

import SwiftUI
import Observation

@MainActor
@Observable
final class AppDataStore {
    // MARK: - 户型数据
    private(set) var unitTypes: [UnitType] = []
    var selectedRoomFilter: RoomFilter = .all
    var selectedAreaFilter: AreaFilter = .all

    var filteredUnitTypes: [UnitType] {
        unitTypes.filter { unit in
            let matchRoom: Bool
            if selectedRoomFilter == .all {
                matchRoom = true
            } else if let max = selectedRoomFilter.maxRooms {
                matchRoom = unit.roomCount >= selectedRoomFilter.minRooms && unit.roomCount <= max
            } else {
                matchRoom = unit.roomCount >= selectedRoomFilter.minRooms
            }

            let matchArea: Bool
            switch selectedAreaFilter {
            case .all: matchArea = true
            case .under120: matchArea = unit.area < 120
            case .range120to160: matchArea = unit.area >= 120 && unit.area <= 160
            case .range160to200: matchArea = unit.area > 160 && unit.area <= 200
            case .above200: matchArea = unit.area > 200
            }

            return matchRoom && matchArea
        }
    }

    // MARK: - 项目概览
    private(set) var projectOverview: ProjectOverview?

    // MARK: - 初始化
    init() {
        loadData()
    }

    func loadData() {
        unitTypes = DataLoader.load("unit_types.json", as: [UnitType].self) ?? []
        projectOverview = DataLoader.load("project_overview.json", as: ProjectOverview.self)
    }

    func resetFilters() {
        selectedRoomFilter = .all
        selectedAreaFilter = .all
    }
}

/// 环境注入 Key
struct AppDataStoreKey: EnvironmentKey {
    @MainActor static let defaultValue = AppDataStore()
}

extension EnvironmentValues {
    var dataStore: AppDataStore {
        get { self[AppDataStoreKey.self] }
        set { self[AppDataStoreKey.self] = newValue }
    }
}
