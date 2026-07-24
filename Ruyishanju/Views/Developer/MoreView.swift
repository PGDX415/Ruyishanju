//
//  MoreView.swift
//  Ruyishanju
//
//  更多 — 聚合位置、开发商、联系、展厅模式入口
//

import SwiftUI

struct MoreView: View {
    @Binding var showKiosk: Bool
    @State private var showShareProject = false

    var body: some View {
        NavigationStack {
            List {
                // 位置配套
                NavigationLink {
                    LocationView()
                } label: {
                    MoreRow(
                        icon: "mappin.and.ellipse",
                        title: "位置与配套",
                        subtitle: "海南五指山 · 周边配套",
                        color: Color(red: 0.31, green: 0.52, blue: 0.73)
                    )
                }

                // 开发商与物业
                NavigationLink {
                    DeveloperView()
                } label: {
                    MoreRow(
                        icon: "building.columns.fill",
                        title: "品牌实力",
                        subtitle: "绿城品牌 · 物业服务",
                        color: AppTheme.primary
                    )
                }

                // 联系与预约
                NavigationLink {
                    ContactView()
                } label: {
                    MoreRow(
                        icon: "phone.fill",
                        title: "预约看房",
                        subtitle: "在线预约 · 电话咨询",
                        color: AppTheme.wood
                    )
                }

                // 购房指南
                Section {
                    NavigationLink {
                        MortgageView()
                    } label: {
                        MoreRow(
                            icon: "dollarsign.circle.fill",
                            title: "房贷计算器",
                            subtitle: "等额本息 · 月供计算",
                            color: Color(red: 0.15, green: 0.60, blue: 0.45)
                        )
                    }

                    NavigationLink {
                        SunlightView()
                    } label: {
                        MoreRow(
                            icon: "sun.max.fill",
                            title: "日照模拟",
                            subtitle: "朝向分析 · 采光评估",
                            color: Color(red: 0.90, green: 0.55, blue: 0.15)
                        )
                    }

                    NavigationLink {
                        PolicyView()
                    } label: {
                        MoreRow(
                            icon: "doc.text.fill",
                            title: "购房政策",
                            subtitle: "海南自贸港 · 购房利好",
                            color: Color(red: 0.15, green: 0.55, blue: 0.55)
                        )
                    }

                    NavigationLink {
                        WuzhishanView()
                    } label: {
                        MoreRow(
                            icon: "mountain.2.fill",
                            title: "五指山风物志",
                            subtitle: "景点 · 美食 · 黎苗文化",
                            color: Color(red: 0.25, green: 0.45, blue: 0.25)
                        )
                    }

                    NavigationLink {
                        WellnessView()
                    } label: {
                        MoreRow(
                            icon: "heart.fill",
                            title: "康养山居",
                            subtitle: "天然氧吧 · 天赋康养资源",
                            color: Color(red: 0.70, green: 0.25, blue: 0.35)
                        )
                    }

                    NavigationLink {
                        TransportView()
                    } label: {
                        MoreRow(
                            icon: "car.fill",
                            title: "交通指南",
                            subtitle: "航空 · 高铁 · 自驾路线",
                            color: Color(red: 0.25, green: 0.40, blue: 0.65)
                        )
                    }

                    NavigationLink {
                        BrochureView()
                    } label: {
                        MoreRow(
                            icon: "book.pages.fill",
                            title: "电子楼书",
                            subtitle: "在线浏览 · 下载 PDF",
                            color: Color(red: 0.50, green: 0.35, blue: 0.20)
                        )
                    }

                    NavigationLink {
                        ConstructionProgressView()
                    } label: {
                        MoreRow(
                            icon: "clock.arrow.2.circlepath",
                            title: "施工进度",
                            subtitle: "一期封顶 · 2026.12交付",
                            color: Color(red: 0.25, green: 0.50, blue: 0.65)
                        )
                    }
                }

                // 其他
                Section {
                    // 展厅演示模式
                    Button {
                        showKiosk = true
                    } label: {
                        MoreRow(
                            icon: "play.rectangle.fill",
                            title: "展厅演示模式",
                            subtitle: "iPad 展厅待机欢迎页",
                            color: Color(red: 0.5, green: 0.3, blue: 0.7)
                        )
                    }

                    // 分享项目
                    Button {
                        showShareProject = true
                    } label: {
                        MoreRow(
                            icon: "square.and.arrow.up.fill",
                            title: "分享项目",
                            subtitle: "推荐给朋友 · 微信/朋友圈",
                            color: Color(red: 0.18, green: 0.70, blue: 0.30)
                        )
                    }

                    // 隐私政策
                    NavigationLink {
                        PrivacyView()
                    } label: {
                        MoreRow(
                            icon: "hand.raised.fill",
                            title: "隐私政策",
                            subtitle: "用户信息收集与使用说明",
                            color: Color(red: 0.4, green: 0.5, blue: 0.6)
                        )
                    }

                    // 免责声明
                    NavigationLink {
                        DisclaimerView()
                    } label: {
                        MoreRow(
                            icon: "exclamationmark.shield.fill",
                            title: "免责声明",
                            subtitle: "信息仅供参考 · 以合同为准",
                            color: Color(red: 0.55, green: 0.45, blue: 0.35)
                        )
                    }

                    // 关于
                    HStack {
                        MoreRow(
                            icon: "info.circle.fill",
                            title: "关于绿城如意山居",
                            subtitle: "版本 1.0 · 乾景源 × 绿城管理",
                            color: AppTheme.textSecondary
                        )
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.system(size: 13))
                            .foregroundColor(AppTheme.textSecondary.opacity(0.4))
                    }
                }
            }
            .navigationTitle("更多")
            .scrollContentBackground(.hidden)
            .background(AppTheme.background)
            .sheet(isPresented: $showShareProject) {
                ShareSheet(items: [ProjectShareText.shareText])
                    .presentationDetents([.medium])
            }
        }
    }
}

struct MoreRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(.white)
                .frame(width: 36, height: 36)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(color)
                )

            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(AppTheme.textPrimary)
                Text(subtitle)
                    .font(.system(size: 12))
                    .foregroundColor(AppTheme.textSecondary)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    MoreView(showKiosk: .constant(false))
}
