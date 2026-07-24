//
//  ComparisonView.swift
//  Ruyishanju
//
//  户型对比 — 并排比较两个户型
//

import SwiftUI

struct ComparisonView: View {
    @State private var unitTypes: [UnitType] = []
    @State private var leftID: String = ""
    @State private var rightID: String = ""
    @State private var showPicker = true

    private var leftUnit: UnitType? { unitTypes.first { $0.id == leftID } }
    private var rightUnit: UnitType? { unitTypes.first { $0.id == rightID } }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if showPicker || leftUnit == nil || rightUnit == nil {
                    pickerSection
                } else {
                    comparisonContent
                }
            }
            .background(AppTheme.background)
            .navigationTitle("户型对比")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                if !showPicker && leftUnit != nil && rightUnit != nil {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("重选") { showPicker = true }
                            .font(.system(size: 14))
                            .foregroundColor(AppTheme.primary)
                    }
                }
            }
            .onAppear {
                unitTypes = DataLoader.load("unit_types.json", as: [UnitType].self) ?? []
                if leftID.isEmpty, let first = unitTypes.first { leftID = first.id }
                if rightID.isEmpty, let last = unitTypes.last { rightID = last.id }
                if unitTypes.count <= 2 { showPicker = false }
            }
        }
    }

    // MARK: - 选择器

    private var pickerSection: some View {
        VStack(spacing: 24) {
            Text("选择要对比的户型")
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(AppTheme.textPrimary)
                .padding(.top, 40)

            HStack(spacing: 20) {
                VStack(spacing: 12) {
                    Text("户型 A")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(AppTheme.textSecondary)

                    Picker("", selection: $leftID) {
                        ForEach(unitTypes) { unit in
                            Text(unit.name).tag(unit.id)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(height: 100)

                    if let unit = leftUnit {
                        VStack(spacing: 4) {
                            Text("\(unit.roomCount)室\(unit.hallCount)厅")
                                .font(.system(size: 14, weight: .medium))
                            Text("\(String(format: "%.0f", unit.area))㎡")
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .foregroundColor(AppTheme.primary)
                        }
                        .padding(12)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(AppTheme.primaryLight.opacity(0.3))
                        )
                    }
                }

                Text("VS")
                    .font(.system(size: 18, weight: .bold, design: .serif))
                    .foregroundColor(AppTheme.wood)

                VStack(spacing: 12) {
                    Text("户型 B")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(AppTheme.textSecondary)

                    Picker("", selection: $rightID) {
                        ForEach(unitTypes) { unit in
                            Text(unit.name).tag(unit.id)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(height: 100)

                    if let unit = rightUnit {
                        VStack(spacing: 4) {
                            Text("\(unit.roomCount)室\(unit.hallCount)厅")
                                .font(.system(size: 14, weight: .medium))
                            Text("\(String(format: "%.0f", unit.area))㎡")
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .foregroundColor(AppTheme.primary)
                        }
                        .padding(12)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(AppTheme.primaryLight.opacity(0.3))
                        )
                    }
                }
            }
            .padding(.horizontal, 20)

            Spacer()

            Button {
                withAnimation { showPicker = false }
            } label: {
                Text("开始对比")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill((leftUnit != nil && rightUnit != nil)
                                  ? AppTheme.primary : Color.gray.opacity(0.4))
                    )
            }
            .disabled(leftUnit == nil || rightUnit == nil)
            .padding(.horizontal, 20)
            .padding(.bottom, 30)
        }
    }

    // MARK: - 对比内容

    private var comparisonContent: some View {
        ScrollView {
            VStack(spacing: 16) {
                // 户型图对比
                floorPlanRow

                // 详细信息表格
                comparisonTable

                Spacer().frame(height: 24)
            }
            .padding(16)
        }
    }

    // MARK: - 户型图行

    private var floorPlanRow: some View {
        HStack(spacing: 12) {
            if let left = leftUnit {
                unitImageCard(left, isLeft: true)
            }
            if let right = rightUnit {
                unitImageCard(right, isLeft: false)
            }
        }
    }

    private func unitImageCard(_ unit: UnitType, isLeft: Bool) -> some View {
        VStack(spacing: 0) {
            floorPlanImage(for: unit)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 160)
                .clipped()

            VStack(spacing: 6) {
                Text(unit.name)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(AppTheme.textPrimary)
                Text("\(unit.roomCount)室\(unit.hallCount)厅\(unit.bathroomCount)卫")
                    .font(.system(size: 12))
                    .foregroundColor(AppTheme.textSecondary)
                Text("\(String(format: "%.0f", unit.area))㎡")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(isLeft ? AppTheme.primary : AppTheme.wood)
            }
            .padding(.vertical, 12)
        }
        .background(AppTheme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
    }

    private func floorPlanImage(for unit: UnitType) -> Image {
        if !unit.floorPlanImage.isEmpty {
            return MediaHelper.image(named: unit.floorPlanImage)
        }
        let floorplans = MediaHelper.Floorplan.allCases
        let index = abs(unit.id.hashValue) % floorplans.count
        return floorplans[index].image
    }

    // MARK: - 对比表格

    private var comparisonTable: some View {
        VStack(spacing: 0) {
            // 表头
            HStack(spacing: 0) {
                Text("对比项")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(AppTheme.textSecondary)
                    .frame(width: 70, alignment: .leading)

                if let left = leftUnit {
                    Text(left.name)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(AppTheme.primary)
                        .frame(maxWidth: .infinity)
                }

                Rectangle()
                    .fill(AppTheme.divider)
                    .frame(width: 1, height: 20)

                if let right = rightUnit {
                    Text(right.name)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(AppTheme.wood)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(AppTheme.surface)
            .clipShape(
                UnevenRoundedRectangle(
                    topLeadingRadius: 12, bottomLeadingRadius: 0,
                    bottomTrailingRadius: 0, topTrailingRadius: 12
                )
            )

            // 数据行
            compareRow(label: "格局", left: leftUnit.map { "\($0.roomCount)室\($0.hallCount)厅\($0.bathroomCount)卫" },
                       right: rightUnit.map { "\($0.roomCount)室\($0.hallCount)厅\($0.bathroomCount)卫" })
            compareRow(label: "面积", left: leftUnit.map { "\(String(format: "%.0f", $0.area))㎡" },
                       right: rightUnit.map { "\(String(format: "%.0f", $0.area))㎡" }, highlight: true)
            compareRow(label: "套内", left: leftUnit?.innerArea.map { "\(String(format: "%.0f", $0))㎡" },
                       right: rightUnit?.innerArea.map { "\(String(format: "%.0f", $0))㎡" })
            compareRow(label: "朝向", left: leftUnit?.orientation, right: rightUnit?.orientation)
            compareRow(label: "楼层", left: leftUnit?.floorLevel, right: rightUnit?.floorLevel)
            compareRow(label: "楼栋", left: leftUnit?.buildingNumber, right: rightUnit?.buildingNumber)
            compareRow(label: "状态", left: leftUnit?.status.rawValue, right: rightUnit?.status.rawValue)

            if let left = leftUnit, let right = rightUnit,
               let leftP = left.priceRange.minTotalPrice,
               let rightP = right.priceRange.minTotalPrice {
                let l = NSDecimalNumber(decimal: leftP).intValue
                let r = NSDecimalNumber(decimal: rightP).intValue
                compareRow(label: "总价",
                           left: "\(l)万起", right: "\(r)万起",
                           highlight: true)
            }

            if let left = leftUnit, let right = rightUnit,
               let leftU = left.priceRange.unitPrice,
               let rightU = right.priceRange.unitPrice {
                let l = NSDecimalNumber(decimal: leftU).intValue
                let r = NSDecimalNumber(decimal: rightU).intValue
                compareRow(label: "单价", left: "\(l)元/㎡", right: "\(r)元/㎡")
            }

            // 标签行
            tagCompareRow(
                label: "特色", leftTags: leftUnit?.featureTags ?? [], rightTags: rightUnit?.featureTags ?? []
            )

            // 描述行
            descriptionCompareRow(
                left: leftUnit?.description ?? "", right: rightUnit?.description ?? ""
            )
        }
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(AppTheme.cardBackground)
                .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
        )
    }

    private func compareRow(label: String, left: String?, right: String?, highlight: Bool = false) -> some View {
        VStack(spacing: 0) {
            Divider().background(AppTheme.divider)
            HStack(spacing: 0) {
                Text(label)
                    .font(.system(size: 13, weight: highlight ? .semibold : .regular))
                    .foregroundColor(AppTheme.textSecondary)
                    .frame(width: 70, alignment: .leading)

                Text(left ?? "-")
                    .font(.system(size: 13, weight: highlight ? .semibold : .regular))
                    .foregroundColor(highlight ? AppTheme.primary : AppTheme.textPrimary)
                    .frame(maxWidth: .infinity)

                Rectangle()
                    .fill(AppTheme.divider)
                    .frame(width: 1, height: 24)

                Text(right ?? "-")
                    .font(.system(size: 13, weight: highlight ? .semibold : .regular))
                    .foregroundColor(highlight ? AppTheme.wood : AppTheme.textPrimary)
                    .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
        }
    }

    private func tagCompareRow(label: String, leftTags: [String], rightTags: [String]) -> some View {
        VStack(spacing: 0) {
            Divider().background(AppTheme.divider)
            HStack(alignment: .top, spacing: 0) {
                Text(label)
                    .font(.system(size: 13))
                    .foregroundColor(AppTheme.textSecondary)
                    .frame(width: 70, alignment: .leading)

                VStack(alignment: .leading, spacing: 4) {
                    ForEach(leftTags, id: \.self) { tag in
                        Text(tag)
                            .font(.system(size: 10))
                            .foregroundColor(AppTheme.primary)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Capsule().fill(AppTheme.primaryLight))
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                Rectangle()
                    .fill(AppTheme.divider)
                    .frame(width: 1)

                VStack(alignment: .leading, spacing: 4) {
                    ForEach(rightTags, id: \.self) { tag in
                        Text(tag)
                            .font(.system(size: 10))
                            .foregroundColor(AppTheme.wood)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Capsule().fill(AppTheme.wood.opacity(0.1)))
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
        }
    }

    private func descriptionCompareRow(left: String, right: String) -> some View {
        VStack(spacing: 0) {
            Divider().background(AppTheme.divider)
            HStack(alignment: .top, spacing: 0) {
                Text("介绍")
                    .font(.system(size: 13))
                    .foregroundColor(AppTheme.textSecondary)
                    .frame(width: 70, alignment: .leading)

                Text(left)
                    .font(.system(size: 11))
                    .foregroundColor(AppTheme.textSecondary)
                    .lineSpacing(3)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Rectangle()
                    .fill(AppTheme.divider)
                    .frame(width: 1)

                Text(right)
                    .font(.system(size: 11))
                    .foregroundColor(AppTheme.textSecondary)
                    .lineSpacing(3)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
        }
    }
}

#Preview {
    ComparisonView()
}
