//
//  ProgressView.swift
//  Ruyishanju
//
//  施工进度 — 工程时间线
//

import SwiftUI

struct ConstructionProgressView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    overallProgress
                    timelineSection
                    detailSection
                }
                .padding(16)
            }
            .background(AppTheme.background)
            .navigationTitle("施工进度")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    // MARK: - 总体进度

    private var overallProgress: some View {
        VStack(spacing: 16) {
            // 进度环形图
            ZStack {
                Circle()
                    .stroke(AppTheme.surface, lineWidth: 12)
                    .frame(width: 140, height: 140)

                Circle()
                    .trim(from: 0, to: 0.82)
                    .stroke(
                        LinearGradient(
                            colors: [AppTheme.primary, Color(red: 0.35, green: 0.55, blue: 0.45)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        style: StrokeStyle(lineWidth: 12, lineCap: .round)
                    )
                    .frame(width: 140, height: 140)
                    .rotationEffect(.degrees(-90))

                VStack(spacing: 4) {
                    Text("82%")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(AppTheme.primary)
                    Text("一期进度")
                        .font(.system(size: 12))
                        .foregroundColor(AppTheme.textSecondary)
                }
            }

            // 文字说明
            VStack(spacing: 8) {
                Text("一期主体结构已全面封顶")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(AppTheme.textPrimary)

                Text("预计 2026年12月 如期交付")
                    .font(.system(size: 14))
                    .foregroundColor(AppTheme.textSecondary)
            }

            // 快速数据
            HStack(spacing: 12) {
                statItem(icon: "building.2.fill", value: "6幢", label: "一期楼栋")
                statItem(icon: "stairs", value: "14层", label: "建筑层数")
                statItem(icon: "calendar.badge.clock", value: "2026.12", label: "预计交付")
                statItem(icon: "checkmark.shield.fill", value: "已封顶", label: "当前阶段")
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppTheme.cardBackground)
                .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
        )
    }

    // MARK: - 时间线

    private var timelineSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
                Rectangle()
                    .fill(AppTheme.primary)
                    .frame(width: 3, height: 18)
                Text("工程时间线")
                    .font(.brandSubtitle)
                    .foregroundColor(AppTheme.textPrimary)
            }

            VStack(spacing: 0) {
                ForEach(Array(milestones.enumerated()), id: \.element.id) { index, milestone in
                    TimelineRow(
                        milestone: milestone,
                        isFirst: index == 0,
                        isLast: index == milestones.count - 1
                    )
                }
            }
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(AppTheme.cardBackground)
                    .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
            )
        }
    }

    // MARK: - 分期详情

    private var detailSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
                Rectangle()
                    .fill(AppTheme.primary)
                    .frame(width: 3, height: 18)
                Text("开发分期")
                    .font(.brandSubtitle)
                    .foregroundColor(AppTheme.textPrimary)
            }

            VStack(spacing: 12) {
                phaseDetail(
                    phase: "一期",
                    status: "主体封顶 · 内外装修中",
                    buildings: "1-6栋（14层山景高层）",
                    units: "建面约100-120㎡",
                    delivery: "2026年12月",
                    isCurrent: true
                )

                phaseDetail(
                    phase: "二期",
                    status: "规划设计中",
                    buildings: "待公布",
                    units: "待公布",
                    delivery: "待定",
                    isCurrent: false
                )

                phaseDetail(
                    phase: "三期",
                    status: "远景规划",
                    buildings: "待公布",
                    units: "待公布",
                    delivery: "待定",
                    isCurrent: false
                )
            }
        }
        .padding(.bottom, 24)
    }

    // MARK: - 里程碑数据

    struct Milestone: Identifiable {
        let id: Int
        let title: String
        let date: String
        let description: String
        let isCompleted: Bool
        let isCurrent: Bool
    }

    let milestones: [Milestone] = [
        Milestone(id: 1, title: "项目立项", date: "2023.03",
                  description: "五指山市政府批准立项，完成土地摘牌", isCompleted: true, isCurrent: false),
        Milestone(id: 2, title: "规划设计", date: "2023.09",
                  description: "绿城桂语系方案确定，通过规划审批", isCompleted: true, isCurrent: false),
        Milestone(id: 3, title: "开工建设", date: "2024.03",
                  description: "一期6幢14层山景高层全面开工", isCompleted: true, isCurrent: false),
        Milestone(id: 4, title: "主体施工", date: "2024.08",
                  description: "完成地下工程，进入主体结构施工阶段", isCompleted: true, isCurrent: false),
        Milestone(id: 5, title: "主体封顶", date: "2025.06",
                  description: "一期6幢楼栋全部主体结构封顶", isCompleted: true, isCurrent: true),
        Milestone(id: 6, title: "内外装修", date: "2025.12",
                  description: "外墙装饰、室内精装修、机电安装", isCompleted: false, isCurrent: false),
        Milestone(id: 7, title: "园林施工", date: "2026.06",
                  description: "社区园林景观、道路铺装、配套设施", isCompleted: false, isCurrent: false),
        Milestone(id: 8, title: "竣工验收", date: "2026.10",
                  description: "五方验收、竣工备案、取得交付许可证", isCompleted: false, isCurrent: false),
        Milestone(id: 9, title: "正式交付", date: "2026.12",
                  description: "一期业主幸福归家，开启山居康养生活", isCompleted: false, isCurrent: false),
    ]

    // MARK: - 辅助组件

    private func statItem(icon: String, value: String, label: String) -> some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(AppTheme.primary)
            Text(value)
                .font(.system(size: 14, weight: .semibold, design: .rounded))
                .foregroundColor(AppTheme.textPrimary)
            Text(label)
                .font(.system(size: 10))
                .foregroundColor(AppTheme.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(AppTheme.surface.opacity(0.5))
        )
    }

    private func phaseDetail(phase: String, status: String, buildings: String, units: String, delivery: String, isCurrent: Bool) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(phase)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(isCurrent ? AppTheme.primary : AppTheme.textSecondary)

                if isCurrent {
                    Text("当前")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Capsule().fill(AppTheme.primary))
                }

                Spacer()

                Text(status)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(isCurrent ? AppTheme.primary : AppTheme.textSecondary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(
                        Capsule()
                            .fill(isCurrent ? AppTheme.primaryLight : AppTheme.surface)
                    )
            }

            VStack(alignment: .leading, spacing: 4) {
                phaseRow(label: "楼栋", value: buildings)
                phaseRow(label: "户型", value: units)
                phaseRow(label: "交付", value: delivery)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(isCurrent ? AppTheme.primaryLight.opacity(0.3) : Color.white)
                .shadow(color: .black.opacity(isCurrent ? 0.04 : 0.02), radius: 4, y: 2)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isCurrent ? AppTheme.primary.opacity(0.2) : .clear, lineWidth: 1)
        )
    }

    private func phaseRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.system(size: 12))
                .foregroundColor(AppTheme.textSecondary)
                .frame(width: 32, alignment: .leading)
            Text(value)
                .font(.system(size: 13))
                .foregroundColor(AppTheme.textPrimary)
        }
    }
}

