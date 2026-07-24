//
//  FavoritesView.swift
//  Ruyishanju
//
//  收藏列表
//

import SwiftUI

struct FavoritesView: View {
    @State private var favoritesManager = FavoritesManager()
    @State private var allUnitTypes: [UnitType] = []

    var favoritedUnits: [UnitType] {
        allUnitTypes.filter { favoritesManager.isFavorited($0.id) }
    }

    var body: some View {
        NavigationStack {
            Group {
                if favoritedUnits.isEmpty {
                    emptyState
                } else {
                    favoritesList
                }
            }
            .background(AppTheme.background)
            .navigationTitle("我的收藏")
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                allUnitTypes = DataLoader.load("unit_types.json", as: [UnitType].self) ?? []
            }
        }
    }

    // MARK: - 收藏列表

    private var favoritesList: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                ForEach(favoritedUnits) { unit in
                    NavigationLink {
                        UnitTypeDetailView(unitType: unit)
                    } label: {
                        FavoriteUnitCard(
                            unit: unit,
                            isFavorited: true,
                            onToggle: { favoritesManager.toggle(unit.id) }
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(16)
        }
    }

    // MARK: - 空状态

    private var emptyState: some View {
        VStack(spacing: 20) {
            Spacer()

            Image(systemName: "heart.slash")
                .font(.system(size: 56))
                .foregroundColor(AppTheme.textSecondary.opacity(0.3))

            Text("暂无收藏户型")
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(AppTheme.textSecondary)

            Text("在户型详情页点击 ♡ 即可收藏")
                .font(.system(size: 14))
                .foregroundColor(AppTheme.textSecondary.opacity(0.6))

            NavigationLink {
                UnitTypeListView()
            } label: {
                Text("浏览户型")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(AppTheme.primary)
                    )
            }

            Spacer()
        }
    }
}

// MARK: - 收藏户型卡片

struct FavoriteUnitCard: View {
    let unit: UnitType
    let isFavorited: Bool
    let onToggle: () -> Void

    var body: some View {
        HStack(spacing: 14) {
            // 户型缩略图
            floorPlanImage(for: unit)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 80, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 8))

            // 信息
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(unit.name)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(AppTheme.textPrimary)

                    Spacer()

                    Button(action: onToggle) {
                        Image(systemName: isFavorited ? "heart.fill" : "heart")
                            .font(.system(size: 18))
                            .foregroundColor(isFavorited ? .red : AppTheme.textSecondary.opacity(0.4))
                    }
                }

                Text("\(unit.roomCount)室\(unit.hallCount)厅\(unit.bathroomCount)卫 · \(String(format: "%.0f", unit.area))㎡")
                    .font(.system(size: 13))
                    .foregroundColor(AppTheme.textSecondary)

                HStack(spacing: 8) {
                    Label(unit.orientation, systemImage: "safari")
                        .font(.system(size: 11))
                        .foregroundColor(AppTheme.textSecondary)
                    Label(unit.buildingNumber, systemImage: "building.2")
                        .font(.system(size: 11))
                        .foregroundColor(AppTheme.textSecondary)
                }

                if let price = unit.priceRange.minTotalPrice {
                    Text("\(NSDecimalNumber(decimal: price).intValue)万起")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(AppTheme.wood)
                }
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
        )
    }

    private func floorPlanImage(for unit: UnitType) -> Image {
        if !unit.floorPlanImage.isEmpty {
            return MediaHelper.image(named: unit.floorPlanImage)
        }
        let floorplans = MediaHelper.Floorplan.allCases
        let index = abs(unit.id.hashValue) % floorplans.count
        return floorplans[index].image
    }
}

#Preview {
    FavoritesView()
}
