//
//  UnitTypeDetailView.swift
//  Ruyishanju
//
//  户型详情页
//

import SwiftUI

struct UnitTypeDetailView: View {
    let unitType: UnitType
    @State private var showFloorPlanZoom = false

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // 户型图大图
                floorPlanSection
                    .frame(height: 320)

                // 户型信息
                infoSection
            }
        }
        .background(AppTheme.background)
        .navigationTitle(unitType.name)
        .navigationBarTitleDisplayMode(.inline)
        .fullScreenCover(isPresented: $showFloorPlanZoom) {
            FloorPlanZoomView(image: floorplanImage, title: unitType.name)
        }
    }

    // MARK: - 户型图

    private var floorPlanSection: some View {
        Button {
            showFloorPlanZoom = true
        } label: {
            ZStack(alignment: .bottomTrailing) {
                floorplanImage
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                // 放大提示
                HStack(spacing: 4) {
                    Image(systemName: "plus.magnifyingglass")
                        .font(.system(size: 11))
                    Text("点击放大查看细部")
                        .font(.system(size: 11))
                }
                .foregroundColor(.white.opacity(0.9))
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(Capsule().fill(Color.black.opacity(0.45)))
                .padding(12)
            }
        }
        .buttonStyle(.plain)
        .background(Color.white)
    }

    /// 根据 unitType.floorPlanImage 字段加载实际户型图，空值时 fallback 到 hash 映射
    private var floorplanImage: Image {
        if !unitType.floorPlanImage.isEmpty {
            return MediaHelper.image(named: unitType.floorPlanImage)
        }
        let floorplans = MediaHelper.Floorplan.allCases
        let index = abs(unitType.id.hashValue) % floorplans.count
        return floorplans[index].image
    }

    // MARK: - 信息区

    private var infoSection: some View {
        VStack(spacing: 20) {
            // 格局与面积
            VStack(spacing: 8) {
                HStack {
                    Text("\(unitType.roomCount)室\(unitType.hallCount)厅\(unitType.bathroomCount)卫")
                        .font(.brandTitle)
                        .foregroundColor(AppTheme.textPrimary)

                    Spacer()

                    statusBadge
                }

                Text("建筑面积 \(String(format: "%.1f", unitType.area))㎡\(unitType.innerArea.map { " · 套内 \(String(format: "%.1f", $0))㎡" } ?? "")")
                    .font(.system(size: 14))
                    .foregroundColor(AppTheme.textSecondary)
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
            )

            // 价格信息
            priceCard

            // 详细信息
            detailCard

            // 户型介绍
            descriptionCard
        }
        .padding(16)
    }

    // MARK: - 价格卡片

    private var priceCard: some View {
        VStack(spacing: 12) {
            HStack {
                Text("参考价格")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppTheme.textSecondary)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(AppTheme.surface)
                    )

                Spacer()

                Text("一房一价，具体以售楼处公示为准")
                    .font(.system(size: 11))
                    .foregroundColor(AppTheme.textSecondary.opacity(0.6))
            }

            if let minPrice = unitType.priceRange.minTotalPrice,
               let maxPrice = unitType.priceRange.maxTotalPrice {
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text("¥")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(AppTheme.wood)
                    Text("\(NSDecimalNumber(decimal: minPrice).intValue)")
                        .font(.system(size: 30, weight: .semibold, design: .rounded))
                        .foregroundColor(AppTheme.wood)
                    Text("- \(NSDecimalNumber(decimal: maxPrice).intValue)万")
                        .font(.system(size: 18, weight: .regular))
                        .foregroundColor(AppTheme.wood)
                }
            }

            if let unitPrice = unitType.priceRange.unitPrice {
                Text("参考单价 \(NSDecimalNumber(decimal: unitPrice).intValue) 元/㎡")
                    .font(.system(size: 13))
                    .foregroundColor(AppTheme.textSecondary)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
        )
    }

    // MARK: - 详细信息卡片

    private var detailCard: some View {
        VStack(spacing: 0) {
            DetailRow(title: "朝向", value: unitType.orientation, icon: "safari")
            Divider().background(AppTheme.divider)
            DetailRow(title: "楼层", value: unitType.floorLevel, icon: "stairs")
            Divider().background(AppTheme.divider)
            DetailRow(title: "楼栋", value: unitType.buildingNumber, icon: "building.2")
            Divider().background(AppTheme.divider)
            DetailRow(title: "状态", value: unitType.status.rawValue, icon: "tag.fill")
        }
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
        )
    }

    // MARK: - 描述卡片

    private var descriptionCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Rectangle()
                    .fill(AppTheme.primary)
                    .frame(width: 3, height: 16)
                Text("户型亮点")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(AppTheme.textPrimary)
            }

            // 标签
            FlowTagLayout(tags: unitType.featureTags, spacing: 8)

            Text(unitType.description)
                .font(.system(size: 15))
                .foregroundColor(AppTheme.textSecondary)
                .lineSpacing(6)
                .padding(.top, 4)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
        )
    }

    // MARK: - 状态标签

    private var statusBadge: some View {
        Text(unitType.status.rawValue)
            .font(.system(size: 12, weight: .medium))
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
}

