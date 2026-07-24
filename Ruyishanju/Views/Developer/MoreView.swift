//
//  MoreView.swift
//  Ruyishanju
//
//  更多 — 聚合位置、开发商、联系、展厅模式入口
//

import SwiftUI

struct MoreView: View {
    @Binding var showKiosk: Bool

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
                        subtitle: "周边学校、商圈、交通",
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

                // 分隔
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

                    // 隐私政策
                    NavigationLink {
                        PrivacyView()
                    } label: {
                        HStack {
                            MoreRow(
                                icon: "hand.raised.fill",
                                title: "隐私政策",
                                subtitle: "用户信息收集与使用说明",
                                color: Color(red: 0.4, green: 0.5, blue: 0.6)
                            )
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.system(size: 13))
                                .foregroundColor(AppTheme.textSecondary.opacity(0.4))
                        }
                    }

                    // 关于
                    HStack {
                        MoreRow(
                            icon: "info.circle.fill",
                            title: "关于绿城如意山居",
                            subtitle: "版本 1.0 · 绿城中国",
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