// MARK: - 时间线行组件

struct TimelineRow: View {
    let milestone: ConstructionProgressView.Milestone
    let isFirst: Bool
    let isLast: Bool

    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            // 时间线指示器
            VStack(spacing: 0) {
                // 连接线（上方）
                Rectangle()
                    .fill(isFirst ? .clear : (milestone.isCompleted ? AppTheme.primary : AppTheme.divider))
                    .frame(width: 2.5, height: 20)

                // 节点
                ZStack {
                    Circle()
                        .fill(milestone.isCompleted ? AppTheme.primary : .white)
                        .frame(width: 18, height: 18)
                        .overlay(
                            Circle()
                                .stroke(milestone.isCompleted ? AppTheme.primary : AppTheme.divider, lineWidth: 2.5)
                        )

                    if milestone.isCompleted {
                        Image(systemName: "checkmark")
                            .font(.system(size: 9, weight: .bold))
                            .foregroundColor(.white)
                    } else if milestone.isCurrent {
                        Circle()
                            .fill(AppTheme.primary)
                            .frame(width: 6, height: 6)
                    }
                }

                // 连接线（下方）
                Rectangle()
                    .fill(isLast ? .clear : (milestone.isCompleted ? AppTheme.primary : AppTheme.divider))
                    .frame(width: 2.5, height: 20)
            }
            .frame(width: 40)

            // 内容
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(milestone.title)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(
                            milestone.isCompleted || milestone.isCurrent
                                ? AppTheme.textPrimary
                                : AppTheme.textSecondary
                        )

                    if milestone.isCurrent {
                        Text("进行中")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(AppTheme.primary)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Capsule().fill(AppTheme.primaryLight))
                    }
                }

                Text(milestone.date)
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .foregroundColor(milestone.isCompleted ? AppTheme.primary : AppTheme.textSecondary)

                Text(milestone.description)
                    .font(.system(size: 13))
                    .foregroundColor(AppTheme.textSecondary)
                    .lineSpacing(3)
            }
            .padding(.vertical, 10)
            .padding(.trailing, 16)
            .padding(.bottom, 4)
        }
    }
}

#Preview {
    ConstructionProgressView()
}
