//
//  UnitTypeListView.swift
//  Ruyishanju
//
//  户型库列表 — 核心模块，支持按室数/面积筛选
//

import SwiftUI

struct UnitTypeListView: View {
    @State private var viewModel = UnitTypeListViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // 筛选栏
                filterBar

                // 户型列表
                if viewModel.filteredUnitTypes.isEmpty {
                    emptyState
                } else {
                    unitTypeList
                }
            }
            .background(AppTheme.background)
            .navigationTitle("户型鉴赏")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    // MARK: - 筛选栏

    private var filterBar: some View {
        VStack(spacing: 0) {
            // 搜索栏
            HStack(spacing: 10) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(AppTheme.textSecondary.opacity(0.5))
                TextField("搜索户型名称、特点...", text: $viewModel.searchQuery)
                    .font(.system(size: 14))
                    .onSubmit {
                        viewModel.applyFilters()
                    }
                if !viewModel.searchQuery.isEmpty {
                    Button {
                        viewModel.searchQuery = ""
                        viewModel.applyFilters()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(AppTheme.textSecondary.opacity(0.4))
                    }
                }
            }
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(AppTheme.surface)
            )
            .padding(.horizontal, 16)
            .padding(.vertical, 10)

            // 室数筛选
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(RoomFilter.allCases) { filter in
                        FilterChip(
                            title: filter.rawValue,
                            isSelected: viewModel.selectedRoomFilter == filter,
                            action: {
                                viewModel.selectedRoomFilter = filter
                                viewModel.applyFilters()
                            }
                        )
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 6)
            }

            // 面积筛选
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(AreaFilter.allCases) { filter in
                        FilterChip(
                            title: filter.rawValue,
                            isSelected: viewModel.selectedAreaFilter == filter,
                            action: {
                                viewModel.selectedAreaFilter = filter
                                viewModel.applyFilters()
                            }
                        )
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 10)
            }

            Divider()
                .background(AppTheme.divider)
        }
        .background(Color.white)
    }

    // MARK: - 户型列表

    private var unitTypeList: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                ForEach(viewModel.filteredUnitTypes) { unitType in
                    NavigationLink {
                        UnitTypeDetailView(unitType: unitType)
                    } label: {
                        UnitTypeCard(unitType: unitType)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(16)
        }
    }

    // MARK: - 空状态

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "house.lodge")
                .font(.system(size: 48))
                .foregroundColor(AppTheme.textSecondary.opacity(0.4))

            Text("暂无匹配户型")
                .font(.brandSubtitle)
                .foregroundColor(AppTheme.textSecondary)

            Button("重置筛选") {
                viewModel.resetFilters()
            }
            .font(.system(size: 14, weight: .medium))
            .foregroundColor(AppTheme.primary)
            .padding(.horizontal, 20)
            .padding(.vertical, 8)
            .background(
                Capsule()
                    .stroke(AppTheme.primary, lineWidth: 1)
            )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.top, 80)
    }
}

// MARK: - 筛选标签

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 13, weight: isSelected ? .semibold : .regular))
                .foregroundColor(isSelected ? .white : AppTheme.textSecondary)
                .padding(.horizontal, 14)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(isSelected ? AppTheme.primary : AppTheme.surface)
                )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - 户型卡片

struct UnitTypeCard: View {
    let unitType: UnitType
    @State private var favoritesManager = FavoritesManager()

    var body: some View {
        VStack(spacing: 0) {
            // 户型图
            ZStack {
                floorplanImage
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 180)
                    .clipped()
            }
            .frame(height: 180)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(alignment: .topTrailing) {
                // 销售状态标签
                statusBadge
                    .padding(8)
            }
            .overlay(alignment: .topLeading) {
                // 收藏按钮
                Button {
                    favoritesManager.toggle(unitType.id)
                } label: {
                    Image(systemName: favoritesManager.isFavorited(unitType.id) ? "heart.fill" : "heart")
                        .font(.system(size: 16))
                        .foregroundColor(favoritesManager.isFavorited(unitType.id) ? .red : .white.opacity(0.8))
                        .frame(width: 32, height: 32)
                        .background(Circle().fill(.black.opacity(0.25)))
                }
                .padding(8)
            }
            .contentShape(Rectangle())

            // 信息区
            VStack(spacing: 10) {
                // 户型名称 + 格局
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(unitType.name)
                            .font(.brandSubtitle)
                            .foregroundColor(AppTheme.textPrimary)

                        Text("\(unitType.roomCount)室\(unitType.hallCount)厅\(unitType.bathroomCount)卫 · \(String(format: "%.1f", unitType.area))㎡")
                            .font(.system(size: 13))
                            .foregroundColor(AppTheme.textSecondary)
                    }

                    Spacer()

                    // 价格
                    VStack(alignment: .trailing, spacing: 2) {
                        if let totalPrice = formattedTotalPrice {
                            Text(totalPrice)
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(AppTheme.wood)
                        }
                        if let unitPrice = formattedUnitPrice {
                            Text(unitPrice)
                                .font(.system(size: 11))
                                .foregroundColor(AppTheme.textSecondary)
                        }
                    }
                }

