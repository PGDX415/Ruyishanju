//
//  TransportView.swift
//  Ruyishanju
//
//  交通导航 — 到达五指山如意山居的路线指南
//

import SwiftUI

struct TransportView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    overviewSection
                    byAirSection
                    byTrainSection
                    byCarSection
                    tipsSection
                }
                .padding(16)
            }
            .background(AppTheme.background)
            .navigationTitle("交通指南")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    // MARK: - 概述

    private var overviewSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("到达五指山")

            Text("五指山市位于海南岛中南部，距离三亚约100公里、海口约220公里。随着海南环岛高速和环岛高铁的全线贯通，五指山的交通便利性大幅提升，「海岛腹地」已成为「一小时生活圈」的重要节点。")
                .font(.system(size: 15))
                .foregroundColor(AppTheme.textSecondary)
                .lineSpacing(6)
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white)
                        .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
                )
        }
    }

    // MARK: - 航空

    private var byAirSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("✈️ 航空出行")

            routeCard(
                title: "三亚凤凰国际机场",
                time: "约 1.5 小时车程",
                desc: "国内主要城市均有直飞航班。落地后沿海南环岛高速（G98）北上，经五指山出口下高速即可抵达。机场可租赁车辆或乘坐网约车直达如意山居。",
                icon: "airplane.departure"
            )

            routeCard(
                title: "海口美兰国际机场",
                time: "约 2.5 小时车程",
                desc: "国际及部分国内航班抵达。落地后沿海南环岛高速（G98）南下，经琼中进入五指山区域。建议结合环岛自驾行程前往。",
                icon: "airplane.arrival"
            )

            routeCard(
                title: "博鳌机场",
                time: "约 2 小时车程",
                desc: "部分城市有直飞博鳌的航班，落地后经G98高速前往五指山，沿途风景宜人。",
                icon: "airplane.circle"
            )
        }
    }

    // MARK: - 铁路

    private var byTrainSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("🚄 高铁出行")

            routeCard(
                title: "三亚站 / 陵水站",
                time: "转汽车约 1-1.5 小时",
                desc: "海南环岛高铁贯穿全岛，建议乘坐至三亚站或陵水站下车。出站后可乘坐直达五指山的大巴（约1小时一班），或租赁车辆自驾前往如意山居。",
                icon: "tram.fill"
            )

            VStack(spacing: 8) {
                HStack {
                    Image(systemName: "info.circle.fill")
                        .font(.system(size: 14))
                        .foregroundColor(AppTheme.primary)

                    Text("铁路小贴士")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(AppTheme.textPrimary)
                    Spacer()
                }

                Text("环岛高铁全程约3小时即可环岛一周，三亚站至海口站约2小时。五指山市距离高铁站（三亚/陵水）约1-1.5小时车程，建议提前预约接送服务。")
                    .font(.system(size: 13))
                    .foregroundColor(AppTheme.textSecondary)
                    .lineSpacing(4)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppTheme.primaryLight.opacity(0.3))
            )
        }
    }

    // MARK: - 自驾

    private var byCarSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("🚗 自驾出行")

            VStack(spacing: 12) {
                driveRoute(
                    from: "海口出发",
                    route: "海南环岛高速 G98 南下",
                    distance: "约 220 公里",
                    time: "约 2.5 小时"
                )
                driveRoute(
                    from: "三亚出发",
                    route: "海南环岛高速 G98 北上",
                    distance: "约 100 公里",
                    time: "约 1.5 小时"
                )
                driveRoute(
                    from: "琼海/博鳌出发",
                    route: "G98 高速西行",
                    distance: "约 150 公里",
                    time: "约 2 小时"
                )
            }

            Text("全岛高速公路网络已实现「田字型」布局，路况优良。五指山段多为山地高速，沿途风光壮丽，自驾本身即是一场视觉盛宴。建议白天行驶，欣赏沿途热带雨林与山脉交叠的美景。")
                .font(.system(size: 14))
                .foregroundColor(AppTheme.textSecondary)
                .lineSpacing(5)
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white)
                        .shadow(color: .black.opacity(0.03), radius: 3, y: 1)
                )
        }
    }

    // MARK: - 温馨提示

    private var tipsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("出行小贴士")

            VStack(spacing: 0) {
                tipItem("01", "五指山早晚温差较大，建议携带薄外套")
                Divider().background(AppTheme.divider)
                tipItem("02", "山区道路弯道较多，自驾请控制车速、注意安全")
                Divider().background(AppTheme.divider)
                tipItem("03", "如意山居营销中心提供免费泊车与接驳服务")
                Divider().background(AppTheme.divider)
                tipItem("04", "如需接送站服务，请提前联系销售顾问预约")
            }
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
            )
        }
    }

    // MARK: - 辅助组件

    private func sectionHeader(_ title: String) -> some View {
        HStack(spacing: 10) {
            Rectangle()
                .fill(AppTheme.primary)
                .frame(width: 3, height: 18)
            Text(title)
                .font(.brandSubtitle)
                .foregroundColor(AppTheme.textPrimary)
        }
    }

    private func routeCard(title: String, time: String, desc: String, icon: String) -> some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(.white)
                .frame(width: 36, height: 36)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(AppTheme.primary)
                )

            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(title)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(AppTheme.textPrimary)
                    Spacer()
                    Text(time)
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundColor(AppTheme.primary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(
                            Capsule()
                                .fill(AppTheme.primaryLight)
                        )
                }
                Text(desc)
                    .font(.system(size: 13))
                    .foregroundColor(AppTheme.textSecondary)
                    .lineSpacing(4)
            }
            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
        )
    }

    private func driveRoute(from: String, route: String, distance: String, time: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(from)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(AppTheme.textPrimary)
                Spacer()
                HStack(spacing: 4) {
                    Text(distance)
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundColor(AppTheme.wood)
                    Text("·")
                        .foregroundColor(AppTheme.textSecondary)
                    Text(time)
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundColor(AppTheme.primary)
                }
            }
            Text(route)
                .font(.system(size: 13))
                .foregroundColor(AppTheme.textSecondary)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.03), radius: 3, y: 1)
        )
    }

    private func tipItem(_ number: String, _ text: String) -> some View {
        HStack(spacing: 14) {
            Text(number)
                .font(.system(size: 13, weight: .bold, design: .monospaced))
                .foregroundColor(AppTheme.primary)
                .frame(width: 24)

            Text(text)
                .font(.system(size: 14))
                .foregroundColor(AppTheme.textPrimary)
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
    }
}

#Preview {
    TransportView()
}
