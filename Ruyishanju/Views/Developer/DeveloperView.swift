//
//  DeveloperView.swift
//  Ruyishanju
//
//  开发商与物业介绍
//

import SwiftUI

struct DeveloperView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // 开发商介绍
                    developerSection

                    // 品牌实力
                    brandStrength

                    // 品牌荣誉
                    brandHonors

                    // 项目开发团队
                    projectTeam

                    // 物业服务
                    propertyServiceSection
                }
                .padding(16)
            }
            .background(AppTheme.background)
            .navigationTitle("品牌实力")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    // MARK: - 开发商

    private var developerSection: some View {
        VStack(spacing: 16) {
            // Logo 和名称
            VStack(spacing: 12) {
                Circle()
                    .fill(AppTheme.primary.opacity(0.1))
                    .frame(width: 80, height: 80)
                    .overlay {
                        Image(systemName: "building.columns.fill")
                            .font(.system(size: 32))
                            .foregroundColor(AppTheme.primary)
                    }

                Text("绿城中国")
                    .font(.brandTitle)
                    .foregroundColor(AppTheme.textPrimary)

                Text("理想生活综合服务商")
                    .font(.brandSlogan)
                    .foregroundColor(AppTheme.textSecondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 24)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(AppTheme.cardBackground)
                    .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
            )

            // 介绍文案
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Rectangle()
                        .fill(AppTheme.primary)
                        .frame(width: 3, height: 16)
                    Text("关于绿城")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(AppTheme.textPrimary)
                }

                Text("绿城中国控股有限公司（股票代码：03900.HK），1995年成立于杭州，是中国领先的优质房产品开发及生活综合服务供应商，连续多年荣获「中国房地产百强企业综合实力TOP10」。")
                    .font(.system(size: 15))
                    .foregroundColor(AppTheme.textSecondary)
                    .lineSpacing(6)
                    .padding(.bottom, 4)

                Text("以「真诚、善意、精致、完美」为核心价值观，绿城始终坚持产品主义，以品质为信仰，致力于为业主创造美好生活。历经近30年发展，绿城已将美好人居的版图拓展至全国200余座城市，累计打造1000余座精品项目。")
                    .font(.system(size: 15))
                    .foregroundColor(AppTheme.textSecondary)
                    .lineSpacing(6)
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(AppTheme.cardBackground)
                    .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
            )
        }
    }

    // MARK: - 品牌实力

    private var brandStrength: some View {
        VStack(spacing: 12) {
            HStack {
                Rectangle()
                    .fill(AppTheme.primary)
                    .frame(width: 3, height: 16)
                Text("品牌实力")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(AppTheme.textPrimary)
                Spacer()
            }
            .padding(.horizontal, 4)

            HStack(spacing: 12) {
                StrengthCard(number: "1995", label: "创立至今", subtitle: "近30年深耕")
                StrengthCard(number: "200+", label: "城市布局", subtitle: "全国覆盖")
                StrengthCard(number: "1000+", label: "精品项目", subtitle: "累计开发")
            }
        }
    }

    // MARK: - 品牌荣誉

    private var brandHonors: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Rectangle()
                    .fill(AppTheme.primary)
                    .frame(width: 3, height: 16)
                Text("品牌荣誉")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(AppTheme.textPrimary)
                Spacer()
            }
            .padding(.horizontal, 4)

            VStack(spacing: 0) {
                HonorRow(year: "2023", title: "中国房地产百强企业综合实力TOP10")
                Divider().background(AppTheme.divider)
                HonorRow(year: "2023", title: "中国房地产产品力优秀企业")
                Divider().background(AppTheme.divider)
                HonorRow(year: "2022", title: "中国物业服务百强满意度领先企业")
                Divider().background(AppTheme.divider)
                HonorRow(year: "2021", title: "中国房地产顾客满意度领先品牌")
                Divider().background(AppTheme.divider)
                HonorRow(year: "2020", title: "中国绿色建筑TOP排行榜TOP10")
            }
            .padding(.vertical, 4)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(AppTheme.cardBackground)
                    .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
            )
        }
    }

    // MARK: - 项目开发团队

    private var projectTeam: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Rectangle()
                    .fill(AppTheme.primary)
                    .frame(width: 3, height: 16)
                Text("如意山居开发团队")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(AppTheme.textPrimary)
                Spacer()
            }
            .padding(.horizontal, 4)

            VStack(alignment: .leading, spacing: 14) {
                teamRow(
                    role: "投资开发",
                    name: "五指山市乾景源实业发展有限公司",
                    description: "项目公司，负责如意山居整体投资与开发建设"
                )
                Divider().background(AppTheme.divider)
                teamRow(
                    role: "代建管理",
                    name: "绿城管理控股有限公司",
                    description: "绿城中国旗下轻资产代建板块，以绿城品质标准全程把控项目规划、设计、工程与交付"
                )
                Divider().background(AppTheme.divider)
                teamRow(
                    role: "建筑设计",
                    name: "绿城桂语系设计团队",
                    description: "传承桂语系极致简约美学语言，融合当代建筑国际审美格调，将建筑妥帖安放在山色之间"
                )
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(AppTheme.cardBackground)
                    .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
            )
        }
    }

    // MARK: - 物业服务

    private var propertyServiceSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Rectangle()
                    .fill(AppTheme.primary)
                    .frame(width: 3, height: 16)
                Text("绿城服务")
                    .font(.brandSubtitle)
                    .foregroundColor(AppTheme.textPrimary)
            }

            VStack(spacing: 12) {
                ServiceFeatureRow(
                    icon: "shield.checkered",
                    title: "24小时安保",
                    description: "全社区智能安防系统，门禁管理、电子巡更、视频监控全覆盖，守护山居安宁。"
                )
                Divider().background(AppTheme.divider).padding(.leading, 48)
                ServiceFeatureRow(
                    icon: "leaf.fill",
                    title: "园林养护",
                    description: "专业园林团队定期维护，保持社区景观四季常青、整洁美观，热带雨林风情尽显。"
                )
                Divider().background(AppTheme.divider).padding(.leading, 48)
                ServiceFeatureRow(
                    icon: "wrench.and.screwdriver.fill",
                    title: "工程维修",
                    description: "专业维修团队快速响应，提供房屋维修、设施维护等一站式贴心服务。"
                )
                Divider().background(AppTheme.divider).padding(.leading, 48)
                ServiceFeatureRow(
                    icon: "figure.2.and.child.holdinghands",
                    title: "社区活动",
                    description: "定期组织邻里活动，融合海南地域文化，营造温馨和谐的山居社区氛围。"
                )
                Divider().background(AppTheme.divider).padding(.leading, 48)
                ServiceFeatureRow(
                    icon: "heart.text.square.fill",
                    title: "康养服务",
                    description: "结合五指山天赋康养资源，提供健康管理、养生讲座等特色康养服务体系。"
                )
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(AppTheme.cardBackground)
                    .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
            )
        }
    }

    // MARK: - 辅助方法

    private func teamRow(role: String, name: String, description: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(role)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(AppTheme.primary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(
                        Capsule()
                            .fill(AppTheme.primaryLight)
                    )
                Spacer()
            }

            Text(name)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(AppTheme.textPrimary)

            Text(description)
                .font(.system(size: 13))
                .foregroundColor(AppTheme.textSecondary)
                .lineSpacing(3)
        }
    }
}

// MARK: - 子组件

struct StrengthCard: View {
    let number: String
    let label: String
    let subtitle: String

    var body: some View {
        VStack(spacing: 8) {
            Text(number)
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundColor(AppTheme.primary)

            Text(label)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(AppTheme.textPrimary)

            Text(subtitle)
                .font(.system(size: 11))
                .foregroundColor(AppTheme.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppTheme.cardBackground)
                .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
        )
    }
}

struct ServiceFeatureRow: View {
    let icon: String
    let title: String
    let description: String

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(AppTheme.primary)
                .frame(width: 28)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppTheme.textPrimary)
                Text(description)
                    .font(.system(size: 13))
                    .foregroundColor(AppTheme.textSecondary)
                    .lineSpacing(3)
            }
        }
    }
}

struct HonorRow: View {
    let year: String
    let title: String

    var body: some View {
        HStack(spacing: 14) {
            Text(year)
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundColor(AppTheme.primary)
                .frame(width: 48)

            Text(title)
                .font(.system(size: 14))
                .foregroundColor(AppTheme.textPrimary)

            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
    }
}

#Preview {
    DeveloperView()
}