                // 标签行
                HStack(spacing: 8) {
                    Label(unitType.orientation, systemImage: "safari")
                        .font(.system(size: 11))
                        .foregroundColor(AppTheme.textSecondary)

                    Label(unitType.buildingNumber, systemImage: "building.2")
                        .font(.system(size: 11))
                        .foregroundColor(AppTheme.textSecondary)

                    ForEach(unitType.featureTags.prefix(3), id: \.self) { tag in
                        Text(tag)
                            .font(.system(size: 10))
                            .foregroundColor(AppTheme.primary)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(
                                Capsule()
                                    .fill(AppTheme.primaryLight)
                            )
                    }
                }
            }
            .padding(14)
        }
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.05), radius: 6, y: 3)
        )
        .contentShape(RoundedRectangle(cornerRadius: 14))
    }

    // MARK: - 户型图获取

    /// 根据 unitType.floorPlanImage 字段加载实际户型图，空值时 fallback 到 hash 映射
    private var floorplanImage: Image {
        if !unitType.floorPlanImage.isEmpty {
            return MediaHelper.image(named: unitType.floorPlanImage)
        }
        let floorplans = MediaHelper.Floorplan.allCases
        let index = abs(unitType.id.hashValue) % floorplans.count
        return floorplans[index].image
    }

    // MARK: - 状态标签

    private var statusBadge: some View {
        Text(unitType.status.rawValue)
            .font(.system(size: 11, weight: .medium))
            .foregroundColor(statusColor)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(
                Capsule()
                    .fill(statusColor.opacity(0.12))
            )
    }

    private var statusColor: Color {
        switch unitType.status {
        case .available: return .green
        case .reserved: return .orange
        case .sold: return .gray
        }
    }

    // MARK: - 格式化价格

    private var formattedTotalPrice: String? {
        guard let min = unitType.priceRange.minTotalPrice else { return nil }
        let minStr = NSDecimalNumber(decimal: min).intValue
        if let max = unitType.priceRange.maxTotalPrice {
            let maxStr = NSDecimalNumber(decimal: max).intValue
            return "\(minStr)-\(maxStr)万"
        }
        return "\(minStr)万起"
    }

    private var formattedUnitPrice: String? {
        guard let price = unitType.priceRange.unitPrice else { return nil }
        return "约\(NSDecimalNumber(decimal: price).intValue)元/㎡"
    }
}

// MARK: - ViewModel

@Observable
class UnitTypeListViewModel {
    var allUnitTypes: [UnitType] = []
    var filteredUnitTypes: [UnitType] = []
    var selectedRoomFilter: RoomFilter = .all
    var selectedAreaFilter: AreaFilter = .all
    var searchQuery: String = ""
    /// 外部传入的预筛选面积范围（例如从鸟瞰图楼栋热区跳转时设置）
    var preselectedAreaFilter: AreaFilter?

    init() {
        loadData()
    }

    func loadData() {
        allUnitTypes = DataLoader.load("unit_types.json", as: [UnitType].self) ?? []
        // 应用预筛选
        if let pre = preselectedAreaFilter {
            selectedAreaFilter = pre
        }
        applyFilters()
    }

    func applyFilters() {
        filteredUnitTypes = allUnitTypes.filter { unit in
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
            case .all:
                matchArea = true
            case .under120:
                matchArea = unit.area < 120
            case .range120to160:
                matchArea = unit.area >= 120 && unit.area <= 160
            case .range160to200:
                matchArea = unit.area > 160 && unit.area <= 200
            case .above200:
                matchArea = unit.area > 200
            }

            let matchSearch: Bool
            if searchQuery.isEmpty {
                matchSearch = true
            } else {
                let query = searchQuery.lowercased()
                matchSearch = unit.name.lowercased().contains(query)
                    || unit.featureTags.contains(where: { $0.lowercased().contains(query) })
                    || unit.orientation.lowercased().contains(query)
                    || unit.buildingNumber.lowercased().contains(query)
            }

            return matchRoom && matchArea && matchSearch
        }
    }

    func resetFilters() {
        selectedRoomFilter = .all
        selectedAreaFilter = .all
        searchQuery = ""
        applyFilters()
    }
}

#Preview {
    UnitTypeListView()
}
