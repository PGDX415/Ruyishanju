//
//  OverviewView.swift
//  Ruyishanju
//
//  项目总览 — 沙盘/鸟瞰图 + 楼栋热区 + 项目信息
//

import SwiftUI

struct OverviewView: View {
    var switchTab: (ContentView.AppTab) -> Void
    @State private var viewModel = OverviewViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // 页面标题
                Text("项目总览")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(AppTheme.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)

                // 沙盘图区域
                sandboxArea

                // 分期信息
                phaseInfoCard

                // 项目介绍
                descriptionCard
            }
            .padding(16)
        }
        .background(AppTheme.background)
    }

    // MARK: - 沙盘图

    @State private var selectedBuilding: Int? = nil

    /// 楼栋模拟数据
    struct Building: Identifiable {
        let id: Int
        let name: String
        let unitRange: String
        let status: String
        /// 热区位置比例 (x, y, width, height)，相对于图片尺寸
        let hotspot: (CGFloat, CGFloat, CGFloat, CGFloat)
    }

    let buildings: [Building] = [
        Building(id: 1, name: "1栋", unitRange: "100-120㎡", status: "在售",
                 hotspot: (0.08, 0.20, 0.18, 0.55)),
        Building(id: 2, name: "2栋", unitRange: "100-120㎡", status: "在售",
                 hotspot: (0.28, 0.18, 0.18, 0.57)),
        Building(id: 3, name: "3栋", unitRange: "100-120㎡", status: "在售",
                 hotspot: (0.48, 0.15, 0.18, 0.60)),
        Building(id: 5, name: "5栋", unitRange: "100-120㎡", status: "在售",
                 hotspot: (0.68, 0.20, 0.18, 0.55)),
        Building(id: 6, name: "6栋", unitRange: "100-120㎡", status: "在售",
                 hotspot: (0.82, 0.17, 0.16, 0.58)),
    ]

    private var sandboxArea: some View {
        VStack(spacing: 12) {
            Text("项目鸟瞰")
                .font(.brandSubtitle)
                .foregroundColor(AppTheme.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)

            GeometryReader { geometry in
                ZStack(alignment: .topLeading) {
                    // 底图
                    MediaHelper.GalleryPhoto.photo07.image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geometry.size.width, height: 280)
                        .clipped()

                    // 楼栋热区
                    ForEach(buildings) { building in
                        let (x, y, w, h) = building.hotspot
                        Button {
                            withAnimation(.spring(response: 0.3)) {
                                selectedBuilding = selectedBuilding == building.id ? nil : building.id
                            }
                        } label: {
                            RoundedRectangle(cornerRadius: 6)
                                .fill(building.status == "在售" ? AppTheme.primary.opacity(0.3) : Color.gray.opacity(0.2))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 6)
                                        .stroke(building.status == "在售" ? AppTheme.primary : .gray, lineWidth: 1.5)
                                )
                                .overlay(alignment: .top) {
                                    Text(building.name)
                                        .font(.system(size: 10, weight: .bold))
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 5)
                                        .padding(.vertical, 2)
                                        .background(
                                            Capsule()
                                                .fill(building.status == "在售" ? AppTheme.primary : .gray)
                                        )
                                        .offset(y: -14)
                                }
                        }
                        .frame(
                            width: geometry.size.width * w,
                            height: 280 * h
                        )
                        .position(
                            x: geometry.size.width * (x + w / 2),
                            y: 280 * (y + h / 2)
                        )
                    }
                }
            }
            .frame(height: 280)
            .clipShape(RoundedRectangle(cornerRadius: 16))

            // 选中楼栋信息卡片
            if let id = selectedBuilding, let building = buildings.first(where: { $0.id == id }) {
                BuildingInfoCard(building: building) {
                    switchTab(.unitTypes)
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
    }

    // MARK: - 分期信息

    private var phaseInfoCard: some View {
        HStack(spacing: 16) {
            PhaseInfoItem(
                title: "在售期数",
                value: "一期",
                icon: "building.columns.fill"
            )

            PhaseInfoItem(
                title: "总期数",
                value: "共3期",
                icon: "square.grid.3x3.fill"
            )

            PhaseInfoItem(
                title: "交付时间",
                value: "2026.12",
                icon: "calendar.badge.clock"
            )

            PhaseInfoItem(
                title: "整体进度",
                value: "一期封顶",
                icon: "checkmark.shield.fill"
            )
        }
    }

    // MARK: - 项目描述

    private var descriptionCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Rectangle()
                    .fill(AppTheme.primary)
                    .frame(width: 3, height: 18)
                Text("绿城如意山居")
                    .font(.brandSubtitle)
                    .foregroundColor(AppTheme.textPrimary)
            }

            Text("绿城如意山居，位于海南五指山，是绿城中国倾力打造的山居康养理想作品。项目占地约300亩，总建筑面积约24.6万㎡，一期打造6幢14层山景高层，以桂语系的极致简约语言，融合当代建筑的国际审美格调，将建筑妥帖安放在山色之间，开启理想山居生活的全新篇章。")
                .font(.system(size: 15))
                .foregroundColor(AppTheme.textSecondary)
                .lineSpacing(6)

            Divider().background(AppTheme.divider)

            VStack(alignment: .leading, spacing: 10) {
                overviewRow(icon: "ruler", title: "容积率", value: "住宅1.0/文旅0.75")
                overviewRow(icon: "tree.fill", title: "绿地率", value: "40%")
                overviewRow(icon: "mountain.2.fill", title: "森林覆盖率", value: "86.44%")
                overviewRow(icon: "car.fill", title: "停车位", value: "440（全地下）")
                overviewRow(icon: "leaf.fill", title: "负氧离子", value: "最高50000个/cm³")
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(AppTheme.cardBackground)
                .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
        )
    }

    private func overviewRow(icon: String, title: String, value: String) -> some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 13))
                .foregroundColor(AppTheme.primary)
                .frame(width: 22)

            Text(title)
                .font(.system(size: 14))
                .foregroundColor(AppTheme.textSecondary)

            Spacer()

            Text(value)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(AppTheme.textPrimary)
        }
    }
}