// MARK: - 详情行

struct DetailRow: View {
    let title: String
    let value: String
    let icon: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundColor(AppTheme.primary)
                .frame(width: 20)

            Text(title)
                .font(.system(size: 14))
                .foregroundColor(AppTheme.textSecondary)

            Spacer()

            Text(value)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(AppTheme.textPrimary)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
    }
}

// MARK: - 流式布局组件

/// 简易流式布局行视图，用于户型特色标签
struct FlowTagLayout: View {
    let tags: [String]
    var spacing: CGFloat = 8

    var body: some View {
        GeometryReader { geometry in
            self.generateContent(in: geometry)
        }
        .frame(height: computeHeight())
    }

    private func generateContent(in geometry: GeometryProxy) -> some View {
        var width: CGFloat = 0
        var rows: [[String]] = [[]]

        for tag in tags {
            let tagWidth = tagWidth(tag)
            if width + tagWidth + (rows.last!.isEmpty ? 0 : spacing) > geometry.size.width {
                rows.append([tag])
                width = tagWidth
            } else {
                rows[rows.count - 1].append(tag)
                width += tagWidth + (rows.last!.count > 1 ? spacing : 0)
            }
        }

        return VStack(alignment: .leading, spacing: spacing) {
            ForEach(rows.indices, id: \.self) { rowIndex in
                HStack(spacing: spacing) {
                    ForEach(rows[rowIndex], id: \.self) { tag in
                        Text(tag)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(AppTheme.primary)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(AppTheme.primaryLight)
                            )
                    }
                }
            }
        }
    }

    private func tagWidth(_ tag: String) -> CGFloat {
        let font = UIFont.systemFont(ofSize: 12, weight: .medium)
        let attributes = [NSAttributedString.Key.font: font]
        let size = (tag as NSString).size(withAttributes: attributes)
        return size.width + 24 + spacing // 24 for horizontal padding
    }

    private func computeHeight() -> CGFloat {
        // 估算高度
        let lineHeight: CGFloat = 30 + spacing
        let estimatedLines = max(1, (tags.count + 2) / 3)
        return lineHeight * CGFloat(estimatedLines)
    }
}

// MARK: - 户型图全屏缩放

struct FloorPlanZoomView: View {
    let image: Image
    let title: String

    @Environment(\.dismiss) private var dismiss
    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .scaleEffect(scale)
                .offset(offset)
                .gesture(
                    MagnificationGesture()
                        .onChanged { value in
                            let newScale = lastScale * value
                            scale = min(max(newScale, 1), 5)
                        }
                        .onEnded { _ in
                            lastScale = scale
                            if scale <= 1 {
                                withAnimation(.spring(response: 0.3)) {
                                    offset = .zero
                                    lastOffset = .zero
                                }
                            }
                        }
                )
                .simultaneousGesture(
                    DragGesture()
                        .onChanged { value in
                            guard scale > 1 else { return }
                            offset = CGSize(
                                width: lastOffset.width + value.translation.width,
                                height: lastOffset.height + value.translation.height
                            )
                        }
                        .onEnded { _ in
                            lastOffset = offset
                        }
                )
                .onTapGesture(count: 2) {
                    withAnimation(.spring(response: 0.3)) {
                        if scale > 1 {
                            scale = 1
                            lastScale = 1
                            offset = .zero
                            lastOffset = .zero
                        } else {
                            scale = 2.5
                            lastScale = 2.5
                        }
                    }
                }

            // 顶部工具栏
            VStack {
                HStack {
                    // 返回按钮
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 26))
                            .foregroundColor(.white.opacity(0.7))
                    }

                    Spacer()

                    // 标题
                    Text(title)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))

                    Spacer()

                    // 重置缩放
                    Button {
                        withAnimation(.spring(response: 0.3)) {
                            scale = 1
                            lastScale = 1
                            offset = .zero
                            lastOffset = .zero
                        }
                    } label: {
                        Image(systemName: "arrow.counterclockwise")
                            .font(.system(size: 20))
                            .foregroundColor(scale > 1 ? .white.opacity(0.7) : .white.opacity(0.25))
                    }
                    .disabled(scale <= 1)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)

                Spacer()

                // 底部提示
                if scale <= 1 {
                    HStack(spacing: 6) {
                        Image(systemName: "hand.draw.fill")
                            .font(.system(size: 11))
                        Text("双指缩放 · 双击放大 · 拖动查看")
                            .font(.system(size: 12))
                    }
                    .foregroundColor(.white.opacity(0.45))
                    .padding(.bottom, 40)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        UnitTypeDetailView(unitType: UnitType(
            id: "test",
            name: "如意·雅居",
            roomCount: 3,
            hallCount: 2,
            bathroomCount: 2,
            area: 126.5,
            innerArea: 102.3,
            orientation: "南北通透",
            floorLevel: "3-8层",
            buildingNumber: "1栋",
            featureTags: ["双阳台", "主卧套房", "明厨明卫"],
            floorPlanImage: "",
            priceRange: PriceRange(minTotalPrice: 185, maxTotalPrice: 210, unitPrice: 15800),
            status: .available,
            description: "三室两厅两卫，南北通透格局。"
        ))
    }
}