// MARK: - 分期信息项

struct PhaseInfoItem: View {
    let title: String
    let value: String
    let icon: String

    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(AppTheme.primary)
                .frame(height: 24)

            Text(value)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(AppTheme.textPrimary)

            Text(title)
                .font(.system(size: 11))
                .foregroundColor(AppTheme.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppTheme.cardBackground)
                .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
        )
    }
}

@Observable
class OverviewViewModel {
    let projectName = "绿城如意山居"
}

// MARK: - 楼栋信息卡片

struct BuildingInfoCard: View {
    let building: OverviewView.Building
    var onViewUnits: (() -> Void)?

    var body: some View {
        Button {
            onViewUnits?()
        } label: {
            HStack(spacing: 14) {
                // 楼栋图标
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(building.status == "在售" ? AppTheme.primaryLight : Color.gray.opacity(0.1))
                        .frame(width: 44, height: 44)
                    Image(systemName: "building.2.fill")
                        .font(.system(size: 18))
                        .foregroundColor(building.status == "在售" ? AppTheme.primary : .gray)
                }

                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(building.name)
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(AppTheme.textPrimary)
                        Text(building.status)
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(building.status == "在售" ? .green : .gray)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(
                                Capsule()
                                    .fill(building.status == "在售" ? Color.green.opacity(0.1) : Color.gray.opacity(0.1))
                            )
                    }
                    Text("户型面积：\(building.unitRange)")
                        .font(.system(size: 13))
                        .foregroundColor(AppTheme.textSecondary)
                }

                Spacer()

                Text("查看户型")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(AppTheme.primary)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(
                        Capsule()
                            .fill(AppTheme.primary.opacity(0.1))
                    )

                Image(systemName: "chevron.right")
                    .font(.system(size: 12))
                    .foregroundColor(AppTheme.textSecondary.opacity(0.4))
            }
            .padding(14)
        }
        .buttonStyle(.plain)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppTheme.cardBackground)
                .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
        )
    }
}

#Preview {
    OverviewView(switchTab: { _ in })
}
